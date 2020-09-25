import 'package:flutter/material.dart';
import 'package:presence/app/model/modelLogin.dart';
import 'package:presence/app/source/constants.dart';
import 'package:presence/gui/mydatafetch.dart';
import 'package:presence/gui/myhome.dart';
import 'package:presence/gui/mymouvement.dart';
import 'package:presence/gui/myscan.dart';
import 'package:presence/gui/myidentification.dart';
import 'package:presence/outils/Apptheme.dart';

class MyDashboard extends StatefulWidget {
  final ModelLogin login;

  const MyDashboard({Key key, this.login}) : super(key: key);
  @override
  _MyDashboard createState() => _MyDashboard();
}

class _MyDashboard extends State<MyDashboard> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    MyHome(),
    MyIdentification(),
    Mydatafetch(),
    Myscan(),
    Mymouvement(),
  ];

  @override
  Widget build(BuildContext context) {
    Future<bool> _willpop() {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            "Voulais-vous quitter l'application ?",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: <Widget>[
            FlatButton(
                child: Text('NON'),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
            FlatButton(
                child: Text('OUI'),
                onPressed: () {
                  Navigator.pop(context, true);
                })
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: _willpop,
        child: Theme(
          data: HotelAppTheme.buildLightTheme(),
          child: SafeArea(
              child: Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.dashboard),
                  icon: Icon(Icons.pages),
                  title: Text('Dashboard'),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.people),
                  icon: Icon(Icons.perm_identity),
                  title: Text('Identification'),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.search),
                  icon: Icon(Icons.search),
                  title: Text('Recherche'),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.mode_edit),
                  icon: Icon(Icons.save_alt),
                  title: Text('Presence'),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.assignment),
                  icon: Icon(Icons.vibration),
                  title: Text('Mouvement'),
                )
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFF39ACF3),
              unselectedItemColor: Color(0xFF18191A),
              showUnselectedLabels: false,
              iconSize: 20,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              elevation: 5,
              onTap: _onItemTapped,
            ),
          )),
        ));
  }

  Widget customMenu(
      {String message, IconData icon, Color color, Color clr, String menu}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Material(
            color: Color(0xB0C0DCEE),
            borderRadius: BorderRadius.circular(10),
            elevation: 1.0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2.3,
              height: MediaQuery.of(context).size.height / 6.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: color),
                      child: Icon(
                        icon,
                        color: clr,
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                    child: Text(
                      "${message}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -20,
            child: InkResponse(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x9663F0E9),
                  ),
                  child: Center(
                    child: Text(
                      "$menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
