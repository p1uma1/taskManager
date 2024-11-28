import 'package:flutter/material.dart';
import 'package:taskmanager_new/services/auth_service.dart';
import '../models/recyclebin.dart';

class SideNavBar extends StatelessWidget {
  final Function(String) onItemSelected;

  SideNavBar({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Task Manager",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              onItemSelected('home');
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Recycle Bin"),
            onTap: () {
              onItemSelected('recycle_bin');
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("Categories"),
            onTap: () {
              onItemSelected('categories'); // When "Categories" is tapped
              Navigator.pop(context);
            },
          ),
          Divider(), // Optional: Add a divider above the logout button

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              AuthService().logout(); // Trigger the logout action
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),

    );
  }
}
