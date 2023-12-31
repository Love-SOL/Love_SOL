import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  bool isExpandedComment = false;

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

  Future<void> uploadImage(int dateLogId, File image, String content) async {
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

  Future<void> writeComment(int imageId, String content) async {
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

// 이미지 업데이트 함수
  void _updateImage(XFile? image) {
    if (image != null) {
      setState(() {
        image0 = File(image.path);
      });
      print(image0);
    }
  }

  Widget _buildImageSelectionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // 우측 정렬
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
                    Icon(
                      Icons.add_photo_alternate,
                      size: 50,
                      color: Color(0XFFA47DE5), // 아이콘의 색상을 연보라색으로 설정
                    ),
                  if (image0 != null)
                    Image.file(
                      image0!,
                      fit: BoxFit.cover, // 이미지의 가로 크기를 조절
                      height: 200, // 이미지 높이 고정
                      width: double.infinity, // 이미지 너비를 최대로 확장
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    content = value;
                  },
                  decoration: InputDecoration(labelText: '내용을 입력해주세요'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await uploadImage(dateLogId, image0!, content);
                  await fetchAlbumData(dateLogId);
                  setState(() {
                    isExpanded = false;
                    image0 = null;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSelectionText(int imageId, List commentList) {
    return Column(
      children: [
        if (commentList.isEmpty) // commentList가 비어있을 때
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              '댓글이 없어요.',
              style: TextStyle(fontSize: 16.0),
            ),
          )
        else // commentList가 비어있지 않을 때
          Container(
            child: ListView.builder(
              shrinkWrap: true, // shrinkWrap을 true로 설정
              physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
              itemCount: commentList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile( // 배경색을 흰색으로 설정
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // 테두리 색상 설정
                        width: 2.0, // 테두리 두께 설정
                      ),
                    ),
                    child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/bear3.png"),
                    radius: 24.0,
                    foregroundColor: Colors.black,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commentList[index]["id"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        commentList[index]["content"], // 댓글 내용
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
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
                  onSubmitted: (message) async {
                    if (message.isNotEmpty) {
                      await writeComment(imageId, message);
                      await fetchAlbumData(dateLogId);
                      commentController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
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
                  title: Text('일기 작성'),
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
                  itemCount: imageList.length,
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
                            height: 200,
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 4 / 4,
                                child: Image.network(imageItem['imgUrl']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              imageItem['content'],
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
                          ExpansionTile(
                            title: Text('댓글 보기'),
                            onExpansionChanged: (expanded) {
                              // ExpansionTile이 열리거나 닫힐 때 호출되는 콜백 함수
                              setState(() {
                                isExpandedComment = expanded;
                              });
                            },
                            initiallyExpanded: false,
                            children: [
                              if (isExpandedComment) _buildCommentSelectionText(imageItem["imageId"], imageItem["commentList"]),
                            ],
                          )
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

  Future<void> _showCommentsModal(BuildContext context, imageItem) async {
    print(imageItem["imageId"]);
    String content = "";

    // 이미지 아이템의 commentList를 가져옵니다.
    List<dynamic> commentList = imageItem['commentList'];
    print(commentList);
    final newComment = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: commentList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(commentList[index]["content"]),
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
                      ElevatedButton(
                      onPressed: () async {
                        await writeComment(imageItem["imageId"], content);
                        await fetchAlbumData(dateLogId);
                        setState(() {
                          content = ""; // 댓글 작성 후 content 변수 초기화
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('댓글 작성'),
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

