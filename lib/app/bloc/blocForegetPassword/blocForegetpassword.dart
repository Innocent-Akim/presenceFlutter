import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presence/app/bloc/blocForegetPassword/eventForegetpassword.dart';
import 'package:presence/app/bloc/blocForegetPassword/stateForegetpassword.dart';
import 'package:presence/app/source/providersource.dart';

class BlocForeget extends Bloc<EventForeget, StateForeget> {
  BlocForeget(StateForeget initialState) : super(initialState);

  @override
  Stream<StateForeget> mapEventToState(EventForeget event) async* {
    try {
      yield StateForegetInit();
      if (event is EventForegetSave) {
        List<dynamic> resultat = await Providerdata.getInit()
            .foregetPassword(foregetpassword: event.foretgetPassword);
        yield StateForegetLoaded(resultat: resultat);
        if (resultat != null) {
          Fluttertoast.showToast(msg: "Mot de passe initialiser avec succes");
        }
      }
    } catch (e) {
      yield StateForegetError(resultat: e.toString());
    }
  }
}
