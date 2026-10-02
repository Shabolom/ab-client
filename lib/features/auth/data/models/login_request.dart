class LoginRequest {
  const LoginRequest({required this.mail, required this.password});

  final String mail;
  final String password;

  Map<String, dynamic> toJson() => {'mail': mail, 'password': password};
}
