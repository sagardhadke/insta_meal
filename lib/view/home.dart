import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_meal/model/allDataModel.dart';
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

  //All data
  AllDataModel? alldetails;
  List<AllCategories>? ofallcategories;

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
      print("Api Url : $getchildApi");
      if (getchildApi.statusCode == 200) {
        ofChildCat = ChildCategory.ofChildCat(jsonDecode(getchildApi.body));
        setState(() {});
        print("Child API Response : $ofChildCat");
      }
    } catch (e) {
      print("Error : ${e.toString()}");
    }
  }

  void getAllApi() async {
    try {
      var getallApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_all_data"));
      if (getallApi.statusCode == 200) {
        alldetails = AllDataModel.fromJson(jsonDecode(getallApi.body));
        ofallcategories = alldetails!.allCategories ?? [];
        print(ofallcategories);
        print("All API Worked");
        setState(() {});
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print("Error : ${e.toString()}");
    }
  }

  @override
  void initState() {
    getParentCat();
    getChildCat();
    getAllApi();
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
      body: SingleChildScrollView(
        child: Column(
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
                                              catName: ofChildCat![i]
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
                                      placeholder: (context, url) =>
                                          Image.asset(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "All Recipe",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            ofallcategories == null ? Center(child: CircularProgressIndicator.adaptive()) :
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 4),
                itemCount: ofallcategories!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyRecipeDetails(id: ofallcategories![i].id.toString(),
                           catName: ofallcategories![i].catName.toString())));
                           print("click");
                        },
                        child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: CachedNetworkImage(
                                    height: 135,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    imageUrl: "${ofallcategories![i].catImage}",
                                    placeholder: (context, url) => Image.asset(
                                      "assets/dummy-placeholder.png",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset("assets/insta_meal.png"),
                                  ),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  "${ofallcategories![i].catName}",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      );
                })
          ],
        ),
      ),
    );
  }
}
