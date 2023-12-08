import 'package:flutter_dotenv/flutter_dotenv.dart';

// Secrets
String secretHeader = dotenv.env['SECRET_HEADER'] ?? '';
String baseApiUrl = dotenv.env['BASE_API_URL'] ?? '';
String webSocketUrl = dotenv.env['WEB_SOCKET_URL'] ?? '';

// Constants
const String authTokenKey = "authToken";
const String networkError = "Network Error";
const String somethingWentWrong =
    "Something Went Wrong. Try again after sometime";
const themeColor = 0xff000000;
const secondaryColor = 0xffffffff;
const awesomeColor = 0xffff7241;
