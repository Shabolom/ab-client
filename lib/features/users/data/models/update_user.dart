/// All fields are optional per the gateway's schema — omitted fields are
/// left as-is server-side, so only send what actually changed.
class UpdateUser {
  const UpdateUser({this.mail, this.name, this.age});

  final String? mail;
  final String? name;
  final int? age;

  Map<String, dynamic> toJson() => {
        if (mail != null) 'mail': mail,
        if (name != null) 'name': name,
        if (age != null) 'age': age,
      };
}
