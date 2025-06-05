// File: lib/models/video_model.dart
// Model class for YouTube video data

class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoURL;
  final String channelName;
  final String channelAvatarUrl;
  final String viewCount;
  final String uploadTime;
  final String duration;
  final String description;
  final String channelId; // Added channelId field

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoURL,
    required this.channelName,
    required this.channelAvatarUrl,
    required this.viewCount,
    required this.uploadTime,
    required this.duration,
    required this.description,
    required this.channelId, // Added to constructor
  });

  // Factory method to create a VideoModel from JSON data
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoURL: json['videoURL'] as String,
      channelName: json['channelName'] as String,
      channelAvatarUrl: json['channelAvatarUrl'] as String,
      viewCount: json['viewCount'] as String,
      uploadTime: json['uploadTime'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      channelId: json['channelId'] as String,
    );
  }

  // Method to convert VideoModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'channelName': channelName,
      'channelAvatarUrl': channelAvatarUrl,
      'viewCount': viewCount,
      'uploadTime': uploadTime,
      'duration': duration,
      'description': description,
      'channelId': channelId,
    };
  }
}
