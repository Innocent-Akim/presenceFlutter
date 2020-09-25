import 'package:bloc/bloc.dart';
import 'package:presence/app/bloc/blocPersonne/eventPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/statePersonne.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/source/providersource.dart';

class BlocPersonne extends Bloc<EventPersonne, StatePersonne> {
  BlocPersonne(StatePersonne initialState) : super(initialState);
  @override
  Stream<StatePersonne> mapEventToState(EventPersonne event) async* {
    yield StatePersonneInit();
    if (event is EventPersonneFetch) {
      yield StatePersonneLoading();
      try {
        List<ModelPersonne> data = await Providerdata.getInit()
            .fetchPersonne(personne: event.personne, type: event.type);
        yield StatePersonneLoaded(data: data);
      } catch (_) {
        yield StatePersonneError(message: _.toString());
      }
    }
    if (event is EventePersonneSave) {
      yield StatePersonneLoading();
      try {
        bool resultat = await Providerdata.getInit()
            .saveIdentification(personne: event.personne);
        yield StatePersonneSave(resultat: resultat);
      } catch (_) {
        yield StatePersonneError(message: "${_.toString()}");
      }
    }
    if (event is EventSearchPersonne) {
      yield StatePersonneLoading();
      try {
        List<ModelPersonne> data = await Providerdata.getInit().searchPersonne(
            searchData: event.personne,
            personne: event.entreprise,
            type: event.type);
        yield StatePersonneLoaded(data: data);
      } catch (_) {
        yield StatePersonneError(message: _.toString());
      }
    }
  }
}
