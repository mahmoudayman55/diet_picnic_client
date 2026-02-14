import 'dart:developer';

class VideoModel {
  final String id;
  final String name;
  final bool availableForAll;
  final String videoLink;
  final String imageUrl;

  VideoModel({
    required this.id,
    required this.name,
    required this.availableForAll,
    required this.videoLink,
    required this.imageUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json, String id) {
    log(json.toString());
    return VideoModel(
    id: id,
    name: json['name'] ?? '',
    videoLink: json['videoLink'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    availableForAll: json['availableForAll'] ?? false,
  );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'videoLink': videoLink,
    'imageUrl': imageUrl,
    'availableForAll': availableForAll,
  };
}
