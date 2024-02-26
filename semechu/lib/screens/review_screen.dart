import 'package:flutter/material.dart';
import 'package:semechu/models/food_detail.dart';

import 'package:semechu/models/review.dart';
import 'package:semechu/models/review_create.dart';
import 'package:semechu/models/user_info.dart';

import 'package:semechu/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  final String foodUUID;

  const ReviewScreen({super.key, required this.foodUUID});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  String _review = '';
  late Future<List<ReviewCreateModel>> _reviewsFuture; // 리뷰 리스트를 불러올 Future
  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성

  void _submitReview() async {
    // 카카오 토큰 가져오기
    String kakaoToken = await _apiService.loadOAuthToken();

    UserModel user = UserModel(oauthId: kakaoToken);
    print("dd$kakaoToken");
    // JWT 토큰 발급받기
    AuthResponse authResponse = await _apiService.getJwtToken(user);

    // 리뷰 생성 모델 생성
    ReviewCreateModel review = ReviewCreateModel(
      content: _review,
      score: _rating,
      foodUUID: widget.foodUUID,
    );

    // 서버에 리뷰 생성 요청 보내기
    await _apiService.createReview(
      review,
      authResponse.authToken,
    );

    // 리뷰 리스트 다시 불러오기
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 작성'),
      ),
      body: Column(
        children: [
          FutureBuilder<FoodDetailModel>(
            future: ApiService().fetchDetailFood(widget.foodUUID),
            builder: (BuildContext context,
                AsyncSnapshot<FoodDetailModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  children: <Widget>[
                    Image.network(snapshot.data!.menuImage),
                    Text(snapshot.data!.menuName),
                    Text(snapshot.data!.price), // price를 String으로 변환
                    Text(snapshot.data!.place),
                  ],
                );
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<ReviewModel>>(
              future: ApiService().fetchReviews(widget.foodUUID),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ReviewModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  print('Fetched reviews count: ${snapshot.data!.length}');
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  snapshot.data![index].content,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    height: 0.09,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '⭐️ ${snapshot.data![index].score.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    height: 0.09,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9417),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // 리뷰 작성 버튼
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('리뷰 작성'),
                        content: TextField(
                          controller: _reviewController,
                          decoration: const InputDecoration(
                            hintText: '리뷰를 작성해주세요.',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () {
                              setState(() {
                                _review = _reviewController.text;
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '리뷰 작성',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 별점 주기 버튼
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '별점 주기',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Slider(
                                value: _rating,
                                min: 0.0,
                                max: 5.0,
                                divisions: 10,
                                onChanged: (double value) {
                                  setState(() {
                                    _rating = value;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: const Text('확인'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.black),
                      Text(
                        ' $_rating',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 등록 버튼
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  _submitReview();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '등록',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
