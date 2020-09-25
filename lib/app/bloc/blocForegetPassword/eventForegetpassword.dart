import 'package:equatable/equatable.dart';
import 'package:presence/app/model/modelPersonne.dart';

abstract class EventForeget extends Equatable {}

class EventForegetSave extends EventForeget {
  final ModelForetgetPassword foretgetPassword;
  EventForegetSave({this.foretgetPassword});
  @override
  List<Object> get props => [foretgetPassword];
}
