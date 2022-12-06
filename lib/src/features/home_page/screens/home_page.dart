import 'package:assistantpro/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';

import '../../../connectivity/connectivity.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(true);
    return Scaffold(
      body: Container(
        color: Colors.cyan,
        child: TextButton(
          onPressed: () => AuthenticationRepository.instance.logoutUser(),
          child: const Text('logout'),
        ),
      ),
    );
  }
}
