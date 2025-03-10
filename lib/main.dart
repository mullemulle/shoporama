import 'package:customer_app/START/start_screen.dart' show StartScreen;
import 'package:customer_app/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension, EasyLocalization;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

import 'START/design.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // TRANSLATION
  try {
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableBuildModes = [];
  } catch (_) {}

  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('da'), // Dansk
        ],
        path: './assets/translation',
        fallbackLocale: const Locale('da'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoporama',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Color.fromRGBO(25, 32, 67, 1),
        appBarTheme: AppBarTheme(foregroundColor: Colors.white, backgroundColor: Color.fromRGBO(25, 32, 67, 1), surfaceTintColor: Color.fromRGBO(25, 32, 67, 1), actionsIconTheme: const IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(25, 32, 67, 1)),
      ),
      home: StartScreen(),
    );
  }
}
