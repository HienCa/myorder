import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:marquee/marquee.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;
import 'package:myorder/views/screens/profile_screen.dart';

class CommentScreen extends StatefulWidget {
  final String id;
  const CommentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  CommentController commentController = Get.put(CommentController());
  _dismissDialog() {
    Navigator.pop(context);
  }

  Future<void> deleteComment(String videoId, String commentId) async {
    try {
      // Reference to the comment document
      final commentRef = firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId);

      // Delete the comment
      await commentRef.delete();
      Get.snackbar(
      'BÌNH LUẬN!',
      'Bạn đã xóa bình luận thành công.',
      backgroundColor: Colors.redAccent, // Màu nền
      colorText: Colors.white, // M
    );
      // print('Comment deleted successfully.');
    } catch (error) {
      // print('Error deleting comment: $error');
    }
  }

  void showSimpleDialog(String uid, String videoId, String commentId) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            // title: const Text(''),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _dismissDialog();
                },
                child: InkWell(
                    onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(uid: uid),
                            ),
                          ),
                        },
                    child: const Center(
                        child: Text(
                      'Xem trang cá nhân',
                      style: TextStyle(fontSize: 20, color: textColor),
                    ))),
              ),
              uid == authController.user.uid
                  ? const Divider(
                      color: textColor,
                    )
                  : Container(),
              uid == authController.user.uid
                  ? SimpleDialogOption(
                      onPressed: () {
                        _dismissDialog();
                      },
                      child: InkWell(
                          onTap: () => {
                                _dismissDialog(),
                                deleteComment(videoId, commentId)
                              },
                          child: const Center(
                              child: Text(
                            'Xóa bình luận',
                            style: TextStyle(fontSize: 20, color: textColor),
                          ))),
                    )
                  : const SimpleDialogOption(),
              uid != authController.user.uid
                  ? const Divider(
                      color: textColor,
                    )
                  : Container(),
              uid != authController.user.uid
                  ? SimpleDialogOption(
                      onPressed: () {
                        _dismissDialog();
                      },
                      child: InkWell(
                          onTap: () => {},
                          child: const Center(
                              child: Text(
                            'Kết bạn',
                            style: TextStyle(fontSize: 20, color: textColor),
                          ))),
                    )
                  : const SimpleDialogOption(),
              const Divider(
                color: textColor,
              ),
              SimpleDialogOption(
                onPressed: () {
                  _dismissDialog();
                },
                child: InkWell(
                    onTap: () => {},
                    child: const Center(
                        child: Text(
                      'Chặn',
                      style: TextStyle(fontSize: 20, color: textColor),
                    ))),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(widget.id);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return ListTile(
                          leading: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(uid: comment.uid))),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage:
                                  NetworkImage(comment.profilePhoto),
                            ),
                          ),
                          title: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileScreen(uid: comment.uid))),
                                child: Text(
                                  "${comment.username}  ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              // Marquee(
                              //   text: "${comment.username}  ",
                              //   style: const TextStyle(
                              //     fontSize: 20,
                              //     color: Colors.red,
                              //     fontWeight: FontWeight.w700,
                              //   ),
                              //   scrollAxis: Axis.horizontal,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   blankSpace: 20.0,
                              //   velocity: 100.0,
                              // ),
                              // Marquee(
                              //   text: 'Some sample text that takes some space.',
                              //   style: const TextStyle(fontWeight: FontWeight.bold),
                              //   scrollAxis: Axis.horizontal,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   blankSpace: 20.0,
                              //   velocity: 100.0,
                              //   pauseAfterRound: const Duration(seconds: 1),
                              //   startPadding: 10.0,
                              //   accelerationDuration: const Duration(seconds: 1),
                              //   accelerationCurve: Curves.linear,
                              //   decelerationDuration:
                              //       const Duration(milliseconds: 500),
                              //   decelerationCurve: Curves.easeOut,
                              // ),
                              Row(
                                children: [
                                  Text(
                                    tago.format(
                                      comment.datePublished.toDate(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${comment.likes.length} thích',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: textColor,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          subtitle: InkWell(
                            onLongPress: () => showSimpleDialog(
                                comment.uid, comment.videoId, comment.id),
                            child: RichText(
                              text: TextSpan(
                                text: comment.comment,
                                style: const TextStyle(
                                    color:
                                        Colors.black), // Đặt kiểu cho văn bản
                              ),
                              maxLines: 5, // Giới hạn số dòng hiển thị
                              overflow: TextOverflow
                                  .ellipsis, // Hiển thị dấu ba chấm khi văn bản quá dài
                            ),
                          ),
                          trailing: InkWell(
                            onTap: () =>
                                commentController.likeComment(comment.id),
                            child: Icon(
                              Icons.favorite,
                              size: 25,
                              color: comment.likes
                                      .contains(authController.user.uid)
                                  ? Colors.red
                                  : textColor,
                            ),
                          ),
                        );
                      });
                }),
              ),
              const Divider(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                // height: 300,
                // width: MediaQuery.sizeOf(context).width,
                child: ListTile(
                  title: TextFormField(
                    controller: _commentController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Bình luận',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        {commentController.postComment(_commentController.text),
                        _commentController.clear()
                        },
                    child: const Text(
                      'Gửi',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
