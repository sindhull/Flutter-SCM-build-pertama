import 'package:apk_sinduuu/screens/JammerScreen.dart';
import 'package:apk_sinduuu/screens/home_screen.dart';
import 'package:apk_sinduuu/screens/MyProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class MainPage extends StatefulWidget {
  final int index;
  const MainPage({super.key, required this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PersistentTabController _controller;

  List<Widget> _listPage = [
    HomePage(),
    JammerScreen(),
    // MapScreen(),
    MyProfile(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ), PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.antenna_radiowaves_left_right),
        title: ("Drone Jammer"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(CupertinoIcons.location_circle),
      //   title: ("Jammer Location"),
      //   activeColorPrimary: Colors.indigo,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // print(_controller.index);
        if (_controller.index == 0) {
          showAlertDialog(BuildContext context) {

            // set up the button
            Widget okButton = TextButton(
              child: Text("OK"),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            );

            // set up the button
            Widget closeButton = TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("Keluar"),
              content: Text("Apakah anda ingin keluar dari aplikasi ?"),
              actions: [
                closeButton,
                okButton,
              ],
            );

            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }
          showAlertDialog(context);
          return false;
        }
        return true;
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _listPage,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style13, // Choose the nav bar style with this property.
      ),
    );
  }
}
