// Widget for displaying video search results
import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/home/models/video_model.dart';

class SearchVideoItem extends StatelessWidget {
  final VideoModel video;

  const SearchVideoItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to video details/player screen
        // This would be implemented in a real app
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playing video: ${video.title}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with duration overlay
            Stack(
              children: [
                Container(
                  width: 160,
                  height: 90,
                  margin: const EdgeInsets.only(left: 16, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(video.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 17,
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
              ],
            ),
            // Video details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${video.viewCount} • ${video.uploadTime}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(video.channelAvatarUrl),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        video.channelName,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // More options button
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildBottomSheet(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
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
          _buildBottomSheetItem(
            context,
            icon: Icons.file_download,
            title: 'Download video',
          ),
          _buildBottomSheetItem(context, icon: Icons.share, title: 'Share'),
          _buildBottomSheetItem(
            context,
            icon: Icons.not_interested,
            title: 'Not interested',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetItem(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return InkWell(
      onTap: () {
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
