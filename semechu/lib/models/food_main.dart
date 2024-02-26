

class FoodMainModel {
  bool success;
  String code;
  String message;
  FoodData data;

  FoodMainModel({required this.success, required this.code, required this.message, required this.data});

  factory FoodMainModel.fromJson(Map<String, dynamic> json) {
    return FoodMainModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: FoodData.fromJson(json['data']),
    );
  }
}

class FoodData {
  List<FoodInfo> foodInfoResponseList;

  FoodData({required this.foodInfoResponseList});

  factory FoodData.fromJson(Map<String, dynamic> json) {
    return FoodData(
      foodInfoResponseList: (json['foodInfoResponseList'] as List)
          .map((i) => FoodInfo.fromJson(i))
          .toList(),
    );
  }
}

class FoodInfo {
  String imageUrl;
  String name;
  String price;
  String place;
  String category;
  double rating;
  String foodUUID;
  int reviewCnt;

  FoodInfo({required this.imageUrl, required this.name, required this.price, required this.place,
    required this.category, required this.rating, required this.foodUUID, required this.reviewCnt});

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
      place: json['place'],
      category: json['category'],
      rating: json['rating'].toDouble(),
      foodUUID: json['foodUUID'],
      reviewCnt: json['reviewCnt'],
    );
  }
}
