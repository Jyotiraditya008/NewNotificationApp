import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minervaschool/Models/PreLoginModels/login_model.dart';

import '../../Repo/api_repositories.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiRepository _repository;
  RegisterCubit(this._repository) : super(InitialRegisterState());

  Future<LoginModel?> login(Map<String, dynamic> map, String token) async {
    try {
      emit(const LoadingRegisterState());
      LoginModel res = await _repository.login(map, token);
      emit(const LoadedRegisterState());
      return res;
    } catch (e, s) {
      emit(ErrorRegisterState(message: e.toString()));
      rethrow;
    }
  }

  Future<LoginModel?> logout(Map<String, dynamic> map, String token) async {
    try {
      emit(const LoadingRegisterState());
      LoginModel res = await _repository.logout(map, token);
      emit(const LoadedRegisterState());
      return res;
    } catch (e, s) {
      emit(ErrorRegisterState(message: e.toString()));
      rethrow;
    }
  }
}
