import 'package:groupify/common/common.dart';
import 'package:intl/intl.dart';

enum NumberValidationError { invalid }

class FormzNumber<T extends num> extends FormzBase<T?, String> {
  const FormzNumber.dirty({
    T? value,
    this.empty = defaultEmpty,
    this.min,
    this.max,
  }) : super.dirty(value);

  const FormzNumber.pure({
    T? value,
    this.empty = defaultEmpty,
    this.min,
    this.max,
  }) : super.pure(value);

  @override
  final bool empty;
  final T? min;
  final T? max;

  static const bool defaultEmpty = true;

  @override
  FormzNumber<T> copyWith({T? value}) {
    return FormzNumber<T>.dirty(
      value: value ?? this.value,
      empty: empty,
      min: min,
      max: max,
    );
  }

  static const String invalidEmptyErrorMessage = '${0} should not be empty.';
  static const String invalidMinErrorMessage = '${0} should higher than ${1}';
  static const String invalidMaxErrorMessage = '${0} should lower than ${1}';

  @override
  String? validator(T? value) {
    if (_isEmptyInvalid(value)) return invalidEmptyErrorMessage;
    if (_isMinInvalid(value)) return Intl.message(invalidMinErrorMessage, args: [min!]);
    if (_isMaxInvalid(value)) return Intl.message(invalidMaxErrorMessage, args: [max!]);

    return null;
  }

  bool _isEmptyInvalid(T? value) => !empty && value == null;
  bool _isMinInvalid(T? value) => value != null && min != null && value! < min!;
  bool _isMaxInvalid(T? value) => value != null && max != null && value! > max!;

  @override
  bool get isEmpty => value == null;

  @override
  dynamic toJsonValue() {
    return value;
  }
}
