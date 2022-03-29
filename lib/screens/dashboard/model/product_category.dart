

class ProductCategory {
  String categoryName;
  String key;

  ProductCategory(
      {this.categoryName,
        this.key
      });

  ProductCategory.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
