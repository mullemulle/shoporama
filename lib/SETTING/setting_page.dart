import 'dart:developer' show log;

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../START/default.dart';
import '/STD_WIDGET/package.dart';
import 'legal_links.dart';

import '../../../COMMON/package.dart';

class SettingPage extends StatelessWidget {
  final Function()? loggedOut;
  final Function()? deleteAccount;
  SettingPage({super.key, this.loggedOut, this.deleteAccount}) {
    log('SettingPage initialize');
  }

  final sitetitleStyle = defaults.textStyle(null).get('site_title');
  final titlefont = defaults.textStyle(null).get('titlefont');
  final subtitlefont = defaults.textStyle(null).get('subtitlefont');
  final navigationStyle = defaults.textStyle(null).get('property_navigationfont');

  final fireuser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    log('SettingPage show');

    return Scaffold(
      appBar: AppBar(title: Text(tr('#title'), style: sitetitleStyle), backgroundColor: Colors.transparent, actions: []),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: kIsWeb ? 1000 : null,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 20),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        AccountInformation(style: titlefont),
                        DoButton(
                          title: tr('#setting.button.logout'),
                          style: navigationStyle,
                          constraints: BoxConstraints(minHeight: 50),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            if (loggedOut != null) loggedOut!();
                          },
                        ),
                        if (fireuser!.isAnonymous) ...[
                          SizedBox(height: 10),
                          DoButton(
                            title: tr('#setting.button.convert_account'),
                            style: navigationStyle,
                            constraints: BoxConstraints(minHeight: 50),
                            onTap: () async => () async => await Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => SettingPage()), (route) => route.isFirst),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  LegalLinks(),
                  if (deleteAccount != null) ...[SizedBox(height: 10), DoButton(title: tr('#setting.button.delete_account'), style: navigationStyle, constraints: BoxConstraints(minHeight: 50), onTap: () async => deleteAccount!())],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void responseDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('#setting.text.response_title'), style: titlefont),
          content: Text(tr('#setting.text.response'), style: subtitlefont),
          actions: [
            TextButton(
              child: Text(tr('#setting.button.yes'), style: subtitlefont.copyWith(backgroundColor: Colors.transparent)),
              onPressed: () async {
                final ref = ProviderScope.containerOf(context);
                if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = fireuser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await fireuser!.reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await fireuser!.reauthenticateWithProvider(GoogleAuthProvider());
      }

      await fireuser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }
}

class AccountInformation extends StatelessWidget {
  final TextStyle? style;
  AccountInformation({super.key, this.style});

  final fireuser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (fireuser == null) Text(tr('#setting.text.no_account'), style: style),
        if (fireuser != null) ...[
          if (fireuser!.isAnonymous) Text(tr('#setting.text.account_is_anonymous'), style: style),
          if (!fireuser!.isAnonymous) ...[
            Text(tr('#setting.text.account_is_not_anonymous'), style: style),
            if (fireuser!.displayName != null) Text(fireuser!.displayName!, style: style),
            if (fireuser!.email != null) Text(fireuser!.email ?? tr('#setting.text.not_found'), style: style),
          ],
        ],
        Container(),
      ],
    );
  }
}
