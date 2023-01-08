import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctions {
  static Future<void> testFunction() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkFunction');
    final response = await callable.call();
    print(response.data);
  }
}