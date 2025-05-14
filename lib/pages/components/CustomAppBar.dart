import 'package:cd_automation/pages/Notification/NotificationPage.dart';
import 'package:cd_automation/util/Localstorage.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? userType;

  @override
  void initState() {
    super.initState();
    loadUserType();
  }

  // Loads the user type from local storage
  Future<void> loadUserType() async {
    String? fetchedUserType = await LocalStorage().getUserTypeData();
    if (mounted) {
      setState(() {
        userType = fetchedUserType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00536E),
      automaticallyImplyLeading: false,
      leading: userType == "admin_users"
          ? Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    widget.scaffoldKey.currentState?.openDrawer();
                  },
                )
              ],
            )
          : null,
      title: const Text(
        "CD Automation",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        // Profile Icon button
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () {
            // Handle profile button functionality
          },
        ),

        // Notifications Icon with a badge
        Stack(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                // Navigate to NotificationPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationPage()),
                );
              },
            ),
            const Positioned(
              right: 6,
              top: 6,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 7,
                child: Text(
                  "3", // Replace "3" with the dynamic notification count
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
