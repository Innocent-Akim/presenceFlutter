import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presence/gui/myspan.dart';
import 'package:presence/outils/Apptheme.dart';

class MyConnexion extends StatefulWidget {
  static const String routeName = '/myconnexion';
  @override
  _MyConnexion createState() => _MyConnexion();
}

class _MyConnexion extends State<MyConnexion> {
  // Future<void> isConnexion()  async {
  //   await Constants.getInstance().connectionState().then((value) => null)
  // }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Center(
                        child: Column(
                          children: [
                            AvatarGlow(
                              endRadius: 60,
                              glowColor: Colors.blue,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border:
                                      Border.all(color: Colors.blue, width: 1),
                                ),
                                child: Icon(
                                  Icons.cloud_off,
                                  size: 30,
                                ),
                              ),
                            ),
                            Text("Echec de la connexion"),
                            Text("Impossible de charger les donnees"),
                            SizedBox(
                              child: Text(""),
                            ),
                            Material(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => Myspan(),
                                      ),
                                    );
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("REESSAYER")),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
