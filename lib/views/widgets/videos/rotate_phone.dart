import 'package:flutter/material.dart';
import 'package:myorder/constants.dart';
import 'package:myorder/utils.dart';
import 'package:video_player/video_player.dart';

class RequiredRotatePhoneToLanscape extends StatefulWidget {
  const RequiredRotatePhoneToLanscape({super.key});

  @override
  State<RequiredRotatePhoneToLanscape> createState() =>
      _RequiredRotatePhoneToLanscapeState();
}

class _RequiredRotatePhoneToLanscapeState
    extends State<RequiredRotatePhoneToLanscape> {
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(defaultVideoRotatePhone)
      ..initialize().then((_) {
        setState(() {
          if (!Utils.isLandscapeOrientation(context)) {
            _controller.play();
            _controller.setLooping(true);
          } else {
            _controller.setLooping(false);
            _controller.pause();
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
