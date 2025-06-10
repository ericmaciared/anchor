class NotificationIdGenerator {
  static var current = 0;

  static Future<int> next() async {
    current += 1;
    return current;
  }
}
