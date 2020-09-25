import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/app/bloc/blocPresence/blocpresence.dart';
import 'package:presence/app/bloc/blocPresence/eventpresence.dart';
import 'package:presence/app/bloc/blocPresence/statepresence.dart';
import 'package:presence/app/model/modelPresence.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/app/source/datasourcesqlife.dart';
import 'package:presence/gui/alert_message.dart';
import 'package:presence/outils/Apptheme.dart';

class Mymouvement extends StatefulWidget {
  static const String rootName = "/myscan";
  @override
  _Mymouvement createState() => _Mymouvement();
}

class _Mymouvement extends State<Mymouvement> {
  TextEditingController motif = TextEditingController();
  ScanResult qrResultat;
  BlocPresence _blocPresence;
  bool _status = false;
  bool connexionStatus = false;
  String result;
  bool condition = true;
  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  // ignore: type_annotate_public_apis
  initState() {
    super.initState();
    _blocPresence = BlocPresence(StatePresenceInit());
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
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

    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(
                    "Utiliser votre carte de service pour faire le deplacement",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF39ACF3),
                        fontWeight: FontWeight.w100),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/smart_login.jpg",
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ],
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
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
      int statusDelete = 0;
      setState(() async {
        statusConnexion();

        qrResultat = resultat;

        if (connexionStatus) {
          List data = await getData(
            batch: qrResultat.rawContent,
            refEnreprise: Constants.modelLogin.refEntreprise,
            status: "2",
          );
          print("-------------------------> ${data}");
          if (data.length > 0) {
            if (data != null) {
              Constants.modelPresence = ModelPresence(
                batch: qrResultat.rawContent,
                refPerVisiter: "",
                objectconsigner: "",
                refEntreprise: Constants.modelLogin.refEntreprise,
                motif: "",
                refPersonne: "",
              );
              setState(() {
                _blocPresence.add(EventsendData(
                  presence: Constants.modelPresence,
                  status: "2",
                ));
              });
            }
            if (Constants.save == true) {
              statusDelete = await deleteData(
                  batch: Constants.modelLocal.batch,
                  refEntreprise: Constants.modelLocal.refEntreprise);
              print("delete resultat OK ${statusDelete}");
            } else {
              statusDelete = await deleteData(
                  batch: Constants.modelLocal.batch,
                  refEntreprise: Constants.modelLocal.refEntreprise);
              print("delete resultat ${statusDelete}");
            }
          } else {
            setState(() {
              forgetPassword(idCarte: qrResultat.rawContent);
            });

            // getBottomSheet(qt: qrResultat.rawContent);
          }
        } else {
          isalertDialogue(
            context: context,
            tilte: "Veuillez vérifier votre connexion internet",
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
                    border: Border.all(color: Colors.blue, width: 1),
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
            dure: 2,
          );
        }
      });
    } on PlatformException catch (_) {
      if (_.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          // resultat = "Camera permissin was denied";
        });
      } else {
        setState(() {
          // qrResultat = "Unknown Error $_";
        });
      }
    } on FormatException {
      setState(() {
        // qrResultat = "You pressed the back button before scanning anithing";
      });
    } catch (_) {
      setState(() {
        // qrResultat = "Unknown Error $_";
      });
    }
  }

  Future<dynamic> forgetPassword({String idCarte}) {
    FocusScope.of(context).requestFocus(FocusNode());
    motif.clear();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.width / 1.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "SIGNALE VOTRE DEPLACEMENT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: TextFormField(
                            controller: motif,
                            maxLines: 20,
                            minLines: 1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Saisissez votre motif",
                                enabled: true),
                          ),
                        ),
                      ),
                    ),
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
                            initMouvement();
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getBottomSheet({String qt}) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return Container(
            child: Container(
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
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: TextFormField(
                            controller: motif,
                            maxLines: 20,
                            minLines: 1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Saisissez votre motif",
                                enabled: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      initMouvement();
                    },
                    child: Container(
                      child: !_status
                          ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Valider",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
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
            ),
          );
        });
  }

  void statusConnexion() async {
    connexionStatus = await Constants.getInstance().connectionState();
  }

  initMouvement() async {
    _status = true;
    setState(() {
      statusConnexion();
    });
    statusConnexion();
    // connexionStatus = await Constants.getInstance().connectionState();
    try {
      print("================================>${connexionStatus}");
      if (connexionStatus) {
        if (isTest) {
          Constants.modelPresence = ModelPresence(
            batch: qrResultat.rawContent,
            refPerVisiter: "",
            objectconsigner: "",
            refEntreprise: Constants.modelLogin.refEntreprise,
            motif: motif.text,
            refPersonne: "",
          );
          Constants.modelLocal = ModelLocal(
            batch: qrResultat.rawContent,
            dateentre: DateTime.now().toString(),
            consigne: "",
            nom: "",
            visiter: "",
            status: '2',
            refEntreprise: Constants.modelLogin.refEntreprise,
          );
          setState(() {
            _blocPresence.add(EventsendData(
              presence: Constants.modelPresence,
              status: "2",
            ));

            if (Constants.save == true) {
              Navigator.of(context).pop();
              FocusScope.of(context).requestFocus(FocusNode());
              Fluttertoast.showToast(msg: "Enregistrement reussi");
            } else {
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "Enregistrement reussi");
            }
            createCustomer(Constants.modelLocal);
            // chargeCount();
          });
          motif.clear();
        } else {
          Fluttertoast.showToast(msg: "Completer les champs");
        }
        setState(() {
          _status = false;
        });
      } else {
        setState(() {
          _status = false;
        });

        Fluttertoast.showToast(msg: "Erreur de connection...");
        // isalertDialogue(
        //   context: context,
        //   tilte: "Erreur de la Connexion",
        //   widget: AvatarGlow(
        //     endRadius: 60,
        //     glowColor: Colors.blue,
        //     child: Container(
        //       height: 50,
        //       width: 50,
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(25),
        //         border:
        //             Border.all(color: Colors.blue, width: 1),
        //       ),
        //       child: Icon(
        //         Icons.cloud_off,
        //         size: 30,
        //       ),
        //     ),
        //   ),
        //   dure: 1000,
        // );
      }
    } catch (_) {
      print(_.toString());
    }
  }

  bool get isTest {
    if (motif.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  void showInSnackBar(String value, Color color) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: color,
    ));
  }
}
