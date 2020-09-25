// import 'dart:io';
// import 'package:http/http.dart' as http;

// Future<http.Response> httpPostWithToken(
//     {String serviceApi, Map<String, dynamic> data}) async {
//   var response;
//   try {
//     response = await http.post('$serviceApi', body: data, headers: {
//       HttpHeaders.authorizationHeader: 'Bearer $token',
//       'X-Requested-With': 'XMLHttpRequest',
//       // 'Content-type': 'application/json',
//     });
//     // print(_urlBase + '$serviceApi');
//     return response;
//   } catch (_) {
//     print(_.toString());
//     throw new Exception("ERROR");
//   }
// }
