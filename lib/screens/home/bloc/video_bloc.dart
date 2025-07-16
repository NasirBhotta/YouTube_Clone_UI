// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:youtube_clone/screens/home/models/video_model.dart';
// import 'package:youtube_clone/screens/home/services/api_service.dart';

// part 'video_event.dart';
// part 'video_state.dart';

// class VideoBloc extends Bloc<VideoEvent, VideoState> {
//   final ApiService apiService;
//   final Map<String, int> _categoryPages = {};
//   final int _limit = 100;
//   bool _isFetching = false;

//   VideoBloc(this.apiService) : super(VideoInitial()) {
//     on<FetchVideos>(_onFetchVideos);
//   }

//   FutureOr<void> _onFetchVideos(
//     FetchVideos event,
//     Emitter<VideoState> emit,
//   ) async {
//     // Prevent multiple simultaneous requests
//     if (_isFetching) return;

//     _isFetching = true;

//     try {
//       final currentState = state;
//       final category = event.category;

//       // Handle refresh or category change
//       if (event.isRefresh ||
//           currentState is! VideoLoaded ||
//           currentState.currentCategory != category) {
//         // Reset pagination for this category
//         _categoryPages[category] = 1;

//         // Show loading state for initial load
//         if (currentState is! VideoLoaded ||
//             currentState.currentCategory != category) {
//           emit(VideoLoading());
//         }

//         final videos = await apiService.fetchVideos(
//           page: 1,
//           limit: _limit,
//           category: category,
//         );

//         final hasReachedEnd = videos.length < _limit;

//         emit(
//           VideoLoaded(
//             videos: videos,
//             hasReachedEnd: hasReachedEnd,
//             currentCategory: category,
//             isLoadingMore: false,
//           ),
//         );
//       }
//       // Handle pagination (load more)
//       else if (!currentState.hasReachedEnd && !currentState.isLoadingMore) {
//         // Show loading more indicator
//         emit(currentState.copyWith(isLoadingMore: true));

//         final currentPage = _categoryPages[category] ?? 1;
//         final nextPage = currentPage + 1;
//         _categoryPages[category] = nextPage;

//         final newVideos = await apiService.fetchVideos(
//           page: nextPage,
//           limit: _limit,
//           category: category,
//         );

//         final allVideos = [...currentState.videos, ...newVideos];
//         final hasReachedEnd = newVideos.length < _limit;

//         emit(
//           VideoLoaded(
//             videos: allVideos,
//             hasReachedEnd: hasReachedEnd,
//             currentCategory: category,
//             isLoadingMore: false,
//           ),
//         );
//       }
//     } catch (error) {
//       // Preserve current videos if it's a pagination error
//       if (state is VideoLoaded && !event.isRefresh) {
//         final currentState = state as VideoLoaded;
//         emit(currentState.copyWith(isLoadingMore: false));
//         // Optionally show a snackbar or toast for pagination errors
//       } else {
//         emit(
//           VideoError(
//             "Failed to fetch videos: ${error.toString()}",
//             category: event.category,
//           ),
//         );
//       }
//     } finally {
//       _isFetching = false;
//     }
//   }

//   // Method to reset all pagination when user logs out or app restarts
//   void resetPagination() {
//     _categoryPages.clear();
//   }

//   // Method to get current page for a category
//   int getCurrentPage(String category) {
//     return _categoryPages[category] ?? 1;
//   }
// }

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtube_clone/screens/home/models/video_model.dart';
import 'package:youtube_clone/screens/home/services/api_service.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final ApiService apiService;
  final int _limit = 10;
  bool _isFetching = false;

  VideoBloc(this.apiService) : super(VideoInitial()) {
    on<FetchVideos>(_onFetchVideos);
  }

  FutureOr<void> _onFetchVideos(
    FetchVideos event,
    Emitter<VideoState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final category = event.category;
      final currentState = state;

      // First Load or Refresh or Category Change
      if (event.isRefresh ||
          currentState is! VideoLoaded ||
          currentState.currentCategory != category) {
        emit(VideoLoading());

        final videos = await apiService.fetchVideos(
          page: 1,
          limit: _limit,
          category: category,
        );

        final hasReachedEnd = videos.length < _limit;

        emit(
          VideoLoaded(
            videos: videos,
            hasReachedEnd: hasReachedEnd,
            currentCategory: category,
            nextPageToken: hasReachedEnd ? null : '2', // logical token
          ),
        );
      }
      // Pagination - Load more
      else if (!currentState.hasReachedEnd && !currentState.isLoadingMore) {
        emit(currentState.copyWith(isLoadingMore: true));

        // Simulate page token using count of pages
        final currentPageToken = currentState.nextPageToken;
        final nextPage =
            currentPageToken != null ? int.tryParse(currentPageToken) ?? 1 : 1;

        final newVideos = await apiService.fetchVideos(
          page: nextPage,
          limit: _limit,
          category: category,
        );

        final combinedVideos = [...currentState.videos, ...newVideos];
        final hasReachedEnd = newVideos.length < _limit;

        emit(
          currentState.copyWith(
            videos: combinedVideos,
            isLoadingMore: false,
            hasReachedEnd: hasReachedEnd,
            nextPageToken: hasReachedEnd ? null : '${nextPage + 1}',
          ),
        );
      }
    } catch (e) {
      if (state is VideoLoaded && !event.isRefresh) {
        // If paginating and fails, just reset loadingMore
        emit((state as VideoLoaded).copyWith(isLoadingMore: false));
      } else {
        emit(
          VideoError(
            "Failed to fetch videos: ${e.toString()}",
            category: event.category,
          ),
        );
      }
    } finally {
      _isFetching = false;
    }
  }

  void resetPagination() {
    // No longer needed as we use dynamic nextPageToken
  }

  int getCurrentPage(String category) {
    // Legacy fallback; not used anymore
    return 1;
  }
}
