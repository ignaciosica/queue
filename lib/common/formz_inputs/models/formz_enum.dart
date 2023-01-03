import 'package:groupify/common/common.dart';

class FormzEnum<T extends BaseEnum> extends FormzBase<T?, String> {
  const FormzEnum.dirty({
    T? value,
    this.empty = true,
  }) : super.dirty(value);

  const FormzEnum.pure({
    T? value,
    this.empty = true,
  }) : super.pure(value);

  @override
  final bool empty;
  static const String invalidEmpty = 'Field must not be empty.';

  @override
  FormzEnum<T> copyWith({T? value}) {
    return FormzEnum.dirty(value: value!, empty: empty);
  }

  @override
  String? validator(T? value) {
    if (value == null && !empty) return invalidEmpty;

    return null;
  }

  @override
  bool get isEmpty => value == null;

  @override
  dynamic toJsonValue() {
    return value?.text;
  }
}
