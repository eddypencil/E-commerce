class CategoryModel{
  final String slug;
  final String name;
  final String url;

  CategoryModel({required this.slug, required this.name, required this.url});

  factory CategoryModel.fromjson(Map<String, dynamic> json){
   return CategoryModel(
      url: json['url'] as String? ?? "",
      name: json['name'] as String? ?? "",
      slug: json['slug'] as String? ?? "",
    );

  }

  Map<String, dynamic> toJson(){
    return {
      "slug":slug,
      'name':name,
      'url':url
    };

  }

}