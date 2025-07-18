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
        // print((state as VideoLoaded).videos);

        emit(
          VideoLoaded(
            videos: [],
            hasReachedEnd: false,
            isLoadingMore: false,
            currentCategory: category,
            nextPageToken: null,
          ),
        );

        emit(VideoLoading());

        List<VideoModel> videos = [];

        videos = await apiService.fetchVideos(
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
}
