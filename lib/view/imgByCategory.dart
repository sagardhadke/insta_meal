import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_meal/model/categoryImg.dart';
import 'package:insta_meal/view/foodreDetails.dart';
import 'package:readmore/readmore.dart';

class MyImgCategory extends StatefulWidget {
  const MyImgCategory({super.key});

  @override
  State<MyImgCategory> createState() => _MyImgCategoryState();
}

class _MyImgCategoryState extends State<MyImgCategory> {
  var response;
  List<CategoryImg>? ofrecipes;

  void getImgCategory() async {
    try {
      var catimgApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_post_list?category_id=5"));
      if (catimgApi.statusCode == 200) {
        ofrecipes = CategoryImg.ofrecipes(jsonDecode(catimgApi.body));
        // response = ofrecipes(jsonDecode(catimgApi.body));
        setState(() {});
        print(ofrecipes);
      }
    } catch (e) {
      print("Error + ${e.toString()}");
    }
  }

  @override
  void initState() {
    getImgCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Category"),
        backgroundColor: Colors.amber,
      ),
      body: ofrecipes == null
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: ofrecipes!.length,
              itemBuilder: (context, i) {
                var ingredients = ofrecipes![i].ingredients;

                List<String> ingredientList = (ingredients ?? '')
                    .split(',')
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                        //  final String recipeId = ofrecipes![i].id!;
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => MyRecipeDetails(id: recipeId),
                      //   ),);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          "${ofrecipes![i].images}",
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/kcal.png"),
                              SizedBox(width: 10),
                              Text("${ofrecipes![i].calories}" + " calories")
                            ],
                          ),
                        ),
                        Text(
                          "Ingredients",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     "• ${ingredients}",
                        //     style: TextStyle(
                        //         color: Colors.grey, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ingredientList.map((ingredient) {
                              return Text(
                                '• $ingredient', // Adding bullet points for each ingredient
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          "methods",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ReadMoreText(
                          "${ofrecipes![i].methods}",
                          trimLines: 3,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
