import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presence/app/bloc/blocPersonne/blocPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/eventPersonne.dart';
import 'package:presence/app/bloc/blocPersonne/statePersonne.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/outils/Apptheme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Mydatafetch extends StatefulWidget {
  @override
  _Mydatafetch createState() => _Mydatafetch();
}

class _Mydatafetch extends State<Mydatafetch> {
  final searchTxt = TextEditingController();
  final controller = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController;
  ScrollController _scrollContro = ScrollController();
  bool connxionStatus = true;
  @override
  void initState() {
    super.initState();
    connectionStatus();
    BlocProvider.of<BlocPersonne>(context).add(EventPersonneFetch(
        personne: Constants.modelLogin.refEntreprise, type: 'AUTRES'));
    _scrollController = ScrollController();
    print(connxionStatus);
    // personne = new BlocPersonne(StatePersonneInit());
    // personne.add(EventPersonneFetch(
    //     personne: Constants.modelLogin.refEntreprise, type: 'AUTRES'));
  }

  void connectionStatus() {
    setState(() {
      Future.delayed(Duration(microseconds: 10)).then((value) async {
        connxionStatus = await Constants.getInstance().connectionState();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: SafeArea(
          child: Scaffold(
        body: SmartRefresher(
          controller: _refreshController,
          scrollController: _scrollController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 1000));
            setState(() {
              connectionStatus();
              if (connxionStatus == true) {
                BlocProvider.of<BlocPersonne>(context).add(EventPersonneFetch(
                    personne: Constants.modelLogin.refEntreprise,
                    type: 'AUTRES'));
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
                padding: const EdgeInsets.all(5.0),
                child: customuseTextField(
                    icon: Icons.search,
                    text: "Rechercher...",
                    controller: searchTxt,
                    onRealeser: (val) {
                      setState(() {
                        connectionStatus();
                        if (connxionStatus == true) {
                          BlocProvider.of<BlocPersonne>(context)
                              .add(EventSearchPersonne(
                            personne: val,
                            entreprise: Constants.modelLogin.refEntreprise,
                            type: 'AUTRES',
                          ));
                          // personne.add(EventSearchPersonne(
                          //   personne: val,
                          //   entreprise: Constants.modelLogin.refEntreprise,
                          //   type: 'AUTRES',
                          // ));
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Veuillez vérifier votre connexion internet");
                        }
                      });
                    },
                    type: TextInputType.text),
              ),
              Expanded(
                child: connxionStatus == true
                    ? construireData()
                    : Center(
                        child: Container(
                          child: AvatarGlow(
                            glowColor: Colors.blue,
                            endRadius: 100,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.cloud_off,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget construireData() {
    return AnimationLimiter(
      child: BlocBuilder<BlocPersonne, dynamic>(
        builder: (context, state) {
          if (state is StatePersonneInit) {
            return Center(
                child: SpinKitCircle(
              color: Colors.blue,
              duration: Duration(seconds: 2),
              size: 35,
            ));
          }
          if (state is StatePersonneLoading) {
            return Center(
              child: SpinKitCircle(
                color: Colors.blue,
                duration: Duration(seconds: 2),
                size: 35,
              ),
            );
          }
          if (state is StatePersonneError) {
            return Center(
              child: Text("${state.message}"),
            );
          }
          if (state is StatePersonneLoaded) {
            return state.data != null
                ? state.data.length > 0
                    ? ListView.builder(
                        controller: _scrollContro,
                        // physics: ScrollPhysics(),
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 375),
                            position: index,
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: customuCard(
                                    adresse: "${state.data[index].adresse}",
                                    contact: "${state.data[index].tel}",
                                    entreprise: "${state.data[index].nom}",
                                    fonction: "${state.data[index].fonction}",
                                    mail: "${state.data[index].email}",
                                    nom: "${state.data[index].entreprise}",
                                    color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text("Aucun donnee trouver sur le recherche"),
                      )
                : Center(
                    child: Text("Aucun donnee trouver sur le recherche"),
                  );
          } else {
            return Container(
                child: Text("Aucun donnee trouver sur le recherche"));
          }
        },
      ),
    );
  }

  Widget customuCard(
      {String entreprise,
      String nom,
      String fonction,
      String contact,
      String mail,
      String adresse,
      Color color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2, bottom: 2),
      child: Form(
        child: Material(
          color: color,
          elevation: 1,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: MediaQuery.of(context).size.height / 5.5,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.personBooth,
                              size: 15,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${entreprise}",
                              style: TextStyle(
                                  //  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<Object>(
                                stream: null,
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.filter_hdr,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${nom}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  );
                                }),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_activity,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${fonction}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${contact}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.mail,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${mail}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.add_location,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${adresse}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customuseTextField(
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
