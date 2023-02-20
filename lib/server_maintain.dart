import 'package:flutter/material.dart';

class ServerMaintain extends StatelessWidget {
  const ServerMaintain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image(
            image: AssetImage("assets/images/server_maintenance.png"),
          ),
        ),
      ),
    );
  }
}
