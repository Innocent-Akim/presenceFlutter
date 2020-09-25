import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presence/app/bloc/blocPersonne/blocPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/eventPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/statePersonne.dart';
import 'package:presence/app/dialog/mydialogIdent.dart';
import 'package:presence/app/source/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyDialogue extends StatefulWidget {
  final TextEditingController valeur;

  const MyDialogue({Key key, this.valeur}) : super(key: key);
  @override
  _MyDialogue createState() => _MyDialogue();
}

class _MyDialogue extends State<MyDialogue> {
  BlocPersonne _blocVisiteur;
  TextEditingController isSearch = TextEditingController();
  final controller = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isSelected = true;
  bool backu = false;
  bool connect = false;
  @override
  void initState() {
    super.initState();
    _blocVisiteur = BlocPersonne(StatePersonneInit());
    _blocVisiteur.add(EventPersonneFetch(
        personne: Constants.modelLogin.refEntreprise, type: 'VISITEUR'));
    isConnexion();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          onPressed: () {
            showDialog(
              context: context,
              child: MydialogIdent(),
              barrierDismissible: false,
            );
          },
          child: Text("Ajouter"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Fermer"),
        ),
      ],
      content: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SmartRefresher(
          controller: _refreshController,
          scrollController: controller,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () {
            setState(() {
              isConnexion();
              if (connect) {
                _blocVisiteur.add(EventPersonneFetch(
                    personne: Constants.modelLogin.refEntreprise,
                    type: 'VISITEUR'));
              } else {
                Fluttertoast.showToast(
                    msg: "Veuillez vérifier votre connexion internet");
              }
              _refreshController.refreshCompleted();
            });
          },
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
                        isConnexion();
                        if (connect) {
                          _blocVisiteur.add(
                            EventSearchPersonne(
                                personne: val,
                                entreprise: Constants.modelLogin.refEntreprise,
                                type: "VISITEUR"),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Veuillez vérifier votre connexion internet");
                        }
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
                      return connect
                          ? ListView.builder(
                              itemCount: state.data.length,
                              itemBuilder: (context, index) {
                                return state.data != null
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.valeur.text =
                                                "${state.data[index].nom}";
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: customCard(
                                            desingation:
                                                "${state.data[index].nom}",
                                            mail: "${state.data[index].email}",
                                            tel: "${state.data[index].tel}",
                                            adress:
                                                "${state.data[index].adresse}"),
                                      )
                                    : Center(
                                        child: Text(
                                          "Aucun donnees trouver sur le recherche",
                                        ),
                                      );
                              },
                            )
                          : Center(
                              child: Text(
                                  "Veuillez vérifier votre connexion internet"),
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

  Widget customCard(
      {String desingation, String mail, String tel, String adress}) {
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "$adress",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void isConnexion() {
    Timer(Duration(milliseconds: 0), () async {
      connect = await Constants.getInstance().connectionState();
    });
  }
}
