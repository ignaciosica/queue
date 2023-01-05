import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:groupify/common/common.dart';

part 'formz_base_cubit_state.dart';

class FormzBaseCubit<T extends FormzBaseCubitState> extends Cubit<T> {
  FormzBaseCubit(T state) : super(state);

  // void propertyChanged(String key, Object value) {
  //   emit(state.propertyChanged(key, value));
  // }

  void propertyChanged(String key, Object value) {
    emit(state.propertyChanged(key, value) as T);
  }
}
