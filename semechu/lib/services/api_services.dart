import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:semechu/models/food_category.dart';
import 'package:semechu/models/food_detail.dart';
import 'package:semechu/models/food_main.dart';

import 'package:semechu/models/review.dart';
import 'package:semechu/models/review_create.dart';
import 'package:semechu/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResponse {
  final String authToken;
  final String memberUUID;

  AuthResponse({required this.authToken, required this.memberUUID});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      authToken: json['data']['authToken'],
      memberUUID: json['data']['memberUUID'],
    );
  }
}

class ApiService {
  static const String baseUrl =
      'http://3.37.129.202:8080'; // 실제 API URL로 변경해주세요.

  Future<FoodMainModel> fetchFoods() async {
    var url = Uri.parse('$baseUrl/api/foods/mainFood'); // 실제 API URL로 변경해주세요.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return FoodMainModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load foods.');
    }
  }

  //음식 디테일
  Future<FoodDetailModel> fetchDetailFood(String foodUUID) async {
    final url = Uri.parse('$baseUrl/api/foods/$foodUUID');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> data = jsonResponse['data'];
      return FoodDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load food');
    }
  }

  //카테고리
  Future<List<FoodCategoryModel>> getFoodsByCategory(String category,
      {String place = '학관',
      int page = 0,
      int size = 100,
      String sort = 'rating,desc'}) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/api/foods?category=$category&place=$place&page=$page&size=$size&sort=$sort"));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is Map) {
        final foodInfoResponseList = data['data']['foodInfoResponseList'];

        if (foodInfoResponseList is List) {
          return foodInfoResponseList
              .map((item) => FoodCategoryModel.fromJson(item))
              .toList();
        } else {
          throw Exception('Expected list but got something else');
        }
      } else {
        throw Exception('Expected map but got something else');
      }
    } else {
      throw Exception("Failed to load foods by category");
    }
  }

  // 리뷰 정보를 가져오는 함수
  Future<List<ReviewModel>> fetchReviews(String foodUUID) async {
    final url = Uri.parse('$baseUrl/api/reviews/$foodUUID');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> reviewList = jsonResponse['data']['reviewInfoList'];
      List<ReviewModel> reviews =
          reviewList.map((item) => ReviewModel.fromJson(item)).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<String> loadProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("토큰 ${prefs.getString('profileInfo')}");
    String oauthId= prefs.getString('profileInfo') ?? '';
    return oauthId.substring(5, 15);
  }

  Future<String> loadOAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("idToken: ${prefs.getString('idToken')}");
    return prefs.getString('idToken') ?? '';
  }

  Future<AuthResponse> getJwtToken(UserModel user) async {
    String oauthId = await loadProfileInfo();
    print("authToken: $oauthId");
    UserModel updatedUser = UserModel(
      oauthId: oauthId,
      email: user.email,
      name: user.name,
    );

    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedUser.toJson()),
    );

    if (response.statusCode != 200) {
      print('code: ${response.statusCode}');
      throw Exception('Failed to get JWT token');
    }

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return AuthResponse.fromJson(jsonResponse);
  }

  Future<void> createReview(ReviewCreateModel review, String jwtToken) async {
    final url = Uri.parse('$baseUrl/api/reviews');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create review');
    }
  }
}
