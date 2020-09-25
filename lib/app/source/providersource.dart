import 'package:presence/app/model/modelGroup.dart';
import 'package:presence/app/model/modelLogin.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/model/modelPresence.dart';
import 'package:presence/app/model/modelType.dart';
import 'package:presence/app/source/datasource.dart';

class Providerdata {
  static Providerdata init;
  static Providerdata getInit() {
    if (init == null) {
      init = Providerdata();
    }
    return init;
  }

  Future<bool> sendPresence({String status, ModelPresence presence}) =>
      Datasource.getInit().sendPresence(presence: presence, status: status);

  Future<List<ModelPersonne>> fetchPersonne({final personne, final type}) =>
      Datasource.getInit().fetchPersonne(personne: personne, type: type);

  Future<List<ModelPersonne>> searchPersonne(
          {String searchData, String personne, String type}) =>
      Datasource.getInit().searchPersonne(
          searchData: searchData, entreprise: personne, type: type);

  Future<bool> saveIdentification({ModelPersonne personne}) =>
      Datasource.getInit().saveIdentite(personne: personne);

  Future<List<dynamic>> fetchLogin({ModelLogin login}) =>
      Datasource.getInit().fetchLogin(login: login);

  Future<List<ModelGroup>> fetchGroup({String refEntreprise}) =>
      Datasource.getInit().fetchGroup(refEntreprise: refEntreprise);

  Future<List<ModelType>> fetchType({String refEntreprise}) =>
      Datasource.getInit().fetchType(refEntreprise: refEntreprise);

  Future<List<ModelGroup>> fetchsearchGroup(
          {String refEntreprise, String valeur}) =>
      Datasource.getInit()
          .fetchsearchGroup(refEntreprise: refEntreprise, valeur: valeur);

  Future<List<dynamic>> countPresence({String refEntreprise}) =>
      Datasource.getInit().countPresence(refEntreprise: refEntreprise);

  Future<List<dynamic>> foregetPassword(
          {ModelForetgetPassword foregetpassword}) =>
      Datasource.getInit().foregetPassword(foregetpassword: foregetpassword);
}
