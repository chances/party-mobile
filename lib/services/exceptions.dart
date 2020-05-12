class NestedException implements Exception {
  String message;
  Exception innerException;

  NestedException(this.message, [this.innerException]);

  String toString() => message;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> innerExceptionMessage = {
      'message': innerException.toString()
    };
    if (innerException is NestedException) {
      var ex = innerException as NestedException;
      innerExceptionMessage = ex.toJson();
    }

    return {'message': message, 'inner_exception': innerExceptionMessage};
  }
}
