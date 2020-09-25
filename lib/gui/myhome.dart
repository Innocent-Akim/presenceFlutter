import 'package:flutter/material.dart';
import 'package:presence/gui/myidentification.dart';
import 'package:presence/gui/mymouvement.dart';
import 'package:presence/gui/myscan.dart';
import 'package:presence/outils/Apptheme.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHome createState() => _MyHome();
}

class _MyHome extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
          color: Colors.white,
          child: SafeArea(
              child: Scaffold(
            body: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "assets/home01.jpg",
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                customMenu(
                                  color: Color(0xFFE22C2C),
                                  icon: Icons.dashboard,
                                  clr: Color(0xFFFFFFFF),
                                  menu: "Dashboard",
                                  message: "23500",
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return MyIdentification();
                                      },
                                    ));
                                  },
                                  child: customMenu(
                                    color: Color(0x8A0BB644),
                                    icon: Icons.perm_identity,
                                    clr: Color(0xFFFFFFFF),
                                    menu: "Identification",
                                    message: "2350",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return Myscan();
                                      },
                                    ));
                                  },
                                  child: customMenu(
                                    color: Color(0xD02EAAE4),
                                    icon: Icons.person_pin_circle,
                                    clr: Color(0xFFFFFFFF),
                                    menu: "Presence",
                                    message: "10215",
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return Mymouvement();
                                      },
                                    ));
                                  },
                                  child: customMenu(
                                    color: Color(0x8AE6AD12),
                                    icon: Icons.settings_applications,
                                    clr: Color(0xFFFFFFFF),
                                    menu: "Mouvement",
                                    message: "2500",
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                    )
                  ],
                ),
              ],
            ),
          ))),
    );
  }

  Widget customMenu(
      {String message, IconData icon, Color color, Color clr, String menu}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                elevation: 0.5,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.height / 4.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: color),
                          child: Icon(
                            icon,
                            color: clr,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 5.0, right: 5.0),
                        child: Text(
                          "${message}",
                          style: TextStyle(
                              color: Color(0x9A000000),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 30,
            top: -20,
            child: InkResponse(
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF39ACF3),
                  ),
                  child: Center(
                    child: Text(
                      "$menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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

// Carousel(
//             boxFit: BoxFit.cover,
//             autoplay: false,
//             animationCurve: Curves.fastOutSlowIn,
//             animationDuration: Duration(milliseconds: 1000),
//             dotSize: 6.0,
//             dotIncreasedColor: Color(0xFFFF335C),
//             dotBgColor: Colors.transparent,
//             dotPosition: DotPosition.topRight,
//             dotVerticalPadding: 10.0,
//             showIndicator: true,
//             indicatorBgPadding: 7.0,
//             images: [
//               NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
//               NetworkImage('https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
//               ExactAssetImage("assets/images/LaunchImage.jpg"),
//             ],
//           ),
