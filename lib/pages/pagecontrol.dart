import 'package:bookofsaints/pages/saintlist.dart';
import 'package:bookofsaints/pages/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:bookofsaints/pages/homepage.dart';

// Enum to handle tab navigation
enum _SelectedTab { home, saintList, settings }

class PageControl extends StatefulWidget {
  const PageControl({super.key});

  @override
  State<PageControl> createState() => _PageControlState();
}

class _PageControlState extends State<PageControl> {
  _SelectedTab _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(), // Based on the selected tab
      extendBody: true, // This makes the body extend to include the navbar
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        margin: const EdgeInsets.all(2),
        indicatorColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(0.000001),
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            selectedColor: Colors.black,
            unselectedColor: Colors.black54,
          ),
          CrystalNavigationBarItem(
            icon: Icons.list,
            selectedColor: Colors.black,
            unselectedColor: Colors.black54,
          ),
          CrystalNavigationBarItem(
            icon: Icons.settings,
            selectedColor: Colors.black,
            unselectedColor: Colors.black54,
          ),
        ],
      ),
    );
  }

  // This function will return the appropriate page
  Widget _buildPage() {
    switch (_selectedTab) {
      case _SelectedTab.home:
        return const MyHomePage();
      case _SelectedTab.saintList:
        return const SaintList();
      case _SelectedTab.settings:
        return const SettingsPage();
      default:
        return const MyHomePage();
    }
  }
}
