class CreateLayerRequest {
  const CreateLayerRequest({
    required this.namespaceId,
    required this.name,
    this.description,
  });

  final int namespaceId;
  final String name;
  final String? description;

  Map<String, dynamic> toJson() => {
        'namespace_id': namespaceId,
        'name': name,
        if (description != null) 'description': description,
      };
}

class GetLayer {
  const GetLayer({
    required this.id,
    required this.namespaceId,
    required this.name,
    required this.description,
  });

  factory GetLayer.fromJson(Map<String, dynamic> json) {
    return GetLayer(
      id: json['id'] as int,
      namespaceId: json['namespace_id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  final int id;
  final int namespaceId;
  final String name;
  final String description;
}

class GetLayersResponse {
  const GetLayersResponse({required this.message, required this.layers});

  factory GetLayersResponse.fromJson(Map<String, dynamic> json) {
    return GetLayersResponse(
      message: json['message'] as String? ?? '',
      layers: (json['layers'] as List<dynamic>? ?? [])
          .map((e) => GetLayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String message;
  final List<GetLayer> layers;
}

class GetLayerByIDResponse {
  const GetLayerByIDResponse({required this.message, required this.layer});

  factory GetLayerByIDResponse.fromJson(Map<String, dynamic> json) {
    return GetLayerByIDResponse(
      message: json['message'] as String? ?? '',
      layer: GetLayer.fromJson(json['layer'] as Map<String, dynamic>),
    );
  }

  final String message;
  final GetLayer layer;
}
