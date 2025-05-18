// File: lib/models/shorts_model.dart
// Model for YouTube Shorts videos

class ShortsModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String username;
  final String userProfileImageUrl;
  final int likes;
  final int comments;
  final int shares;
  final String musicName;
  final bool isVerified;
  final String description;

  ShortsModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.username,
    required this.userProfileImageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.musicName,
    this.isVerified = false,
    required this.description,
  });

  // Factory method to create a ShortsModel from JSON data
  factory ShortsModel.fromJson(Map<String, dynamic> json) {
    return ShortsModel(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      title: json['title'] as String,
      username: json['username'] as String,
      userProfileImageUrl: json['userProfileImageUrl'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
      musicName: json['musicName'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      description: json['description'] as String,
    );
  }

  // Method to convert ShortsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'username': username,
      'userProfileImageUrl': userProfileImageUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'musicName': musicName,
      'isVerified': isVerified,
      'description': description,
    };
  }
}
