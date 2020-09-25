import 'package:bloc/bloc.dart';
import 'package:presence/app/bloc/blocGroup/eventGroup.dart';
import 'package:presence/app/bloc/blocGroup/stateGroup.dart';
import 'package:presence/app/model/modelGroup.dart';
import 'package:presence/app/source/providersource.dart';

class BlocGroup extends Bloc<EventGroup, StateGroup> {
  BlocGroup(StateGroup initialState) : super(initialState);

  @override
  Stream<StateGroup> mapEventToState(EventGroup event) async* {
    yield StateGroupInit();
    if (event is EventfetchGroup) {
      yield StateGroupLoading();
      try {
        List<ModelGroup> data = await Providerdata.getInit()
            .fetchGroup(refEntreprise: event.refEntreprise);
        yield StateGroupLoaded(group: data);
      } catch (_) {
        yield StateGroupError(message: _.toString());
      }
    }
    if (event is EventsearchGroup) {
      yield StateGroupLoading();

      try {
        List<ModelGroup> data = await Providerdata.getInit().fetchsearchGroup(
            refEntreprise: event.refEntreprise, valeur: event.val);
        yield StateGroupLoaded(group: data);
      } catch (_) {
        yield StateGroupError(message: _.toString());
      }
    }
  }
}
