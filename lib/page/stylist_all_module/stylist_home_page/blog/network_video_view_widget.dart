import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../project_specific/progressbar_view.dart';

class NetworkVideoViewWidget extends StatefulWidget {
  final String videoString;
  final bool showThumbnail;
  final VoidCallback? onTap;

  const NetworkVideoViewWidget({
    super.key, 
    required this.videoString,
    this.showThumbnail = true,
    this.onTap,
  });

  @override
  State<NetworkVideoViewWidget> createState() => _NetworkVideoViewWidgetState();
}

class _NetworkVideoViewWidgetState extends State<NetworkVideoViewWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

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
          _isInitialized = true;
          _controller.setLooping(true);
          _controller.setVolume(1.0);
          if (!widget.showThumbnail) {
            _controller.play();
          }
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
    if (!_isInitialized) {
      return const ProgressBarView();
    }

    if (widget.showThumbnail) {
      // Show thumbnail with play button for list view
      return GestureDetector(
        onTap: widget.onTap ?? () {},
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            // Dark overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.3),
            ),
            // Play button (visual only)
            const Center(
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      );
    }

    // Full video player for content view
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
