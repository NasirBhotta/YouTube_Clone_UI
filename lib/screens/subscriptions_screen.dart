import 'package:flutter/material.dart';
import 'package:youtube_clone/models/channel_model.dart';
import 'package:youtube_clone/screens/home/models/video_model.dart';
import 'package:youtube_clone/utils/dummy_data.dart';
import 'package:youtube_clone/screens/home/widgets/video_card.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<ChannelModel> _subscriptions = [];
  List<VideoModel> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _subscriptions = DummyData.subscriptions;

      _videos =
          DummyData.videos
              .where(
                (video) => _subscriptions.any(
                  (channel) => channel.id == video.channelId,
                ),
              )
              .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
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
                child: Icon(Icons.account_circle, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _subscriptions.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.people_alt_outlined,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'All',
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }

                        final channel = _subscriptions[index - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                channel.name.split(' ')[0],
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(height: 1),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Recent',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Videos',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child:
                        _videos.isEmpty
                            ? const Center(
                              child: Text(
                                'No videos from your subscriptions yet.',
                              ),
                            )
                            : ListView.builder(
                              itemCount: _videos.length,
                              itemBuilder: (context, index) {
                                return VideoCard(video: _videos[index]);
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
