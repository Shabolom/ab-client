class CreateCustomParamRequest {
  const CreateCustomParamRequest({
    required this.name,
    required this.namespaceId,
    required this.type,
  });

  final String name;
  final int namespaceId;
  final String type;

  Map<String, dynamic> toJson() => {
        'name': name,
        'namespace_id': namespaceId,
        'type': type,
      };
}

class GetCustomParam {
  const GetCustomParam({
    required this.id,
    required this.namespaceId,
    required this.name,
    required this.type,
  });

  factory GetCustomParam.fromJson(Map<String, dynamic> json) {
    return GetCustomParam(
      id: json['id'] as int,
      namespaceId: json['namespace_id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  final int id;
  final int namespaceId;
  final String name;
  final String type;
}

class GetCustomParamsResponse {
  const GetCustomParamsResponse({required this.message, required this.customParams});

  factory GetCustomParamsResponse.fromJson(Map<String, dynamic> json) {
    return GetCustomParamsResponse(
      message: json['message'] as String? ?? '',
      customParams: (json['custom_params'] as List<dynamic>? ?? [])
          .map((e) => GetCustomParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String message;
  final List<GetCustomParam> customParams;
}

class GetCustomParamByIDResponse {
  const GetCustomParamByIDResponse({required this.message, required this.customParam});

  factory GetCustomParamByIDResponse.fromJson(Map<String, dynamic> json) {
    return GetCustomParamByIDResponse(
      message: json['message'] as String? ?? '',
      customParam:
          GetCustomParam.fromJson(json['custom_param'] as Map<String, dynamic>),
    );
  }

  final String message;
  final GetCustomParam customParam;
}
