import 'package:flutter/material.dart';

class AlbumWidget extends StatefulWidget {
  @override
  _AlbumWidgetState createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  List<String> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      child: ListView(
        shrinkWrap: true, // Add this to make the ListView take only the space it needs
        children: [
          AspectRatio(
            aspectRatio: 4 / 1,
            child: Image.asset('assets/purple2.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '~~~~한 날',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '댓글:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text(
              comments.isEmpty ? '첫 번째 댓글이 없습니다.' : comments.first,
            ),
            onTap: () {
              _showCommentsModal(context);
            },
          ),
          // Add other non-scrollable widgets here
        ],
      ),
    );
  }

  Future<void> _showCommentsModal(BuildContext context) async {
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
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            comments.add(commentController.text);
                            commentController.clear();
                          });
                          Navigator.pop(context, commentController.text);
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

class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AlbumWidget(), // Add AlbumWidget here
      ],
    );
  }
}
