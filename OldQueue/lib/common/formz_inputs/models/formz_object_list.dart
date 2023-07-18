import 'package:groupify/common/common.dart';

class FormzObjectList<T> extends FormzBase<List<T>?, String> {
  const FormzObjectList.dirty({
    List<T>? value,
    this.min,
    this.max,
    this.options,
    this.empty = defaultEmpty,
  }) : super.dirty(value);

  const FormzObjectList.pure({
    List<T>? value = const [],
    this.min,
    this.max,
    this.options,
    this.empty = defaultEmpty,
  }) : super.pure(value);

  @override
  final bool empty;

  static const bool defaultEmpty = true;
  final List<T>? options;
  final int? min;
  final int? max;

  @override
  FormzObjectList<T> copyWith({List<T>? value}) {
    return FormzObjectList<T>.dirty(
      value: value,
      empty: empty,
      options: options,
      min: min,
      max: max,
    );
  }

  static const String invalidEmptyErrorMessage = 'Field should not be empty.';

  static const String invalidMinErrorMessage = 'Please select more elements, min:';
  static const String invalidMaxErrorMessage = 'Too many elements selected, max:';

  @override
  String? validator(List<T>? value) {
    if (_isEmptyInvalid(value)) return invalidEmptyErrorMessage;

    if (min != null && value!.length < min!) return invalidMinErrorMessage + min!.toString();

    if (max != null && value!.length > max!) return invalidMaxErrorMessage + max!.toString();

    return null;
  }

  bool _isEmptyInvalid(List<T>? value) => !empty && value!.isEmpty;

  @override
  bool get isEmpty => value == null;

  @override
  dynamic toJsonValue() {
    return value;
  }
}
