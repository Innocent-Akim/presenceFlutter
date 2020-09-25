import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:presence/app/model/modelPersonne.dart';

abstract class StatePersonne extends Equatable {}

class StatePersonneInit extends StatePersonne {
  @override
  List<Object> get props => [];
}

class StatePersonneLoading extends StatePersonne {
  @override
  List<Object> get props => [];
}

class StatePersonneLoaded extends StatePersonne {
  final List<ModelPersonne> data;
  StatePersonneLoaded({@required this.data});
  @override
  List<Object> get props => [];
}

class StatePersonneError extends StatePersonne {
  final message;
  StatePersonneError({@required this.message});
  @override
  List<Object> get props => [message];
}

class StatePersonneSave extends StatePersonne {
  @override
  List<Object> get props => [];
  final resultat;
  StatePersonneSave({this.resultat});
}
