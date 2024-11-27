import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
