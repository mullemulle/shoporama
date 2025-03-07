import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../COMMON/package.dart';
import '../STD_WIDGET/package.dart';

// EmailAuthWidget
class MailLogin extends StatelessWidget {
  final Function(String action, String message) onLeaving;
  MailLogin({super.key, required this.onLeaving});

  // Providers
  final emailProvider = StateProvider<String>((ref) => '');
  final passwordProvider = StateProvider<String>((ref) => '');
  final isLoadingProvider = StateProvider<bool>((ref) => false);
  final errorMessageProvider = StateProvider<String?>((ref) => null);

  // Style
  final subtitlefont = defaults.textStyle(null).get('subtitlefont');
  final navigationStyle = defaults.textStyle(null).get('property_navigationfont');

  final constraints = BoxConstraints(minHeight: 50, maxWidth: 400);

  @override
  Widget build(BuildContext context) {
    final navigationSecondaryStyle = navigationStyle.copyWith(backgroundColor: Colors.transparent, color: navigationStyle.backgroundColor);

    FocusNode focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(title: Text(tr("#mail_login.text.title"))),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: kIsWeb ? 1000 : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(isLoadingProvider);
                final errorMessage = ref.watch(errorMessageProvider);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Email Input
                      TextField(
                        focusNode: focusNode,
                        decoration: InputDecoration(labelText: tr('#mail_login.text.email'), border: OutlineInputBorder(borderSide: BorderSide())),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          ref.read(emailProvider.notifier).state = value;
                        },
                      ),

                      SizedBox(height: 16),

                      // Password Input
                      TextField(
                        decoration: InputDecoration(labelText: tr('#mail_login.text.password'), border: OutlineInputBorder()),
                        obscureText: true,
                        onChanged: (value) {
                          ref.read(passwordProvider.notifier).state = value;
                        },
                      ),
                      SizedBox(height: 16),

                      // Error Message
                      if (errorMessage != null) Text(errorMessage, style: TextStyle(color: Colors.red)),

                      // Action Buttons
                      DoButton(enabled: !isLoading, onTap: () => _login(context, ref), title: tr("#mail_login.button.login"), style: navigationStyle, constraints: constraints),
                      SizedBox(height: 16),
                      DoButton(enabled: !isLoading, onTap: () => _register(context, ref), title: tr("#mail_login.button.register"), style: navigationSecondaryStyle, constraints: constraints),
                      Center(child: Text(tr("#mail_login.button.register_help"), style: subtitlefont)),
                      SizedBox(height: 16),
                      DoButton(enabled: !isLoading, onTap: () => _resetPassword(context, ref), title: tr("#mail_login.button.forgot_password"), style: navigationSecondaryStyle, constraints: constraints),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Login method
  Future<void> _login(BuildContext context, WidgetRef ref) async {
    try {
      final email = ref.read(emailProvider);
      final password = ref.read(passwordProvider);

      if (email.isEmpty || password.isEmpty) {
        ref.read(errorMessageProvider.notifier).state = tr("#mail_login.error.empty_fields");
        return;
      }

      ref.read(isLoadingProvider.notifier).state = true;

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      ref.read(isLoadingProvider.notifier).state = false;

      if (!userCredential.user!.emailVerified) {
        await _showEmailVerificationDialog(context, userCredential.user!);
      } else {
        if (context.mounted) _showSuccess('success', tr("#mail_login.success.login"));
      }
    } catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      ref.read(errorMessageProvider.notifier).state = _handleAuthError(e);
    }
  }

  // Register method
  Future<void> _register(BuildContext context, WidgetRef ref) async {
    try {
      final email = ref.read(emailProvider);
      final password = ref.read(passwordProvider);

      if (email.isEmpty || password.isEmpty) {
        ref.read(errorMessageProvider.notifier).state = tr("#mail_login.error.empty_fields");
        return;
      }

      ref.read(isLoadingProvider.notifier).state = true;

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      ref.read(isLoadingProvider.notifier).state = false;

      await _showEmailVerificationDialog(context, userCredential.user!);
    } catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      ref.read(errorMessageProvider.notifier).state = _handleAuthError(e);
    }
  }

  // Reset Password method
  Future<void> _resetPassword(BuildContext context, WidgetRef ref) async {
    try {
      final email = ref.read(emailProvider);

      if (email.isEmpty) {
        ref.read(errorMessageProvider.notifier).state = tr("#mail_login.error.empty_email");
        return;
      }

      ref.read(isLoadingProvider.notifier).state = true;

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ref.read(isLoadingProvider.notifier).state = false;
      if (context.mounted) _showSuccess('success', tr("#mail_login.success.reset_password"));
    } catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      ref.read(errorMessageProvider.notifier).state = _handleAuthError(e);
    }
  }

  // Show email verification dialog
  Future<void> _showEmailVerificationDialog(BuildContext context, User user) async {
    bool isVerified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(tr("#mail_login.text.verify_email")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr("#mail_login.text.check_email")),
              SizedBox(height: 16),
              DoButton(
                onTap: () async {
                  await user.sendEmailVerification();
                },
                title: tr("#mail_login.button.resend_verification"),
                style: navigationStyle,
                constraints: constraints,
              ),
            ],
          ),
          actions: [
            DoButton(
              onTap: () async {
                await user.reload();
                if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                  isVerified = true;
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              title: tr("#mail_login.button.check_verification"),
              style: navigationStyle,
              constraints: constraints,
            ),
          ],
        );
      },
    );

    if (isVerified && context.mounted) {
      _showSuccess('success', tr("#mail_login.success.email_verified"));
    }
  }

  // Handle authentication errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return tr("#mail_login.error.invalid_email");
        case 'user-disabled':
          return tr("#mail_login.error.user_disabled");
        case 'user-not-found':
          return tr("#mail_login.error.user_not_found");
        case 'wrong-password':
          return tr("#mail_login.error.wrong_password");
        case 'email-already-in-use':
          return tr("#mail_login.error.email_in_use");
        case 'operation-not-allowed':
          return tr("#mail_login.error.operation_not_allowed");
        case 'weak-password':
          return tr("#mail_login.error.weak_password");
        default:
          return tr("#mail_login.error.unknown");
      }
    }
    return tr("#mail_login.error.unknown");
  }

  void _showSuccess(String action, String message) {
    onLeaving(action, message);
  }
}
