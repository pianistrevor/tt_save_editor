import 'package:flutter/material.dart';
import 'package:tt_save_editor/view/pages/home_page.dart';
import 'package:tt_save_editor/view/pages/settings_page.dart';

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  int _selectedTab = 0;
  late Widget _mainContent;
  final List<NavigationRailDestination> _navRailDestinations = [
    const NavigationRailDestination(
      icon: Icon(Icons.house_outlined),
      selectedIcon: Icon(Icons.house),
      label: Text('Home'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('Home'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buildMainContent();
  }

  void _navRailDestinationChanged(int index) {
    setState(() {
      _selectedTab = index;
      _buildMainContent();
    });
  }

  void _buildMainContent() {
    switch (_selectedTab) {
      case 0:
        _mainContent = _buildHomePage();
      case 1:
        _mainContent = _buildSettingsPage();
    }
  }

  HomePage _buildHomePage() => const HomePage();
  SettingsPage _buildSettingsPage() => const SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TTSaveFileEditor'),
      ),
      body: Row(
        children: [
          NavigationRail(
            destinations: _navRailDestinations,
            onDestinationSelected: _navRailDestinationChanged,
            selectedIndex: _selectedTab,
            elevation: 5.0,
          ),
          Expanded(child: _mainContent),
        ],
      ),
    );
  }
}
