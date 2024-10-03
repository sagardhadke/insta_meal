import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_meal/model/childCategory.dart';
import 'package:insta_meal/model/parentRecipesCat.dart';
import 'package:insta_meal/view/foodreDetails.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<ParentRecipesCat>? ofrecipeCat;
  List<ChildCategory>? ofChildCat;

  void getParentCat() async {
    try {
      var getParentApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_parent_category_list"));
      if (getParentApi.statusCode == 200) {
        ofrecipeCat =
            ParentRecipesCat.ofrecipeCat(jsonDecode(getParentApi.body));
        setState(() {});
        print("Parent Response : $ofrecipeCat");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getChildCat() async {
    try {
      var getchildApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_child_category_list?parent_id=1"));
      if (getchildApi.statusCode == 200) {
        ofChildCat = ChildCategory.ofChildCat(jsonDecode(getchildApi.body));
        setState(() {});
        print("Child API Response : $ofChildCat");
      }
    } catch (e) {}
  }

  @override
  void initState() {
    getParentCat();
    getChildCat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello, Sagar Welcome, 👋🏻",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.green,
      ),
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            width: double.infinity,
            "assets/head.png",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Text(
                  "view all",
                  style: TextStyle(fontSize: 17, color: Colors.green[800]),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ofChildCat == null
                ? Center(child: CircularProgressIndicator.adaptive())
                : Row(
                    children: [
                      for (int i = 0; i < ofChildCat!.length; i++) ...{
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyRecipeDetails(
                                            id: ofChildCat![i].id.toString(),
                                            catName: ofrecipeCat![i]
                                                .catName
                                                .toString(),
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 135,
                              width: 90,
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    height: 75,
                                    width: 75,
                                    fit: BoxFit.fill,
                                    imageUrl: "${ofChildCat![i].catImg}",
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
                                    child: Text(
                                      "${ofChildCat![i].catName}",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
