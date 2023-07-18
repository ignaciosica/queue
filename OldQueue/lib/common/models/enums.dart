import 'package:flutter/material.dart';

mixin BaseEnum {
  String get enumIdentifier;

  String get text;
}

mixin IconEnum on BaseEnum {
  IconData get icon;
}

class Enums {
  static const Map<String, List<IconEnum>> map = {
    'privacy_enum': PrivacyEnum.values,
    'cost_enum': NewCostEnum.values,
    'explore_options_enum': ExploreOptionEnum.values,
  };
}

enum PrivacyEnum with BaseEnum, IconEnum {
  public('Public', Icons.public_rounded),
  friends('Friends', Icons.people_rounded),
  private('Private', Icons.lock_person_rounded);

  const PrivacyEnum(this.text, this.icon);

  @override
  final String enumIdentifier = 'privacy_policy_enum';

  @override
  final String text;

  @override
  final IconData icon;
}

enum NewCostEnum with BaseEnum, IconEnum {
  free('Free', Icons.money_off_rounded),
  firstTier('1 to 20', Icons.attach_money_rounded),
  secondTier('20 to 100', Icons.attach_money_rounded);

  const NewCostEnum(this.text, this.icon);

  @override
  final String enumIdentifier = 'cost_tier_enum';

  @override
  final String text;

  @override
  final IconData icon;
}

enum ExploreOptionEnum with BaseEnum, IconEnum {
  plans('Plans', Icons.event_rounded),
  people('People', Icons.people_rounded),
  communities('Communities', Icons.apartment_rounded);

  const ExploreOptionEnum(this.text, this.icon);

  @override
  final String enumIdentifier = 'explore_options_enum';

  @override
  final String text;

  @override
  final IconData icon;
}

enum GenderEnum with BaseEnum, IconEnum {
  male('Male', Icons.male_rounded),
  female('Female', Icons.female_rounded),
  other('Other', Icons.transgender_rounded);

  const GenderEnum(this.text, this.icon);

  @override
  final String enumIdentifier = 'gender_enum';

  @override
  final String text;

  @override
  final IconData icon;
}
