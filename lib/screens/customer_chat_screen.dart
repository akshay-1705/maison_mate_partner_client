import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/provider/send_quote_model.dart';
import 'package:maison_mate/screens/send_quote_screen.dart';
import 'package:maison_mate/services/web_socket_service.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class CustomerChatScreen extends StatefulWidget {
  final MyJobDetailsResponse? data;
  const CustomerChatScreen({super.key, required this.data});

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  List<ChatMessage> messages = [];
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  WebSocketService webSocketService = WebSocketService();
  IOWebSocketChannel? channel;
  late Future<ApiResponse> futureData;
  late String apiUrl;

  @override
  void initState() {
    super.initState();
    apiUrl =
        "$baseApiUrl/partners/chat?entity_id=${widget.data?.userId}&entity_type=User";
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((apiResponse) {
      if (mounted) {
        // TODO: This is incorrect. Consider time of message and then order
        // accordingly. Backend will also change.
        var data = apiResponse.data;
        data.received.forEach((message) {
          messages.add(
              ChatMessage(messageContent: message, messageType: 'receiver'));
        });

        data.sent.forEach((message) {
          messages
              .add(ChatMessage(messageContent: message, messageType: 'sender'));
        });
      }
    });
    initializeWebSocket();
  }

  Future<void> initializeWebSocket() async {
    channel = await webSocketService.connect();
    webSocketService.subscribe(channel, 'ChatChannel');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (channel == null) {
      return Scaffold(appBar: chatAppBar(context), body: Container());
    } else {
      return Scaffold(
          appBar: chatAppBar(context),
          body: StreamBuilder(
              stream: channel?.stream,
              builder: (context, snapshot) {
                listenToMessage(snapshot);
                return GetRequestFutureBuilder<dynamic>(
                    future: futureData,
                    apiUrl: apiUrl,
                    builder: (context, data) {
                      return renderElements();
                    });
              }));
    }
  }

  void listenToMessage(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.data != null) {
      var data = jsonDecode(snapshot.data);
      var message = data['message'];

      if (message is Map && message['chat'] != null) {
        messages.add(ChatMessage(
            messageContent: message['chat'], messageType: 'receiver'));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  Stack renderElements() {
    return Stack(
      children: <Widget>[
        chat(),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
            height: 65,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (messageController.text != '') {
                      messages.add(ChatMessage(
                          messageContent: messageController.text,
                          messageType: 'sender'));

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      });
                      setState(() {});
                      channel?.sink.add(jsonEncode({
                        'data': jsonEncode({
                          'text': messageController.text,
                          'receiver_type': 'User',
                          'receiver_id': widget.data?.userId
                        }),
                        'command': 'message',
                        'identifier': jsonEncode({'channel': 'ChatChannel'})
                      }));
                      messageController.text = '';
                    }
                  },
                  backgroundColor: Colors.black,
                  elevation: 0,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector chat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    return GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapped on a non-actionable item
          FocusScope.of(context).unfocus();
        },
        child: Container(
            padding: const EdgeInsets.only(bottom: 50),
            color: Colors.white70,
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "receiver"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            )));
  }

  AppBar chatAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.data!.userName ?? '',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (widget.data?.status == 'Accepted') ...[
                GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider(
                          create: (context) => SendQuoteModel(),
                          child: SendQuoteScreen(jobId: widget.data?.id),
                        );
                      }));
                    },
                    child: const Text('Send Quote',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12))),
              ],
              const SizedBox(
                width: 5,
              ),
              threeDotMenu()
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> threeDotMenu() {
    return PopupMenuButton<String>(
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'customerInactive',
            child: Text('Customer Inactive'),
          ),
        ];
      },
      onSelected: (String choice) {
        if (choice == 'customerInactive') {
          // Perform an action for userInactive
        }
      },
      icon: const Icon(Icons.more_vert), // The 3-dot icon
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}
