class LogInWithSpotifyFailure implements Exception {
  const LogInWithSpotifyFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  final String message;
}
