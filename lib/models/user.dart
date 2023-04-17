class UserModel {
  int? userId;
  String? name;
  String? profilePic;
  String? contactNumber;
  String? email;
  String? address;

  UserModel({
    required this.userId,
    required this.name,
    required this.profilePic,
    required this.contactNumber,
    required this.email,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      profilePic: json['profilePic'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'profilePic': profilePic,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
    };
  }
}

List<UserModel> userModels = <UserModel>[];
