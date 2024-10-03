import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:insta_meal/model/allDataModel.dart';

class MyAllDataApi extends StatefulWidget {
  const MyAllDataApi({super.key});

  @override
  State<MyAllDataApi> createState() => _MyAllDataApiState();
}

class _MyAllDataApiState extends State<MyAllDataApi> {
  var response;
  AllDataModel? alldatamodel;
  List<AllCategories>? ofCategory;
  List<AllPosts>? ofPosts;

  void getAllData() async {
    var alldataApi = await http.get(Uri.parse(
        "https://mapi.trycatchtech.com/v3/healthy_recipes/healthy_recipes_all_data"));

    if (alldataApi.statusCode == 200) {
      alldatamodel = AllDataModel.fromJson(jsonDecode(alldataApi.body));
      ofCategory = alldatamodel!.allCategories;
      setState(() {});
      print(ofCategory);
    }
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Data",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              children: [
                if (ofCategory != null) ...{
                  for (int i = 0; i < ofCategory!.length; i++) ...{
                    Container(
                      height: 160,
                      width: 100,
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: 135,
                            fit: BoxFit.fill,
                            imageUrl: "${ofCategory![i].catImage}",
                            placeholder: (context, url) =>
                                Image.asset("assets/dummy-placeholder.png"),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/insta_meal.png"),
                          ),
                          // Image.network("${ofCategory![i].catImage}"),
                          Text(
                            "${ofCategory![i].catName}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.hind(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    )
                  },
                }
              ],
            ),
          )
        ],
      ),
    );
  }
}
