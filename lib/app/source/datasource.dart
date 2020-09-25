import 'dart:convert';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:presence/app/model/modelGroup.dart';
import 'package:presence/app/model/modelLogin.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/model/modelPresence.dart';
import 'package:presence/app/model/modelType.dart';
import 'package:presence/app/source/constants.dart';

class Datasource {
  static bool enregistrement = false;
  static const path = "http://192.168.43.34/presenceApi/app/home/app.php";
  // static const path =
  //     "https://tapandpayservice.com/presence/myPresence/app/home/app.php";
  // static const path =
  //     "https://tapandpayservice.com/smico/myPresence/app/home/app.php";
  static Datasource init;
  var resultat;
  static Datasource getInit() {
    if (init == null) {
      init = Datasource();
    }
    return init;
  }

  getUrl() {
    var url = Uri.parse("$path");
    return http.MultipartRequest('POST', url);
  }

  Future<bool> sendPresence({ModelPresence presence, String status}) async {
    // var url = Uri.parse("$path");

    Constants.save = false;
    try {
      // Future.delayed(Duration(milliseconds: 1));
      final reponse = await http.post("$path", body: {
        'action': 'PRESENCE',
        'batch': presence.batch,
        'Motif': presence.motif,
        'refPerVisiter': presence.refPerVisiter,
        'object_consigner': presence.objectconsigner,
        'refEntreprise': presence.refEntreprise,
        'status': status,
        'nomvisiteur': presence.refPersonne,
      });
      var resultat = await jsonDecode(reponse.body);
      Vibrate.vibrate();
      if (resultat['status']) {
        Constants.save = true;
        return Constants.save;
      }
    } on Exception catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return false;
  }

  Future<List<dynamic>> countPresence({String refEntreprise}) async {
    try {
      final reponse = await http.post("$path",
          body: {'action': 'COUNT_PRESENCE', 'entrepriser': refEntreprise});
      var resultat = await jsonDecode(reponse.body);
      if (resultat != null) {
        return resultat;
      }
    } on Exception catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return null;
  }

  Future<List<ModelPersonne>> fetchPersonne(
      {final personne, final type}) async {
    final List<ModelPersonne> person = List();

    try {
      final reponse = await http.post(
        "$path",
        body: {'action': 'PERSONNE', 'entreprise': personne, 'type': type},
      );
      resultat = await json.decode(reponse.body);
      if (resultat != null) {
        for (int index = 0; index < resultat.length; index++) {
          person.add(ModelPersonne.fromJson(resultat[index]));
        }
      }

      return person;
    } on Exception catch (_) {
      Fluttertoast.showToast(msg: "Veille verifier la connexion");
    }
    return null;
  }

  Future<bool> saveIdentite({ModelPersonne personne}) async {
    try {
      final reponse = await http.post(
        "$path",
        body: {
          'action': 'IDENTIFICATION',
          'nom': personne.nom,
          'genre': personne.genre,
          'tel': personne.tel,
          'email': personne.email,
          'adresse': personne.adresse,
          'entreprise': personne.entreprise,
          'typeIden': personne.refType,
          'fonction': personne.fonction,
          'refEntreprise': personne.refEntreprise,
        },
      );

      var resultat = await jsonDecode(reponse.body);
      enregistrement = resultat['status'];
      Vibrate.vibrate();
      if (resultat['status'] == true) {
        Fluttertoast.showToast(msg: 'Succes');
        Constants.save = true;
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Succes');
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return false;
  }

  Future<List<dynamic>> fetchLogin({ModelLogin login}) async {
    try {
      var reponse = await http.post(
        "$path",
        body: {
          'action': 'AUTHENTIFICATION',
          'username': login.psedo,
          'password': login.pswd
        },
      );
      var resultat = await json.decode(reponse.body);
      print(resultat);
      if (resultat != null) {
        return resultat;
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return null;
  }

  Future<List<ModelType>> fetchType({String refEntreprise}) async {
    List<ModelType> type = List();
    try {
      final reponse = await http.post("$path", body: {
        'action': 'TYPE_DATA',
        'Entreprise': refEntreprise,
      });
      var resultat = await json.decode(reponse.body);
      for (int index = 0; index < resultat.length; index++) {
        type.add(ModelType.fromJson(resultat[index]));
      }
      return type;
    } catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return null;
  }

  Future<List<ModelPersonne>> searchPersonne(
      {String searchData, String entreprise, String type}) async {
    final List<ModelPersonne> person = List();
    try {
      final reponse = await http.post(
        "$path",
        body: {
          'action': 'SEARCH_PERSONNE',
          'search': searchData,
          'entreprise': entreprise,
          'type': type
        },
      );

      resultat = await json.decode(reponse.body);
      print(reponse.body);
      for (int index = 0; index < resultat.length; index++) {
        person.add(ModelPersonne.fromJson(resultat[index]));
      }
      return person;
    } on Exception catch (_) {
      Fluttertoast.showToast(msg: "${_.toString()}");
    }
    return null;
  }

  Future<List<ModelGroup>> fetchGroup({String refEntreprise}) async {
    try {
      List<ModelGroup> group = List();
      final reponse = await http.post("$path", body: {
        'action': 'GROUP',
        'entreprise': refEntreprise,
      });
      var resultat = await json.decode(reponse.body);
      for (int index = 0; index < resultat.length; index++) {
        group.add(ModelGroup.fromJson(resultat[index]));
      }
      return group;
    } catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return null;
  }

  Future<List<ModelGroup>> fetchsearchGroup(
      {String refEntreprise, String valeur}) async {
    try {
      List<ModelGroup> group = List();
      final reponse = await http.post("$path", body: {
        'action': 'GROUP_SEARCH',
        'entreprise': refEntreprise,
        'search': valeur,
      });
      var resultat = await json.decode(reponse.body);
      for (int index = 0; index < resultat.length; index++) {
        group.add(ModelGroup.fromJson(resultat[index]));
      }
      return group;
    } catch (_) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return null;
  }

  Future<List<dynamic>> foregetPassword(
      {ModelForetgetPassword foregetpassword}) async {
    try {
      final reponse = await http.post('$path', body: {
        'action': 'FOREGETPASSWORD',
        'nom': foregetpassword.nom,
        'telephone': foregetpassword.telephone,
        'password': foregetpassword.password
      });
      var resultat = await jsonDecode(reponse.body);
      Vibrate.feedback(FeedbackType.success);
      if (resultat != null) {
        return resultat;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Veuillez vérifier votre connexion internet");
    }
    return null;
  }
}
