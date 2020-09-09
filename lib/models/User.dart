class User {
  final String username;
  final String email;
  final String password;
  final String profileImage;
  final String createdAt;
  final String updatedAt;
  final String id;

  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      createdAt: json['createdAt'],
      email: json['email'],
      password: json['password'],
      profileImage: json['profileImage'],
      updatedAt: json['updatedAt'],
      username: json['username'],
    );
  }
}
