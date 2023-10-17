import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/user_response.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/widgets/user_card.dart';

class FavouritesWidget extends StatefulWidget {
  const FavouritesWidget({Key? key}) : super(key: key);

  @override
  State<FavouritesWidget> createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  final TextEditingController searchController = TextEditingController();
  List<UserResponse> filteredUsers = [];
  late Future<ApiResponse> futureData;
  static const String apiUrl = '$baseApiUrl/partners/favourites';

  @override
  void initState() {
    super.initState();
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((apiResponse) {
      if (mounted) {
        filteredUsers = apiResponse.data.favourites;
        searchController.addListener(() {
          onSearchChanged(apiResponse.data.favourites);
        });
      }
    });
  }

  onSearchChanged(List<UserResponse> users) {
    final query = searchController.text.toLowerCase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredUsers = users
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
    return Column(children: [
      const SizedBox(height: 20),
      MyForm.searchField(searchController),
      const SizedBox(height: 20),
      if (filteredUsers.isEmpty)
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
        ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      _showDeleteConfirmation(user);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: UserCard(user: user),
            );
          },
        )
    ]);
  }

  void _showDeleteConfirmation(UserResponse user) {
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
              },
            ),
          ],
        );
      },
    );
  }
}
