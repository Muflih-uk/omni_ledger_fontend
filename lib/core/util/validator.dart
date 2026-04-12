class Validators {
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }

    if (value.length != 10) {
      return "Enter valid number";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  static String? itemName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter item name";
    }
    return null;
  }

  static String? itemPrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter price";
    }
    if (double.tryParse(value) == null) {
      return "Invalid number";
    }
    return null;
  }
}
