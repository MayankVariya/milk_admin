import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milk_admin_panel/models/user.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelByProfile() async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("admin").doc("profile").get();
    if (docSnap.data() != null) {
      userModel = UserModel.fromJson(docSnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
