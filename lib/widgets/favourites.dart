import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/user_response.dart';
import 'package:maison_mate/provider/favourites_model.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/user_card.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FavouritesWidget extends StatefulWidget {
  const FavouritesWidget({Key? key}) : super(key: key);

  @override
  State<FavouritesWidget> createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  final TextEditingController searchController = TextEditingController();
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/favourites';

  @override
  void initState() {
    super.initState();
    var stateModel = Provider.of<FavouritesModel>(context, listen: false);
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((apiResponse) {
      if (mounted) {
        stateModel.filteredUsers = apiResponse.data.favourites;
        searchController.addListener(() {
          onSearchChanged(apiResponse.data.favourites, stateModel);
        });
      }
    });
  }

  onSearchChanged(List<UserResponse> users, FavouritesModel stateModel) {
    final query = searchController.text.toLowerCase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        stateModel.filteredUsers = users
            .where((user) => user.name!.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetRequestFutureBuilder<dynamic>(
        future: futureData,
        apiUrl: apiUrl,
        builder: (context, data) {
          return renderData(context);
        });
  }

  Column renderData(BuildContext context) {
    final FavouritesModel model = Provider.of<FavouritesModel>(context);

    return Column(children: [
      const SizedBox(height: 20),
      MyForm.searchField(searchController),
      const SizedBox(height: 20),
      if (model.filteredUsers.isEmpty)
        Container(
            height: MediaQuery.of(context).size.height * 0.50,
            alignment: Alignment.center,
            child: const Center(
              child: Text(
                "No favorite users available",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ))
      else
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: model.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = model.filteredUsers[index];
                return Column(children: [
                  const SizedBox(height: 15),
                  Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            showDeleteConfirmation(user, context, model);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: UserCard(user: user),
                  )
                ]);
              },
            ))
    ]);
  }

  void showDeleteConfirmation(
      UserResponse user, BuildContext context, FavouritesModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content:
              Text('You are going to delete ${user.name} from favourites.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(user, context, model);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteUser(
      UserResponse user, BuildContext context, FavouritesModel model) async {
    try {
      const storage = FlutterSecureStorage();
      var authToken = await storage.read(key: authTokenKey);
      authToken ??= '';
      var userId = user.id;
      String deleteApiUrl = '$baseApiUrl/partners/favourite/$userId';

      final response = await http.delete(
        Uri.parse(deleteApiUrl),
        headers: <String, String>{'Partner-Authorization': authToken},
      );
      if (response.statusCode == 200 && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          model.removeItemFromFilteredUsers(user);
          ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                  message: 'Successfully removed from favourites', error: false)
              .getSnackbar());
        });
      } else {
        throw ('Unable to remove from favourites');
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: 'Unable to remove from favourites', error: true)
                .getSnackbar());
      });
    }
  }
}
