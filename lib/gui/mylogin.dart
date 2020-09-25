import 'dart:async';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/app/bloc/blocForegetPassword/blocForegetpassword.dart';
import 'package:presence/app/bloc/blocForegetPassword/eventForegetpassword.dart';
import 'package:presence/app/bloc/blocForegetPassword/stateForegetpassword.dart';
import 'package:presence/app/bloc/blocLoginn/blocLogin.dart';
import 'package:presence/app/bloc/blocLoginn/eventLogin.dart';
import 'package:presence/app/bloc/blocLoginn/stateLogin.dart';
import 'package:presence/app/model/modelLogin.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/app/source/providersource.dart';
import 'package:presence/gui/alert_message.dart';
import 'package:presence/gui/mydashboard.dart';
import 'package:presence/gui/myforgetpassword.dart';
import 'package:presence/outils/Apptheme.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key key}) : super(key: key);

  static const String rootName = "/mylogin";

  @override
  _MyLogin createState() => _MyLogin();
}

class _MyLogin extends State<MyLogin> {
  // ButtonState stateOnlyText = ButtonState.loading;
  // ButtonState stateTextWithIcon = ButtonState.loading;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController confirmePassword = TextEditingController();
  TextEditingController tel = TextEditingController();
  BlocForeget _blocForeget;
  void initState() {
    super.initState();
    _blocForeget = BlocForeget(StateForegetInit());
  }

