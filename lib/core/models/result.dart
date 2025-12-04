class Result<T> {
  final bool isSuccess;
  final T? data;
  final String? message;

  const Result._({
    required this.isSuccess,
    this.data,
    this.message,
  });

  factory Result.success(T data, [String? message]) {
    return Result._(
      isSuccess: true,
      data: data,
      message: message,
    );
  }

  factory Result.failure(String message) {
    return Result._(
      isSuccess: false,
      message: message,
    );
  }

  bool get isFailure => !isSuccess;
}
