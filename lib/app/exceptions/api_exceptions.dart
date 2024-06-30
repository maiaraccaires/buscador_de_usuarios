class ApiException implements Exception {
  final Object object;
  final String message;

  ApiException({
    required this.object,
    required this.message,
  });

  @override
  String toString() => 'ApiException: (Object: $object. Message: $message)';
}
