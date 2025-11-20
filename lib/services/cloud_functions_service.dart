import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Complete match using cloud function
  Future<Map<String, dynamic>> completeMatch(String matchId) async {
    try {
      final callable = _functions.httpsCallable('completeMatch');
      final result = await callable.call<Map<String, dynamic>>({
        'matchId': matchId,
      });

      return result.data;
    } catch (e) {
      print('Error calling completeMatch function: $e');
      rethrow;
    }
  }
}