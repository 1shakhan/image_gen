import 'dart:math';

class MockApiService {
  static int attempts = 0;

  Future<String> getImageLink() async {
    attempts++;
    final ms = 2000 + Random().nextInt(999);
    await Future.delayed(Duration(milliseconds: ms));
    if (attempts % 3 != 0) return 'https://placehold.co/400/png';
    throw Exception('attempts $attempts');
  }
}
