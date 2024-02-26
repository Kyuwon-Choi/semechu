class FoodDetailModel {
  final String menuName, menuImage, place, foodUUID, category, price;
  final double rating;
  final int reviewCnt;

  FoodDetailModel({
    required this.menuImage,
    required this.menuName,
    required this.place,
    required this.rating,
    required this.price,
    required this.foodUUID,
    required this.category,
    required this.reviewCnt,
  });

  factory FoodDetailModel.fromJson(Map<String, dynamic> json) {
    return FoodDetailModel(
      menuImage: json['imageUrl'],
      menuName: json['name'],
      place: json['place'],
      rating: json['rating'].toDouble(),
      price: json['price'],
      foodUUID: json['foodUUID'],
      category: json['category'],
      reviewCnt: json['reviewCnt'],
    );
  }
}
