import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomSnackbar {
  static Future delayed(BuildContext context, String name, String title, IconData? icon, {bool always = false}) async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.remove('show collectionlist hint');

    final count = prefs.getInt('show $name hint') ?? 0;
    if (count < 3 || (always && (count != 99))) {
      await prefs.setInt('show $name hint', count + 1);

      Future.delayed(const Duration(milliseconds: 200)).then(
        (value) {
          show(context, name, title, icon);
        },
      );
    }
  }

  static Future show(BuildContext context, String? name, String title, IconData? icon) async {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        //  backgroundColor: defaults.color(null).get('snackbartitlefont'),
        content: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                icon,
                color: Theme.of(context).snackBarTheme.contentTextStyle!.color!,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                //style: defaults.textStyle(null).get('Snackbartitlefont'),
              ),
            ),
          ],
        ),
        action: name == null
            ? null
            : SnackBarAction(
                label: tr('#snakbar.i_know'),
                textColor: Colors.white,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt('show $name hint', 99);
                },
              ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
