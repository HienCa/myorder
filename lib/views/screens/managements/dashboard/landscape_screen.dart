import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:myorder/views/screens/managements/dashboard/dashboard_screen.dart';
import 'package:video_player/video_player.dart';

class MyLandscapeScreen extends StatefulWidget {
  const MyLandscapeScreen({super.key});

  @override
  State<MyLandscapeScreen> createState() => _MyLandscapeScreenState();
}

class _MyLandscapeScreenState extends State<MyLandscapeScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(defaultVideoRotatePhone)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: Utils.isLandscapeOrientation(context)
              ? const MyDashBoard()
              : buildVideoPlayer(),
        );
      },
    );
  }

  Widget buildVideoPlayer() {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
