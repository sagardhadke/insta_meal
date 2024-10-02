import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insta_meal/model/categoryImg.dart';
import 'package:readmore/readmore.dart';

class MyImgCategory extends StatefulWidget {
  const MyImgCategory({super.key});

  @override
  State<MyImgCategory> createState() => _MyImgCategoryState();
}

class _MyImgCategoryState extends State<MyImgCategory> {
  var response;
  List<CategoryImg>? ofcatimg;

  void getImgCategory() async {
    try {
      var catimgApi = await http.get(Uri.parse(
          "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_post_list?category_id=5"));
      if (catimgApi.statusCode == 200) {
        ofcatimg = CategoryImg.ofcatimg(jsonDecode(catimgApi.body));
        // response = ofcatimg(jsonDecode(catimgApi.body));
        setState(() {});
        print(ofcatimg);
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
      body: ofcatimg == null
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: ofcatimg!.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        "${ofcatimg![i].images}",
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
                            Text("${ofcatimg![i].calories}" + " calories")
                          ],
                        ),
                      ),
                      Text(
                        "Ingredients",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${ofcatimg![i].ingredients}",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "methods",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      ReadMoreText(
                        "${ofcatimg![i].methods}",
                        trimLines: 3,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
