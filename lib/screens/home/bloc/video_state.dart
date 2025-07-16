// part of 'video_bloc.dart';

// @immutable
// sealed class VideoState {}

// final class VideoInitial extends VideoState {}

// class VideoLoading extends VideoState {}

// class VideoLoaded extends VideoState {
//   final List<VideoModel> videos;
//   final bool hasReachedEnd;
//   final bool isLoadingMore;
//   final String currentCategory;

//   VideoLoaded({
//     required this.videos,
//     required this.hasReachedEnd,
//     required this.currentCategory,
//     this.isLoadingMore = false,
//   });

//   VideoLoaded copyWith({
//     List<VideoModel>? videos,
//     bool? hasReachedEnd,
//     bool? isLoadingMore,
//     String? currentCategory,
//   }) {
//     return VideoLoaded(
//       videos: videos ?? this.videos,
//       hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//       currentCategory: currentCategory ?? this.currentCategory,
//     );
//   }
// }

// class VideoError extends VideoState {
//   final String message;
//   final String? category;

//   VideoError(this.message, {this.category});
// }

part of 'video_bloc.dart';

@immutable
sealed class VideoState {}

/// Initial state before any data is loaded
final class VideoInitial extends VideoState {}

/// Loading state (first load)
class VideoLoading extends VideoState {}

/// Loaded state with all required metadata
class VideoLoaded extends VideoState {
  final List<VideoModel> videos;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String currentCategory;
  final String? nextPageToken;

  VideoLoaded({
    required this.videos,
    required this.hasReachedEnd,
    required this.currentCategory,
    this.isLoadingMore = false,
    this.nextPageToken,
  });

  VideoLoaded copyWith({
    List<VideoModel>? videos,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? currentCategory,
    String? nextPageToken,
  }) {
    return VideoLoaded(
      videos: videos ?? this.videos,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentCategory: currentCategory ?? this.currentCategory,
      nextPageToken: nextPageToken ?? this.nextPageToken,
    );
  }
}

/// Error state with optional category context
class VideoError extends VideoState {
  final String message;
  final String? category;

  VideoError(this.message, {this.category});
}
