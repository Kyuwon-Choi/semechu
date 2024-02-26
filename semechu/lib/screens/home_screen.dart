import 'package:flutter/material.dart';
import 'package:semechu/models/food_main.dart';
import 'package:semechu/screens/food_list_screen.dart';
import 'package:semechu/screens/review_screen.dart';
import 'package:semechu/services/api_services.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFFFF6B17),
            ),
            onPressed: () {
              // Save the context to a local variable
              final context = this.context;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('로그아웃 하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('예'),
                        onPressed: () async {
                          // Use the context saved to the local variable
                          (context);
                        },
                      ),
                      TextButton(
                        child: const Text('아니오'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            const Flexible(
              flex: 0,
              child: Center(
                  child: Text(
                '세메추',
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFFFF9417),
                  fontWeight: FontWeight.w600,
                ),
              )),
            ),
            const SizedBox(
              height: 80,
            ),
            Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: makeButton,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '📌    추천 메뉴',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<FoodMainModel>(
                future: ApiService().fetchFoods(),
                builder: (BuildContext context,
                    AsyncSnapshot<FoodMainModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          snapshot.data!.data.foodInfoResponseList.length,
                      itemBuilder: (context, index) {
                        FoodInfo food =
                            snapshot.data!.data.foodInfoResponseList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewScreen(foodUUID: food.foodUUID),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: 250,
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Image.network(food.imageUrl),
                                    Text(food.name),
                                    Text(food.place),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get makeButton {
    return <Widget>[
      Column(
        children: [
          IconButton(
            icon: Image.asset(
              "images/buttons/rice.png",
              width: 80,
              height: 80,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodListScreen(category: 'RICE'),
                ),
              );
            },
          ),
          const Text(
            '밥류',
          ),
        ],
      ),
      Column(
        children: [
          IconButton(
            icon: Image.asset(
              "images/buttons/noodle.png",
              width: 80,
              height: 80,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FoodListScreen(category: 'NOODLE'),
                ),
              );
            },
          ),
          const Text(
            '면류',
          ),
        ],
      ),
      Column(
        children: [
          IconButton(
            icon: Image.asset(
              "images/buttons/meat.png",
              width: 80,
              height: 80,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodListScreen(category: 'MEET'),
                ),
              );
            },
          ),
          const Text(
            '육류',
          ),
        ],
      ),
      Column(
        children: [
          IconButton(
            icon: Image.asset(
              "images/buttons/soup.png",
              width: 80,
              height: 80,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodListScreen(category: 'STEW'),
                ),
              );
            },
          ),
          const Text(
            '탕/찌개류',
          ),
        ],
      ),
    ];
  }
}
