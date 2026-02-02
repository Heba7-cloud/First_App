class UserModel {
  // 1. تغيير النوع من int إلى String
  String? id;
  String name;
  String email;
  String password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      // 2. التأكد من تحويل القيمة القادمة من قاعدة البيانات لنص
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}