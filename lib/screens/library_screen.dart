// Library screen showing saved videos and playlists
import 'package:flutter/material.dart';
import 'package:youtube_clone/models/video_model.dart';
import 'package:youtube_clone/utils/dummy_data.dart';
import 'package:youtube_clone/widgets/history_video_item.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<VideoModel> history = DummyData.videos.take(5).toList();
    final List<VideoModel> likedVideos =
        DummyData.videos.skip(5).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // History section
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return HistoryVideoItem(video: history[index]);
                },
              ),
            ),

            const Divider(height: 1),

            // Your videos section
            ListTile(
              leading: const Icon(Icons.smart_display_outlined),
              title: const Text('Your videos'),
              onTap: () {},
            ),

            // Downloads section
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Downloads'),
              subtitle: const Text('40 videos'),
              onTap: () {},
            ),

            // Your movies section
            ListTile(
              leading: const Icon(Icons.movie_outlined),
              title: const Text('Your movies'),
              onTap: () {},
            ),

            const Divider(height: 1),

            // Playlists section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Playlists',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Recently added',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ),

            // Liked videos
            ListTile(
              leading: const Icon(Icons.thumb_up_outlined),
              title: const Text('Liked videos'),
              subtitle: Text('${likedVideos.length} videos'),
              onTap: () {},
            ),

            // Watch later
            ListTile(
              leading: const Icon(Icons.watch_later_outlined),
              title: const Text('Watch later'),
              subtitle: const Text('0 unwatched videos'),
              onTap: () {},
            ),

            // New playlist button
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New playlist'),
              onTap: () {
                // Show create playlist dialog
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Create playlist'),
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter playlist name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CREATE'),
                          ),
                        ],
                      ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
