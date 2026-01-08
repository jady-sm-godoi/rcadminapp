class AppException {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}