import 'dart:math';

class NotificationIdGenerator {
  static const _max = 0x7FFFFFFF;
  static var random = Random();

  static Future<int> next() async {
    var id = random.nextInt(_max);
    return id;
  }
}
