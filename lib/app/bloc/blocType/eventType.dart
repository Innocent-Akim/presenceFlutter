import 'package:equatable/equatable.dart';

abstract class EventType extends Equatable {}

class EventTypeFetch extends EventType {
  @override
  List<Object> get props => [];
  final refEntreprise;
  EventTypeFetch({this.refEntreprise});
}
