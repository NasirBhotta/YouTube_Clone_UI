// File: lib/models/channel_model.dart
// Model class for YouTube channel data

class ChannelModel {
  final String id;
  final String name;
  final String profilePicture;
  final int subscriberCount;
  final bool isVerified;
  final String description;
  final String bannerUrl;

  ChannelModel({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.subscriberCount,
    this.isVerified = false,
    required this.description,
    required this.bannerUrl,
  });

  // Factory method to create a ChannelModel from JSON data
  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String,
      subscriberCount: json['subscriberCount'] as int,
      isVerified: json['isVerified'] as bool? ?? false,
      description: json['description'] as String,
      bannerUrl: json['bannerUrl'] as String,
    );
  }

  // Method to convert ChannelModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePicture': profilePicture,
      'subscriberCount': subscriberCount,
      'isVerified': isVerified,
      'description': description,
      'bannerUrl': bannerUrl,
    };
  }
}
