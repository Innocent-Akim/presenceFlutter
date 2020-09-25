import 'package:equatable/equatable.dart';
import 'package:presence/app/model/modelLogin.dart';

abstract class StateLogin extends Equatable {}

class StateLoginInit extends StateLogin {
  @override
  List<Object> get props => [];
}

class StateLoginLoading extends StateLogin {
  @override
  List<Object> get props => [];
}

class StateLoginError extends StateLogin {
  final message;
  StateLoginError({this.message});
  @override
  List<Object> get props => [message];
}

class StateLoginLoaded extends StateLogin {
  final List<dynamic> list;
  StateLoginLoaded({this.list});
  @override
  List<Object> get props => [];
}
