// File: lib/utils/dummy_data.dart
// Dummy data for testing the YouTube clone app

import 'package:youtube_clone/models/channel_model.dart';
import 'package:youtube_clone/models/shorts_model.dart';
import 'package:youtube_clone/models/video_model.dart';

class DummyData {
  // Sample subscription channels
  static final List<ChannelModel> subscriptions = [
    ChannelModel(
      id: 'c1',
      name: 'Flutter Dev',
      profilePicture: 'assets/images/channels/flutter_dev.jpg',
      subscriberCount: 1250000,
      isVerified: true,
      description:
          'Official Flutter development channel with tutorials, tips and tricks.',
      bannerUrl: 'assets/images/banners/flutter_dev_banner.jpg',
    ),
    ChannelModel(
      id: 'c2',
      name: 'Mobile Dev Hub',
      profilePicture: 'assets/images/channels/mobile_dev_hub.jpg',
      subscriberCount: 850000,
      isVerified: true,
      description: 'Latest trends and tutorials in mobile app development.',
      bannerUrl: 'assets/images/banners/mobile_dev_hub_banner.jpg',
    ),
    ChannelModel(
      id: 'c3',
      name: 'Code With Mark',
      profilePicture: 'assets/images/channels/code_with_mark.jpg',
      subscriberCount: 325000,
      isVerified: false,
      description:
          'Coding tutorials and walkthroughs for developers of all levels.',
      bannerUrl: 'assets/images/banners/code_with_mark_banner.jpg',
    ),
    ChannelModel(
      id: 'c5',
      name: 'API Builders',
      profilePicture: 'assets/images/channels/api_builders.jpg',
      subscriberCount: 487000,
      isVerified: true,
      description: 'Everything you need to know about working with APIs.',
      bannerUrl: 'assets/images/banners/api_builders_banner.jpg',
    ),
    ChannelModel(
      id: 'c6',
      name: 'Flutter UI Master',
      profilePicture: 'assets/images/channels/flutter_ui_master.jpg',
      subscriberCount: 923000,
      isVerified: true,
      description: 'Creating beautiful and responsive UIs with Flutter.',
      bannerUrl: 'assets/images/banners/flutter_ui_master_banner.jpg',
    ),
    ChannelModel(
      id: 'c7',
      name: 'State Masters',
      profilePicture: 'assets/images/channels/state_masters.jpg',
      subscriberCount: 756000,
      isVerified: false,
      description: 'Mastering state management in modern frameworks.',
      bannerUrl: 'assets/images/banners/state_masters_banner.jpg',
    ),
  ];

  // Sample regular videos data
  static final List<VideoModel> videos = [
    VideoModel(
      id: 'v1',
      title: 'Flutter Tutorial for Beginners - Build iOS and Android Apps',
      thumbnailUrl: 'https://i.ytimg.com/vi/1ukSR1GRtMU/maxresdefault.jpg',
      channelName: 'Flutter Dev',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      viewCount: '1.2M views',
      uploadTime: '2 weeks ago',
      duration: '12:45',
      description:
          'Learn the basics of Flutter and build your first mobile app. This tutorial covers setup, widgets, state management and more.',
      channelId: 'c1',
    ),
    VideoModel(
      id: 'v2',
      title: 'Mobile App Development in 2025 - Which Framework to Choose?',
      thumbnailUrl: 'https://i.ytimg.com/vi/1ukSR1GRtMU/maxresdefault.jpg',
      channelName: 'Mobile Dev Hub',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      viewCount: '854K views',
      uploadTime: '3 days ago',
      duration: '18:32',
      description:
          'Comparing the top mobile development frameworks in 2025. Analysis of Flutter, React Native, SwiftUI, Jetpack Compose and more.',
      channelId: 'c2',
    ),
    VideoModel(
      id: 'v3',
      title: 'How to Create a YouTube Clone with Flutter',
      thumbnailUrl: 'https://i.ytimg.com/vi/h-igXZCCrrc/maxresdefault.jpg',
      channelName: 'Code With Mark',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      viewCount: '325K views',
      uploadTime: '1 month ago',
      duration: '25:18',
      description:
          'Step-by-step tutorial on creating a YouTube clone using Flutter. Build screens, implement video playback, and more.',
      channelId: 'c3',
    ),
    VideoModel(
      id: 'v4',
      title: 'React Native vs Flutter: The Ultimate Comparison',
      thumbnailUrl: 'https://i.ytimg.com/vi/X8ipUgXH6jw/maxresdefault.jpg',
      channelName: 'Cross-Platform Chronicles',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
      viewCount: '1.5M views',
      uploadTime: '2 months ago',
      duration: '15:22',
      description:
          'A detailed comparison of React Native and Flutter for cross-platform mobile development. Performance, UI, development experience and more.',
      channelId: 'c4',
    ),
    VideoModel(
      id: 'v5',
      title: 'Working with YouTube API in Flutter - Complete Guide',
      thumbnailUrl: 'https://i.ytimg.com/vi/1ukSR1GRtMU/maxresdefault.jpg',
      channelName: 'API Builders',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
      viewCount: '487K views',
      uploadTime: '3 weeks ago',
      duration: '22:49',
      description:
          'Learn how to integrate the YouTube API in your Flutter application. Authentication, search, playlists, and video management.',
      channelId: 'c5',
    ),
    VideoModel(
      id: 'v6',
      title: 'Building Beautiful UIs with Flutter',
      thumbnailUrl: 'https://i.ytimg.com/vi/1ukSR1GRtMU/maxresdefault.jpg',
      channelName: 'Flutter UI Master',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/women/6.jpg',
      viewCount: '923K views',
      uploadTime: '1 week ago',
      duration: '28:15',
      description:
          'Advanced techniques for creating beautiful and responsive user interfaces in Flutter. Animations, custom widgets and theming.',
      channelId: 'c6',
    ),
    VideoModel(
      id: 'v7',
      title: 'State Management in Flutter - Provider vs Bloc vs Riverpod',
      thumbnailUrl: 'https://i.ytimg.com/vi/3tm-R7ymwhc/maxresdefault.jpg',
      channelName: 'State Masters',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/men/7.jpg',
      viewCount: '756K views',
      uploadTime: '5 days ago',
      duration: '32:41',
      description:
          'Comparing different state management solutions in Flutter. Learn when to use Provider, Bloc or Riverpod in your applications.',
      channelId: 'c7',
    ),
    VideoModel(
      id: 'v8',
      title: 'Flutter Firebase Integration Tutorial',
      thumbnailUrl: 'https://i.ytimg.com/vi/EXp0gq9kGxI/maxresdefault.jpg',
      channelName: 'Backend Builders',
      channelAvatarUrl: 'https://randomuser.me/api/portraits/women/8.jpg',
      viewCount: '612K views',
      uploadTime: '2 weeks ago',
      duration: '20:19',
      description:
          'Step-by-step guide to integrating Firebase services into your Flutter application. Authentication, Firestore, Storage and more.',
      channelId: 'c8',
    ),
  ];

