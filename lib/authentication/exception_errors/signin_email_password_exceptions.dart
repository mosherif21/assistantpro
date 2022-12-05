class SignInWithEmailAndPasswordFailure {
  final String errorMessage;
  const SignInWithEmailAndPasswordFailure(
      [this.errorMessage = "An unknown error occurred"]);
  factory SignInWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'user-not-found':
        return const SignInWithEmailAndPasswordFailure(
            'There is no user with this email');
      case 'wrong-password':
        return const SignInWithEmailAndPasswordFailure(
            'Password entered is incorrect');
      default:
        return const SignInWithEmailAndPasswordFailure('');
    }
  }
}
