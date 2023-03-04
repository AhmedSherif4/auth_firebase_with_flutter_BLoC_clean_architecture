// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class BaseException implements Exception {
  final String errorMessage;
  BaseException(
    this.errorMessage,
  );
}

class UnknownException extends BaseException {
  UnknownException(super.errorMessage);
}

