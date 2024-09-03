import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  double _volume = 1.0; // Volume level from 0.0 to 1.0

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/n.mp4', // Replace with your video URL
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _skipForward() {
    final newPosition = _controller.value.position + Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _skipBackward() {
    final newPosition = _controller.value.position - Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _changeVolume(bool increase) {
    setState(() {
      _volume = increase
          ? (_volume + 0.1).clamp(0.0, 1.0)
          : (_volume - 0.1).clamp(0.0, 1.0);
      _controller.setVolume(_volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player App'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  VideoControls(
                    controller: _controller,
                    onSkipForward: _skipForward,
                    onSkipBackward: _skipBackward,
                    onVolumeUp: () => _changeVolume(true),
                    onVolumeDown: () => _changeVolume(false),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onSkipForward;
  final VoidCallback onSkipBackward;
  final VoidCallback onVolumeUp;
  final VoidCallback onVolumeDown;

  const VideoControls({
    required this.controller,
    required this.onSkipForward,
    required this.onSkipBackward,
    required this.onVolumeUp,
    required this.onVolumeDown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              },
            ),
            IconButton(
              icon: Icon(Icons.replay_10),
              onPressed: onSkipBackward,
            ),
            IconButton(
              icon: Icon(Icons.forward_10),
              onPressed: onSkipForward,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.volume_down),
              onPressed: onVolumeDown,
            ),
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: onVolumeUp,
            ),
          ],
        ),
      ],
    );
  }
}
