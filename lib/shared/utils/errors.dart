class BackendExepction implements Exception {
  final String message;
  final int? code;

  BackendExepction(this.message, {this.code});
  

  
  @override
  String toString() {
    return 'BackendExepction{message: $message, code: $code}';
  }

  String get status {
    switch (code) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 404:
        return 'Not Found';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Unknown Error';
    }
  }
}
