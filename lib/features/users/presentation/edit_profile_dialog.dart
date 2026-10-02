import 'package:flutter/material.dart';

import '../../../common/widgets/form_dialog.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/models/update_user.dart';
import 'users_controller.dart';

Future<bool?> showEditProfileDialog(
  BuildContext context, {
  required UsersController usersController,
  required AuthController authController,
}) {
  final formKey = GlobalKey<FormState>();
  final user = authController.currentUser;
  final nameController = TextEditingController(text: user?.name ?? '');
  final mailController = TextEditingController(text: user?.mail ?? '');
  final ageController = TextEditingController(text: user?.age.toString() ?? '');

  return showDialog<bool>(
    context: context,
    builder: (context) => FormDialog(
      title: 'Редактировать профиль',
      formKey: formKey,
      onSubmit: () async {
        final error = await usersController.updateProfile(
          UpdateUser(
            name: nameController.text.trim(),
            mail: mailController.text.trim(),
            age: int.tryParse(ageController.text.trim()),
          ),
        );
        if (error != null) return error;
        await authController.bootstrap();
        return null;
      },
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: mailController,
            decoration: const InputDecoration(labelText: 'Почта'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Возраст'),
          ),
        ],
      ),
    ),
  );
}
