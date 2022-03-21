
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
class LogoutPage extends StatefulWidget {
  LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sair"),
        centerTitle: true,
      ),
body: Padding(padding: EdgeInsets.symmetric(vertical: 24),
    child: OutlinedButton(
      onPressed: () => context.read<AuthService>().logout(),
      style: OutlinedButton.styleFrom(
        primary: Colors.red,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(16),
          child: Text("Sair do App",
          style: TextStyle(fontSize: 18),
          ),
          )
        ],
      ),
    ),
)

    );
  }
}