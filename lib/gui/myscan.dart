import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presence/app/bloc/blocPersonne/blocPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/eventPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/statePersonne.dart';
import 'package:presence/app/bloc/blocPresence/blocpresence.dart';
import 'package:presence/app/bloc/blocPresence/eventpresence.dart';
import 'package:presence/app/bloc/blocPresence/statepresence.dart';
import 'package:presence/app/model/modelPresence.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/app/source/datasourcesqlife.dart';
import 'package:presence/gui/alert_message.dart';
import 'package:presence/gui/myvisiteur.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class Myscan extends StatefulWidget {
  static const String rootName = "/myscan";

  @override
  _Myscan createState() => _Myscan();
}

class _Myscan extends State<Myscan> {
  TextEditingController observation = TextEditingController();
  TextEditingController nomComplet = TextEditingController();
  TextEditingController idCarte = TextEditingController();
  TextEditingController isSearch = TextEditingController();
  TextEditingController motif = TextEditingController();
  TextEditingController visiteur = TextEditingController();
  BlocPresence _blocPresence;
  BlocPersonne _blocPersonne;
  BlocPersonne _blocVisiteur;

  ScanResult qrResultat;
  String result;
  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  bool backu = false;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  bool _canVibrate = true;
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  bool isSelected = true;
  bool isSelecteded = false;
  bool connecter = false;
  @override
  initState() {
    super.initState();
    connexionStatus();
    print(connecter);
    _blocPresence = BlocPresence(StatePresenceInit());
    Constants.save = false;
    _blocPersonne = BlocPersonne(StatePersonneInit());
    _blocVisiteur = BlocPersonne(StatePersonneInit());
    _blocPersonne.add(EventPersonneFetch(
        personne: Constants.modelLogin.refEntreprise, type: 'AUTRES'));
    _blocVisiteur.add(EventPersonneFetch(
        personne: Constants.modelLogin.refEntreprise, type: 'VISITEUR'));
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
    });
    vibres();
  }

  void vibres() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? print("This device can vibrate")
          : print("This device cannot vibrate");
    });
  }

  void connexionStatus() async {
    connecter = await Constants.getInstance().connectionState();
  }

  @override
  Widget build(BuildContext context) {
    var contentList = <Widget>[
      if (qrResultat != null)
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Result Type"),
                subtitle: Text(qrResultat.type?.toString() ?? ""),
              ),
              ListTile(
                title: Text("Raw Content"),
                subtitle: Text(qrResultat.rawContent ?? ""),
              ),
              ListTile(
                title: Text("Format"),
                subtitle: Text(qrResultat.format?.toString() ?? ""),
              ),
              ListTile(
                title: Text("Format note"),
                subtitle: Text(qrResultat.formatNote ?? ""),
              ),
            ],
          ),
        ),
      ListTile(
        title: Text("Camera selection"),
        dense: true,
        enabled: false,
      ),
      RadioListTile(
        onChanged: (v) => setState(() => _selectedCamera = -1),
        value: -1,
        title: Text("Default camera"),
        groupValue: _selectedCamera,
      ),
    ];

    for (var i = 0; i < _numberOfCameras; i++) {
      contentList.add(RadioListTile(
        onChanged: (v) => setState(() => _selectedCamera = i),
        value: i,
        title: Text("Camera ${i + 1}"),
        groupValue: _selectedCamera,
      ));
    }

    contentList.addAll([
      ListTile(
        title: Text("Button Texts"),
        dense: true,
        enabled: false,
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(
            hasFloatingPlaceholder: true,
            labelText: "Flash On",
          ),
          controller: _flashOnController,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(
            hasFloatingPlaceholder: true,
            labelText: "Flash Off",
          ),
          controller: _flashOffController,
        ),
      ),
      ListTile(
        title: TextField(
          decoration: InputDecoration(
            hasFloatingPlaceholder: true,
            labelText: "Cancel",
          ),
          controller: _cancelController,
        ),
      ),
    ]);

    if (Platform.isAndroid) {
      contentList.addAll([
        ListTile(
          title: Text("Android specific options"),
          dense: true,
          enabled: false,
        ),
        ListTile(
          title:
              Text("Aspect tolerance (${_aspectTolerance.toStringAsFixed(2)})"),
          subtitle: Slider(
            min: -1.0,
            max: 1.0,
            value: _aspectTolerance,
            onChanged: (value) {
              setState(() {
                _aspectTolerance = value;
              });
            },
          ),
        ),
        CheckboxListTile(
          title: Text("Use autofocus"),
          value: _useAutoFocus,
          onChanged: (checked) {
            setState(() {
              _useAutoFocus = checked;
            });
          },
        )
      ]);
    }

    contentList.addAll([
      ListTile(
        title: Text("Other options"),
        dense: true,
        enabled: false,
      ),
      CheckboxListTile(
        title: Text("Start with flash"),
        value: _autoEnableFlash,
        onChanged: (checked) {
          setState(() {
            _autoEnableFlash = checked;
          });
        },
      )
    ]);

    contentList.addAll([
      ListTile(
        title: Text("Barcode formats"),
        dense: true,
        enabled: false,
      ),
      ListTile(
        trailing: Checkbox(
          tristate: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: selectedFormats.length == _possibleFormats.length
              ? true
              : selectedFormats.length == 0 ? false : null,
          onChanged: (checked) {
            setState(() {
              selectedFormats = [
                if (checked ?? false) ..._possibleFormats,
              ];
            });
          },
        ),
        dense: true,
        enabled: false,
        title: Text("Detect barcode formats"),
        subtitle: Text(
          'If all are unselected, all possible platform formats will be used',
        ),
      ),
    ]);

    contentList.addAll(_possibleFormats.map(
      (format) => CheckboxListTile(
        value: selectedFormats.contains(format),
        onChanged: (i) {
          setState(() => selectedFormats.contains(format)
              ? selectedFormats.remove(format)
              : selectedFormats.add(format));
        },
        title: Text(format.toString()),
      ),
    ));

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              isSelected = true;
                            },
                          );
                        },
                        child: customButton(
                          title: "Agent",
                          color: isSelected == true
                              ? Color(0xFF31ACFF)
                              : Colors.white,
                          isColor: isSelected == true
                              ? Colors.white
                              : Color(0xFF31ACFF),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        child: customButton(
                            title: "Visiteur",
                            color: isSelected == false
                                ? Color(0xFF31ACFF)
                                : Colors.white,
                            isColor: isSelected == false
                                ? Colors.white
                                : Color(0xFF31ACFF)),
                        onTap: () {
                          setState(() {
                            isSelected = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/scanern.jpg",
                    width: MediaQuery.of(context).size.width - 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _scanCard();
          },
          label: Text(
            "Scan",
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.camera,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget customButton({
    String title,
    Color color,
    Color isColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: Column(
            children: [
              Text(
                "$title",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: (color),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isColor, width: 3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value, Color color) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: color,
    ));
  }

  Future _scanCard() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );
      var resultat = await BarcodeScanner.scan(options: options);
      setState(() async {
        qrResultat = resultat;
        if (isSelected == false && qrResultat.rawContent.length > 0) {
          idCarte.text = qrResultat.rawContent;
          try {
            List data = await getData(
                batch: qrResultat.rawContent,
                refEnreprise: Constants.modelLogin.refEntreprise,
                status: "0");

            if (data.length > 0) {
              setState(() {
                Constants.modelLocal = ModelLocal.fromJson(data[0]);
                _ackAlertsortie(
                  context: context,
                  consigne: Constants.modelLocal.consigne,
                  heureEntre: Constants.modelLocal.dateentre,
                  personne: Constants.modelLocal.nom,
                  viter: Constants.modelLocal.visiter,
                );
                Constants.modelPresence = ModelPresence(
                    batch: Constants.modelLocal.batch,
                    refPerVisiter: "",
                    objectconsigner: "",
                    refEntreprise: Constants.modelLogin.refEntreprise,
                    motif: "",
                    refPersonne: "");
                _blocPresence.add(
                  EventsendData(presence: Constants.modelPresence, status: "1"),
                );
              });

              if (Constants.save == true) {
                setState(() async {
                  await deleteData(
                      batch: Constants.modelLocal.batch,
                      refEntreprise: Constants.modelLocal.refEntreprise);
                });
              } else {
                setState(() async {
                  await deleteData(
                      batch: Constants.modelLocal.batch,
                      refEntreprise: Constants.modelLocal.refEntreprise);
                });
              }
            } else {
              setState(() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return Myvisiteur(
                      qrResultat: qrResultat.rawContent,
                    );
                  }),
                );
              });

              // getBottomSheet();
            }
          } catch (_) {
            print(_.toString());
          }
        } else if (isSelected == true && qrResultat.rawContent.length > 0) {
          try {
            List data = await getData(
                batch: qrResultat.rawContent,
                refEnreprise: Constants.modelLogin.refEntreprise,
                status: "1");
            if (data.length > 0) {
              Constants.modelLocal = ModelLocal.fromJson(data[0]);
              if (Constants.modelLocal.consigne != null) {
                // isAlerter(index: 1);
                // isAlerter();
                isalertDialogue(
                    context: context,
                    dure: 0,
                    tilte: "${Constants.modelLocal.consigne}",
                    widget: Icon(
                      Icons.verified_user,
                      color: Colors.blue,
                      size: 35,
                    ));
                Constants.modelPresence = ModelPresence(
                    batch: Constants.modelLocal.batch,
                    refPerVisiter: "",
                    objectconsigner: "",
                    refEntreprise: Constants.modelLogin.refEntreprise,
                    motif: "",
                    refPersonne: "");
                setState(() {
                  _blocPresence = BlocPresence(StatePresenceInit());
                  _blocPresence.add(EventsendData(
                      presence: Constants.modelPresence, status: "0"));
                });

                if (Constants.save == true) {
                  setState(() async {
                    await deleteData(
                        batch: Constants.modelLocal.batch,
                        refEntreprise: Constants.modelLocal.refEntreprise);
                  });
                }
              }
            } else {
              setState(() {
                observation.clear();
                isAlerter(index: 0);
              });
            }
          } catch (_) {
            print(_.toString());
          }
        }
      });
    } on PlatformException catch (_) {
      if (_.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          print("Camera permissin was denied");
        });
      } else {
        setState(() {
          print("Unknown Error $_");
        });
      }
    } on FormatException {
      setState(() {
        print("You pressed the back button before scanning anithing");
      });
    } catch (_) {
      setState(() {
        print("Unknown Error $_");
      });
    }
  }

  Widget customTextField(
      {String held,
      TextEditingController controller,
      IconData icon,
      Function onPresse}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: TextFormField(
            controller: controller,
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
    );
  }

  void getBottomSheet() {
    visiteur.clear();
    nomComplet.clear();
    motif.clear();
    idCarte.clear();
    observation.clear();
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                customTextField(
                                    held: "Personne a visiter",
                                    controller: nomComplet,
                                    icon: Icons.person,
                                    onPresse: () {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        _ackAlert(context);
                                      });
                                    }),
                                customTextField(
                                    held: "Nom visiteur",
                                    controller: visiteur,
                                    icon: Icons.person,
                                    onPresse: () {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        _ackAlertvisiteur(context);
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
                                  controller:
                                      isSelected == false ? observation : "",
                                  icon: Icons.open_in_browser,
                                ),
                                customTextField(
                                  held: "Motif",
                                  controller: motif,
                                  icon: Icons.border_color,
                                  onPresse: () {
                                    setState(() {
                                      if (visiteur.text == nomComplet.text) {
                                        showInSnackBar(
                                            "Nom invalider", Colors.black);
                                      }
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      backu = true;
                                    });
                                    try {
                                      Constants.modelPresence = ModelPresence(
                                        batch: idCarte.text,
                                        refPerVisiter: nomComplet.text,
                                        objectconsigner: observation.text,
                                        refEntreprise:
                                            Constants.modelLogin.refEntreprise,
                                        motif: motif.text,
                                        refPersonne: visiteur.text,
                                      );
                                      Constants.modelLocal = ModelLocal(
                                        batch: idCarte.text,
                                        dateentre: DateTime.now().toString(),
                                        consigne: observation.text,
                                        nom: nomComplet.text,
                                        visiter: visiteur.text,
                                        status: '1',
                                        refEntreprise:
                                            Constants.modelLogin.refEntreprise,
                                      );
                                      setState(() {
                                        _blocPresence =
                                            BlocPresence(StatePresenceInit());
                                        _blocPresence.add(EventsendData(
                                          presence: Constants.modelPresence,
                                          status: "1",
                                        ));
                                      });
                                      setState(() {
                                        if (Constants.save == true) {
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(msg: "succes");
                                        }
                                        createCustomer(Constants.modelLocal);
                                      });
                                    } catch (_) {
                                      Fluttertoast.showToast(
                                          msg: "Erreur ${_.toString()}");
                                    }
                                  },
                                  child: Container(
                                    child: backu
                                        ? Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                          )
                                        : Center(
                                            child: SpinKitCircle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
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
                                type: 'VISITEUR'),
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
                            return state.data.isNotEmpty
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
                                type: 'AUTRES'),
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

  Future<void> _ackAlertsortie(
      {BuildContext context,
      String consigne,
      String personne,
      String viter,
      String heureEntre}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("AU REVOIR")),
          content: Container(
            width: MediaQuery.of(context).size.width - 5,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                Material(
                  elevation: 1,
                  color: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 5,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              color: Colors.white,
                              elevation: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 5,
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nom",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "${viter}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              color: Colors.white,
                              elevation: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 5,
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Personne a visiter",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "${personne}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              color: Colors.white,
                              elevation: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 5,
                                child: Row(
                                  children: [
                                    Icon(Icons.open_in_browser),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Objet consigne",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "${consigne}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Material(
                              color: Colors.white,
                              elevation: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 5,
                                child: Row(
                                  children: [
                                    Icon(Icons.perm_contact_calendar),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Heure entre",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "${heureEntre.substring(10, 19)}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> isAlerter({int index}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("OBJET CONSIGNE"),
                SizedBox(
                  height: 10,
                ),
                Material(
                  color: Colors.grey.withOpacity(.1),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: TextField(
                          controller: observation,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Objet a consigne",
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                setState(() {
                  connexionStatus();
                  if (connecter) {
                    try {
                      if (observation.text.trim().isNotEmpty ||
                          observation.text.trim().isEmpty) {
                        Constants.modelPresence = ModelPresence(
                          batch: qrResultat.rawContent,
                          refPerVisiter: "",
                          objectconsigner: observation.text,
                          refEntreprise: Constants.modelLogin.refEntreprise,
                          motif: "",
                          refPersonne: "",
                        );
                        Constants.modelLocal = ModelLocal(
                          batch: qrResultat.rawContent,
                          dateentre: DateTime.now().toString(),
                          consigne: observation.text,
                          nom: nomComplet.text,
                          visiter: visiteur.text,
                          status: '0',
                          refEntreprise: Constants.modelLogin.refEntreprise,
                        );
                        setState(() {
                          _blocPresence = BlocPresence(StatePresenceInit());
                          _blocPresence.add(
                            EventsendData(
                              presence: Constants.modelPresence,
                              status: "0",
                            ),
                          );
                          if (Constants.save == true) {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(msg: "Succes");
                          } else {
                            Fluttertoast.showToast(msg: "Succes");
                            Navigator.of(context).pop();
                          }
                          createCustomer(Constants.modelLocal);
                        });
                      }
                    } catch (_) {
                      print(_.toString());
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Veuillez vérifier votre connexion internet");
                  }
                });
              },
              child: Text("Valider"),
            ),
          ],
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
}
