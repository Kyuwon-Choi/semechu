import 'package:flutter/material.dart';
import 'package:semechu/models/food_category.dart';
import 'package:semechu/screens/review_screen.dart';
import 'package:semechu/services/api_services.dart';
import 'dart:math';

class FoodListScreen extends StatefulWidget {
  final String category;

  const FoodListScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  ApiService apiService = ApiService();
  List<FoodCategoryModel> foods = [];
  FoodCategoryModel? recommendedFood;

  @override
  void initState() {
    super.initState();
    fetchFoods(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFFF9417), width: 2),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    fetchFoods('학관');
                  },
                  child: const Text('학생회관'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFFF9417), width: 2),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('진관홀'),
                  onPressed: () {
                    fetchFoods('진관');
                  },
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReviewScreen(foodUUID: foods[index].foodUUID),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              foods[index].menuImage,
                              width: 97,
                              height: 88,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                foods[index].menuName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  foods[index].place,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '⭐️ ${foods[index].rating}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 100,
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFFF9417), width: 2),
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  '랜덤 음식 추천',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  recommendRandomFood();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 음식 데이터를 API에서 불러오는 함수.
  void fetchFoods(String place) async {
    List<FoodCategoryModel> fetchedFoods =
        await apiService.getFoodsByCategory(widget.category, place: place);

    setState(() {
      foods = fetchedFoods;
    });
  }

  // 랜덤한 음식을 추천하는 함수
  void recommendRandomFood() {
    if (foods.isEmpty) {
      return;
    }

    int randomIndex = Random().nextInt(foods.length);

    setState(() {
      recommendedFood = foods[randomIndex];
    });

    // 음식이 선택되었을 때 ReviewScreen으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(foodUUID: recommendedFood!.foodUUID),
      ),
    );
  }
}
