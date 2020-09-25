import 'package:equatable/equatable.dart';
import 'package:presence/app/model/modelGroup.dart';

abstract class StateGroup extends Equatable {}

class StateGroupInit extends StateGroup {
  @override
  List<Object> get props => [];
}

class StateGroupLoading extends StateGroup {
  @override
  List<Object> get props => [];
}

class StateGroupError extends StateGroup {
  @override
  List<Object> get props => [];
  final message;
  StateGroupError({this.message});
}

class StateGroupLoaded extends StateGroup {
  final List<ModelGroup> group;
  StateGroupLoaded({this.group});
  @override
  List<Object> get props => [group];
}
