import 'dart:io';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('SocketException') || 
        errorStr.contains('Failed host lookup') || 
        errorStr.contains('NetworkIsUnreachable') ||
        error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (errorStr.contains('TimeoutException')) {
      return 'Connection timed out. Please try again.';
    }
    return 'An error occurred: $error';
  }
}
