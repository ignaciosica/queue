part of 'formz_base_cubit.dart';

abstract class FormzBaseCubitState extends Equatable with ValidateMixin {
  FormzBaseCubitState(this.status, this.propsMap);

  FormzBaseCubitState.pure(this.propsMap) {
    status = FormzStatus.pure;
  }

  FormzBaseCubitState.dirty(this.status, this.propsMap);

  late final FormzStatus status;
  late final Map<String, dynamic> propsMap;

  dynamic propertyChanged(String key, dynamic value);
  dynamic copyWithStatus(FormzStatus status);

  Map<String, dynamic> propertyChangedAux(String key, dynamic value) {
    late dynamic property;
    final newPropsMap = Map<String, dynamic>.from(propsMap);

    if (!key.contains('->')) {
      property = (propsMap[key]! as CopyableFormzMixin).copyWith(value: value);
      newPropsMap[key] = property;
    } else {
      final keys = key.split('->');
      property = (propsMap[keys[0]]! as FormzBaseCubitState).propertyChanged(keys.sublist(1).join('->'), value);
      newPropsMap[keys[0]] = property;
    }

    return newPropsMap;
  }

  T readProperty<T>(String key) {
    late T property;

    if (!key.contains('->')) {
      property = propsMap[key]! as T;
    } else {
      final keys = key.split('->');
      final obj = propsMap[keys[0]]! as FormzBaseCubitState;
      property = obj.readProperty<T>(keys.sublist(1).join('->'));
    }

    return property;
  }

  FormzBase<T, String> readFormzProperty<T>(String key) {
    late FormzBase<T, String> property;

    if (!key.contains('->')) {
      property = propsMap[key]! as FormzBase<T, String>;
    } else {
      final keys = key.split('->');
      final obj = propsMap[keys[0]]! as FormzBaseCubitState;
      property = obj.readFormzProperty<T>(keys.sublist(1).join('->'));
    }

    return property;
  }

  @override
  List<Object?> get props {
    return List<Object>.of(propsMap.values.cast()).followedBy([status]).toList();
  }

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(
      propsMap.map<String, dynamic>((key, dynamic value) {
        if (value is FormzBase<dynamic, String>) {
          final dynamic jsonVal = value.toJsonValue();
          return MapEntry<String, dynamic>(key, jsonVal);
        } else {
          return MapEntry<String, dynamic>(key, value);
        }
      }),
    );
  }
}

mixin ValidateMixin {
  List<FormzBase<dynamic, String>> toValidationList(Iterable<dynamic> properties) {
    return properties.where((dynamic e) => e is! String).map<List<FormzBase<dynamic, String>>>((dynamic e) {
      if (e is FormzBaseCubitState) {
        return toValidationList(e.propsMap.values);
      } else {
        return [e as FormzBase<dynamic, String>];
      }
    }).reduce((l1, l2) => l1 + l2);
  }
}
