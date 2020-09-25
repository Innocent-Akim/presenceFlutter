import 'package:bloc/bloc.dart';
import 'package:presence/app/bloc/blocLoginn/eventLogin.dart';
import 'package:presence/app/bloc/blocLoginn/stateLogin.dart';
import 'package:presence/app/source/providersource.dart';

class BlocLogin extends Bloc<EventLogin, StateLogin> {
  BlocLogin(StateLogin initialState) : super(initialState);

  @override
  Stream<StateLogin> mapEventToState(EventLogin event) async* {
    yield StateLoginInit();
    if (event is EventSignIn) {
      try {
        List<dynamic> data =
            await Providerdata.getInit().fetchLogin(login: event.login);
        yield StateLoginLoaded(list: data);
      } catch (_) {
        print(_.toString());
      }
    }
  }
}
