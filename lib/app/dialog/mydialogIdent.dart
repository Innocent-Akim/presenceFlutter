import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presence/app/bloc/blocGroup/blocGroup.dart';
import 'package:presence/app/bloc/blocGroup/eventGroup.dart';
import 'package:presence/app/bloc/blocGroup/stateGroup.dart';
import 'package:presence/app/bloc/blocPersonne/blocPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/eventPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/statePersonne.dart';
import 'package:presence/app/bloc/blocType/blocType.dart';
import 'package:presence/app/bloc/blocType/eventType.dart';
import 'package:presence/app/bloc/blocType/stateType.dart';
import 'package:presence/app/model/modelPersonne.dart';
import 'package:presence/app/source/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:presence/app/source/datasource.dart';
import 'package:presence/gui/alert_message.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:presence/outils/Apptheme.dart';

class MydialogIdent extends StatefulWidget {
  @override
  _MydialogIdent createState() => _MydialogIdent();
}

class _MydialogIdent extends State<MydialogIdent> {
  final ScrollController _scrollControle = ScrollController();
  BlocPersonne _blocPersonne;
  BlocGroup _blocGroup;
  BlocType _blocType;

  TextEditingController nom = TextEditingController();
  TextEditingController entreprise = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController fonction = TextEditingController();
  TextEditingController isSearch = TextEditingController();
  bool issexe = true;
  bool etat = false;
  String isgende = 'HOMME';
  bool connectionStatus = false;
  var idPays;
  void initState() {
    super.initState();
    Datasource.enregistrement = false;
    connecteStatus();
    _blocType = new BlocType(StateTypeInit());
    _blocPersonne = BlocPersonne(StatePersonneInit());
    _blocGroup = new BlocGroup(StateGroupInit());
    _blocType
        .add(EventTypeFetch(refEntreprise: Constants.modelLogin.refEntreprise));

    _blocGroup.add(
        EventfetchGroup(refEntreprise: Constants.modelLogin.refEntreprise));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: ModalProgressHUD(
          inAsyncCall: etat,
          dismissible: true,
          opacity: 0.3,
          progressIndicator: SpinKitCircle(
            color: Colors.blue,
          ),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: _scrollControle,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "IDENTIFICATION",
                      style: TextStyle(
                        color: Color(0xFF39ACF3),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // SELECT code,nom,tel,sexe,email,adresse,type,codeEntrep from personne;
                  // code, nom, tel, sexe, email, adresse, entreprise_, fonction, dateAdd, type, batch, image, codeEntrep, reference

                  customuseTextField(
                    text: "Saisissez votre nom complet",
                    controller: nom,
                    icon: FontAwesomeIcons.user,
                  ),

                  // customuseTextField(
                  //   text: "Saisissez votre sexe",
                  //   controller: _nom,
                  //   icon: Icons.accessibility,
                  // ),
                  customuseRadiobtn(
                    isColor: Color(0xFF31ACFF),
                    isFocus: Colors.black26,
                  ),

                  customuseTextFieldTE(
                      text: "Saisissez votre numero",
                      controller: tel,
                      icon: Icons.add_call,
                      type: TextInputType.phone),
                  customuseTextField(
                      text: "Saisissez votre email",
                      type: TextInputType.emailAddress,
                      controller: mail,
                      icon: FontAwesomeIcons.envelope),
                  customuseTextField(
                      text: "Saisissez votre adresse",
                      controller: adresse,
                      icon: FontAwesomeIcons.mapMarkerAlt),
                  customuseTextField(
                      text: "Saisissez votre entreprise",
                      controller: entreprise,
                      icon: FontAwesomeIcons.sitemap,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _ackAlert(context);
                        });
                      }),
                  customuseTextField(
                      text: "Typer d'identification",
                      controller: type,
                      icon: FontAwesomeIcons.ioxhost,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());

