import 'package:formz/formz.dart';
import 'package:groupify/common/common.dart';

part 'root_cubit_state.dart';

class RootCubit extends FormzBaseCubit<RootCubitState> {
  RootCubit() : super(RootCubitState.pure());
}
