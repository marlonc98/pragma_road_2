import 'package:flutter/material.dart';
import 'package:remote_data_kit/remote_data_kit.dart';
import 'package:portal_remoto/presentation/constants/text_constants.dart';

extension CharacterStatusLabel on CharacterStatus {
  String get textKey => switch (this) {
    CharacterStatus.alive => TextConstants.characterStatusAlive,
    CharacterStatus.dead => TextConstants.characterStatusDead,
    CharacterStatus.unknown => TextConstants.characterStatusUnknown,
  };

  Color get color => switch (this) {
    CharacterStatus.alive => Colors.green,
    CharacterStatus.dead => Colors.red,
    CharacterStatus.unknown => Colors.grey,
  };
}

extension CharacterGenderLabel on CharacterGender {
  String get textKey => switch (this) {
    CharacterGender.female => TextConstants.characterGenderFemale,
    CharacterGender.male => TextConstants.characterGenderMale,
    CharacterGender.genderless => TextConstants.characterGenderGenderless,
    CharacterGender.unknown => TextConstants.characterGenderUnknown,
  };

  IconData get icon => switch (this) {
    CharacterGender.female => Icons.female,
    CharacterGender.male => Icons.male,
    CharacterGender.genderless ||
    CharacterGender.unknown => Icons.question_mark,
  };
}