                          _ackAlertType(context);
                        });
                      }),
                  customuseTextField(
                      text: "Saisissez votre fonction",
                      controller: fonction,
                      icon: FontAwesomeIcons.unlink),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        etat = true;
                        connecteStatus();
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            if (connectionStatus) {
                              Constants.personne = ModelPersonne(
                                nom: nom.text,
                                genre: isgende,
                                adresse: adresse.text,
                                refEntreprise:
                                    Constants.modelLogin.refEntreprise,
                                tel: "${idPays}${tel.text}",
                                email: mail.text,
                                refType: type.text,
                                fonction: fonction.text,
                                entreprise: entreprise.text,
                              );

                              if (isFieldtest() == true) {
                                _blocPersonne.add(EventePersonneSave(
                                    personne: Constants.personne));
                                setState(() {
                                  etat = false;
                                  isclear();
                                });
                              } else {
                                etat = false;
                                Fluttertoast.showToast(
                                    msg: "Completer les champs stp");
                              }
                            } else {
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
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Colors.blue, width: 1),
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
                                dure: 1,
                              );
                              setState(() {
                                etat = false;
                              });
                            }
                          });
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Center(
                            child: Text(
                          "Enregistrer",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(0xFF39ACF3)),
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

  void connecteStatus() async {
    connectionStatus = await Constants.getInstance().connectionState();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget customuseTextField({
    TextEditingController controller,
    String text,
    IconData icon,
    TextInputType type,
    Function onTap,
  }) {
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

//  Container(
//                 child: CountryCodePicker(
//                   initialSelection: 'CD',
//                   showCountryOnly: false,
//                   showOnlyCountryWhenClosed: false,
//                   favorite: ['+243', 'CD'],
//                 ),
//               ),
  Widget customuseTextFieldTE({
    TextEditingController controller,
    String text,
    IconData icon,
    TextInputType type,
    Function onTap,
  }) {
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
              prefixIcon: CountryCodePicker(
                initialSelection: 'CD',
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: ['+243', 'CD'],
                onChanged: (code) {
                  setState(() {
                    idPays = code.dialCode;
                    print("====================================>${idPays}");
                  });
                },
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

  Widget customuseRadiobtn({Color isColor, Color isFocus}) {
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
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        issexe = true;
                        isgende = 'HOMME';
                      });
                    },
                    child: customRadiobt(
                      designation: "Homme",
                      isColor: issexe == true ? isColor : isFocus,
                      isFocus: isFocus,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        issexe = false;
                        isgende = 'FEMME';
                      });
                    },
                    child: customRadiobt(
                      designation: "Femme",
                      isColor: issexe == false ? isColor : isFocus,
                      isFocus: isFocus,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget customRadiobt({String designation, Color isColor, Color isFocus}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text(
            "$designation",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isColor,
              border: Border.all(
                color: isFocus,
                width: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Entreprise')),
          content: Container(
            width: MediaQuery.of(context).size.width - 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: customuseTextField1(
                      controller: isSearch,
                      icon: Icons.search,
                      text: "Rechercher",
                      onRealeser: (val) {
                        setState(() {
                          _blocGroup.add(
                            EventsearchGroup(
                              val: val,
                              refEntreprise: Constants.modelLogin.refEntreprise,
                            ),
                          );
                        });
                      }),
                ),
                Expanded(
                  child: BlocBuilder(
                    cubit: _blocGroup,
                    builder: (context, state) {
                      if (state is StateGroupInit) {
                        return Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 25,
                          ),
                        );
                      }
                      if (state is StateGroupLoading) {
                        return Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 25,
                          ),
                        );
                      }
                      if (state is StateGroupError) {
                        return Center(
                          child: Text("Error ${state.message}"),
                        );
                      }
                      if (state is StateGroupLoaded) {
                        return connectionStatus
                            ? ListView.builder(
                                itemCount: state.group.length,
                                itemBuilder: (context, index) {
                                  return state.group.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              entreprise.text =
                                                  "${state.group[index].nomGroupe}";
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: customCard(
                                            desingation:
                                                "${state.group[index].nomGroupe}",
                                            mail: "${state.group[index].email}",
                                            tel: "${state.group[index].tel}",
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            "Aucun donnees trouver sur le recherche",
                                          ),
                                        );
                                },
                              )
                            : () {
                                isalertDialogue(
                                  context: context,
                                  dure: 3,
                                  tilte: "Erreur de la connexion",
                                  widget: Container(
                                    height: 40,
                                    width: 40,
                                    child: Icon(
                                      Icons.cloud_off,
                                    ),
                                  ),
                                );
                              };
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget customuseTextField1(
      {TextEditingController controller,
      String text,
      IconData icon,
      TextInputType type,
      Function onRealeser}) {
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
            onChanged: onRealeser,
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

  Widget customCard({String desingation, String mail, String tel}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        elevation: 0.1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[100]),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "$desingation",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "$tel",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "$mail",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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

  Widget customCardtype({String desingation}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        elevation: 0.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "$desingation",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
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

  Future<void> _ackAlertType(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 6,
          child: AlertDialog(
            title: Center(child: Text('Type identification ')),
            content: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<BlocType, dynamic>(
                      cubit: _blocType,
                      builder: (context, state) {
                        if (state is StateTypeInit) {
                          return Center(
                            child: SpinKitCircle(
                              color: Colors.blue,
                              size: 25,
                            ),
                          );
                        }
                        if (state is StateTypeLoading) {
                          return Center(
                            child: SpinKitCircle(
                              color: Colors.blue,
                              size: 25,
                            ),
                          );
                        }
                        if (state is StateTypeError) {
                          return Center(
                            child: Text("Error ${state.message}"),
                          );
                        }
                        if (state is StateTypeLoaded) {
                          return ListView.builder(
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              return state.data.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          type.text =
                                              "${state.data[index].designation}";
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: customCardtype(
                                        desingation:
                                            "${state.data[index].designation}",
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        "Aucun donnees trouver sur le recherche",
                                      ),
                                    );
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget isStatusConnecter() {
    return ConnectionStatusBar(
      height: 25,
      width: double.maxFinite,
      color: Colors.redAccent,
      lookUpAddress: 'www.google.com',
      endOffset: const Offset(0.0, 0.0),
      beginOffset: const Offset(0.0, -1.0),
      animationDuration: const Duration(milliseconds: 200),
      title: const Text(
        'Please check your internet connection',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  void isclear() {
    nom.clear();
    adresse.clear();
    tel.clear();
    mail.clear();
    type.clear();
    fonction..clear();
    entreprise..clear();
  }

// )e2DMx1r1lp3n@ac2HS4
// https://presencefaysal.000webhostapp.com/
// T!gm&IP2Ls$5}!ZX
  bool isFieldtest() {
    if (nom.text.trim().isNotEmpty ||
        tel.text.trim().isNotEmpty ||
        mail.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }
}