  // Sample short videos data
  static final List<ShortsModel> shorts = [
    ShortsModel(
      id: 's1',
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-portrait-of-a-fashion-woman-with-silver-makeup-39875-large.mp4',
      thumbnailUrl: 'https://i.imgur.com/rNfZByJ.jpg',
      title: 'Fashion Trends 2025',
      username: 'fashionista',
      userProfileImageUrl: 'https://i.imgur.com/JQ8tPid.jpg',
      likes: 245000,
      comments: 1890,
      shares: 5460,
      musicName: 'Original Sound - fashionista',
      isVerified: true,
      description:
          'Check out these amazing fashion trends for 2025! #fashion #trending',
    ),
    ShortsModel(
      id: 's2',
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-young-woman-vlogger-recording-content-for-her-channel-39765-large.mp4',
      thumbnailUrl: 'https://i.imgur.com/mEyDcDY.jpg',
      title: 'Day in my life',
      username: 'lifestyle_vlogger',
      userProfileImageUrl: 'https://i.imgur.com/5GWiL3T.jpg',
      likes: 182350,
      comments: 942,
      shares: 2134,
      musicName: 'Happy Day - PopMusic',
      isVerified: false,
      description: 'A day in my life as a content creator! #vlog #dayinmylife',
    ),
    ShortsModel(
      id: 's3',
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-man-under-multicolored-lights-1237-large.mp4',
      thumbnailUrl: 'https://i.imgur.com/fDcVCOS.jpg',
      title: 'LED Light Tricks',
      username: 'tech_wizard',
      userProfileImageUrl: 'https://i.imgur.com/6QYI9j0.jpg',
      likes: 563420,
      comments: 2893,
      shares: 10287,
      musicName: 'Electronic Beats - DJ MixMaster',
      isVerified: true,
      description:
          'Amazing light tricks you can do at home! #lights #diy #tech',
    ),
    ShortsModel(
      id: 's4',
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-top-aerial-shot-of-seashore-with-rocks-1090-large.mp4',
      thumbnailUrl: 'https://i.imgur.com/YlrOgOj.jpg',
      title: 'Amazing Nature Views',
      username: 'nature_explorer',
      userProfileImageUrl: 'https://i.imgur.com/1Q4Z3LW.jpg',
      likes: 784253,
      comments: 3241,
      shares: 14526,
      musicName: 'Peaceful Waves - Nature Sounds',
      isVerified: true,
      description:
          'Discovered this amazing view during my travels! #nature #travel',
    ),
    ShortsModel(
      id: 's5',
      videoUrl:
          'https://assets.mixkit.co/videos/preview/mixkit-urban-dancer-performing-on-a-rooftop-40157-large.mp4',
      thumbnailUrl: 'https://i.imgur.com/8mZRo5c.jpg',
      title: 'Urban Dance Performance',
      username: 'dance_pro',
      userProfileImageUrl: 'https://i.imgur.com/PJUqTXg.jpg',
      likes: 427863,
      comments: 1564,
      shares: 8745,
      musicName: 'Street Rhythm - HipHop Beats',
      isVerified: false,
      description:
          'New dance routine! Let me know what you think 🔥 #dance #urban',
    ),
  ];

  // You can add more dummy data for other features here
}
