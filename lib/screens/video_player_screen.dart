// Video player screen for YouTube clone app
import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/home/models/video_model.dart';
import 'package:youtube_clone/utils/dummy_data.dart';
import 'package:youtube_clone/screens/home/widgets/video_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel video;
  final bool? isToggled;
  final GestureDragDownCallback? onPanDown;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragStartCallback? onPanStart;
  final GestureDragEndCallback? onPanEnd;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    this.onPanDown,
    this.onPanUpdate,
    this.onPanStart,
    this.onPanEnd,
    this.isToggled,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isDescriptionExpanded = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isSubscribed = false;
  bool _isDragging = false;
  double _opacity = 1;
  double _cumulativeDrag = 0.0;
  double x_axis = 0;
  double y_axix = 0;

  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.video.videoURL);
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
        showLiveFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _youtubePlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Video player area
        _buildVideoPlayer(),

        // Video details section
        Expanded(
          child: SingleChildScrollView(
            child:
                _opacity == 0
                    ? SizedBox.shrink()
                    : Opacity(
                      opacity: _opacity,
                      child: Container(
                        color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildVideoInfo(),
                            _buildActionButtons(),
                            _buildChannelInfo(),
                            _buildDescription(),
                            _buildCommentSection(),
                            _buildRelatedVideos(),
                          ],
                        ),
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    double calculateScale() {
      if (_cumulativeDrag <= 150) {
        return 1.0;
      } else {
        // Start scaling down after 150px drag
        // Map drag from 150-450 to scale from 1.0-0.5
        double dragRange = _cumulativeDrag - 150;
        double maxDragForScaling = 300; // 150 to 450 = 300px range
        double scaleReduction = (dragRange / maxDragForScaling).clamp(0.0, 0.5);
        return (1.0 - scaleReduction).clamp(
          0.6,
          1.0,
        ); // Min scale is 0.5 (half size)
      }
    }

    double currentScale = calculateScale();
    double playerWidth = MediaQuery.of(context).size.width * currentScale;
    double playerHeight = playerWidth * (9 / 16); // Maintain 16:9 aspect ratio
    if (widget.isToggled != null) {
      if (widget.isToggled == true) {
        print(widget.isToggled);
      }
    }
    return GestureDetector(
      onPanStart: (details) {
        widget.onPanStart!(details);
        setState(() {
          _isDragging = true;
        });
      },
      onPanDown: widget.onPanDown,
      onPanUpdate: (details) {
        widget.onPanUpdate!(details);

        _cumulativeDrag += details.delta.dy;

        _cumulativeDrag = _cumulativeDrag.clamp(-900.0, 900.0);

        double dragForOpacity = _cumulativeDrag.clamp(-100.0, 100.0);

        if (_cumulativeDrag >= 0) {
          _opacity = 1.0 - (dragForOpacity.abs() / 100.0);
        } else {
          _opacity = 1;
        }

        setState(() {});
      },
      onPanEnd: (details) {
        widget.onPanEnd!(details);
        if (_cumulativeDrag >= 400) {
          _cumulativeDrag = 400;
        } else {
          setState(() {
            _isDragging = false;
            _cumulativeDrag = 0;
            _opacity = 1;
          });
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 200, // Fixed height for the video player container
        child: Stack(
          children: [
            Positioned(
              right: 0, // Position to the right edge
              bottom: 0, // Position to the bottom edge
              width: playerWidth, // Half the screen width
              height: playerHeight, // Maintain 16:9 aspect ratio
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _youtubePlayerController,
                  showVideoProgressIndicator: _isDragging ? true : false,
                  progressIndicatorColor: Colors.red,
                ),
                builder:
                    (context, player) => SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: player,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.video.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.video.viewCount} • ${widget.video.uploadTime}',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            label: 'Like',
            color: _isLiked ? Colors.blue : null,
            onTap: () {
              setState(() {
                _isLiked = !_isLiked;
                if (_isLiked && _isDisliked) {
                  _isDisliked = false;
                }
              });
            },
          ),
          _buildActionButton(
            icon: _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
            label: 'Dislike',
            color: _isDisliked ? Colors.blue : null,
            onTap: () {
              setState(() {
                _isDisliked = !_isDisliked;
                if (_isDisliked && _isLiked) {
                  _isLiked = false;
                }
              });
            },
          ),
          _buildActionButton(
            icon: Icons.reply_outlined,
            label: 'Share',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality not implemented'),
                ),
              );
            },
          ),
          _buildActionButton(
            icon: Icons.file_download_outlined,
            label: 'Download',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download functionality not implemented'),
                ),
              );
            },
          ),
          _buildActionButton(
            icon: Icons.library_add_outlined,
            label: 'Save',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Save functionality not implemented'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color ?? Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.video.channelAvatarUrl),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.channelName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '1.2M subscribers',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSubscribed = !_isSubscribed;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSubscribed ? Colors.grey[300] : Colors.red,
              foregroundColor: _isSubscribed ? Colors.black : Colors.white,
            ),
            child: Text(_isSubscribed ? 'SUBSCRIBED' : 'SUBSCRIBE'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return InkWell(
      onTap: () {
        setState(() {
          _isDescriptionExpanded = !_isDescriptionExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.video.description,
              maxLines: _isDescriptionExpanded ? null : 3,
              overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 4),
            Text(
              _isDescriptionExpanded ? 'Show less' : 'Show more',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/40.jpg',
                ),
                radius: 16,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Great tutorial! Helped me a lot.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Show all comments button
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comments functionality not implemented'),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              // color: Colors.grey[100],
              child: const Center(
                child: Text(
                  'View all comments',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    // Filter out the current video and get up to 5 related videos
    final relatedVideos =
        DummyData.videos.where((v) => v.id != widget.video.id).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Related Videos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: relatedVideos.length,
          itemBuilder: (context, index) {
            return VideoCard(
              video: relatedVideos[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VideoPlayerScreen(
                          video: relatedVideos[index],
                          isToggled: widget.isToggled,
                        ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
