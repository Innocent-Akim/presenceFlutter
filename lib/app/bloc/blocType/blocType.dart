import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence/app/bloc/blocType/eventType.dart';
import 'package:presence/app/bloc/blocType/stateType.dart';
import 'package:presence/app/model/modelType.dart';
import 'package:presence/app/source/providersource.dart';

class BlocType extends Bloc<EventType, StateType> {
  BlocType(StateType initialState) : super(initialState);

  @override
  Stream<StateType> mapEventToState(EventType event) async* {
    yield StateTypeInit();
    if (event is EventTypeFetch) {
      yield StateTypeLoading();
      try {
        List<ModelType> data = await Providerdata.getInit()
            .fetchType(refEntreprise: event.refEntreprise);
        yield StateTypeLoaded(data: data);
      } catch (_) {
        yield StateTypeError(message: _.toString());
      }
    }
  }
}
