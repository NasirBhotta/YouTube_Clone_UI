// Home screen that displays video feed
import 'package:flutter/material.dart';
import 'package:youtube_clone/models/video_model.dart';
import 'package:youtube_clone/screens/search_screen.dart';
import 'package:youtube_clone/screens/video_player_screen.dart';
import 'package:youtube_clone/utils/dummy_data.dart';
import 'package:youtube_clone/widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'All',
    'Music',
    'Gaming',
    'Live',
    'Comedy',
    'Podcasts',
    'News',
    'Cooking',
    'Recent uploads',
    'Watched',
    'New to you',
  ];

  int _selectedCategoryIndex = 0;
  late List<VideoModel> _videos;
  bool _isLoading = true;
  bool _isVideoClicked = false;
  late VideoModel _video;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  // void _addVideo(VideoModel video) {
  //   _video = video;
  // }

  void _loadVideos() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _videos = DummyData.videos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/youtube.png', height: 22),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: GestureDetector(
              onTap: () {
                // Navigate to profile
              },
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
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : _isVideoClicked
              ? Stack(children: [VideoPlayerScreen(video: _video)])
              : Column(
                children: [
                  // Categories
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 12 : 8,
                              right: index == _categories.length - 1 ? 12 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  _selectedCategoryIndex == index
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                color:
                                    _selectedCategoryIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Videos
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.white,
                      onRefresh: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: ListView.builder(
                        itemCount: _videos.length,
                        itemBuilder: (context, index) {
                          final video = _videos[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _isVideoClicked = !_isVideoClicked;
                                _video = video;
                              });

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder:
                              //         (context) =>
                              //             VideoPlayerScreen(video: video),
                              //   ),
                              // );
                            },
                            child: VideoCard(video: video),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
