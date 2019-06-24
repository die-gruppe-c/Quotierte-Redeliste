import 'package:flutter/material.dart';

enum SpeechType { Statement, Frage, Antwort }

class SpeechTypeUtils {
  static enumToString(SpeechType type) => type.toString().split('.').last;
  static IconData iconForEnum(SpeechType type) {
    switch (type) {
      case SpeechType.Statement:
        return Icons.info_outline;
        break;
      case SpeechType.Frage:
        return Icons.help_outline;
        break;
      case SpeechType.Antwort:
        return Icons.question_answer;
        break;
    }

    return null;
  }
}
