import '../../../../common/models/err_info_reason.dart';
import 'user.dart';

class DeleteUsersReply {
  const DeleteUsersReply({
    required this.errInfoReason,
    required this.user,
    required this.message,
  });

  factory DeleteUsersReply.fromJson(Map<String, dynamic> json) {
    return DeleteUsersReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );
  }

  final ErrInfoReason errInfoReason;
  final User user;
  final String message;
}
