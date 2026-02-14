import 'dart:developer';

class SubOffer {
  final String id;
  final String image;
  final String name;
  final String packageId,mainOfferId;
  final String level;
  final int order;
  final double oldPrice, newPrice;

  SubOffer({
    required this.id,
    required this.image,
    required this.name,
    required this.order,
    required this.packageId,
    required this.mainOfferId,
    required this.level,
    required this.newPrice,
    required this.oldPrice,
  });

  factory SubOffer.fromJson(Map<String, dynamic> json,String offerName) => SubOffer(
    image: json['image'] ?? '',
    packageId: json['package_id'] ?? '',
    level: json['level'],
    id: json['id'],
    name: offerName,
    mainOfferId: json['offer_id'],
    newPrice: double.parse(json['new_price'].toString()),
    oldPrice: double.parse(json['old_price'].toString()), order: json['order'],
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'package_id': packageId,
        'offer_id': mainOfferId,
        'image': image,
        'name': name,
        'new_price': newPrice,
        'old_price': oldPrice,
        'level': level,
      };
}

class OfferModel {
  final String id;
  final int order;
  final String name;
  final bool isAvailable;
  final String coverImage;
  final List<SubOffer> subOffers;

  OfferModel({
    required this.id,
    required this.order,
    required this.name,
    required this.isAvailable,
    required this.coverImage,
    required this.subOffers,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json, String id) =>
      OfferModel(
        id: id,
        name: json['name'] ?? '',
        order: json['order'] ?? 0,
        isAvailable: json['isAvailable'] ,
        coverImage: json['cover_image'] ?? '',
        subOffers: (json['sub_offers'] as List<dynamic>? ?? [])
            .map((e) => SubOffer.fromJson(e as Map<String, dynamic>,json['name']))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'order': order,
        'isAvailable': isAvailable,
        'cover_image': coverImage,
        'sub_offers': subOffers.map((e) => e.toJson()).toList(),
      };


  List<String> getPackageIds() {
    log(subOffers.map((subOffer) => subOffer.packageId).toList().toString());
    return subOffers.map((subOffer) => subOffer.packageId).toList();
  }

}
