part of 'register_cubit.dart';

abstract class RegisterState {
  const RegisterState();
}

class InitialRegisterState extends RegisterState {}

class LoadedRegisterState extends RegisterState {
  const LoadedRegisterState();
}

class LoadingRegisterState extends RegisterState {
  const LoadingRegisterState();
}

class ErrorRegisterState extends RegisterState {
  final String message;
  const ErrorRegisterState({required this.message});
}
