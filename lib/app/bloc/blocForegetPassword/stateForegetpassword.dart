import 'package:equatable/equatable.dart';

abstract class StateForeget extends Equatable {}

class StateForegetInit extends StateForeget {
  @override
  List<Object> get props => [];
}

class StateForegetLoading extends StateForeget {
  @override
  List<Object> get props => [];
}

class StateForegetLoaded extends StateForeget {
  final List<dynamic> resultat;
  StateForegetLoaded({this.resultat});
  @override
  List<Object> get props => [];
}

class StateForegetError extends StateForeget {
  final resultat;
  StateForegetError({this.resultat});
  @override
  List<Object> get props => [];
}
