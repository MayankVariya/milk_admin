class LoginModel {
  String? id;
  String? pass;
  bool? isprofilecomplited;
  LoginModel(
      {required this.id, required this.pass, required this.isprofilecomplited});

  LoginModel.fromMap(map) {
    id = map["id"];
    pass = map["pass"];
    if (map["isprofilecomplited"] != null) {
      isprofilecomplited = map["isprofilecomplited"];
    } else {
      isprofilecomplited = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "pass": pass, "isprofilecomplited": isprofilecomplited};
  }
}
