import 'package:cd_automation/pages/AdminPages/PowerMeterListDashPage.dart';
import 'package:cd_automation/pages/AdminPages/PowerMeterReadingPage.dart';
import 'package:cd_automation/pages/AdminPages/Powermeterlistdwnrpt.dart';
import 'package:cd_automation/pages/AdminPages/WaterMeterListDash.dart';
import 'package:cd_automation/pages/AdminPages/WaterMeterReadingPage.dart';
import 'package:cd_automation/pages/AdminPages/Watermeterlistdwnrpt.dart';
import 'package:cd_automation/pages/DeviceUUIDPage.dart';
import 'package:cd_automation/pages/Notification/NotificationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cd_automation/firebase_options.dart';
import 'package:cd_automation/pages/AdminLoginPage.dart';
import 'package:cd_automation/pages/AdminPages/PowerMeterList.dart';
import 'package:cd_automation/pages/AdminPages/WaterMeterList.dart';
import 'package:cd_automation/pages/AdminPages/AddAdminPage.dart';
import 'package:cd_automation/pages/AdminPages/AddRegularUserPage.dart';
import 'package:cd_automation/pages/AdminPages/AdminUserListPage.dart';
import 'package:cd_automation/pages/AdminPages/PowermeterPage.dart';
import 'package:cd_automation/pages/AdminPages/RegularUserListPage.dart';
import 'package:cd_automation/pages/AdminPages/UserEditOption.dart';
import 'package:cd_automation/pages/AdminPages/UserListPage.dart';
import 'package:cd_automation/pages/DashboardPage.dart';
import 'package:cd_automation/pages/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cd_automation",
      initialRoute: "/",
      routes: {
        "/": (context) => GetStartedPage(),
        "/device_uuid": (context) => DeviceUUIDPage(),
        "/auth/login": (context) => LoginPage(),
        "/dashboard": (context) => DashboardPage(),
        "/admin/userlist": (context) => UserListPage(),
        "/admin/adminlist": (context) => AdminUserListPage(),
        "/admin/regularlist": (context) => RegularUserListPage(),
        "/admin/add/adminUser": (context) => AddAdminPage(),
        "/admin/add/regularUser": (context) => AddRegularUserPage(),
        "/admin/editoption": (context) => UserEditPage(userName: "Jhon Doe"),
        //"/admin/editregularuserform": (context) => EditUserFormPage(),
        //"/admin/editadminform": (context) => EditAdminPage(),
        "/admin/powerMeter": (context) => PowerMeterPage(),
        "/admin/waterMeterList": (context) => WaterMeterList(
              scaffoldKey: GlobalKey<ScaffoldState>(),
            ),
        "/admin/powerMeterList": (context) => PowerMeterList(
              scaffoldKey: GlobalKey<ScaffoldState>(),
            ),
        //"/admin/addnewwatermeter": (context) => AddNewWaterMeter(),
        // "/admin/watermeter/edit": (context) =>
        //     WaterMeterEditOption(userName: "Hello1")
        //"/admin/edit/watermeter/name": (context) => EditWaterMeter(),

        "/admin/reading/powermeter": (context) => PowerMeterReadingPage(
              scaffoldKey: GlobalKey<ScaffoldState>(),
            ),
        "/admin/reading/watermeter": (context) => WaterMeterReadingPage(
              scaffoldKey: GlobalKey<ScaffoldState>(),
            ),
        // "/admin/reading/meterScanner/qr": (context) => MeterScannerPage(),
        // // "/admin/reading/scannerviewpage": (context) => Scannerviewpage(
        //       userName: "Power meter",
        //       scaffoldKey: GlobalKey<ScaffoldState>(),
        //     ),
        // "/admin/reading/scannerdetailspage": (context) => Scannerdetailspage(
        //       userName: "Ro meter",
        //       scaffoldKey: GlobalKey<ScaffoldState>(),
        //     ),
        // "/admin/reading/scannerviewreport": (context) => Scannerviewreport(
        //       scaffoldKey: GlobalKey<ScaffoldState>(),
        //     ),

        "/admin/dashboard/watermeterlist": (context) => Watermeterlistdash(),
        "/admin/dashboard/powermeterlist": (context) =>
            Powermeterlistdashpage(),
        "/notification": (context) => NotificationPage(),
        // "/admin/dashboard/watermeterlist/details": (context) =>
        //     Watermeterdetailsdash(watermetername: "watermetername")

        "/admin/download/report/watermeter/list": (context) =>
            Watermeterlistdwnrpt(),
        "/admin/download/report/powermeter/list": (context) =>
            Powermeterlistdwnrpt()
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/admin/watermeter': // Handle dynamic routes
            return MaterialPageRoute(builder: (context) => PowerMeterPage());
          default:
            return MaterialPageRoute(
                builder: (context) => LoginPage()); // Create a 404 page
        }
      },
    );
  }
}
