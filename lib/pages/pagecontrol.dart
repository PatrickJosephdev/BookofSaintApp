import 'package:myapp/pages/saintlist.dart';
import 'package:myapp/pages/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:myapp/pages/homepage.dart';

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
    // Check if the current theme is dark or light
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _buildPage(), // Based on the selected tab
      extendBody: true, // This makes the body extend to include the navbar
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        margin: const EdgeInsets.all(2),
        indicatorColor:
            isDarkMode ? Colors.white : Colors.black, // Change indicator color
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.00000001)
            : Colors.white.withOpacity(0.0000001), // Change background color
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            selectedColor: isDarkMode
                ? Colors.white
                : Colors.black, // Change selected color
            unselectedColor: isDarkMode
                ? Colors.white54
                : Colors.black54, // Change unselected color
          ),
          CrystalNavigationBarItem(
            icon: Icons.list,
            selectedColor: isDarkMode ? Colors.white : Colors.black,
            unselectedColor: isDarkMode ? Colors.white54 : Colors.black54,
          ),
          CrystalNavigationBarItem(
            icon: Icons.settings,
            selectedColor: isDarkMode ? Colors.white : Colors.black,
            unselectedColor: isDarkMode ? Colors.white54 : Colors.black54,
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
