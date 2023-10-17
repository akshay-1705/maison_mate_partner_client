import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_mate/shared/my_form.dart';

class FavouritesWidget extends StatefulWidget {
  const FavouritesWidget({Key? key}) : super(key: key);

  @override
  State<FavouritesWidget> createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  final TextEditingController searchController = TextEditingController();
  final List<User> favoriteUsers = [
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
    User(name: 'Random', serviceOffered: 'ABC'),
  ];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = favoriteUsers;
    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = favoriteUsers
          .where((user) => user.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20),
      MyForm.searchField(searchController),
      const SizedBox(height: 20),
      if (filteredUsers.isEmpty)
        Container(
            height: MediaQuery.of(context).size.height * 0.70,
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

  void _showDeleteConfirmation(User user) {
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

class User {
  final String name;
  final String serviceOffered;

  User({required this.name, required this.serviceOffered});
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          user.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black54, // Add a touch of blue color
          ),
        ),
        subtitle: Text(
          'Service Offered: ${user.serviceOffered}',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.blueGrey, // Add a touch of green color
          ),
        ),
      ),
    );
  }
}
