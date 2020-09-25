import 'package:equatable/equatable.dart';

abstract class StatePresence extends Equatable {}

class StatePresenceInit extends StatePresence {
  @override
  List<Object> get props => [];
}

class StatePresenceLoading extends StatePresence {
  @override
  List<Object> get props => [];
}

class StatePresenceLoaded extends StatePresence {
  @override
  List<Object> get props => [];
  final bool bol;
  StatePresenceLoaded({this.bol});
}

class StatePresenceError extends StatePresence {
  @override
  List<Object> get props => [];
  final message;
  StatePresenceError({this.message});
}
