class User {
  final String username;
  final String profileImage;
  final String id;

  User({
    this.id,
    this.username,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      profileImage: json['profileImage'],
      username: json['username'],
    );
  }
}
