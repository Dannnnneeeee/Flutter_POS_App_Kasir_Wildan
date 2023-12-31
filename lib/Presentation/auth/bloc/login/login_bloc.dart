import 'package:bloc/bloc.dart';
import 'package:flutter_pos_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_pos_app/data/models/response/auth_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDataSource authRemoteDataSource;
  LoginBloc(this.authRemoteDataSource) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final response = await authRemoteDataSource.login(
        event.email,
        event.password,
      );
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
