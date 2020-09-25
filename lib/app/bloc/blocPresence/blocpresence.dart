import 'package:bloc/bloc.dart';
import 'package:presence/app/bloc/blocPresence/eventpresence.dart';
import 'package:presence/app/bloc/blocPresence/statepresence.dart';
import 'package:presence/app/source/providersource.dart';

class BlocPresence extends Bloc<EventPresence, StatePresence> {
  BlocPresence(StatePresence initialState) : super(initialState);
  @override
  Stream<StatePresence> mapEventToState(EventPresence event) async* {
    yield StatePresenceInit();
    if (event is EventsendData) {
      yield StatePresenceLoading();
      try {
        bool resultat = await Providerdata.getInit()
            .sendPresence(presence: event.presence, status: event.status);

        yield StatePresenceLoaded(bol: resultat);
      } catch (e) {
        StatePresenceError(message: e.toString());
      }
    }
  }
}
