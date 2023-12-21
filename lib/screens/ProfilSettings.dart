import 'package:flutter/material.dart';

class ProfileSet extends StatefulWidget {
  const ProfileSet({super.key});

  @override
  State<ProfileSet> createState() => _ProfileSetState();
}

class _ProfileSetState extends State<ProfileSet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ...Other Widget Components...
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                _buildCard("Profile Settings", "Update your profile here", Icons.person, Colors.indigoAccent),
                SizedBox(height: 5),
                _buildCard("Security Settings", "Update your security here", Icons.security, Colors.indigoAccent),
                SizedBox(height: 5),
                _buildCard("About", "View documentation here", Icons.question_answer, Colors.indigoAccent),
                SizedBox(height: 5),
                _buildCard("Logout", "", Icons.logout_sharp, Colors.indigoAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon, Color iconColor) {
    return GestureDetector(
      onTap: () {
        if (title == "Profile Settings") {
          print("Profile Settings tapped");
          // Add functionality for Profile Settings
        } else if (title == "Security Settings") {
          print("Security Settings tapped");
          // Add functionality for Security Settings
        } else if (title == "About") {
          print("About tapped");
          // Add functionality for About
        } else if (title == "Logout") {
          print("Logout tapped");
          // Add functionality for Logout
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.03),
              spreadRadius: 10,
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 30)
            ],
          ),
        ),
      ),
    );
  }
}
