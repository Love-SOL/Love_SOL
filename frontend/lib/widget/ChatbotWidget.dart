import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = '';
const endpoint = 'https://api.openai.com/v1/chat/completions';

void main() => runApp(ChatBotApp());

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
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  return ChatBubble(
                    text: message.text,
                    isUserMessage: message.isUserMessage,
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }


  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: '메시지 입력'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final message = _controller.text;
              if (message.isNotEmpty) {
                _handleMessageSubmit(message);
                _controller.clear();
              }
            },
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

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.all(8.0),
//         padding: EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: isUserMessage ? Colors.blue : Colors.green,
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.green,
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