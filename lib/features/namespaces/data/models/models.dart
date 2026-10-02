class CreateNamespaceRequest {
  const CreateNamespaceRequest({required this.name, this.description});

  final String name;
  final String? description;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
      };
}

class GetNamespace {
  const GetNamespace({required this.id, required this.name, required this.description});

  factory GetNamespace.fromJson(Map<String, dynamic> json) {
    return GetNamespace(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  final int id;
  final String name;
  final String description;
}

class GetNamespacesResponse {
  const GetNamespacesResponse({required this.message, required this.namespaces});

  factory GetNamespacesResponse.fromJson(Map<String, dynamic> json) {
    return GetNamespacesResponse(
      message: json['message'] as String? ?? '',
      namespaces: (json['namespaces'] as List<dynamic>? ?? [])
          .map((e) => GetNamespace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String message;
  final List<GetNamespace> namespaces;
}

class GetNamespaceByIDResponse {
  const GetNamespaceByIDResponse({required this.message, required this.namespace});

  factory GetNamespaceByIDResponse.fromJson(Map<String, dynamic> json) {
    return GetNamespaceByIDResponse(
      message: json['message'] as String? ?? '',
      namespace: GetNamespace.fromJson(json['namespace'] as Map<String, dynamic>),
    );
  }

  final String message;
  final GetNamespace namespace;
}
