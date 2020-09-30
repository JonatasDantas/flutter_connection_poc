import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_info/sim_info.dart';

class ConnectivityAnalyser extends StatefulWidget {
  @override
  _ConnectivityAnalyserState createState() => _ConnectivityAnalyserState();
}

class _ConnectivityAnalyserState extends State<ConnectivityAnalyser> {
  static bool offline = false;
  Map<String, dynamic> _connectionData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: FlatButton(
              onPressed: () => getConnectivityInfo(),
              child: Text(
                offline ? "Sem Internet" : "Capturar Dados de conexão",
                style: TextStyle(color: Colors.white),
              ),
              color: offline
                  ? Colors.grey[600]
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          ..._connectionData.keys.map((String property) {
            return InfoItem(
              title: property,
              data: _connectionData[property],
              icon: Icons.wifi,
            );
          }).toList()
          // ListView(
          //   children: _connectionData.keys.map((String property) {
          //     return InfoItem(
          //       title: property,
          //       data: _connectionData[property],
          //       icon: Icons.wifi,
          //     );
          //   }).toList(),
          // )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool state = false;

      if (result == ConnectivityResult.none) {
        final snackBar = SnackBar(
          content: Text('Perca de conexão detectada!'),
        );
        state = true;

        Scaffold.of(context).showSnackBar(snackBar);
      }

      setState(() => offline = state);
    });
  }

  void getConnectivityInfo() async {
    var wifiBSSID = await (Connectivity().getWifiBSSID());
    var wifiIP = await (Connectivity().getWifiIP());
    var wifiName = await (Connectivity().getWifiName());

    var data = <String, dynamic>{
      'Wifi BSSId': wifiBSSID,
      'IP': wifiIP,
      'Wifi Name': wifiName,
    };

    if (await Permission.phone.request().isGranted) {
      data = {
        ...data,
        'VOIP': await SimInfo.getAllowsVOIP,
        'Nome da Operadora': await SimInfo.getCarrierName,
        'Codigo País': await SimInfo.getIsoCountryCode,
        'mobileCountryCode': await SimInfo.getMobileCountryCode,
        'mobileNetworkCode': await SimInfo.getMobileNetworkCode
      };
    }

    setState(() {
      _connectionData = data;
    });
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
