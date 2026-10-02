import 'package:flutter/material.dart';

import '../../../common/format.dart';
import '../../../common/widgets/async_list_view.dart';
import '../../../common/widgets/feature_scaffold.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/models/user.dart';
import 'edit_profile_dialog.dart';
import 'users_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    super.key,
    required this.controller,
    required this.authController,
  });

  final UsersController controller;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Пользователи',
      subtitle: 'Все зарегистрированные пользователи',
      trailing: OutlinedButton.icon(
        onPressed: () => showEditProfileDialog(
          context,
          usersController: controller,
          authController: authController,
        ),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Мой профиль'),
      ),
      child: AsyncListView<User>(
        controller: controller.list,
        emptyLabel: 'Пользователей пока нет',
        itemBuilder: (context, user) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(user.name.isEmpty ? '?' : user.name[0].toUpperCase())),
            title: Text(user.name.isEmpty ? user.mail : user.name),
            subtitle: Text('${user.mail} · ${user.age} лет · с ${formatDate(user.createdAt)}'),
            trailing: user.id == authController.currentUser?.id
                ? const Chip(label: Text('Вы'))
                : null,
          ),
        ),
      ),
    );
  }
}
