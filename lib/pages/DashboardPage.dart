import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? usertype;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: const FlyoutBar(), // Use FlyoutBar component here
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MeterCard(
                    route: "/admin/reading/watermeter",
                    imagePath: "assets/images/watermeter.png",
                    title: "Water meter"),
                const SizedBox(width: 20),
                const MeterCard(
                    route: "/admin/reading/powermeter",
                    imagePath: "assets/images/powermeter.png",
                    title: "Power meter"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
      IconData icon, String title, List<Widget> subItems) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        leading: Icon(icon, color: Colors.white),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        children: subItems,
      ),
    );
  }

  Widget _buildDrawerSubItem(String title, String route) {
    return ListTile(
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class MeterCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String route;

  const MeterCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: 150,
        height: 170,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 90, height: 80, fit: BoxFit.contain),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
