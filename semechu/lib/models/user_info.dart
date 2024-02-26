class UserModel {
  final String name;
  final String email;
  final String oauthId;

  UserModel({
    this.name = 'Default Name', // 기본 이름 설정
    this.email = 'default@example.com', // 기본 이메일 설정
    required this.oauthId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? 'Default Name',
      email: json['email'] ?? 'default@example.com',
      oauthId: json['oauthId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'oauthId': oauthId,
    };
  }
}
