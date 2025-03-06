class Metaphone {
  static String encode(String input) {
    if (input.isEmpty) {
      return "";
    }

    input = input.toUpperCase();
    var output = "";

    for (var i = 0; i < input.length; i++) {
      var c = input[i];
      var code = _getMetaphoneCode(c, i, input);

      if (code != null) {
        if (i > 0 && _isVowel(input[i - 1])) {
          if (code != 'H' && code != 'W') {
            output += code;
          }
        } else {
          output += code;
        }
      }
    }

    // Remove trailing 'H's
    while (output.isNotEmpty && output[output.length - 1] == 'H') {
      output = output.substring(0, output.length - 1);
    }

    // Limit length to 4 characters
    if (output.length > 4) {
      output = output.substring(0, 4);
    }

    return output;
  }

  static String? _getMetaphoneCode(String c, int i, String input) {
    switch (c) {
      case 'A':
      case 'E':
      case 'I':
      case 'O':
      case 'U':
        return null;
      case 'B':
        return 'B';
      case 'C':
        if (i == 0 || _isVowel(input[i - 1])) {
          return 'K';
        } else {
          return 'S';
        }
      case 'D':
        if (i == 0 || _isVowel(input[i - 1])) {
          return 'T';
        } else {
          return 'D';
        }
      case 'F':
        if (i == 0) {
          return 'F';
        } else {
          return 'V';
        }
      case 'G':
        if (i == 0) {
          return 'G';
        } else {
          return 'J';
        }
      case 'H':
        if (i == 0 || ((i == 1) && (input[i - 1] == 'W')) || ((i == 2) && (input[i - 1] == 'W' && input[i - 2] == 'H'))) {
          return 'H';
        } else {
          return null;
        }
      case 'J':
        if (i == 0) {
          return 'J';
        } else {
          return 'D';
        }
      case 'K':
        return 'K';
      case 'L':
        return 'L';
      case 'M':
        return 'M';
      case 'N':
        return 'N';
      case 'P':
        return 'P';
      case 'Q':
        return 'Q';
      case 'R':
        return 'R';
      case 'S':
        if (i == 0) {
          return 'S';
        } else {
          return 'Z';
        }
      case 'T':
        if (i == 0) {
          return 'T';
        } else {
          return 'D';
        }
      case 'V':
        return 'V';
      case 'W':
        if (i == 0) {
          return 'W';
        } else {
          return null;
        }
      case 'X':
        if (i == 0) {
          return 'K';
        } else {
          return 'X';
        }
      case 'Y':
        if (i == 0) {
          return 'Y';
        } else {
          return 'W';
        }
      case 'Z':
        return 'Z';
      default:
        return null;
    }
  }

  static bool _isVowel(String c) {
    return ['A', 'E', 'I', 'O', 'U'].contains(c);
  }
}