  BlocLogin login;
  bool connexion = true;
  bool _visible = true;
  bool _etat = false;
  bool condition = true;
  final _globalKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: SafeArea(
        child: Scaffold(
          key: _globalKey,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // buildCustomButton(),
                  Image.asset(
                    "${pathImage}",
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue[200],
                            width: 1,
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.white)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, bottom: 8.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(.1),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: username,
                                            decoration: InputDecoration(
                                                hintText: "Nom d'utilisateur",
                                                prefixIcon: Icon(Icons.person,
                                                    size: 20),
                                                border: InputBorder.none),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Material(
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(.1),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: password,
                                            obscureText: _visible,
                                            decoration: InputDecoration(
                                                hintText: "Mot de passe",
                                                prefixIcon: Icon(
                                                    Icons.enhanced_encryption,
                                                    size: 20),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              _visible
                                                  ? FontAwesomeIcons.eyeSlash
                                                  : FontAwesomeIcons.eye,
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _visible = !_visible;
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                child: MyForgetPassword());
                                          });

                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) {
                                          //   return MyForgetPassword();
                                          // }));
                                          // forgetPassword();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            "Mot de passe oublier?",
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: Icon(
                                            FontAwesomeIcons.google,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: Icon(
                                            FontAwesomeIcons.facebook,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _etat = true;
                                      connectionStatus();
                                    });
                                    try {
                                      if (connexion == true) {
                                        if (username.text.trim().isNotEmpty &&
                                            password.text.trim().isNotEmpty) {
                                          Constants.modelLogin = ModelLogin(
                                            psedo: username.text.trim(),
                                            pswd: password.text.trim(),
                                          );
                                          List data =
                                              await Providerdata.getInit()
                                                  .fetchLogin(
                                                      login:
                                                          Constants.modelLogin);
                                          setState(
                                            () {
                                              BlocProvider.of<BlocLogin>(
                                                      context)
                                                  .add(
                                                EventSignIn(
                                                  login: Constants.modelLogin,
                                                ),
                                              );

                                              if (data != null) {
                                                if (data.length > 0) {
                                                  setState(() {
                                                    _etat = true;
                                                  });
                                                  Constants.modelLogin =
                                                      ModelLogin.fromJson(
                                                          data[0]);
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  Timer(Duration(seconds: 3),
                                                      () {
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return MyDashboard(
                                                          login: Constants
                                                              .modelLogin);
                                                    }), (route) => false);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _etat = false;
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Nom d'utilisateur ou Mot depasse incorect ");
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  _etat = false;
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Nom d'utilisateur ou Mot depasse incorect");
                                                });
                                              }
                                            },
                                          );
                                        } else {
                                          setState(() {
                                            _etat = false;
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Completer les champs vide");
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _etat = false;
                                          isalertDialogue(
                                            context: context,
                                            tilte:
                                                "Veuillez vérifier votre connexion internet",
                                            widget: AvatarGlow(
                                              endRadius: 30,
                                              glowColor: Colors.blue,
                                              child: Center(
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color: Colors.blue,
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.cloud_off,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            dure: 100,
                                          );
                                        });
                                      }
                                    } on SocketException catch (_) {
                                      print(_.toString());
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 8.0),
                                    child: Container(
                                      child: _etat != true
                                          ? Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFF31ACFF),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.2,
                                                height: 45,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Center(
                                                          child: Text(
                                                        "SE CONNECTER",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: SpinKitCircle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void connectionStatus() async {
    connexion = await Constants.getInstance().connectionState();
  }

  void showInSnackBar({BuildContext context, String value, Color color}) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: Colors.blue),
      ),
      backgroundColor: color,
    ));
  }
  // Widget buildCustomBtn() {
  //   return ProgressButton.icon(
  //     iconedButtons: {
  //       ButtonState.idle: IconedButton(
  //         text: "Connexion",
  //         icon: Icon(Icons.send, color: Colors.white),
  //         color: Colors.blue.shade500,
  //       ),
  //       ButtonState.loading:
  //           IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
  //       ButtonState.fail: IconedButton(
  //           text: "Failed",
  //           icon: Icon(Icons.cancel, color: Colors.white),
  //           color: Colors.red.shade300),
  //       ButtonState.success: IconedButton(
  //           text: "Success",
  //           icon: Icon(
  //             Icons.check_circle,
  //             color: Colors.white,
  //           ),
  //           color: Colors.green.shade400)
  //     },
  //     onPressed: () {
  //       setState(() {
  //         print("Salut");
  //       });
  //     },
  //     state: ButtonState.idle,
  //   );
  // }

  // Widget buildCustomButton() {
  //   var progressTextButton = ProgressButton(
  //     stateWidgets: {
  //       ButtonState.idle: Text(
  //         "Connexion",
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
  //       ),
  //       ButtonState.loading: Text(
  //         "Loading",
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
  //       ),
  //       ButtonState.fail: Text(
  //         "Fail",
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
  //       ),
  //       ButtonState.success: Text(
  //         "Success",
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
  //       )
  //     },
  //     stateColors: {
  //       ButtonState.idle: Colors.blue.shade400,
  //       ButtonState.loading: Colors.blue.shade300,
  //       ButtonState.fail: Colors.red.shade300,
  //       ButtonState.success: Colors.green.shade400,
  //     },
  //     onPressed: onPressedCustomButton,
  //     state: stateOnlyText,
  //     padding: EdgeInsets.all(8.0),
  //   );
  //   return progressTextButton;
  // }

  // void onPressedCustomButton() {
  //   setState(() {
  //     switch (stateOnlyText) {
  //       case ButtonState.idle:
  //         stateOnlyText = ButtonState.loading;
  //         break;
  //       case ButtonState.loading:
  //         stateOnlyText = ButtonState.fail;
  //         break;
  //       case ButtonState.success:
  //         stateOnlyText = ButtonState.idle;
  //         break;
  //       case ButtonState.fail:
  //         stateOnlyText = ButtonState.success;
  //         break;
  //     }
  //   });
  // }

  Widget customuseTextField(
      {TextEditingController controller,
      String text,
      IconData icon,
      TextInputType type}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
      child: Card(
        elevation: 3.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: type,
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

  Future<dynamic> forgetPassword() {
    FocusScope.of(context).requestFocus(FocusNode());
    nom.clear();
    confirmePassword.clear();
    password1.clear();
    tel.clear();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
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
                        obscure: false),
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
                        obscure: true),
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
                              Constants.foretgetPassword =
                                  ModelForetgetPassword(
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
                                    foretgetPassword:
                                        Constants.foretgetPassword,
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
        );
      },
    );
  }

  // void _sendSMS({String message, List<String> recipents}) async {
  //   String _resultat = await sendSMS(message: message, recipients: recipents)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print("Envoie ========================>${_resultat}");
  // }
}
