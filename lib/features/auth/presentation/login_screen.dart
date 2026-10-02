import 'package:flutter/material.dart';

import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller, this.isMock = false});

  final AuthController controller;

  /// When true, the app is running against the in-memory mock backend
  /// (`--dart-define=USE_MOCK_API=true`) rather than the real gateway.
  final bool isMock;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  static const _demoMail = 'admin@example.com';
  static const _demoPassword = 'demo1234';

  void _fillDemoCredentials() {
    setState(() {
      _isRegisterMode = false;
      _mailController.text = _demoMail;
      _passwordController.text = _demoPassword;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = _isRegisterMode
        ? await widget.controller.register(
            mail: _mailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
            age: int.tryParse(_ageController.text.trim()) ?? 0,
          )
        : await widget.controller.login(
            mail: _mailController.text.trim(),
            password: _passwordController.text,
          );
    if (!success && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.science_outlined,
                            size: 40, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(
                          'AB Admin',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          _isRegisterMode ? 'Создайте аккаунт' : 'Войдите в аккаунт',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (widget.isMock) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Демо-режим: бэкенд не используется, все данные фейковые.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Демо-доступ: $_demoMail / $_demoPassword',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: _fillDemoCredentials,
                                    child: const Text('Подставить'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _mailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Почта'),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Укажите почту' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Пароль'),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Укажите пароль' : null,
                        ),
                        if (_isRegisterMode) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Имя'),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Укажите имя' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Возраст'),
                            validator: (v) {
                              final age = int.tryParse(v?.trim() ?? '');
                              return age == null ? 'Укажите возраст числом' : null;
                            },
                          ),
                        ],
                        if (widget.controller.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            widget.controller.errorMessage!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: widget.controller.isSubmitting ? null : _submit,
                          child: widget.controller.isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(_isRegisterMode ? 'Зарегистрироваться' : 'Войти'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: widget.controller.isSubmitting
                              ? null
                              : () => setState(() => _isRegisterMode = !_isRegisterMode),
                          child: Text(_isRegisterMode
                              ? 'Уже есть аккаунт? Войти'
                              : 'Нет аккаунта? Зарегистрироваться'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
