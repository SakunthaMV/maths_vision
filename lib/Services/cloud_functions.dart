import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctions {
  static Future<void> testFunction() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkFunction');
    try {
      final response = await callable.call();
      print(response.data);
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Error: ${e.toString()}');
    } catch (e) {
      print(e.toString());
    }
  }
}