import 'package:currency_converter/ui/screens/faqs.dart';
import 'package:currency_converter/ui/screens/feedback_screen.dart';
import 'package:currency_converter/ui/screens/history.dart';
import 'package:currency_converter/ui/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter/ui/screens/currencies.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF121331), // Set the background color here
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFFBC0D),
              ),
              child: Image.asset(
                "assets/images/logo2.png",
                width: 478,
                height: 250,
              ),
            ),
            _buildListTileWithIcon(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
            _buildListTileWithIcon(
              icon: Icons.history,
              text: 'History',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ),
                );
              },
            ),
            _buildListTileWithIcon(
              icon: Icons.account_balance_wallet,
              text: 'Currencies',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Currencies(),
                  ),
                );
              },
            ),
            _buildListTileWithIcon(
              icon: Icons.help,
              text: 'FAQs',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FAQs(),
                  ),
                );
              },
            ),
            _buildListTileWithIcon(
              icon: Icons.feedback,
              text: 'Feedback',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FeedbackScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTileWithIcon({
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFFFBC0D)),
      title: Text(
        text,
        style: TextStyle(color: Color(0xFFFFBC0D)),
      ),
      onTap: onTap,
    );
  }
}
