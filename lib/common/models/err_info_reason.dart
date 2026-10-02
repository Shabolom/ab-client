/// Mirrors the gateway's `ErrInfoReason` enum.
///
/// Note the gateway conflates two kinds of information in one enum:
/// [statusOk] means "no error", the others mean "error, and this is which
/// kind". A response is only successful when this is [statusOk].
enum ErrInfoReason {
  unspecified,
  validationError,
  invalidRequest,
  statusOk;

  static ErrInfoReason fromJson(String? value) {
    switch (value) {
      // ab-gate-way omits the field on success (`{"message": "success"}`)
      // and reports failures with a non-2xx status instead, which surfaces
      // as an ApiException before any reply model is parsed.
      case null:
        return ErrInfoReason.statusOk;
      case 'VALIDATION_ERROR':
        return ErrInfoReason.validationError;
      case 'INVALID_REQUEST':
        return ErrInfoReason.invalidRequest;
      case 'STATUS_OK':
        return ErrInfoReason.statusOk;
      case 'UNSPECIFIED':
      default:
        return ErrInfoReason.unspecified;
    }
  }

  String toJson() {
    switch (this) {
      case ErrInfoReason.validationError:
        return 'VALIDATION_ERROR';
      case ErrInfoReason.invalidRequest:
        return 'INVALID_REQUEST';
      case ErrInfoReason.statusOk:
        return 'STATUS_OK';
      case ErrInfoReason.unspecified:
        return 'UNSPECIFIED';
    }
  }
}
