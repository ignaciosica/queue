import 'package:groupify/common/common.dart';

class FormzDateTime extends FormzBase<DateTime?, String> implements CopyableFormzMixin<DateTime?> {
  const FormzDateTime.dirty({
    DateTime? value,
    this.min,
    this.max,
    this.initial,
    this.empty = true,
  }) : super.dirty(value);

  const FormzDateTime.pure({
    DateTime? value,
    this.min,
    this.max,
    this.initial,
    this.empty = true,
  }) : super.pure(value);

  static const String invalidEmpty = 'Date must not be empty.';
  static const String invalidMin = 'Date must be more recent than:';
  static const String invalidMax = 'Date must be before than:';

  @override
  final bool empty;
  final DateTime? min;
  final DateTime? max;
  final DateTime? initial;

  @override
  FormzDateTime copyWith({DateTime? value}) {
    return FormzDateTime.dirty(value: value ?? this.value, min: min, max: max, empty: empty, initial: initial);
  }

  @override
  String? validator(DateTime? value) {
    if (value == null && !empty) return invalidEmpty;

    if (_isMinInvalid(value)) return invalidMin;

    if (_isMaxInvalid(value)) return invalidMax;

    return null;
  }

  bool _isMinInvalid(DateTime? value) => min != null && (value?.isBefore(min!) ?? false);

  bool _isMaxInvalid(DateTime? value) => max != null && (value?.isAfter(max!) ?? false);

  @override
  bool get isEmpty => value == null;

  @override
  dynamic toJsonValue() {
    return value?.toIso8601String();
  }
}
