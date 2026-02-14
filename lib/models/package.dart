class Package {
  final String id;
  final String name;

  Package({
    required this.id,
    required this.name,
  });

  /// 🟢 من JSON
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  /// 🟢 إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // /// 🟢 نسخة وهمية (Fake) للاختبار
  // factory Package.fake() {
  //   return Package(
  //     id: 'pkg_${DateTime.now().millisecondsSinceEpoch}',
  //     name: 'VIP Package 💎',
  //   );
  // }

  @override
  String toString() => name;

  /// 🟢 مفيد لو حابب تعمل مقارنة بين الباقات
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Package && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
