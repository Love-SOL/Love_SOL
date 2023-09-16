import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = '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';
const endpoint = 'https://api.openai.com/v1/chat/completions';


Future<String> getChatGPTResponse(List<Map<String, dynamic>> messages) async {

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': messages,
      'temperature': 0.34,
      'max_tokens': 256,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0,
    }),
  );

  var decode = utf8.decode(response.bodyBytes);

  if (response.statusCode == 200) {
    Map<String , dynamic > responseBody = json.decode(decode);
    final chatGPTResponse = responseBody['choices'][0]['message']['content'];
    return chatGPTResponse;
  } else {
    throw Exception('Failed to connect to ChatGPT API');
  }
}

class ChatBotApp extends StatefulWidget {
  final Function(String) onMessageReceived; // 콜백 함수 추가

  ChatBotApp({required this.onMessageReceived});

  @override
  _ChatBotAppState createState() => _ChatBotAppState();
}

class _ChatBotAppState extends State<ChatBotApp> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];


  void _handleMessageSubmit(String message) async {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUserMessage: true,
      ));
    });


    try {
      final botResponse = await getChatGPTResponse([
        {
          "role": "system",
          "content": "너는 데이트 장소 추천 전문가야.\n나는 장소에 대한 정보를 너에게 알려줄 거야. 너는 장소에 대한 정보를 받게 되면, 그 장소 주변에 있는 데이트 장소를 추천해줘. 30글자 이내로 문장을 끝마쳐줘."
        },
        {
          "role": "user",
          "content": message,
        },
      ]);


      setState(() {
        _messages.add(ChatMessage(
          text: botResponse,
          isUserMessage: false,
        ));
      });
      widget.onMessageReceived(botResponse);
    } catch (e) {
      final errorMessage = 'API 요청에 실패했습니다: $e';
      setState(() {
        _messages.add(ChatMessage(
          text: errorMessage,
          isUserMessage: false,
        ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Container(
                  color: Color(0xA47DE5),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatBubble(
                        text: message.text,
                        isUserMessage: message.isUserMessage,
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Color(0xFFFFFFFF),
                child: _buildMessageInput(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (message) {
                if (message.isNotEmpty) {
                  _handleMessageSubmit(message);
                  _controller.clear();
                }
              },
              decoration: InputDecoration(
                hintText: '궁금한 점을 입력하세요',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors
                      .deepPurple), // Change this color to the color you want
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  ChatBubble({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Color(0xFFDADADA) : Color(0xFFA47DE5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

