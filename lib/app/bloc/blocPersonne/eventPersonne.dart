import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:presence/app/model/modelPersonne.dart';

abstract class EventPersonne extends Equatable {}

class EventPersonneFetch extends EventPersonne {
  final personne;
  final type;
  EventPersonneFetch({this.personne, @required this.type});
  @override
  List<Object> get props => [];
}

class EventePersonneSave extends EventPersonne {
  @override
  List<Object> get props => [];
  final ModelPersonne personne;
  EventePersonneSave({this.personne});
}

class EventSearchPersonne extends EventPersonne {
  @override
  List<Object> get props => [];
  final personne;
  final entreprise;
  final type;
  EventSearchPersonne({this.personne, this.entreprise, @required this.type});
}
