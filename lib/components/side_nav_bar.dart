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
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade900, // Dark blue background for the header
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center the content
              children: [
                // Title text in the drawer header
                Text(
                  "Task Manager",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26, // Slightly larger for better emphasis
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10), // Space between title and icon
                // Centered Icon below the title
                Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 60, // Smaller icon size
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Add a line break between header and menu options
          SizedBox(height: 10), // Adds space after the drawer header

          // Home ListTile
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue.shade900, size: 22), // Smaller icon
            title: Text("Home", style: TextStyle(fontSize: 18)),
            onTap: () {
              onItemSelected('home');
              Navigator.pop(context); // Close the drawer
            },
          ),

          // Recycle Bin ListTile
          ListTile(
            leading: Icon(Icons.delete, color: Colors.blue.shade900, size: 22), // Smaller icon
            title: Text("Recycle Bin", style: TextStyle(fontSize: 18)),
            onTap: () {
              onItemSelected('recycle_bin');
              Navigator.pop(context); // Close the drawer
            },
          ),

          // Categories ListTile
          ListTile(
            leading: Icon(Icons.category, color: Colors.blue.shade900, size: 22), // Smaller icon
            title: Text("Categories", style: TextStyle(fontSize: 18)),
            onTap: () {
              onItemSelected('categories');
              Navigator.pop(context); // Close the drawer
            },
          ),

          Divider(), // Divider for visual separation

          // Logout ListTile
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue.shade900, size: 22), // Smaller icon
            title: Text("Logout", style: TextStyle(fontSize: 18)),
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
