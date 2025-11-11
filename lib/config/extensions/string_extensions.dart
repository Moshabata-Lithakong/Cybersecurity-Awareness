extension StringExtensions on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  String get trimAndLower => trim().toLowerCase();

  String get removeExtraSpaces => replaceAll(RegExp(r'\s+'), ' ').trim();

  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isStrongPassword {
    if (length < 6) return false;
    // Check for at least one number and one letter
    final hasNumber = RegExp(r'[0-9]').hasMatch(this);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(this);
    return hasNumber && hasLetter;
  }

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  String get obfuscateEmail {
    if (!isEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${'*' * username.length}@$domain';
    }
    
    final firstChar = username[0];
    final lastChar = username[username.length - 1];
    final stars = '*' * (username.length - 2);
    
    return '$firstChar$stars$lastChar@$domain';
  }
}