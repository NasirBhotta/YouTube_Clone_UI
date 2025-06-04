// File: lib/widgets/short_video_player.dart
// Widget for displaying and playing YouTube Shorts videos

import 'package:flutter/material.dart';
import 'package:youtube_clone/models/shorts_model.dart';
import 'package:video_player/video_player.dart';

class ShortVideoPlayer extends StatefulWidget {
  final ShortsModel short;
  final int currentIndex;
  final int index;

  const ShortVideoPlayer({
    super.key,
    required this.short,
    required this.currentIndex,
    required this.index,
  });

  @override
  State<ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

class _ShortVideoPlayerState extends State<ShortVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(ShortVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the index and currentIndex match, play the video
    if (widget.index == widget.currentIndex) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    } else {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.short.videoUrl)
      ..initialize().then((_) {
        // Start playing if this is the current video in view
        if (widget.index == widget.currentIndex) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {
            _isPlaying = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player
          _controller.value.isInitialized
              ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
              : Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),

          // Gradient overlay at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ),

          // Controls overlay
          if (_showControls)
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left side - video info
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username and verified badge
                          Row(
                            children: [
                              Text(
                                '@${widget.short.username}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (widget.short.isVerified)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Text(
                                  'Subscribe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Video title/description
                          Text(
                            widget.short.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Music info
                          Row(
                            children: [
                              const Icon(
                                Icons.music_note,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.short.musicName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Right side - action buttons
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Like button
                        _buildActionButton(
                          icon:
                              _isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                          label: _formatCount(widget.short.likes),
                          onTap: _toggleLike,
                          iconColor: _isLiked ? Colors.white : Colors.white,
                        ),
                        const SizedBox(height: 24),

                        // Comments button
                        _buildActionButton(
                          icon: Icons.comment,
                          label: _formatCount(widget.short.comments),
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),

                        // Share button
                        _buildActionButton(
                          icon: Icons.reply,
                          label: _formatCount(widget.short.shares),
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),

                        // More options button
                        _buildActionButton(
                          icon: Icons.more_horiz,
                          label: '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),

                        // User profile picture
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.short.userProfileImageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Play/pause button in the center
          if (_showControls && !_controller.value.isInitialized)
            Center(child: CircularProgressIndicator(color: Colors.red)),
          if (_showControls && _controller.value.isInitialized)
            Center(
              child: IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  color: Colors.white.withOpacity(0.7),
                  size: 60,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: iconColor, size: 28),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
      ],
    );
  }
}
