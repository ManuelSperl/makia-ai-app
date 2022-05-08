/*
    Class creates a Http-Exception Message
 */
class HttpException implements Exception {
  final String message;

  HttpException({
    this.message,
  });

  @override
  String toString() {
    return message;
  }
}
