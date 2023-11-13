import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maison_mate/constants.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  Future<IOWebSocketChannel> connect() async {
    final value = await getToken();
    final channel = IOWebSocketChannel.connect(
        "$webSocketUrl?subscriber_type=Partner&subscriber_auth_token=$value");
    return channel;
  }

  Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final authToken = await storage.read(key: authTokenKey);
    return authToken ?? '';
  }

  subscribe(channel, channelName) {
    channel.sink.add(jsonEncode({
      'command': 'subscribe',
      'identifier': jsonEncode({'channel': channelName})
    }));
  }

  sendMessage(channel, channelName, message) {
    channel.sink.add(jsonEncode({
      'data': jsonEncode(message),
      'command': 'message',
      'identifier': jsonEncode({'channel': channelName})
    }));
  }
}
