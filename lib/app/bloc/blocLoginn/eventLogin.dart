import 'package:equatable/equatable.dart';
import 'package:presence/app/model/modelLogin.dart';

abstract class EventLogin extends Equatable {}

class EventSignIn extends EventLogin {
  final ModelLogin login;
  EventSignIn({this.login});
  @override
  List<Object> get props => [login];
}
