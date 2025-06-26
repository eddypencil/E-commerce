class BadRequestException implements Exception {
  final String message;
  BadRequestException([this.message = 'Bad request']);
  @override
  String toString() => 'BadRequestException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);
  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Not found']);
  @override
  String toString() => 'NotFoundException: $message';
}

class ServerErrorException implements Exception {
  final String message;
  ServerErrorException([this.message = 'Internal server error']);
  @override
  String toString() => 'ServerErrorException: $message';
}