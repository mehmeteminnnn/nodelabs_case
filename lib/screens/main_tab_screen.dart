import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: TabBarView(
        controller: _tabController,
        children: const [
          ExploreScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, size: 20),
                  SizedBox(width: 6),
                  Text('Ana Sayfa'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 20),
                  SizedBox(width: 6),
                  Text('Profil'),
                ],
              ),
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: RectangularIndicator(
            color: Colors.white,
            bottomLeftRadius: 40,
            bottomRightRadius: 40,
            topLeftRadius: 40,
            topRightRadius: 40,
            paintingStyle: PaintingStyle.stroke,
          ),
        ),
      ),
    );
  }
}
