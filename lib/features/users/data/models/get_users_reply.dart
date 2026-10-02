import '../../../../common/models/err_info_reason.dart';
import 'user.dart';

class GetUsersReply {
  const GetUsersReply({required this.errInfoReason, required this.users});

  factory GetUsersReply.fromJson(Map<String, dynamic> json) {
    return GetUsersReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      users: (json['users'] as List<dynamic>? ?? [])
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final ErrInfoReason errInfoReason;
  final List<User> users;
}
