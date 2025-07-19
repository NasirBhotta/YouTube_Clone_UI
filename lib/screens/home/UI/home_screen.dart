// Home screen that displays video feed with YouTube-like drag functionality
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/screens/home/models/video_model.dart';
import 'package:youtube_clone/screens/home/bloc/video_bloc.dart';
import 'package:youtube_clone/screens/search_screen.dart';
import 'package:youtube_clone/screens/video_player_screen.dart';
import 'package:youtube_clone/screens/home/widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  late final ScrollController _scrollController;
  late final AnimationController _videoPlayerAnimationController;

  int _selectedCategoryIndex = 0;
  bool _isVideoPlayerVisible = false;
  final bool _visibillity = false;
  bool toggled = false;
  late VideoModel _selectedVideo;

  // For drag-to-dismiss functionality
  double _dragOffset = 0;
  bool _isDragging = false;
  static const double _dismissThreshold = 400.0;
  static const double _maxDragOffset = 400.0; // Maximum drag offset

  @override
  void initState() {
    super.initState();

    // Initialize scroll controller
    _scrollController = ScrollController()..addListener(_onScroll);

    // Initialize animation controllers
    _videoPlayerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Load initial videos using BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoBloc>().add(
        FetchVideos(category: _categories[_selectedCategoryIndex]),
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<VideoBloc>();
      final state = bloc.state;

      if (state is VideoLoaded &&
          !state.isLoadingMore &&
          !state.hasReachedEnd &&
          state.currentCategory == _categories[_selectedCategoryIndex]) {
        bloc.add(FetchVideos(category: _categories[_selectedCategoryIndex]));
      }
    }
  }

  void _onCategorySelected(int index) {
    if (_selectedCategoryIndex != index) {
      setState(() {
        _selectedCategoryIndex = index;
      });

      // Scroll to top when changing category
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

      // Fetch videos for the new category
      context.read<VideoBloc>().add(
        FetchVideos(category: _categories[index], isRefresh: true),
      );
    }
  }

  void _openVideoPlayer(VideoModel video) {
    setState(() {
      _selectedVideo = video;
      _isVideoPlayerVisible = true;
      _dragOffset = 0;
      _isDragging = false;
    });
    _videoPlayerAnimationController.forward();
  }

  void _closeVideoPlayer() {
    _videoPlayerAnimationController.reverse().then((_) {
      setState(() {
        _isVideoPlayerVisible = false;
        _isDragging = false;
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    // Only allow dragging if dragOffset is <= 440
    if (_dragOffset <= _maxDragOffset) {
      setState(() {
        _isDragging = true;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Only update drag offset if we're within the allowed range
    if (_dragOffset <= _maxDragOffset) {
      setState(() {
        _dragOffset += (details.delta.dy - 0.1);
        _dragOffset = _dragOffset.clamp(0.0, _maxDragOffset);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragOffset >= 400) {
      // Don't set _isDragging to false when closing to prevent snap-back
      _dragOffset = 400;
    } else {
      setState(() {
        _isDragging = false;
        _dragOffset = 0;
      });
    }
  }

  // Method to handle video click when at drag offset 440
  void _onVideoClick() {
    if (_dragOffset >= _maxDragOffset) {
      setState(() {
        _dragOffset = 0;
        _isDragging = false;
        toggled = !toggled;
      });
    }
  }

  Future<void> _refreshVideos() async {
    final bloc = context.read<VideoBloc>();

    // Add the refresh event
    bloc.add(
      FetchVideos(
        category: _categories[_selectedCategoryIndex],
        isRefresh: true,
      ),
    );

    // Wait for the bloc to complete the refresh
    await bloc.stream.firstWhere(
      (state) => state is VideoLoaded || state is VideoError,
    );
  }

  double get _backgroundOpacity {
    if (!_isVideoPlayerVisible) return 0.0;
    if (_dragOffset <= 0) return 0.0;

    // Show white background for small drag amounts
    const maxBackgroundOffset = 200.0;
    if (_dragOffset <= 100 && _dragOffset > 0) return 1.0;

    if (_dragOffset > maxBackgroundOffset) return 0.0;

    return (1.0 - (_dragOffset / maxBackgroundOffset)).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _videoPlayerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Only show AppBar when video player is not visible or when dragging
      appBar:
          (!_isVideoPlayerVisible || _dragOffset >= 90) ? _buildAppBar() : null,
      body: BlocConsumer<VideoBloc, VideoState>(
        listener: (context, state) {
          // Handle any side effects here if needed
          if (state is VideoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<VideoBloc>().add(
                      FetchVideos(
                        category: _categories[_selectedCategoryIndex],
                        isRefresh: true,
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VideoInitial || state is VideoLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (state is VideoLoaded) {
            return Stack(
              children: [
                // Home content with opacity animation
                _buildHomeContent(state),
                // White background for small drags
                if (_backgroundOpacity > 0)
                  Opacity(
                    opacity: _backgroundOpacity,
                    child: Container(color: Colors.white),
                  ),
                // Video player overlay
                if (_isVideoPlayerVisible) _buildVideoPlayerOverlay(),
              ],
            );
          } else if (state is VideoError) {
            return _buildErrorWidget(state.message);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
            onTap: () {},
            child: const CircleAvatar(
              radius: 14,
              child: Icon(Icons.account_circle, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayerOverlay() {
    return AnimatedBuilder(
      animation: _videoPlayerAnimationController,
      builder: (context, child) {
        // When closing (drag offset > dismiss threshold), keep the drag offset
        // to prevent snap-back animation
        final shouldMaintainDragOffset = _dragOffset > _dismissThreshold;

        return Transform.translate(
          offset: Offset(
            0,
            _isDragging || shouldMaintainDragOffset
                ? _dragOffset
                : _dragOffset * (1 - _videoPlayerAnimationController.value),
          ),
          child: Stack(
            children: [
              Stack(
                children: [
                  // Add GestureDetector to handle video clicks when at max drag offset
                  GestureDetector(
                    onTap: _onVideoClick,
                    child: VideoPlayerScreen(
                      video: _selectedVideo,
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      isToggled: toggled,
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: GestureDetector(
                      onTap: _closeVideoPlayer,
                      child:
                          _isDragging
                              ? SizedBox.shrink()
                              : Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                    ),
                  ),
                  // Drag indicator
                  if (_dragOffset > 0)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 60,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _dragOffset > _dismissThreshold
                                ? 'Release to close'
                                : _dragOffset >= _maxDragOffset
                                ? 'Tap to expand'
                                : 'Drag down to minimize',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Video Detail should be here
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeContent(VideoLoaded state) {
    return Column(
      children: [
        // Categories
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () => _onCategorySelected(index),
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 12 : 8,
                    right: index == _categories.length - 1 ? 12 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
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
            color: Colors.red,
            onRefresh: _refreshVideos,
            child:
                state.videos.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.videos.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.videos.length) {
                          // Loading indicator for pagination
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        final video = state.videos[index];
                        return GestureDetector(
                          onTap: () => _openVideoPlayer(video),
                          child: VideoCard(video: video),
                        );
                      },
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No videos found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try refreshing or selecting a different category',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<VideoBloc>().add(
                FetchVideos(
                  category: _categories[_selectedCategoryIndex],
                  isRefresh: true,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
