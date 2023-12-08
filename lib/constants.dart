import 'package:flutter_dotenv/flutter_dotenv.dart';

String secretHeader = dotenv.env['SECRET_HEADER'] ?? '';
const String authTokenKey = "authToken";
String baseApiUrl = dotenv.env['BASE_API_URL'] ?? '';
String webSocketUrl = dotenv.env['WEB_SOCKET_URL'] ?? '';
const String networkError = "Network Error";
const String somethingWentWrong =
    "Something Went Wrong. Try again after sometime";
const themeColor = 0xff000000;
const secondaryColor = 0xffffffff;
const awesomeColor = 0xffff7241;
