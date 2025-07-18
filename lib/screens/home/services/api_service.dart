import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_clone/screens/home/models/video_model.dart';

class ApiService {
  static const String _apiKey = 'AIzaSyBCJMDCFba-_uX346TPq01og0DsY-j1OiU';
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  final Map<String, String?> _pageTokens = {};

  Future<List<VideoModel>> fetchVideos({
    required int page,
    required int limit,
    String category = 'All',
    bool isRefresh = false, // Add this to support refresh
  }) async {
    try {
      final key = '${category.toLowerCase()}_page$page';

      if (isRefresh) {
        // Clear all cached tokens for the category when refreshing
        _pageTokens.removeWhere(
          (k, v) => k.startsWith('${category.toLowerCase()}_page'),
        );
      }

      final pageToken = isRefresh ? null : _pageTokens[key];
      Map<String, dynamic> result;

      if (category.toLowerCase() == 'all') {
        result = await _fetchTrendingVideosWithPagination(
          maxResults: limit,
          pageToken: pageToken,
        );
      } else {
        result = await _fetchVideosByCategoryWithPagination(
          category,
          maxResults: limit,
          pageToken: pageToken,
        );
      }

      final nextPageToken = result['nextPageToken'];
      if (nextPageToken != null && !isRefresh) {
        _pageTokens['${category.toLowerCase()}_page${page + 1}'] =
            nextPageToken;
      } else if (nextPageToken != null && isRefresh && page == 1) {
        // For refresh on page 1, set the token for page 2
        _pageTokens['${category.toLowerCase()}_page2'] = nextPageToken;
      }

      return result['videos'] as List<VideoModel>;
    } catch (e) {
      print('Error in fetchVideos: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> _fetchTrendingVideosWithPagination({
    required int maxResults,
    String? pageToken,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/videos?part=snippet,statistics,contentDetails'
      '&chart=mostPopular&regionCode=US&maxResults=$maxResults'
      '${pageToken != null ? '&pageToken=$pageToken' : ''}&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'videos': _parseVideos(data['items']),
        'nextPageToken': data['nextPageToken'],
      };
    } else {
      throw Exception('Failed to fetch trending videos');
    }
  }

  Future<Map<String, dynamic>> _fetchVideosByCategoryWithPagination(
    String category, {
    required int maxResults,
    String? pageToken,
  }) async {
    final searchUrl = Uri.parse(
      '$_baseUrl/search?part=snippet&type=video&q=$category&maxResults=$maxResults'
      '${pageToken != null ? '&pageToken=$pageToken' : ''}&key=$_apiKey',
    );

    final response = await http.get(searchUrl);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videoIds = (data['items'] as List)
          .map((item) => item['id']['videoId'] ?? '')
          .where((id) => id.isNotEmpty)
          .join(',');

      if (videoIds.isEmpty) return {'videos': [], 'nextPageToken': null};

      final videos = await _fetchVideoDetails(videoIds);
      return {'videos': videos, 'nextPageToken': data['nextPageToken']};
    } else {
      throw Exception('Failed to fetch category videos');
    }
  }

  Future<List<VideoModel>> _fetchVideoDetails(String videoIds) async {
    final url = Uri.parse(
      '$_baseUrl/videos?part=snippet,statistics,contentDetails&id=$videoIds&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parseVideos(data['items']);
    } else {
      throw Exception('Failed to fetch video details');
    }
  }

  List<VideoModel> _parseVideos(List<dynamic> items) {
    return items.map((item) {
      final snippet = item['snippet'];
      final statistics = item['statistics'];
      final contentDetails = item['contentDetails'];
      final id = item['id'] is Map ? item['id']['videoId'] : item['id'];

      return VideoModel(
        id: id,
        title: snippet['title'] ?? '',
        thumbnailUrl: snippet['thumbnails']['high']['url'] ?? '',
        channelName: snippet['channelTitle'] ?? '',
        channelAvatarUrl: snippet['thumbnails']['default']['url'] ?? '',
        videoURL: 'https://www.youtube.com/watch?v=$id',
        viewCount: _formatViewCount(statistics['viewCount'] ?? '0'),
        uploadTime: _formatUploadTime(snippet['publishedAt'] ?? ''),
        duration: _formatDuration(contentDetails['duration'] ?? ''),
        description: snippet['description'] ?? '',
        channelId: snippet['channelId'] ?? '',
      );
    }).toList();
  }

  Future<Map<String, String>> getChannelDetails(String channelId) async {
    final url = Uri.parse(
      '$_baseUrl/channels?part=snippet&id=$channelId&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if ((data['items'] as List).isNotEmpty) {
        final channel = data['items'][0];
        return {
          'avatarUrl': channel['snippet']['thumbnails']['default']['url'],
          'title': channel['snippet']['title'],
        };
      }
    }
    return {};
  }

  String _formatViewCount(String viewCount) {
    final count = int.tryParse(viewCount) ?? 0;
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M views';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K views';
    }
    return '$count views';
  }

  String _formatUploadTime(String publishedAt) {
    try {
      final publishedDate = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final diff = now.difference(publishedDate);

      if (diff.inDays > 365) return '${diff.inDays ~/ 365} years ago';
      if (diff.inDays > 30) return '${diff.inDays ~/ 30} months ago';
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      return '${diff.inMinutes} minutes ago';
    } catch (_) {
      return 'Unknown';
    }
  }

  String _formatDuration(String duration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(duration);

    final h = int.tryParse(match?.group(1) ?? '0') ?? 0;
    final m = int.tryParse(match?.group(2) ?? '0') ?? 0;
    final s = int.tryParse(match?.group(3) ?? '0') ?? 0;

    if (h > 0)
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
