import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationRequirer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permissões"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Prezado Usuário,'),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'É necessário conceder permissão para que o aplicativo possa '
              'efetuar medições adequadamente.',
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Sem a permissão necessária não será possível executar testes de medição.',
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: FlatButton(
                  child: Text(
                    "Conceder Permissão",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColorDark,
                  onPressed: () => _requireLocation(context),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: FlatButton(
                  child: Text(
                    "Fechar",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.orange,
                  onPressed: () => _requireLocation(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  _requireLocation(BuildContext context) async {
    var permission = await requestPermission();
    Navigator.of(context).pop(permission);
  }
}
