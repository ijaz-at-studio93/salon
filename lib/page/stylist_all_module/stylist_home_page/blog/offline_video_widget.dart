import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../project_specific/progressbar_view.dart';

class OfflineVideoWidget extends StatefulWidget {
  final String videoString;
  const OfflineVideoWidget({super.key, required this.videoString});

  @override
  State<OfflineVideoWidget> createState() => _OfflineVideoWidgetState();
}

class _OfflineVideoWidgetState extends State<OfflineVideoWidget> {
  late VideoPlayerController _controller;

  bool isPlay = false;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.videoString));
    _controller.setLooping(true);
    _controller.initialize().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            isPlay = !(isPlay);
            if (isPlay) {
              setState(() {
                _controller.play();
              });
            } else {
              setState(() {
                _controller.pause();
                isPlay = false;
              });
            }
          },
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const ProgressBarView(),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            top: Get.height / 2,
            child: isPlay
                ? const SizedBox()
                : const Icon(
                    Icons.play_arrow,
                    size: 50,
                  ))
      ],
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
