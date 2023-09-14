import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:dio/src/multipart_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumWidget extends StatefulWidget {
  final int dateLogId; // dateLogId를 저장할 변수 추가

  AlbumWidget({required this.dateLogId}); // 생성자 추가
  @override
  _AlbumWidgetState createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  List<String> comments = [];
  List<dynamic> imageList = [];
  TextEditingController commentController = TextEditingController();
  late int dateLogId; // dateLogId 변수 선언
  String userId = '';
  String coupleId = '';
  File? image0;
  String content = "";
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    dateLogId = widget.dateLogId;
    _initializeData();
  }

  void _initializeData() async {
    await _loadUserData();
    if (dateLogId != 0) {
      fetchAlbumData(dateLogId);
    } else {
      fetchAlbumAllData(dateLogId);
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  void uploadImage(int dateLogId, File image, String content) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        "content": content
      });
      List<int> imageBytes = image.readAsBytesSync();

      MultipartFile multipartFile = MultipartFile.fromBytes(imageBytes, filename: "image.jpg");

      // String Content를 FormData에 추가
      formData.files.add(MapEntry('image', multipartFile));
      // Replace the URL with your API endpoint.
      var response = await dio.post('http://10.0.2.2:8080/api/date-log/$dateLogId', data: formData);
      // Handle the response as needed.

      print('Response: ${response.data}');

    } catch (e) {
      print("에러 발생: $e");
    }
  }

  void writeComment(int imageId, String content) async {
    try {
      print(content);
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/comment/$imageId'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'content': content,
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];
      print("sadasdad");
      // 필요한 작업 수행
      if (statusCode == 200) {
        // 1원 이체 성공

      } else {
        print(statusCode);
        // 1원 이체 실패
        // 1원 이체 실패 실패 시의 처리를 수행
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  Future<void> fetchAlbumData(int dateLogId) async {
    print("데이트로그아이디는 ");
    print(dateLogId);
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/date-log/$dateLogId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decode = utf8.decode(response.bodyBytes);
        // 서버 응답 성공
        Map<String, dynamic> responseBody = json.decode(decode);

        // 파싱한 데이터에서 필드에 접근
        int statusCode = responseBody['statusCode'];
        if (statusCode == 200) {
          final decode = utf8.decode(response.bodyBytes);
          print(decode);

          // responseBody를 사용하여 데이터 추출
          int statusCode = responseBody['statusCode'];
          String messages = responseBody['messages'];
          String developerMessage = responseBody['developerMessage'];
          String timestamp = responseBody['timestamp'];

          // data 항목에 접근
          Map<String, dynamic> data = responseBody['data'];
          int dateLogId = data['dateLogId'];
          String dateAt = data['dateAt'];
          int mileage = data['mileage'];

          // imageList 항목에 접근
          List<dynamic> updatedImageList = data['imageList'].reversed.toList(); // 새로운 이미지 목록
          setState(() {
            imageList = updatedImageList; // 이미지 목록을 업데이트하고 화면을 다시 그립니다.
          });

          // 나머지 코드 생략...
        } else {
          print(statusCode);
          // 실패 처리
        }
      } else {
        print("서버 응답 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  Future<void> fetchAlbumAllData(int dateLogId) async {
    print("커플아이디는 ");
    print(coupleId);
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/date-log/image/all/$coupleId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decode = utf8.decode(response.bodyBytes);
        // 서버 응답 성공
        Map<String, dynamic> responseBody = json.decode(decode);

        // 파싱한 데이터에서 필드에 접근
        int? statusCode = responseBody['statusCode'] as int?;
        if (statusCode == 200) {
          final decode = utf8.decode(response.bodyBytes);
          print(decode);

          List<dynamic> updatedImageList = responseBody['data'].reversed.toList(); // 새로운 이미지 목록
          setState(() {
            imageList = updatedImageList; // 이미지 목록을 업데이트하고 화면을 다시 그립니다.
          });

        } else {
          print(statusCode);
          // 실패 처리
        }
      } else {
        print("서버 응답 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("에러발생 $e");
    }
    print(imageList);
  }

// 이미지를 표시하는 위젯
  Widget _buildImageWidget() {
    print(image0);
    return image0 != null
        ? Image.file(image0!, key: UniqueKey())
        : SizedBox.shrink(); // 이미지가 없는 경우 빈 위젯 반환
  }

// 이미지 업데이트 함수
  void _updateImage(XFile? image) {
    if (image != null) {
      print("하하하하 너냐?");
      setState(() {
        image0 = File(image.path);
      });
      print(image0);
    }
  }

  Widget _buildImageSelectionText() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              // 이미지를 선택한 경우, 선택한 이미지를 표시
              _updateImage(image);
            }
          },
          child: Container(
            height: 200,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (image0 == null)
                    Icon(Icons.add_photo_alternate, size: 50),
                  if (image0 != null)
                    Image.file(
                      image0!,
                      fit: BoxFit.cover, // 이미지의 가로 크기를 조절
                      height: 200, // 이미지 높이 고정
                      width: double.infinity, // 이미지 너비를 최대로 확장
                    ),
                  Text(
                    '이미지를 선택하세요',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) {
              // 사용자가 입력한 값을 content 변수에 저장
              content = value;
            },
            decoration: InputDecoration(labelText: '내용 입력'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // 작성하기 버튼을 누를 때의 동작 추가
            uploadImage(dateLogId, image0!, content);
            setState(() {
              isExpanded = false;
            });
            fetchAlbumData(dateLogId);
            setState(() {

            });
          },
          child: Text('작성하기'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(

      child: Stack(
        children: [
          Column(
            children: [
              if (dateLogId != 0)
                ExpansionTile(
                  title: Text('이미지 삽입'),
                  onExpansionChanged: (expanded) {
                    // ExpansionTile이 열리거나 닫힐 때 호출되는 콜백 함수
                    setState(() {
                      isExpanded = expanded;
                    });
                  },
                  initiallyExpanded: false,
                  children: [
                    // 이미지 표시 부분 (기존 내용 삭제)
                    if (isExpanded) _buildImageSelectionText(),
                  ],
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: imageList.length, // imageList의 길이로 아이템 개수 설정
                  itemBuilder: (context, index) {
                    final imageItem = imageList[index];
                    return Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 200, // 높이를 200px로 지정
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center( // 가운데 정렬을 위해 Center 위젯 사용
                              child: AspectRatio(
                                aspectRatio: 4 / 4,
                                child: Image.network(imageItem['imgUrl']), // 이미지 URL로 이미지 가져오기
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              imageItem['content'], // 이미지 설명 또는 내용 출력
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ListTile(
                            title: Text(
                              imageItem["comment"] != null ? imageItem["comment"] : "댓글이 없습니다."
                            ),
                            onTap: () {
                              _showCommentsModal(context, imageItem);
                            },
                          ),
                          // Add other non-scrollable widgets here
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<void> _showAddEventDialog(int dateLogId) async {
    final picker = ImagePicker();
    File? image0;
    String content = "";
    Color eventColor = Colors.blue; // 이벤트의 기본 색상 설정
    print(dateLogId);

    // 이미지를 표시하는 위젯
    Widget _buildImageWidget() {
      print(image0);
      return image0 != null
          ? Image.file(image0!, key: UniqueKey())
          : SizedBox.shrink(); // 이미지가 없는 경우 빈 위젯 반환
    }

// 이미지 업데이트 함수
    void _updateImage(XFile? image) {
      if (image != null) {
        print("하하하하 너냐?");
        setState(() {
          image0 = File(image.path);
        });
        print(image0);
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "사진을 입력해주세요",
                style: TextStyle(fontSize: 16),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                        _updateImage(image); // 이미지 업데이트
                      },
                      child: Text('사진 추가'),
                    ),
                    _buildImageWidget(), // 이미지를 표시하는 위젯 추가
                    if (image0 == null)
                      Text("TQ"),
                    if (image0 != null)
                      Text("?????"),
                    TextField(
                      onChanged: (value) {
                        // 사용자가 입력한 값을 content 변수에 저장
                        content = value;
                      },

                      decoration: InputDecoration(labelText: '내용'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uploadImage(dateLogId, image0!, content);
                        Navigator.of(context).pop();
                      },
                      child: Text('일정 추가'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('취소'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Future<void> _showCommentsModal(BuildContext context, imageItem) async {
    print(imageItem["imageId"]);
    String content = "";
    final newComment = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: '댓글 추가...',
                          ),
                          onChanged: (value) {
                            content = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            // comments.add(commentController.text);
                            commentController.clear();
                            writeComment(imageItem["imageId"], content);
                          });
                          // Navigator.pop(context, commentController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (newComment != null) {
      setState(() {
        comments.add(newComment);
      });
    }
  }
}

