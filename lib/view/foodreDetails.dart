import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_meal/model/recipeDetails.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

class MyRecipeDetails extends StatefulWidget {
  final String id;
  final String catName;
  const MyRecipeDetails({required this.id, required this.catName, Key? key})
      : super(key: key);

  @override
  State<MyRecipeDetails> createState() => _MyRecipeDetailsState();
}

class _MyRecipeDetailsState extends State<MyRecipeDetails> {
  var response;
  List<RecipeDetails>? ofrecipes;
  bool isLoading = true;
  String errorMessage = '';

  void recipesDetailsApi() async {
    try {
      var recipedetailsApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_post_list?category_id=" +
              "${widget.id}"));
      print("API URL : $recipedetailsApi");
      if (recipedetailsApi.statusCode == 200) {
        ofrecipes = RecipeDetails.ofrecipes(jsonDecode(recipedetailsApi.body));
        print("Response : $response");
        setState(() {});
        if (ofrecipes == null || ofrecipes!.isEmpty) {
          errorMessage = "No Recipe Found";
        }
      } else {
        errorMessage = "Error: No Recipe Found!";
      }
    } catch (e) {
      errorMessage = "Recipe Data Not Found";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    recipesDetailsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe Details"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator.adaptive()
              : errorMessage.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/insta_meal.png"),
                        SizedBox(height: 20),
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ],
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.fill,
                                imageUrl: "${ofrecipes![i].images}",
                                placeholder: (context, url) => Image.asset(
                                  "assets/dummy-placeholder.png",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset("assets/insta_meal.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.55,
                                      child: Text(
                                        widget.catName,
                                        style: GoogleFonts.hind(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Image.asset("assets/kcal.png"),
                                    SizedBox(width: 5),
                                    Text("${ofrecipes![i].calories}" +
                                        " calories")
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
                        );
                      }),
        ));
  }
}
