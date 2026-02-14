class SubTopic {
  final String image;
  final String description;

  SubTopic({required this.image, required this.description});

  factory SubTopic.fromJson(Map<String, dynamic> json) => SubTopic(
    image: json['image'] ?? '',
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'description': description,
  };

  /// 🟢 Dummy data
  static List<SubTopic> dummyList() {
    return [
      SubTopic(
        image: "https://picsum.photos/200/300?random=1",
        description: "هذا شرح مختصر لموضوع العرض الأول",
      ),
      SubTopic(
        image: "https://picsum.photos/200/300?random=2",
        description: "تفاصيل إضافية عن العرض الثاني",
      ),
      SubTopic(
        image: "https://picsum.photos/200/300?random=3",
        description: "مميزات العرض الثالث",
      ),
    ];
  }
}

class PackageGroup {
  final String id;
  final String name;
  final String packageId;

  PackageGroup({required this.id, required this.name, required this.packageId});

  factory PackageGroup.fromJson(Map<String, dynamic> json) => PackageGroup(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    packageId: json['packageId'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'packageId': packageId,
  };

  /// 🟢 Dummy data
  static List<PackageGroup> dummyList(String packageId) {
    return [
      PackageGroup(id: "group1", name: "المجموعة الأولى", packageId: packageId),
      PackageGroup(id: "group2", name: "المجموعة الثانية", packageId: packageId),
    ];
  }
}

class PackageModel {
  final String id;
  final int order;
  final String name;
  final String description;
  final String about;
  bool isAvailable;

  /// Base image (always required)
  final String baseImage;
  final String coverImage;

  /// Optional tiered images
  final String? vipImage;
  final String? eliteImage;
  final String? superEliteImage;

  final String type; // 'individual' or 'group'
  List<PackageGroup> groups;

  PackageModel({
    required this.id,
    required this.order,
    required this.name,
    required this.about,
    required this.isAvailable,
    required this.description,
    required this.baseImage,
    required this.coverImage,
    this.vipImage,
    this.eliteImage,
    this.superEliteImage,
    this.type = 'individual',
    this.groups = const [],
  });

  @override
  String toString() => name;

  factory PackageModel.fromJson(Map<String, dynamic> json, String id) =>
      PackageModel(
        id: id,
        name: json['name'] ?? '',
        order: json['order'] ?? 0,
        about: json['about'] ?? '',
        isAvailable: json['isAvailable'] ?? true,

        baseImage: json['baseImage'] ?? '',
        coverImage: json['coverImage'] ?? '',
        vipImage: json['vipImage'],
        eliteImage: json['eliteImage'],
        superEliteImage: json['superEliteImage'],
        type: json['type'] ?? 'individual',
        groups: (json['groups'] as List<dynamic>? ?? [])
            .map((e) => PackageGroup.fromJson(e as Map<String, dynamic>))
            .toList(),
        description: json['description'] ?? "",
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'order': order,
    'baseImage': baseImage,
    'isAvailable': isAvailable,
    'vipImage': vipImage,
    'eliteImage': eliteImage,
    'coverImage': coverImage,
    'superEliteImage': superEliteImage,
    'about': about,
    'type': type,
    'description': description,
    'groups': groups.map((e) => e.toJson()).toList(),
  };
}