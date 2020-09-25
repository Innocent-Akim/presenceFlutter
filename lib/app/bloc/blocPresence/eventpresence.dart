import 'package:equatable/equatable.dart';
import 'package:presence/app/model/modelPresence.dart';

abstract class EventPresence extends Equatable {}

class EventsendData extends EventPresence {
  @override
  List<Object> get props => [];
  final ModelPresence presence;
  final status;
  EventsendData({this.presence, this.status});
}
