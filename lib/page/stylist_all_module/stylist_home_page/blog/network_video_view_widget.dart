import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../project_specific/progressbar_view.dart';

class NetworkVideoViewWidget extends StatefulWidget {
  final String videoString;

  const NetworkVideoViewWidget({super.key, required this.videoString});

  @override
  State<NetworkVideoViewWidget> createState() => _NetworkVideoViewWidgetState();
}

class _NetworkVideoViewWidgetState extends State<NetworkVideoViewWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoString,
      ),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
          _controller.setVolume(1.0);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const ProgressBarView(); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
