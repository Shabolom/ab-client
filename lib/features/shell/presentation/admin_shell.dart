import 'package:flutter/material.dart';

import '../../../gateway_client.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../custom_params/presentation/custom_params_controller.dart';
import '../../custom_params/presentation/custom_params_screen.dart';
import '../../experiments/presentation/experiments_controller.dart';
import '../../experiments/presentation/experiments_screen.dart';
import '../../feature_toggles/presentation/feature_toggles_controller.dart';
import '../../feature_toggles/presentation/feature_toggles_screen.dart';
import '../../layers/presentation/layers_controller.dart';
import '../../layers/presentation/layers_screen.dart';
import '../../namespaces/presentation/namespaces_controller.dart';
import '../../namespaces/presentation/namespaces_screen.dart';
import '../../users/presentation/users_controller.dart';
import '../../users/presentation/users_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.gatewayClient, required this.authController});

  final GatewayClient gatewayClient;
  final AuthController authController;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _Destination {
  const _Destination(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _AdminShellState extends State<AdminShell> {
  late final NamespacesController _namespaces;
  late final LayersController _layers;
  late final CustomParamsController _customParams;
  late final FeatureTogglesController _featureToggles;
  late final ExperimentsController _experiments;
  late final UsersController _users;

  int _selectedIndex = 0;

  static const _destinations = [
    _Destination('Эксперименты', Icons.science_outlined),
    _Destination('Неймспейсы', Icons.workspaces_outlined),
    _Destination('Слои', Icons.layers_outlined),
    _Destination('Кастомные параметры', Icons.tune),
    _Destination('Фича-тогглы', Icons.toggle_on_outlined),
    _Destination('Пользователи', Icons.people_outline),
  ];

  @override
  void initState() {
    super.initState();
    final client = widget.gatewayClient;
    _namespaces = NamespacesController(client.namespaces);
    _layers = LayersController(client.layers);
    _customParams = CustomParamsController(client.customParams);
    _featureToggles = FeatureTogglesController(client.featureToggles);
    _experiments = ExperimentsController(client.experiments);
    _users = UsersController(client.users);

    _namespaces.list.load();
    _layers.list.load();
    _customParams.list.load();
    _featureToggles.list.load();
    _experiments.list.load();
    _users.list.load();
  }

  @override
  void dispose() {
    _namespaces.dispose();
    _layers.dispose();
    _customParams.dispose();
    _featureToggles.dispose();
    _experiments.dispose();
    _users.dispose();
    super.dispose();
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return ExperimentsScreen(
          controller: _experiments,
          layers: _layers,
          customParams: _customParams,
        );
      case 1:
        return NamespacesScreen(controller: _namespaces);
      case 2:
        return LayersScreen(controller: _layers, namespaces: _namespaces);
      case 3:
        return CustomParamsScreen(controller: _customParams, namespaces: _namespaces);
      case 4:
        return FeatureTogglesScreen(controller: _featureToggles, namespaces: _namespaces);
      case 5:
      default:
        return UsersScreen(controller: _users, authController: widget.authController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final content = IndexedStack(
      index: _selectedIndex,
      children: List.generate(_destinations.length, _buildContent),
    );

    final railDestinations = _destinations
        .map((d) => NavigationRailDestination(
              icon: Icon(d.icon),
              label: Text(d.label),
            ))
        .toList();

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              minExtendedWidth: 220,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              destinations: railDestinations,
              leading: _RailHeader(authController: widget.authController),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _LogoutButton(authController: widget.authController),
                  ),
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_selectedIndex].label),
        actions: [_LogoutButton(authController: widget.authController)],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: _RailHeader(authController: widget.authController)),
            for (var i = 0; i < _destinations.length; i++)
              ListTile(
                leading: Icon(_destinations[i].icon),
                title: Text(_destinations[i].label),
                selected: i == _selectedIndex,
                onTap: () {
                  setState(() => _selectedIndex = i);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
      body: content,
    );
  }
}

class _RailHeader extends StatelessWidget {
  const _RailHeader({required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          CircleAvatar(child: Text((user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : '?')),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user?.name ?? '', overflow: TextOverflow.ellipsis),
                Text(
                  user?.mail ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Выйти',
      icon: const Icon(Icons.logout),
      onPressed: () => authController.logout(),
    );
  }
}
