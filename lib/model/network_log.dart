class NectorNetworkLog {
  final String message;
  final dynamic error;
  final DateTime? loggedAt;
  final StackTrace? stackTrace;

  NectorNetworkLog({
    required this.message,
    this.loggedAt,
    this.error,
    this.stackTrace,
  });

  @override
  int get hashCode => Object.hash(loggedAt, message, error, stackTrace);

  @override
  bool operator ==(Object other) {
    return other is NectorNetworkLog &&
        loggedAt == other.loggedAt &&
        message == other.message &&
        error == other.error &&
        stackTrace == other.stackTrace;
  }
}
