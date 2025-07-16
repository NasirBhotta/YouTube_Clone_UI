part of 'video_bloc.dart';

@immutable
sealed class VideoEvent {}

/// Fetch videos for a category. Can be initial, refresh, or load more.
class FetchVideos extends VideoEvent {
  final String category;
  final bool isRefresh;

  FetchVideos({required this.category, this.isRefresh = false});
}
