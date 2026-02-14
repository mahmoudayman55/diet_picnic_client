class BookModel {
  final String id;
  final String name;
  final bool availableForAll;
  final String link;
  final String imageUrl;

  BookModel({
    required this.id,
    required this.name,
    required this.availableForAll,
    required this.link,
    required this.imageUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json, String id) => BookModel(
    id: id,
    name: json['name'] ?? '',
    link: json['link'] ?? '',
    imageUrl: json['imageUrl'] ?? '', availableForAll: json['availableForAll']??false,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'link': link,
    'imageUrl': imageUrl,
    'availableForAll': availableForAll,
  };
} 