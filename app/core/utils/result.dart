/// Простой sealed-результат для операций, которые могут упасть.
/// Используется там, где не хочется throw (например, в use-case).
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) success,
    required R Function(Object error, StackTrace? stack) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.value);
    if (self is Failure<T>) return failure(self.error, self.stack);
    throw StateError('Unreachable');
  }
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

class Failure<T> extends Result<T> {
  const Failure(this.error, [this.stack]);
  final Object error;
  final StackTrace? stack;
}