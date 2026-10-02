import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/shell/presentation/admin_shell.dart';
import 'gateway_client.dart';

class AbAdminApp extends StatefulWidget {
  const AbAdminApp({super.key, required this.gatewayClient});

  final GatewayClient gatewayClient;

  @override
  State<AbAdminApp> createState() => _AbAdminAppState();
}

class _AbAdminAppState extends State<AbAdminApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController(widget.gatewayClient.auth, widget.gatewayClient.users);
    _authController.bootstrap();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMock = widget.gatewayClient.isMock && !AppConfig.hideDemoHints;
    return MaterialApp(
      title: 'AB Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      builder: (context, child) {
        if (!isMock || child == null) return child ?? const SizedBox.shrink();
        return Banner(
          message: 'DEMO',
          location: BannerLocation.topEnd,
          color: Colors.deepOrange,
          child: child,
        );
      },
      home: AnimatedBuilder(
        animation: _authController,
        builder: (context, _) {
          switch (_authController.status) {
            case AuthStatus.unknown:
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            case AuthStatus.unauthenticated:
              return LoginScreen(controller: _authController, isMock: isMock);
            case AuthStatus.authenticated:
              return AdminShell(
                gatewayClient: widget.gatewayClient,
                authController: _authController,
              );
          }
        },
      ),
    );
  }
}
