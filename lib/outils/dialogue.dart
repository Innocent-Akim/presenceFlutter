import 'package:flutter/material.dart';

class Dialogue {
  final tilte;
  Dialogue({this.tilte});
  final _globalKey = GlobalKey<FormState>();
  showDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 8,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "${tilte}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 40,
                          child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
