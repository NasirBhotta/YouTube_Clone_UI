// Optimized Home screen that displays video feed with YouTube-like drag functionality
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
  // Constants - moved to class level for better performance
  static const List<String> _categories = [
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

  static const double _dismissThreshold = 390.9505208333336;
  static const double _maxDragOffset = 390.9505208333336;

  // Controllers
  late final ScrollController _scrollController;
  late final AnimationController _videoPlayerAnimationController;

  // State variables - grouped logically
  int _selectedCategoryIndex = 0;
  late VideoModel _selectedVideo;

  // Video player state
  bool _isVideoPlayerVisible = false;
  bool _toggled = true;
  bool isPiPMode = false;
  double pipX = 0;
  double pipY = 0;
  // Drag state - using separate class for better organization
  late final _DragState _dragState;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _dragState = _DragState();
    _loadInitialVideos();
  }

  void _initializeControllers() {
    _scrollController = ScrollController()..addListener(_onScroll);
    _videoPlayerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _loadInitialVideos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VideoBloc>().add(
          FetchVideos(category: _categories[_selectedCategoryIndex]),
        );
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Check if we're near the bottom for pagination
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVideos();
    }
  }

  void _loadMoreVideos() {
    final bloc = context.read<VideoBloc>();
    final state = bloc.state;

    if (state is VideoLoaded &&
        !state.isLoadingMore &&
        !state.hasReachedEnd &&
        state.currentCategory == _categories[_selectedCategoryIndex]) {
      bloc.add(FetchVideos(category: _categories[_selectedCategoryIndex]));
    }
  }

  void _onCategorySelected(int index) {
    if (_selectedCategoryIndex == index) return;

    setState(() {
      _selectedCategoryIndex = index;
    });

    _scrollToTop();
    _fetchCategoryVideos(index);
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _fetchCategoryVideos(int index) {
    context.read<VideoBloc>().add(
      FetchVideos(category: _categories[index], isRefresh: true),
    );
  }

  void _openVideoPlayer(VideoModel video) {
    setState(() {
      _selectedVideo = video;
      isPiPMode = false;
      _isVideoPlayerVisible = true;
      _toggled = true;
    });

    _dragState.reset();
    _videoPlayerAnimationController.forward();
  }

  void _closeVideoPlayer() {
    _videoPlayerAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVideoPlayerVisible = false;
        });
        _dragState.reset();
      }
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (isPiPMode) {
      _dragState.setDragging(true);
    } else if (_dragState.offset <= _maxDragOffset) {
      _dragState.setDragging(true);
      setState(() {});
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (isPiPMode) {
      // Get screen dimensions
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      // Assuming PiP video dimensions (adjust as needed)
      final pipWidth = screenWidth / 5.5;
      final pipHeight = screenHeight / 12;

      // Update position with bounds checking
      pipX += details.delta.dx;
      pipY += details.delta.dy;

      // Keep PiP video within screen bounds
      // pipX = pipX.clamp(0 - pipWidth + 50, screenWidth - 50); // Allow partial off-screen
      // pipY = pipY.clamp(0, screenHeight - pipHeight - 50);

      // Limit horizontal movement: from -pipWidth (left edge) to 0 (right edge)
      pipX = pipX.clamp(-pipWidth - 75, 0);

      // Limit vertical movement: from 0 (top) to screenHeight - pipHeight (bottom)
      pipY = pipY.clamp(-120, 390);

      print("$pipX pipx");
      print("$pipY pipy");

      setState(() {});
      return;
    }

    if (_dragState.offset <= _maxDragOffset) {
      _dragState.updateOffset(details.delta.dy, _maxDragOffset);
    }
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (isPiPMode) {
      // Snap to nearest corner
      final corners = {
        'topRight': Offset(-5, -115.36425781250001),
        'bottomLeft': Offset(-140.30205420291784, 390.9505208333336),
        'topLeft': Offset(-140.30205420291784, -115.36425781250001),
        'bottomRight': Offset(-5, 390.9505208333336),
      };

      final current = Offset(pipX, pipY);
      Offset closestCorner = corners.values.first;
      double minDistance = double.infinity;

      for (var corner in corners.values) {
        final distance = (current - corner).distance;
        if (distance < minDistance) {
          minDistance = distance;
          closestCorner = corner;
        }
      }

      pipX = closestCorner.dx;
      pipY = closestCorner.dy;
      print("$pipX pipx");
      print("$pipY pipy");
    }
    if (_dragState.offset >= _dismissThreshold) {
      _dragState.setOffset(_dismissThreshold);

      if (!isPiPMode) {
        pipX = 0;
        pipY = _maxDragOffset;
      }
      isPiPMode = true;
    } else {
      _dragState.reset();
    }
    setState(() {});
  }

  Future<void> _refreshVideos() async {
    final bloc = context.read<VideoBloc>();
    bloc.add(
      FetchVideos(
        category: _categories[_selectedCategoryIndex],
        isRefresh: true,
      ),
    );

    // Wait for completion
    await bloc.stream.firstWhere(
      (state) => state is VideoLoaded || state is VideoError,
    );
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: _buildAppBar(),
            ),
          ),
          Positioned(
            top:
                _shouldShowAppBar()
                    ? MediaQuery.of(context).size.height * 0.1
                    : 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocConsumer<VideoBloc, VideoState>(
              listener: _handleBlocStateChanges,
              builder: _buildContent,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowAppBar() {
    return !_isVideoPlayerVisible || _dragState.offset >= 90;
  }

  void _handleBlocStateChanges(BuildContext context, VideoState state) {
    if (state is VideoError) {
      _showErrorSnackBar(state.message);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => _refreshVideos(),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, VideoState state) {
    if (state is VideoInitial || state is VideoLoading) {
      return const _LoadingWidget();
    }

    if (state is VideoLoaded) {
      return _buildLoadedContent(state);
    }

    if (state is VideoError) {
      return _ErrorWidget(message: state.message, onRetry: _refreshVideos);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadedContent(VideoLoaded state) {
    return Stack(
      children: [
        _HomeContent(
          categories: _categories,
          selectedCategoryIndex: _selectedCategoryIndex,
          videos: state.videos,
          isLoadingMore: state.isLoadingMore,
          scrollController: _scrollController,
          onCategorySelected: _onCategorySelected,
          onVideoTap: _openVideoPlayer,
          onRefresh: _refreshVideos,
        ),
        if (_dragState.backgroundOpacity > 0)
          Opacity(
            opacity: _dragState.backgroundOpacity,
            child: Container(color: Colors.white),
          ),
        if (_isVideoPlayerVisible) _buildVideoPlayerOverlay(),
      ],
    );
  }

  Widget _buildVideoPlayerOverlay() {
    return AnimatedBuilder(
      animation: _videoPlayerAnimationController,
      builder: (context, child) {
        final shouldMaintainDragOffset = _dragState.offset > _dismissThreshold;
        // Calculate offset based on mode
        Offset translationOffset;

        if (isPiPMode) {
          // In PiP mode, use pipX and pipY for free movement
          translationOffset = Offset(pipX, pipY);
        } else {
          // In normal mode, use existing drag logic (vertical only)
          translationOffset = Offset(
            0,
            _dragState.isDragging || shouldMaintainDragOffset
                ? _dragState.offset
                : _dragState.offset *
                    (1 - _videoPlayerAnimationController.value),
          );
        }
        print(translationOffset);
        return Transform.translate(
          offset: translationOffset,
          child: _VideoPlayerOverlay(
            video: _selectedVideo,
            stateReset: () {
              isPiPMode = false;
              _dragState.reset();
              setState(() {});
            },
            dragState: _dragState,
            isToggled: _toggled,

            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onClose: _closeVideoPlayer,
            dismissThreshold: _dismissThreshold,
            maxDragOffset: _maxDragOffset,
            isPiPMode: isPiPMode,
          ),
        );
      },
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
}

// Separate drag state management class
class _DragState {
  double offset = 0;
  bool isDragging = false;

  void updateOffset(double deltaY, double maxOffset) {
    offset += deltaY;
    offset = offset.clamp(0.0, maxOffset);
  }

  void setOffset(double newOffset) {
    offset = newOffset;
  }

  void setDragging(bool dragging) {
    isDragging = dragging;
  }

  void reset() {
    offset = 0;
    isDragging = false;
  }

  double get backgroundOpacity {
    if (offset <= 0) return 0.0;

    const maxBackgroundOffset = 200.0;
    if (offset <= 100 && offset > 0) return 1.0;
    if (offset > maxBackgroundOffset) return 0.0;

    return (1.0 - (offset / maxBackgroundOffset)).clamp(0.0, 1.0);
  }
}

// Extracted widgets for better performance and organization
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.red));
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
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
            onPressed: onRetry,
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

class _HomeContent extends StatelessWidget {
  final List<String> categories;
  final int selectedCategoryIndex;
  final List<VideoModel> videos;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final void Function(int) onCategorySelected;
  final void Function(VideoModel) onVideoTap;
  final Future<void> Function() onRefresh;

  const _HomeContent({
    required this.categories,
    required this.selectedCategoryIndex,
    required this.videos,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onCategorySelected,
    required this.onVideoTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CategorySelector(
          categories: categories,
          selectedIndex: selectedCategoryIndex,
          onCategorySelected: onCategorySelected,
        ),
        Expanded(
          child: RefreshIndicator(
            color: Colors.red,
            onRefresh: onRefresh,
            child:
                videos.isEmpty
                    ? const _EmptyStateWidget()
                    : _VideosList(
                      videos: videos,
                      isLoadingMore: isLoadingMore,
                      scrollController: scrollController,
                      onVideoTap: onVideoTap,
                    ),
          ),
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final void Function(int) onCategorySelected;

  const _CategorySelector({
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _CategoryItem(
            category: categories[index],
            isSelected: selectedIndex == index,
            isFirst: index == 0,
            isLast: index == categories.length - 1,
            onTap: () => onCategorySelected(index),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String category;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: isFirst ? 12 : 8, right: isLast ? 12 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _VideosList extends StatelessWidget {
  final List<VideoModel> videos;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final void Function(VideoModel) onVideoTap;

  const _VideosList({
    required this.videos,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: videos.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == videos.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        final video = videos[index];
        return GestureDetector(
          onTap: () => onVideoTap(video),
          child: VideoCard(video: video),
        );
      },
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
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
}

class _VideoPlayerOverlay extends StatelessWidget {
  final VideoModel video;
  final _DragState dragState;
  final bool isToggled;
  bool isPiPMode;
  final void Function(DragStartDetails) onPanStart;
  final void Function(DragUpdateDetails) onPanUpdate;
  final void Function(DragEndDetails) onPanEnd;
  final void Function() stateReset;
  final VoidCallback onClose;
  final double dismissThreshold;
  final double maxDragOffset;

  _VideoPlayerOverlay({
    required this.video,
    required this.dragState,
    required this.isToggled,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onClose,
    required this.dismissThreshold,
    required this.maxDragOffset,
    required this.isPiPMode,
    required this.stateReset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayerScreen(
          video: video,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          isToggled: isToggled,
          isPiPMode: isPiPMode,
          isDragging: dragState.isDragging,
          resetState: onClose,
        ),
        if (!dragState.isDragging)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
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

        if (isPiPMode)
          Positioned(
            top: 130,
            left: 160,
            child: GestureDetector(
              onTap: stateReset,
              child: Container(
                color: const Color.fromARGB(0, 255, 0, 0),
                width: MediaQuery.of(context).size.width / 5.5,
                height: MediaQuery.of(context).size.height / 12,
              ),
            ),
          ),
        if (isPiPMode)
          Positioned(
            top: 100,
            right: 20,
            child: GestureDetector(
              onTap: stateReset,
              child: Container(
                color: const Color.fromARGB(0, 255, 0, 0),
                width: MediaQuery.of(context).size.width / 5.5,
                height: MediaQuery.of(context).size.height / 8.1,
              ),
            ),
          ),
      ],
    );
  }
}
