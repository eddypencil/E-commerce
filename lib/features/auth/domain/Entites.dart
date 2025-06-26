class UserEntity {
  final int id;
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final String gender;
  final String image;

  UserEntity(
      {required this.id,
      required this.username,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.gender,
      required this.image});
}
