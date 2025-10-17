class KhabokiRegex {
  static final RegExp email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static final RegExp phone = RegExp(r'^\d{11}$');

  static final password = RegExp(r'^[a-zA-Z0-9#@!%&\.]{8,}$');

  static final RegExp numeric = RegExp(r'^[0-9]+$');

  static bool validPassword(String s) {
    return password.hasMatch(s);
  }

  static bool validUserId(String id) {
    return numeric.hasMatch(id);
  }
}
