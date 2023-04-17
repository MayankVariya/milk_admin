import 'package:milk_admin_panel/models/login.dart';

 validateUserId(String? userId, List<LoginModel> loginModel) {
  if (userId == null || userId.isEmpty) {
    return "Please Enter Mobile Number";
  // ignore: unrelated_type_equality_checks
  } else if (userId != loginModel[0].id) {
    return "Please Enter Valid Mobile Number";
  } else {
    return null;
  }
}


validatePassword(String value) {
  if (value.isEmpty) {
    return 'Please enter Password';
  } else if (value.length <= 6) {
    "please enter more than 6 character password";
  }
}

String? validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Mobile Number must contain only Numbers';
  }else if (value.length != 10){
    return 'Mobile Number must be of 10 digit';}
  return null;
}

String? validateEmail(String value) {
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter Email Id';
  } else if (!regExp.hasMatch(value)) {
    return 'Enter in the format:name@example.com';
  }
  return null;
}

String? validateAddress(String value) {
  if (value.isEmpty) {
    return 'Please enter Address';
  }
  return null;
}
