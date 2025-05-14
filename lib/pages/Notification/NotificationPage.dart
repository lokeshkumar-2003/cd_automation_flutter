import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "New Admin Added",
      time: "10.45AM",
      message:
          "A New Admin User[User Name] has been Successfully added By [Admin User Name]",
      isAlert: false,
    ),
    NotificationItem(
      title: "New Regular User Added",
      time: "10.36AM",
      message:
          "A New Regular User[user Name] has been Successfully added By [Admin User Name]",
      isAlert: false,
    ),
    NotificationItem(
      title: "Successfully Removed User Name by Admin",
      time: "12.32PM",
      message: "",
      isAlert: false,
    ),
    NotificationItem(
      title: "Alert!",
      time: "1.30PM",
      message:
          "Alert!, Your Account has been logged in from a new device. If This wasn’t you, please secure your account immediately.",
      isAlert: true,
    ),
  ];

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FlyoutBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00536E),
        title: const Text(
          'CD Automation',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),

          // this part is unused, i kept it incase for use in future

          // Stack(
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.notifications_none),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => NotificationPage()),
          //         );
          //       },
          //     ),
          //     Positioned(
          //       right: 8,
          //       top: 8,
          //       child: Container(
          //         padding: const EdgeInsets.all(2),
          //         decoration: const BoxDecoration(
          //           color: Colors.red,
          //           shape: BoxShape.circle,
          //         ),
          //         child: const Text(
          //           '3',
          //           style: TextStyle(fontSize: 10, color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return NotificationCard(item: item);
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String time;
  final String message;
  final bool isAlert;

  NotificationItem({
    required this.title,
    required this.time,
    required this.message,
    this.isAlert = false,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isAlert ? Colors.red : Colors.green;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: item.isAlert ? Colors.red[50] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified, color: color, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: item.isAlert ? Colors.red : Color(0xFF00536E),
                        fontWeight:
                            item.isAlert ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.time,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (item.message.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        item.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00536E),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.close, color: Color(0xFF00536E)),
            ],
          ),
        ),
      ),
    );
  }
}
