import 'package:flutter/material.dart';

Future<dynamic> isalertDialogue(
    {BuildContext context, String tilte, Widget widget, int dure}) {
  // Future.delayed(new Duration(seconds: dure)).then((value) {
  FocusScope.of(context).requestFocus(FocusNode());
  //   Navigator.of(context).pop();
  // });
  // flutter_speed_dial_material_design
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          width: 80,
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: Text(
                      "$tilte",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Text(""),
                ),
                Center(child: widget)
              ],
            ),
          ),
        ),
      );
    },
  );
}
