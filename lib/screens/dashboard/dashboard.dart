import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_connection_poc/screens/connectivity/connectivity.dart';
import 'package:flutter_connection_poc/screens/location/location.dart';
import 'package:flutter_connection_poc/screens/location_requirer/requirer.dart';
import 'package:flutter_connection_poc/screens/specs/specs.dart';
import 'package:geolocator/geolocator.dart';

enum TabItem { Location, Connectivity, Specs }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => checkLocationPermission(context));
  }

  void checkLocationPermission(BuildContext context) async {
    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LocationRequirer())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POC de Conectividade"),
      ),
      body: _buildContents(),
      bottomNavigationBar: _buildNavigationBar(context),
    );
  }

  Widget _buildContents() {
    switch (TabItem.values[selectedTab]) {
      case TabItem.Location:
        return Location();
        break;
      case TabItem.Connectivity:
        return ConnectivityAnalyser(); 
        break;
      case TabItem.Specs:
        return Specs();
        break;
    }

    return Container();
  }

  void _updateTabItem(int index) {
    _updateSelectedTab(index);
  }

  void _updateSelectedTab(int index) {
    setState(() {
      this.selectedTab = index;
    });
  }

  Widget _buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        _buildNavItem(context,
            icon: Icons.location_on, text: describeEnum(TabItem.Location)),
        _buildNavItem(context,
            icon: Icons.wifi, text: describeEnum(TabItem.Connectivity)),
        _buildNavItem(context,
            icon: Icons.phone_iphone, text: describeEnum(TabItem.Specs)),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: this.selectedTab,
      onTap: _updateTabItem,
    );
  }

  BottomNavigationBarItem _buildNavItem(BuildContext context,
      {IconData icon, String text}) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text(text));
  }
}
