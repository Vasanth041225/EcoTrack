class UserModel {
  final String uid;
  final String email;
  final String role;
  final bool banned; 

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.banned, 
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "role": role,
      "banned": banned, 
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      email: map["email"],
      role: map["role"],
      banned: map["banned"] ?? false, 
    );
  }
}
