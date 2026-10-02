import '../../../../common/models/err_info_reason.dart';

/// The session token itself never appears here — the gateway sets it as a
/// cookie, which [ApiClient]'s cookie jar picks up automatically.
class AuthReply {
  const AuthReply({required this.errInfoReason, required this.message});

  factory AuthReply.fromJson(Map<String, dynamic> json) {
    return AuthReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      message: json['message'] as String? ?? '',
    );
  }

  final ErrInfoReason errInfoReason;
  final String message;

  bool get isOk => errInfoReason == ErrInfoReason.statusOk;
}
