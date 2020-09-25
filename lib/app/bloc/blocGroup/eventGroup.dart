import 'package:equatable/equatable.dart';

abstract class EventGroup extends Equatable {}

class EventfetchGroup extends EventGroup {
  @override
  List<Object> get props => [];
  final refEntreprise;
  EventfetchGroup({this.refEntreprise});
}

class EventsearchGroup extends EventGroup {
  @override
  List<Object> get props => [];
  final val;
  final refEntreprise;
  EventsearchGroup({this.val, this.refEntreprise});
}
