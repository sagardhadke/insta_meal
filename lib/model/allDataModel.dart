
class AllDataModel {
    List<AllCategories>? allCategories;
    List<AllPosts>? allPosts;

    AllDataModel({this.allCategories, this.allPosts});

    AllDataModel.fromJson(Map<String, dynamic> json) {
        allCategories = json["all_categories"] == null ? null : (json["all_categories"] as List).map((e) => AllCategories.fromJson(e)).toList();
        allPosts = json["all_posts"] == null ? null : (json["all_posts"] as List).map((e) => AllPosts.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(allCategories != null) {
            _data["all_categories"] = allCategories?.map((e) => e.toJson()).toList();
        }
        if(allPosts != null) {
            _data["all_posts"] = allPosts?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class AllPosts {
    String? postId;
    String? calories;
    String? ingredients;
    String? methods;
    String? postImage;
    String? thumbImage;
    List<String>? catId;

    AllPosts({this.postId, this.calories, this.ingredients, this.methods, this.postImage, this.thumbImage, this.catId});

    AllPosts.fromJson(Map<String, dynamic> json) {
        postId = json["post_id"];
        calories = json["calories"];
        ingredients = json["ingredients"];
        methods = json["methods"];
        postImage = json["post_image"];
        thumbImage = json["thumb_image"];
        catId = json["cat_id"] == null ? null : List<String>.from(json["cat_id"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["post_id"] = postId;
        _data["calories"] = calories;
        _data["ingredients"] = ingredients;
        _data["methods"] = methods;
        _data["post_image"] = postImage;
        _data["thumb_image"] = thumbImage;
        if(catId != null) {
            _data["cat_id"] = catId;
        }
        return _data;
    }
}

class AllCategories {
    String? id;
    String? catName;
    String? catImage;
    String? thumbImage;

    AllCategories({this.id, this.catName, this.catImage, this.thumbImage});

    AllCategories.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        catName = json["cat_name"];
        catImage = json["cat_image"];
        thumbImage = json["thumb_image"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["cat_name"] = catName;
        _data["cat_image"] = catImage;
        _data["thumb_image"] = thumbImage;
        return _data;
    }
}