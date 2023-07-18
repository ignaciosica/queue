import 'package:groupify/common/common.dart';

enum TextValidationError { invalid }

class FormzText extends FormzBase<String, String> {
  const FormzText.dirty({
    String value = '',
    this.maxLength = 280,
    this.empty = true,
    this.regExp,
  }) : super.dirty(value ?? '');

  const FormzText.pure({
    String? value,
    this.maxLength = 280,
    this.empty = true,
    this.regExp,
  }) : super.pure(value ?? '');

  static const String invalidLengthErrorMessage = 'Field has surpassed max length.';
  static const String invalidEmptyErrorMessage = 'Field should not be empty.';
  static const String invalidValueErrorMessage = 'Field does not match regExp.';

  static const String usernameRegex = r'^[A-Za-z0-9_]+$';
  static const String onlyAlphaRegex = r'^[A-Za-z]+$';
  static const String alphanumericRegex = r'^[a-zA-Z0-9]*$';
  static const String numericRegex = r'^[0-9]*$';

  @override
  FormzText copyWith({String? value}) {
    return FormzText.dirty(value: value ?? this.value, maxLength: maxLength, empty: empty, regExp: regExp);
  }

  @override
  final bool empty;
  final int maxLength;
  final String? regExp;

  @override
  String? validator(String? value) {
    if (_isLengthInvalid(value)) return invalidLengthErrorMessage;

    if (_isEmptyInvalid(value)) return invalidEmptyErrorMessage;

    if (regExp != null && _isRegExpInvalid(value)) return invalidValueErrorMessage;

    return null;
  }

  bool _isLengthInvalid(String? value) => (value?.length ?? 0) > maxLength;

  bool _isEmptyInvalid(String? value) => !empty && (value?.isEmpty ?? true);

  bool _isRegExpInvalid(String? value) => !RegExp(regExp!).hasMatch(value ?? '');

  @override
  bool get isEmpty => value.isEmpty;

  @override
  dynamic toJsonValue() {
    return value;
  }
}
