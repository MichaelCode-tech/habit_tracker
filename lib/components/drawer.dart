import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/themeProvider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // Header with Icon
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/logo.png',
                height: 60,
                width: 60,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Menu Items
          _buildDrawerItem(
            context,
            title: "H O M E",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          _buildDrawerItem(
            context,
            title: "A B O U T",
            icon: Icons.info,
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Habit Tracker',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset(
                  'assets/icons/logo.png',
                  height: 40,
                  width: 40,
                ),
                children: [
                  const Text("Develop small habits, achieve big goals."),
                ],
              );
            },
          ),

          // Theme toggle tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Provider.of<ThemeProvider>(context).isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Footer text
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Text(
              "V E R S I O N  1 . 0",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: onTap,
      ),
    );
  }
}
