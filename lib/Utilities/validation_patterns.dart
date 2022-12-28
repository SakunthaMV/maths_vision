bool emailValidity(String email) {
  const String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}

bool phoneValidity(String number){
  const String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  final RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(number);
}
