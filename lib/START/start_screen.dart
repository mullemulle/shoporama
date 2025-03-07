import 'package:customer_app/PRODUCT/product_page.dart';
import 'package:customer_app/SETUP/setup_start_screen.dart';
import 'package:customer_app/SETTING/setting_page.dart';
import 'package:customer_app/_SERVICE/setup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;
import 'package:getwidget/getwidget.dart';

import '../APP_LOGIN/mail_login.dart';
import '../ORDER/order_page.dart';
import '../STD_WIDGET/package.dart';
import '../WARNING/warning_users.dart' show WarningUsers;
import 'design.dart';

final Map<String, Widget> appMap = {};
final startPageProvider = StateProvider<int>((ref) => 0);

final userProvider = StateProvider<User?>((ref) {
  try {
    return FirebaseAuth.instance.currentUser;
  } catch (e) {
    return null;
  }
});

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    if (userState == null) return MailLogin(onLeaving: (action, message) => ref.invalidate(userProvider));

    final setup = ref.watch(fetchSetupByIdProvider(uid: FirebaseAuth.instance.currentUser?.uid));

    return setup.when(
      data: (setup) {
        if (setup == null || setup.appKey == null) return SetupCheckScreen(setup: setup);

        final navState = ref.watch(startPageProvider);

        return Scaffold(
          appBar: AppBar(title: Image.asset('assets/shoporama.png'), centerTitle: true, actions: action(context: context, value: navState)),
          body: userState == null ? MailLogin(onLeaving: (action, message) => ref.invalidate(userProvider)) : App(setup: setup, page: navState),
          bottomNavigationBar: Navigation(value: navState, warning: setup.warningCount, onTap: (value) => ref.read(startPageProvider.notifier).state = value, onWarningTap: (value) {}),
        );
      },
      error: (error, stackTrace) => Scaffold(body: NothingFound()),
      loading: () => Scaffold(body: const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0)))),
    );
  }

  action({required BuildContext context, required int value}) {
    return [
      PopupMenuButton<String>(
        onSelected: (value) async {
          switch (value) {
            case 'restparti':
              await Navigator.push(context, CupertinoPageRoute(builder: (context) => RestpartiStartScreen()));
              break;
            case 'user':
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder:
                      (context) => SettingPage(
                        loggedOut: () {
                          if (context.mounted) {
                            final ref = ProviderScope.containerOf(context);
                            ref.read(userProvider.notifier).state = null;

                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        },
                      ),
                ),
              );

              break;

            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Valgte: $value")));
              break;
          }
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
        elevation: 6,
        itemBuilder:
            (BuildContext context) => [
              PopupMenuItem(value: "setup", child: Row(children: [Icon(Icons.settings, color: Colors.blue), SizedBox(width: 10), Text("Indstillinger")])),
              PopupMenuItem(value: "user", child: Row(children: [Icon(Icons.person_2_rounded, color: Colors.green), SizedBox(width: 10), Text("Bruger")])),
              const PopupMenuDivider(),
              PopupMenuItem(value: "restparti", child: Row(children: [Icon(Icons.store, color: Colors.black), SizedBox(width: 10), Text("Restparti leverandør")])),
            ],
      ),
    ];
  }
}

class Navigation extends StatelessWidget {
  final int value;
  final Function(int value) onTap;
  final int warning;
  final Function(int value) onWarningTap;
  const Navigation({super.key, this.value = 0, required this.onTap, required this.warning, required this.onWarningTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: value,
      onTap: (value) => onTap(value),
      elevation: 0,
      backgroundColor: Color.fromRGBO(25, 32, 67, 1), //0.45
      unselectedItemColor: Colors.white,
      fixedColor: Colors.amber,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(label: tr('#start.navigation.home'), icon: Icon(Icons.home, size: 33)),
        BottomNavigationBarItem(label: tr('#start.navigation.statistic'), icon: Icon(Icons.shopping_basket, size: 33)),
        BottomNavigationBarItem(label: tr('#start.navigation.add'), icon: Icon(Icons.add_circle, size: 33)),
        if (warning > 1)
          BottomNavigationBarItem(
            label: 'warning',
            icon: GFIconBadge(
              position: GFBadgePosition.bottomEnd(),
              padding: const EdgeInsets.all(0),
              counterChild: GFBadge(color: Colors.red, shape: GFBadgeShape.circle, child: Text('$warning', style: TextStyle(color: Colors.white))),
              child: GFIconButton(
                padding: const EdgeInsets.only(bottom: 3),
                type: GFButtonType.transparent,
                color: Colors.transparent,
                onPressed: () => onTap(3),
                icon: Icon(Icons.warning, color: Colors.yellowAccent, size: 33), //Icon(Icons.home, color: style.color, size: 33),
              ),
            ),
          ),
        //BottomNavigationBarItem(label: tr('#start.navigation.add'), icon: Icon(Icons.warning, size: 33, color: Colors.yellowAccent)),
      ],
    );
  }
}

class App extends ConsumerWidget {
  final int page;
  final Setup setup;
  const App({super.key, required this.page, required this.setup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: switch (page) {
        0 => appCache('start_page', onInit: () => ProductPage(supplierId: setup.supplierId)),
        1 => appCache('order_page', onInit: () => OrderPage(supplierId: setup.supplierId)),
        2 => ProductPage(supplierId: setup.supplierId),
        3 => WarningUsers(setup: setup),

        _ => Text('NOT FOUND'),
      },
    );
  }

  appCache(String page, {required Widget Function() onInit}) {
    if (appMap.containsKey(page)) {
      return appMap[page];
    } else {
      final widget = onInit();

      appMap[page] = widget;

      return widget;
    }
  }
}

class SetupCheckScreen extends StatelessWidget {
  final Setup? setup;
  const SetupCheckScreen({super.key, required this.setup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: switch (setup == null) {
          true => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(decoration: infoboxDecoration, padding: EdgeInsets.all(10), child: Text(tr('#start.setup_check.goto_setup'), style: infoboxStyle)),
              SizedBox(height: 20),
              DoButton(
                title: tr('#start.setup_check.button.goto_setup'),
                constraints: BoxConstraints(maxHeight: 50, maxWidth: 200),
                style: doButtonStyle,
                onTap: () async => await Navigator.push(context, CupertinoPageRoute(builder: (context) => RestpartiStartScreen())),
              ),
            ],
          ),
          false => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(decoration: infoboxDecoration, padding: EdgeInsets.all(10), child: Text(tr('#start.setup_check.waiting'), style: infoboxStyle)),
              SizedBox(height: 20),
              DoButton(
                title: tr('#start.setup_check.button.check'),
                constraints: BoxConstraints(maxHeight: 50, maxWidth: 200),
                style: doButtonStyle,
                onTap: () async {
                  final result = await _showLoadingDialog(context);

                  if (result && context.mounted) {
                    ProviderScope.containerOf(context).invalidate(fetchSetupByIdProvider);
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#start.setup_check.still_nothing'))));
                  }
                },
              ),
            ],
          ),
        },
      ),
    );
  }

  Future<bool> _showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(content: Column(mainAxisSize: MainAxisSize.min, children: [Text(tr('#start.setup_check.loading')), SizedBox(height: 20), SpinKitCircle(color: Colors.blue, size: 50.0)])),
    );

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await Future.delayed(Duration(milliseconds: 10));
    final setup = await SetupService().fetchById(uid);
    final bool success = setup != null && setup.appKey != null;

    if (context.mounted) {
      Navigator.pop(context);
    }

    return success;
  }
}
