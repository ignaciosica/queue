import 'package:groupify/common/common.dart';

enum DynamicValidationError { invalid }

class FormzObject<T> extends FormzBase<T?, String> {
  const FormzObject.dirty({
    T? value,
    this.empty = defaultEmpty,
  }) : super.dirty(value);

  const FormzObject.pure({
    T? value,
    this.empty = defaultEmpty,
  }) : super.pure(value);

  @override
  final bool empty;

  static const bool defaultEmpty = true;

  @override
  FormzObject<T> copyWith({T? value}) {
    return FormzObject<T>.dirty(
      value: value,
      empty: empty,
    );
  }

  static const String invalidEmptyErrorMessage = 'Field should not be empty.';

  @override
  String? validator(T? value) {
    if (_isEmptyInvalid(value)) return invalidEmptyErrorMessage;

    return null;
  }

  bool _isEmptyInvalid(T? value) => !empty && value == null;

  @override
  bool get isEmpty => value == null;

  @override
  dynamic toJsonValue() {
    if (value != null && value is ToJsonValueMixin) {
      return (value! as ToJsonValueMixin).toJsonValue();
    }
    return value;
  }
}
