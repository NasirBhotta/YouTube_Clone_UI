// Widget for displaying videos in the history section
import 'package:flutter/material.dart';
import 'package:youtube_clone/models/video_model.dart';
import 'package:youtube_clone/screens/video_player_screen.dart';

class HistoryVideoItem extends StatelessWidget {
  final VideoModel video;
  final String watchedTime;
  final bool showRemoveButton;

  const HistoryVideoItem({
    super.key,
    required this.video,
    this.watchedTime = 'Today',
    this.showRemoveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(video: video),
          ),
        );
      },
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 12),
          // Thumbnail with progress indicator
          Stack(
            children: [
              // Thumbnail
              Container(
                width: 160,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(video.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Duration badge
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    video.duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Progress bar at bottom of thumbnail
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  // This simulates video progress (70% watched)
                  width: 160 * 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Video details
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       video.title,
          //       maxLines: 2,
          //       overflow: TextOverflow.ellipsis,
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     const SizedBox(height: 4),
          //     // Channel name
          //     Text(
          //       video.channelName,
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Theme.of(context).textTheme.labelLarge?.color,
          //       ),
          //     ),
          //     const SizedBox(height: 2),
          //     // Views and watched time indicator
          //     Row(
          //       children: [
          //         Text(
          //           video.viewCount,
          //           style: TextStyle(
          //             fontSize: 12,
          //             color: Theme.of(context).textTheme.labelLarge?.color,
          //           ),
          //         ),
          //         Text(
          //           ' • ',
          //           style: TextStyle(
          //             fontSize: 12,
          //             color: Theme.of(context).textTheme.labelLarge?.color,
          //           ),
          //         ),
          //         Text(
          //           'Watched $watchedTime',
          //           style: TextStyle(
          //             fontSize: 12,
          //             color: Theme.of(context).textTheme.labelLarge?.color,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // More options button
          // if (showRemoveButton)
          //   IconButton(
          //     icon: const Icon(Icons.close),
          //     padding: EdgeInsets.zero,
          //     constraints: const BoxConstraints(),
          //     onPressed: () {
          //       _showRemoveDialog(context);
          //     },
          //   )
          // else
          //   IconButton(
          //     icon: const Icon(Icons.more_vert),
          //     padding: EdgeInsets.zero,
          //     constraints: const BoxConstraints(),
          //     onPressed: () {
          //       _showOptionsBottomSheet(context);
          //     },
          //   ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove from history?'),
            content: const Text(
              'This video will be removed from your watch history.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video removed from history'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('REMOVE'),
              ),
            ],
          ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomSheetItem(
                context,
                icon: Icons.access_time,
                title: 'Save to Watch Later',
              ),
              _buildBottomSheetItem(
                context,
                icon: Icons.playlist_add,
                title: 'Save to playlist',
              ),
              _buildBottomSheetItem(context, icon: Icons.share, title: 'Share'),
              _buildBottomSheetItem(
                context,
                icon: Icons.not_interested,
                title: 'Not interested',
              ),
              _buildBottomSheetItem(
                context,
                icon: Icons.history,
                title: 'Remove from history',
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveDialog(context);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildBottomSheetItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title - Not implemented'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
