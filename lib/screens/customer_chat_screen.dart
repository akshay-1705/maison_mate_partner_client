import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/message_response.dart';
import 'package:maison_mate/network/response/my_job_details_response.dart';
import 'package:maison_mate/provider/send_quote_model.dart';
import 'package:maison_mate/screens/image_view_screen.dart';
import 'package:maison_mate/screens/send_quote_screen.dart';
import 'package:maison_mate/services/web_socket_service.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:path_provider/path_provider.dart';
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
  bool scrollOnce = false;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    apiUrl =
        "$baseApiUrl/partners/chat?entity_id=${widget.data?.userId}&entity_type=User&identifier_type=JobAssignment&identifier_id=${widget.data?.id}";
    futureData = GetClient.fetchData(apiUrl);
    futureData.then((apiResponse) {
      if (mounted) {
        List<MessageResponse> chat = apiResponse.data.messages;
        for (var message in chat) {
          String messageType = message.isSender ? 'sender' : 'receiver';
          ChatMessage cM = ChatMessage(
              messageContent: message.text, messageType: messageType);
          if (message.imageUrl != null) {
            cM.imageUrl = message.imageUrl ?? '';
          }

          messages.add(cM);
        }
      }
    });
    initializeWebSocket();
  }

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
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

      if (message is Map && message['text'] != null) {
        messages.add(ChatMessage(
            messageContent: message['text'],
            messageType: 'receiver',
            imageUrl: message['image_url']));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  Future<void> getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    showOverlay();
    final pickedFile = await picker.pickImage(source: source);
    hideOverlay();

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      sendToServer(file);
    }
  }

  void sendToServer(File pickedFile) {
    const int maxFileSize = 10 * 1024 * 1024;
    if (pickedFile.lengthSync() <= maxFileSize) {
      messages.add(ChatMessage(
          messageContent: '', messageType: 'sender', file: pickedFile));
      String base64String =
          base64Encode(File(pickedFile.path).readAsBytesSync());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      setState(() {});
      channel?.sink.add(jsonEncode({
        'data': jsonEncode({
          'text': '',
          'file': base64String,
          'receiver_type': 'User',
          'receiver_id': widget.data?.userId,
          'identifier_id': widget.data?.id,
          'identifier_type': 'JobAssignment'
        }),
        'command': 'message',
        'identifier': jsonEncode({'channel': 'ChatChannel'})
      }));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message:
                    'File size exceeds the maximum allowed size of ${maxFileSize ~/ (1024 * 1024)} MB.',
                error: true)
            .getSnackbar());
      });
    }
  }

  void openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () {
                  getImage(context, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  getImage(context, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
                GestureDetector(
                    onTap: () async {
                      openImagePicker(context);
                    },
                    child: const Icon(Icons.camera_alt)),
                const SizedBox(
                  width: 20,
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
                          'receiver_id': widget.data?.userId,
                          'identifier_id': widget.data?.id,
                          'identifier_type': 'JobAssignment'
                        }),
                        'command': 'message',
                        'identifier': jsonEncode({'channel': 'ChatChannel'})
                      }));
                      messageController.text = '';
                    }
                  },
                  backgroundColor: Colors.green.shade400,
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
      if (!scrollOnce) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        scrollOnce = true;
      }
    });
    return GestureDetector(
        onTap: () {
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
                        child: Column(children: [
                          if (messages[index].messageContent.isNotEmpty) ...[
                            Text(
                              messages[index].messageContent,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ] else if (messages[index].file != null) ...[
                            messages[index].file!.lengthSync() > 1000
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewScreen(
                                              imagePath:
                                                  messages[index].file!.path),
                                        ),
                                      );
                                    },
                                    child: Image.file(
                                      File(messages[index].file!.path),
                                      width: 100,
                                      height: 100,
                                    ),
                                  )
                                : const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                          ] else if (messages[index].imageUrl != null) ...[
                            GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    messages[index].downloading = true;
                                  });
                                  File? tempFile;
                                  Directory tempDir =
                                      await getTemporaryDirectory();
                                  String tempFilePath =
                                      '${tempDir.path}/temp_image_$index.jpg';
                                  http.Response response = await http.get(
                                      Uri.parse(
                                          messages[index].imageUrl ?? ''));
                                  if (response.statusCode == 200) {
                                    tempFile = File(tempFilePath);
                                    await tempFile
                                        .writeAsBytes(response.bodyBytes);
                                  } else {
                                    throw Exception('Failed to download image');
                                  }
                                  setState(() {
                                    messages[index].file = tempFile;
                                    messages[index].downloading = false;
                                  });
                                },
                                child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: messages[index].downloading ?? false
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.black38),
                                          )
                                        : const Icon(Icons.downloading)))
                          ],
                        ])),
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
                  color: Colors.orange,
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
              if (widget.data?.status == 'Pending') ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  String? imageUrl;
  File? file;
  bool? downloading = false;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      this.imageUrl,
      this.file,
      this.downloading});
}
