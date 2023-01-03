import 'package:formz/formz.dart';

abstract class FormzBase<T, E> extends FormzInput<T, E>
    implements CopyableFormzMixin<T>, OptionalFormzMixin<T>, ToJsonValueMixin {
  const FormzBase.pure(T value) : super.pure(value);
  const FormzBase.dirty(T value) : super.dirty(value);
}

mixin CopyableFormzMixin<T> {
  FormzBase<T, String> copyWith({T? value});
}

mixin ToJsonValueMixin {
  dynamic toJsonValue();
}

mixin OptionalFormzMixin<T> {
  bool get empty;
  bool get isEmpty;
  T get value;
}
