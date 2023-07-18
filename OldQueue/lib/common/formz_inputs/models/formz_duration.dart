import 'package:groupify/common/common.dart';
import 'package:intl/intl.dart';

class FormzDuration extends FormzBase<Duration?, String> {
  const FormzDuration.dirty({
    Duration? value,
    this.min,
    this.max,
    this.empty = true,
  }) : super.dirty(value);

  const FormzDuration.pure({
    Duration? value,
    this.min,
    this.max,
    this.empty = true,
  }) : super.pure(value);

  static const String invalidEmptyErrorMessage = 'Field should not be empty.';
  static const String invalidMinErrorMessage = 'Field should higher than ${1}';
  static const String invalidMaxErrorMessage = 'Field should lower than ${1}';

  @override
  final bool empty;
  final Duration? min;
  final Duration? max;

  @override
  FormzDuration copyWith({Duration? value}) {
    return FormzDuration.dirty(value: value ?? this.value, min: min, max: max);
  }

  @override
  String? validator(Duration? value) {
    if (value == null && !empty) return invalidEmptyErrorMessage;
    if (_isMinInvalid(value)) return Intl.message(invalidMinErrorMessage, args: [min!]);
    if (_isMaxInvalid(value)) return Intl.message(invalidMaxErrorMessage, args: [max!]);

    return null;
  }

  bool _isMinInvalid(Duration? value) => min != null && (value! < min!);

  bool _isMaxInvalid(Duration? value) => max != null && (value! > max!);

  @override
  bool get isEmpty => value == null;

  @override
  dynamic toJsonValue() {
    return value.toString();
  }
}
