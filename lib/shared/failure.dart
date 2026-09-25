class Failure {
  final String message;
  final Map<String, dynamic>? extraData;

  const Failure(this.message, {this.extraData});

  @override
  String toString() => 'Failure(message: $message, extraData: $extraData)';
}
