import '../../../../common/models/err_info_reason.dart';
import 'user.dart';

class GetUserReply {
  const GetUserReply({required this.errInfoReason, required this.user});

  factory GetUserReply.fromJson(Map<String, dynamic> json) {
    return GetUserReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      // The gateway currently returns the user object itself rather than
      // wrapping it in `{"user": ...}` as the openapi spec describes.
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? json),
    );
  }

  final ErrInfoReason errInfoReason;
  final User user;
}
