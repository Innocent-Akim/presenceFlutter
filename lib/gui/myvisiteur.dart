import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:presence/app/bloc/blocPersonne/blocPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/eventPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/statePersonne.dart';
import 'package:presence/app/bloc/blocPresence/blocpresence.dart';
import 'package:presence/app/bloc/blocPresence/eventpresence.dart';
import 'package:presence/app/bloc/blocPresence/statepresence.dart';
import 'package:presence/app/dialog/dialogFetch.dart';
import 'package:presence/app/model/modelPresence.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/app/source/datasourcesqlife.dart';

class Myvisiteur extends StatefulWidget {
  final qrResultat;
  const Myvisiteur({Key key, this.qrResultat}) : super(key: key);
  @override
  _Myvisiteur createState() => _Myvisiteur();
}

class _Myvisiteur extends State<Myvisiteur> {
  TextEditingController observation = TextEditingController();
  TextEditingController nomComplet = TextEditingController();
  TextEditingController idCarte = TextEditingController();
  TextEditingController isSearch = TextEditingController();
  TextEditingController motif = TextEditingController();
  TextEditingController visiteur = TextEditingController();

  BlocPresence _blocPresence;
  BlocPersonne _blocPersonne;
  BlocPersonne _blocVisiteur;
  bool isSelected = true;
  bool backu = false;
  bool _connect = true;
  void initState() {
    super.initState();
    _blocPresence = BlocPresence(StatePresenceInit());
    _blocPresence = BlocPresence(StatePresenceInit());
    Constants.save = false;
    idCarte.text = widget.qrResultat;
    _blocPersonne = BlocPersonne(StatePersonneInit());
    _blocVisiteur = BlocPersonne(StatePersonneInit());
    _blocPersonne.add(EventPersonneFetch(
        personne: Constants.modelLogin.refEntreprise, type: 'AUTRES'));
    _blocVisiteur.add(EventPersonneFetch(
        personne: Constants.modelLogin.refEntreprise, type: 'VISITEUR'));
    isConnexion();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: backu,
          progressIndicator: SpinKitCircle(
            color: Colors.blue,
          ),
          child: Container(
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/paa-id-selfie.png",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 6,
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Column(
                                children: [
                                  customTextField(
                                      held: "Personne a visiter",
                                      controller: nomComplet,
                                      icon: Icons.person,
                                      onPresse: () {
                                        setState(() {
                                          isConnexion();
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (_connect)
                                            _ackAlert(context);
                                          else
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Veuillez vérifier votre connexion internet");
                                        });
                                      }),
                                  customTextField(
                                      held: "Nom visiteur",
                                      controller: visiteur,
                                      icon: Icons.person,
                                      onPresse: () {
                                        setState(() {
                                          isConnexion();
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (_connect) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return MyDialogue(
                                                  valeur: visiteur,
                                                );
                                              },
                                              barrierDismissible: false,
                                            );
                                            // _ackAlertvisiteur(context);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Veuillez vérifier votre connexion internet");
                                          }
                                        });
                                      }),
                                  customTextField(
                                      held: "N.carte visite",
                                      controller: idCarte,
                                      icon: Icons.card_travel,
                                      onPresse: () {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        });
                                      }),
                                  customTextField(
                                    held: "Objet a consigne",
                                    controller: observation,
                                    icon: Icons.open_in_browser,
                                  ),
                                  customTextField(
                                    held: "Motif",
                                    controller: motif,
                                    max: 5,
                                    onPresse: () {
                                      setState(() {
                                        if (visiteur.text == nomComplet.text) {
                                          Fluttertoast.showToast(
                                              msg: "Nom invalider");
                                        }
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        backu = true;
                                        isConnexion();
                                      });

                                      Timer(Duration(milliseconds: 1000), () {
                                        if (_connect) {
                                          if (nomComplet.text
                                                  .trim()
                                                  .isNotEmpty ||
                                              visiteur.text.trim().isNotEmpty ||
                                              motif.text.trim().isNotEmpty) {
                                            try {
                                              Constants.modelPresence =
                                                  ModelPresence(
                                                batch: idCarte.text,
                                                refPerVisiter: nomComplet.text,
                                                objectconsigner:
                                                    observation.text,
                                                refEntreprise: Constants
                                                    .modelLogin.refEntreprise,
                                                motif: motif.text,
                                                refPersonne: visiteur.text,
                                              );
                                              Constants.modelLocal = ModelLocal(
                                                batch: idCarte.text,
                                                dateentre:
                                                    DateTime.now().toString(),
                                                consigne: observation.text,
                                                nom: nomComplet.text,
                                                visiter: visiteur.text,
                                                status: '1',
                                                refEntreprise: Constants
                                                    .modelLogin.refEntreprise,
                                              );
                                              setState(() {
                                                _blocPresence = BlocPresence(
                                                    StatePresenceInit());
                                                _blocPresence.add(EventsendData(
                                                  presence:
                                                      Constants.modelPresence,
                                                  status: "1",
                                                ));
                                              });
                                              setState(() {
                                                backu = false;
                                                Navigator.of(context).pop();

                                                if (Constants.save == true) {
                                                  Navigator.of(context).pop();
                                                  Fluttertoast.showToast(
                                                      msg: "succes");
                                                }
                                                createCustomer(
                                                    Constants.modelLocal);
                                              });
                                            } catch (_) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Erreur ${_.toString()}");
                                            }
                                          } else {
                                            setState(() {
                                              backu = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Completer les champs svp");
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          child: Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Valider",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      )),
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
          ),
        ),
      ),
    );
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            "CHERCHER AGENT",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          )),
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
                          _blocPersonne.add(
                            EventSearchPersonne(
                                personne: val,
                                entreprise: Constants.modelLogin.refEntreprise,
                                type: "AUTRES"),
                          );
                        });
                      }),
                ),
                Expanded(
                  child: BlocBuilder(
                    cubit: _blocPersonne,
                    builder: (context, state) {
                      if (state is StatePersonneInit) {
                        return Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 25,
                          ),
                        );
                      }
                      if (state is StatePersonneLoading) {
                        return Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 25,
                          ),
                        );
                      }
                      if (state is StatePersonneError) {
                        return Center(
                          child: Text("Error ${state.message}"),
                        );
                      }
                      if (state is StatePersonneLoaded) {
                        return ListView.builder(
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            return state.data != null
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        nomComplet.text =
                                            "${state.data[index].nom}";
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: customCard(
                                      desingation: "${state.data[index].nom}",
                                      mail: "${state.data[index].email}",
                                      tel: "${state.data[index].tel}",
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
        );
      },
    );
  }

  Future<void> _ackAlertvisiteur(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Chercher le nom du visiteur')),
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
                          _blocPersonne.add(
                            EventSearchPersonne(
                                personne: val,
                                entreprise: Constants.modelLogin.refEntreprise,
                                type: "VISITEUR"),
                          );
                        });
                      }),
                ),
                Expanded(
                  child: BlocBuilder(
                    cubit: _blocVisiteur,
                    builder: (context, state) {
                      if (state is StatePersonneInit) {
                        return Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 25,
                          ),
                        );
                      }
                      if (state is StatePersonneLoading) {
                        return Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 25,
                          ),
                        );
                      }
                      if (state is StatePersonneError) {
                        return Center(
                          child: Text("Error ${state.message}"),
                        );
                      }
                      if (state is StatePersonneLoaded) {
                        return ListView.builder(
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            return state.data != null
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        visiteur.text =
                                            "${state.data[index].nom}";
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: customCard(
                                      desingation: "${state.data[index].nom}",
                                      mail: "${state.data[index].email}",
                                      tel: "${state.data[index].tel}",
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
        );
      },
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
                          fontSize: 13,
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

  void isConnexion() {
    Timer(Duration(milliseconds: 0), () async {
      _connect = await Constants.getInstance().connectionState();
    });
  }

  // maxLines: 20,
  //                           minLines: 1,
  Widget customTextField({
    String held,
    TextEditingController controller,
    IconData icon,
    Function onPresse,
    int max = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white54,
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: max,
              onTap: onPresse,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: held,
                enabled: true,
                prefixIcon: Icon(
                  icon,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
