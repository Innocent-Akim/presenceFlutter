import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:presence/app/model/modelLogin.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/model/modelPresence.dart';
import 'package:presence/app/source/datasourcesqlife.dart';

const String pathImage = "assets/logo smico.png";

class Constants {
  static Constants _init;

  static Constants getInstance() {
    if (_init == null) {
      _init = Constants();
    }
    return _init;
  }

  static bool save = false;
  static ModelPersonne personne = ModelPersonne();
  static ModelLogin modelLogin = ModelLogin();
  static ModelPresence modelPresence = ModelPresence();
  static ModelLocal modelLocal = ModelLocal();
  static ModelForetgetPassword foretgetPassword = ModelForetgetPassword();

  static String isVisiter(String y) {
    int x = int.parse(y);
    if (x > 0 && x < 10) {
      return "00$x";
    } else if (x >= 10 && x < 100) {
      return "0$x";
    } else if (x >= 100 && x < 1000) {
      return "$x";
    } else {
      return "00$x";
    }
  }

  Future<bool> connectionState() async {
    try {
      if (await isConnected()) {
        Future.delayed(Duration(seconds: 1));
        final resultat = await InternetAddress.lookup("tapandpayservice.com");
        if (resultat.isNotEmpty && resultat[0].rawAddress.isNotEmpty) {
          print("api access");
          return true;
        }
      } else {
        print(
            "===========================>Veuillez vérifier votre connexion internet");
        return false;
      }
    } on SocketException catch (_) {
      print(
          "====================================>Veuillez vérifier votre connexion internet");
    }
    return false;
  }

  Future<bool> isConnected() async {
    try {
      bool connected =
          await DataConnectionChecker().hasConnection.then((value) {
        return value;
      }).catchError((onError) => false);

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        if (connected) {
          print("internet access");
          return true;
        } else {
          print("Veuillez vérifier votre connexion internet");
          return false;
        }
      } else {
        print(
            "Vous n'êtes pas connecté à internet \nReésayer votre demande ultérieurement");
        return false;
      }
    } catch (e) {
      print("Veuillez vérifier votre connexion internet");
      return false;
    }
  }
}

PageViewIndicator pageViewIndicator({
  BuildContext context,
  ValueNotifier<int> pageIndexNotifier,
}) {
  return PageViewIndicator(
    pageIndexNotifier: pageIndexNotifier,
    length: 4,
    normalBuilder: (animationController, index) => Circle(
      size: 5.0,
      color: Colors.grey[400],
    ),
    highlightedBuilder: (animationController, index) => ScaleTransition(
      scale: CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      ),
      child: Circle(
        size: 8.0,
        color: Theme.of(context).primaryColor,
      ),
    ),
  );
}

Widget customuseTextFieldConstants(
    {TextEditingController controller,
    String text,
    IconData icon,
    TextInputType type,
    Function onTap,
    bool obscure}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
    child: Card(
      elevation: 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextFormField(
          obscureText: obscure,
          controller: controller,
          keyboardType: type,
          onTap: onTap,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: text,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
              size: 15,
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
          maxLines: 1,
        ),
      ),
    ),
  );
}
