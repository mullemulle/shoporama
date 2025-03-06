import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Kunne ikke åbne $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _launchURL('https://swio.me/woodappeula'),
            child: Row(
              children: [Icon(Icons.article, color: Colors.green), SizedBox(width: 10), Text('EULA', style: TextStyle(color: Colors.green))],
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () => _launchURL('https://swio.me/woodappprivacypolicy'),
            child: Row(
              children: [Icon(Icons.article, color: Colors.green), SizedBox(width: 10), Text('Privacy Policy', style: TextStyle(color: Colors.green))],
            ),
          ),
        ],
      ),
    );
  }
}
