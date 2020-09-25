import 'package:equatable/equatable.dart';
import 'package:presence/app/model/modelType.dart';

abstract class StateType extends Equatable {}

class StateTypeInit extends StateType {
  @override
  List<Object> get props => [];
}

class StateTypeLoading extends StateType {
  @override
  List<Object> get props => [];
}

class StateTypeLoaded extends StateType {
  @override
  List<Object> get props => [];
  final List<ModelType> data;
  StateTypeLoaded({this.data});
}

class StateTypeError extends StateType {
  @override
  List<Object> get props => [];
  final message;
  StateTypeError({this.message});
}
