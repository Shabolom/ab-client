import 'package:flutter/material.dart';

import 'app.dart';
import 'gateway_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final gatewayClient = await GatewayClient.create();
  runApp(AbAdminApp(gatewayClient: gatewayClient));
}
