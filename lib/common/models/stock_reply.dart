import 'err_info_reason.dart';

/// The generic ack shape most write endpoints (`create*`, `set*`, `update*`
/// rollout/status) reply with.
class StockReply {
  const StockReply({required this.errInfoReason, required this.message});

  factory StockReply.fromJson(Map<String, dynamic> json) {
    return StockReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      message: json['message'] as String? ?? '',
    );
  }

  final ErrInfoReason errInfoReason;
  final String message;

  bool get isOk => errInfoReason == ErrInfoReason.statusOk;
}
