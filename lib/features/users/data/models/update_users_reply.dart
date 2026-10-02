import '../../../../common/models/err_info_reason.dart';
import 'user.dart';

class UpdateUsersReply {
  const UpdateUsersReply({
    required this.errInfoReason,
    required this.user,
    required this.message,
  });

  factory UpdateUsersReply.fromJson(Map<String, dynamic> json) {
    return UpdateUsersReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );
  }

  final ErrInfoReason errInfoReason;
  final User user;
  final String message;
}
