class RegisterRequest {
  const RegisterRequest({
    required this.mail,
    required this.password,
    required this.name,
    required this.age,
  });

  final String mail;
  final String password;
  final String name;
  final int age;

  Map<String, dynamic> toJson() => {
        'mail': mail,
        'password': password,
        'name': name,
        'age': age,
      };
}
