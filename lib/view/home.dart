import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_meal/model/parentRecipesCat.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<ParentRecipesCat>? ofrecipeCat;

  void getParentCat() async {
    try {
      var getParentApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_parent_category_list"));
      if (getParentApi.statusCode == 200) {
        ofrecipeCat =
            ParentRecipesCat.ofrecipeCat(jsonDecode(getParentApi.body));
        setState(() {});
        print("Response : $ofrecipeCat");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    getParentCat();
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
      backgroundColor: const Color(0xFFD8D8D8),
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
            child: Text(
              "Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ofrecipeCat == null
                ? Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Row(
                    children: [
                      for (int i = 0; i < ofrecipeCat!.length; i++) ...{
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            height: 100,
                            width: 90,
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  height: 75,
                                  width: 75,
                                  fit: BoxFit.fill,
                                  imageUrl: "${ofrecipeCat![i].catImage}",
                                  placeholder: (context, url) => Image.asset(
                                    "assets/dummy-placeholder.png",
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/insta_meal.png"),
                                ),
                                Text("data")
                              ],
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
