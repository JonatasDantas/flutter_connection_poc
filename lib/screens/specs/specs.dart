import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Specs extends StatefulWidget {
  @override
  _SpecsState createState() => _SpecsState();
}

class _SpecsState extends State<Specs> {
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: FlatButton(
              onPressed: () => getDeviceInfo(),
              child: Text(
                "Capturar Dados do dispositivo",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          ..._deviceData.keys.map((String property) {
            return InfoItem(
              title: property,
              data: _deviceData[property],
              icon: Icons.wifi,
            );
          }).toList()
        ],
      ),
    );
  }

  void getDeviceInfo() async  {
    Map<String, dynamic> data;

    try {
      if (Platform.isAndroid) {
        data = _readAndroidInfo(await DeviceInfoPlugin().androidInfo, await ImeiPlugin.getImei());
      } else if (Platform.isIOS) {
        data = _readIosInfo(await DeviceInfoPlugin().iosInfo, await ImeiPlugin.getImei());
      }
    } on PlatformException {
      data = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    setState(() {
      _deviceData = data;
    });
  }

  _readAndroidInfo(AndroidDeviceInfo data, String imei) {
    return <String, dynamic> {
      "Fabricante": data.manufacturer,
      "Modelo": data.model,
      "Plataforma": "Android",
      "Versão SO": data.version.release,
      "IMEI": imei
    };
  }

  _readIosInfo(IosDeviceInfo data, String imei) {
    return <String, dynamic> {
      "Fabricante": "Apple",
      "Modelo": data.model,
      "Plataforma": "iOS",
      "Versão SO": data.systemVersion,
      "IMEI": imei
    };
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  InfoItem({this.icon, @required this.title, this.data})
      : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(data),
    );
  }
}
