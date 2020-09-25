import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence/app/bloc/blocLoginn/blocLogin.dart';
import 'package:presence/app/bloc/blocLoginn/stateLogin.dart';
import 'package:presence/app/bloc/blocPersonne/blocPersonne.dart';
import 'package:presence/gui/myconnexiontest.dart';
import 'package:presence/gui/mylogin.dart';
import 'package:presence/gui/myspan.dart';
import 'package:presence/outils/app_theme.dart';
import 'package:presence/starters/start_page.dart';
import 'app/bloc/blocPersonne/blocPersonne.dart';
import 'app/bloc/blocPersonne/statePersonne.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyMain()));
}

class MyMain extends StatefulWidget {
  @override
  _MyMain createState() => _MyMain();
}

class _MyMain extends State<MyMain> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF31ACFF),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BlocPersonne(StatePersonneInit())),
        BlocProvider(create: (context) => BlocLogin(StateLoginInit())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xFF31ACFF),
            scaffoldBackgroundColor: Colors.white,
            textTheme: AppTheme.textTheme,
            accentColor: Color(0xFF31ACFF)
            //  platform: TargetPlatform.iOS,
            ),
        routes: {
          MyLogin.rootName: (_) => MyLogin(),
          MyConnexion.routeName: (_) => MyConnexion(),
          Starters.rooteName: (_) => Starters(),
        },
        home: Myspan(),
        // home: Starters(),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
