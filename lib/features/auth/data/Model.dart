class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final String gender;
  final String image;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "gender": gender,
      "image": image,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"] ?? 0,
        username: json["username"]?? 'error',
        email: json["email"],
        firstname: json["firstname"]?? 'error',
        lastname: json["lastname"]?? 'error',
        gender: json["gender"]?? 'error',
        image: json["image"] ?? 'error');
  }
}
