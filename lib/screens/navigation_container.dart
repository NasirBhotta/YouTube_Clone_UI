// Main navigation container that handles the bottom navigation
import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/home/UI/home_screen.dart';
import 'package:youtube_clone/screens/library_screen.dart';
import 'package:youtube_clone/screens/shorts_screen.dart';
import 'package:youtube_clone/screens/subscriptions_screen.dart';
import 'package:youtube_clone/screens/upload_screen.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ShortsScreen(),
    const UploadScreen(),
    const SubscriptionsScreen(),
    const LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showUploadOptions();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildUploadOption(Icons.upload, 'Upload a video'),
              _buildUploadOption(Icons.live_tv, 'Go live'),
              _buildUploadOption(Icons.video_call, 'Create a Short'),
              _buildUploadOption(Icons.podcasts, 'Create a post'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadOption(IconData icon, String label) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 20),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            activeIcon: Icon(Icons.play_circle_fill),
            label: 'Shorts',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 241, 241),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: 'Subs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
