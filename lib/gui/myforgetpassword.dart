import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/app/bloc/blocForegetPassword/blocForegetpassword.dart';
import 'package:presence/app/bloc/blocForegetPassword/eventForegetpassword.dart';
import 'package:presence/app/bloc/blocForegetPassword/stateForegetpassword.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/source/constants.dart';

class MyForgetPassword extends StatefulWidget {
  @override
  _MyForgetPassword createState() => _MyForgetPassword();
}

class _MyForgetPassword extends State<MyForgetPassword> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController confirmePassword = TextEditingController();
  TextEditingController tel = TextEditingController();
  BlocForeget _blocForeget;
  bool condition = true;
  void initState() {
    super.initState();
    _blocForeget = BlocForeget(StateForegetInit());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"))
      ],
      content: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.width / 1.2,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "MOT DE PASSE OUBLIER",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  customuseTextFieldConstants(
                    text: "Nom complet",
                    controller: nom,
                    icon: FontAwesomeIcons.user,
                    obscure: false,
                  ),
                  customuseTextFieldConstants(
                      text: "Nom d'utilisateur",
                      controller: tel,
                      icon: FontAwesomeIcons.user,
                      type: TextInputType.text,
                      obscure: false),
                  customuseTextFieldConstants(
                    text: "Mot de passe",
                    type: TextInputType.text,
                    controller: password1,
                    icon: Icons.vpn_key,
                    obscure: true,
                  ),
                  customuseTextFieldConstants(
                    text: "Confirmer le mot  depasse",
                    type: TextInputType.text,
                    controller: confirmePassword,
                    icon: Icons.vpn_key,
                    obscure: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: condition
                            ? Theme.of(context).primaryColor
                            : Colors.grey[100],
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          // height: 50,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Initialiser",
                            style: GoogleFonts.dMSans(
                              textStyle: TextStyle(
                                  color: condition
                                      ? Colors.white
                                      : Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() async {
                            Constants.foretgetPassword = ModelForetgetPassword(
                              nom: nom.text,
                              telephone: tel.text,
                              password: confirmePassword.text,
                            );

                            if (password1.text != confirmePassword.text) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Les deux mot depasse n'est pas conforme");
                            } else {
                              _blocForeget = BlocForeget(StateForegetInit());
                              _blocForeget.add(
                                EventForegetSave(
                                  foretgetPassword: Constants.foretgetPassword,
                                ),
                              );
                              // print(await Providerdata.getInit()
                              //     .foregetPassword(
                              //         foregetpassword:
                              //             Constants.foretgetPassword));
                            }
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
