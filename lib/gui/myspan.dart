import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/app/source/mypreferences.dart';
import 'package:presence/gui/myconnexiontest.dart';
import 'package:presence/gui/mylogin.dart';
import 'package:presence/outils/Apptheme.dart';
import 'package:presence/outils/fade_animation.dart';
import 'package:presence/starters/start_page.dart';

class Myspan extends StatefulWidget {
  static const String rootName = "/myspan";
  @override
  _Myspan createState() => _Myspan();
}

class _Myspan extends State<Myspan> {
  static bool connexion = false;
  void initState() {
    init();
    super.initState();
  }

  Future<void> isLogin() async {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(
        context,
        MyLogin.rootName,
      );
    });
  }

  Future<void> init() async {
    await Constants.getInstance()
        .connectionState()
        .then((value) => connexion = value);
    bool etat = await Mypreferences.mypreferences().getToken('value');
    if (connexion != false) {
      if (etat) {
        isLogin();
      } else {
        Timer(Duration(seconds: 4), () {
          Navigator.pushReplacementNamed(
            context,
            Starters.rooteName,
          );
        });
      }
    } else {
      Timer(Duration(seconds: 4), () {
        Navigator.pushReplacementNamed(
          context,
          MyConnexion.routeName,
        );
      });
    }
  }

  Future<bool> get getToken async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Expanded(child: FadeAnimation(1.3, getIcon())),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Expanded(child: FadeAnimation(1.6, ismamu())),
                    // FadeAnimation(
                    //     1.7,
                    //     SpinKitCircle(
                    //       size: 25,
                    //       color: Color(0xFF31ACFF),
                    //       duration: Duration(seconds: 4),
                    //     ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getIcon() {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Image.asset(
        "${pathImage}",
        width: MediaQuery.of(context).size.width * 0.4,
      ),
    );
  }

  ismamu() {
    return FadeAnimation(
      2,
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Version 1.1.0',
            style: GoogleFonts.dMSans(
              textStyle: TextStyle(
                  // color: Colors.black87,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(width: 2.0),
          Text(
            'Build by FAYSALCompagny',
            style: GoogleFonts.dMSans(
              textStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
