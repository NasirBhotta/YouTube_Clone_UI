// Search screen for finding videos
import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/home/models/video_model.dart';
import 'package:youtube_clone/utils/dummy_data.dart';
import 'package:youtube_clone/widgets/search_video_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<VideoModel> _searchResults = [];
  bool _isSearching = false;
  final List<String> _recentSearches = [
    'Flutter tutorial',
    'Mobile app development',
    'React Native vs Flutter',
    'YouTube API tutorial',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      // Filter videos by title (case insensitive)
      final results =
          DummyData.videos.where((video) {
            return video.title.toLowerCase().contains(query.toLowerCase());
          }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });

      // Add to recent searches if not already there
      if (!_recentSearches.contains(query) && query.isNotEmpty) {
        setState(() {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 10) {
            _recentSearches.removeLast();
          }
        });
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            cursorColor: Colors.red,
            cursorWidth: 1.5,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Search YouTube',
              border: InputBorder.none,
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        style: ButtonStyle(
                          iconSize: WidgetStatePropertyAll(20),
                        ),
                        onPressed: _clearSearch,
                      )
                      : null,
            ),
            onChanged: (value) {
              setState(() {}); // Just to update the clear button visibility
            },
            onSubmitted: _performSearch,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_voice),
            onPressed: () {
              // Voice search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice search is not implemented yet'),
                ),
              );
            },
          ),
        ],
      ),
      body:
          _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isNotEmpty
              ? ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return SearchVideoItem(video: _searchResults[index]);
                },
              )
              : _searchController.text.isEmpty
              ? _buildRecentSearches()
              : const Center(child: Text('No results found')),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent searches',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_recentSearches.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text('CLEAR ALL'),
                ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentSearches.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(_recentSearches[index]),
              trailing: IconButton(
                icon: const Icon(Icons.north_west),
                onPressed: () {
                  _searchController.text = _recentSearches[index];
                  _performSearch(_recentSearches[index]);
                },
              ),
              onTap: () {
                _searchController.text = _recentSearches[index];
                _performSearch(_recentSearches[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
