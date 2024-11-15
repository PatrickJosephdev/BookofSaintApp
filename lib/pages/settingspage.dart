import 'package:myapp/sub-subpage/aboutus.dart';
import 'package:myapp/sub-subpage/feedback.dart';
import 'package:flutter/material.dart';
import 'package:myapp/subpage/favorite.dart';
import 'package:myapp/themes/themedatastyle.dart';
import 'package:myapp/themes/themeprovider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [

         ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Favorite'),
            onTap: () async{
             final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritePage()),
                  );
                  if (result != null) {
                    // Handle the returned saint name if needed
                    // You can fetch the saint's details again if needed
                  }

              // Navigate to notifications settings page
            },
          ),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('FeedBack'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );

              // Navigate to notifications settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
              // Navigate to notifications settings page
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Check For Update'),
            onTap: () {
              // Navigate to help center page
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
             value: themeProvider.themeDataStyle == ThemeDataStyle.dark,
          onChanged: (value) {
            themeProvider.changeTheme();
          },
            ),
          ),
        ],
      ),
    );
  }
}
