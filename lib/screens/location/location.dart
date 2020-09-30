import 'package:flutter/material.dart';
import 'package:flutter_connection_poc/screens/location_requirer/requirer.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  static String locationText = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () => getLocation(context),
            child: Text(
              "Capturar Localização",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColorDark,
          ),
          Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              "Resultado: $locationText",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void getLocation(BuildContext context) async {
    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LocationRequirer()));
    }

    if ([LocationPermission.always, LocationPermission.whileInUse]
        .contains(permission)) {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

      setState(() => locationText = position.toString());

    } else {
      setState(() => locationText = "Localização não foi compartilhada!");
    }
  }
}
