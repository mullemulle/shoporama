
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field2/intl_phone_field.dart';

// PhoneAuthWidget
class PhoneLogin extends StatelessWidget {
  final Function(String action, String message) onLeaving;
  PhoneLogin({super.key, required this.onLeaving});

// Providers
  final phoneNumberProvider = StateProvider<String>((ref) => '');
  final verificationIdProvider = StateProvider<String?>((ref) => null);
  final smsCodeProvider = StateProvider<String?>((ref) => null);
  final isLoadingProvider = StateProvider<bool>((ref) => false);
  final errorMessageProvider = StateProvider<String?>((ref) => null);

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(title: Text(tr("#login.title"))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, child) {
            final isLoading = ref.watch(isLoadingProvider);
            final verificationId = ref.watch(verificationIdProvider);
            final errorMessage = ref.watch(errorMessageProvider);

            final countryCode = WidgetsBinding.instance.platformDispatcher.locale.countryCode;
            final languageCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phone Number Input

                IntlPhoneField(
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: countryCode,
                  languageCode: (languageCode ?? 'en'),
                  onChanged: (phone) {
                    ref.read(phoneNumberProvider.notifier).state = phone.completeNumber ?? '';
                  },
                  onCountryChanged: (country) {},
                ),

                SizedBox(height: 16),

                // Verification Code Input (conditionally shown)
                if (verificationId != null)
                  TextField(
                    decoration: InputDecoration(
                      labelText: tr("#login.text.verification_code"),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      ref.read(smsCodeProvider.notifier).state = value;
                    },
                  ),
                SizedBox(height: 16),

                // Error Message
                if (errorMessage != null)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),

                // Action Button

                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (verificationId == null) {
                            _sendCode(context, ref);
                          } else {
                            _verifyCode(context, ref);
                          }
                        },
                  child: isLoading ? Center(child: SpinKitCircle(color: Colors.amber, size: 50.0)) : Text(verificationId == null ? tr("#login.button.send_code") : tr("#login.button.verify_code")),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Sends the verification code
  Future<void> _sendCode(BuildContext context, WidgetRef ref) async {
    try {
      final phoneNumber = ref.read(phoneNumberProvider);

      if (phoneNumber.isEmpty) {
        ref.read(errorMessageProvider.notifier).state = "Phone number cannot be empty.";
        return;
      }

      ref.read(isLoadingProvider.notifier).state = true;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final isAnonymously = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

          if (isAnonymously) {
            await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
            ref.read(isLoadingProvider.notifier).state = false;

            if (context.mounted) _showSuccess('success', "Account converted successfully!");
          } else {
            await FirebaseAuth.instance.signInWithCredential(credential);
            ref.read(isLoadingProvider.notifier).state = false;
            if (context.mounted) _showSuccess('success', "Account successfully!");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          ref.read(isLoadingProvider.notifier).state = false;
          ref.read(errorMessageProvider.notifier).state = e.message ?? "Verification failed.";
        },
        codeSent: (String verificationId, int? resendToken) {
          ref.read(verificationIdProvider.notifier).state = verificationId;
          ref.read(isLoadingProvider.notifier).state = false;
          ref.read(errorMessageProvider.notifier).state = null;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!context.mounted) return;

          ref.read(verificationIdProvider.notifier).state = null;
          ref.read(errorMessageProvider.notifier).state = null;
        },
      );
    } catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      ref.read(errorMessageProvider.notifier).state = e.toString();

      if (context.mounted) _showSuccess('error', e.toString());
    }
  }

  // Verifies the code
  Future<void> _verifyCode(BuildContext context, WidgetRef ref) async {
    try {
      final verificationId = ref.read(verificationIdProvider);
      final smsCode = ref.read(smsCodeProvider);

      if (verificationId == null || smsCode == null) {
        ref.read(errorMessageProvider.notifier).state = "Please enter the verification code.";
        return;
      }

      ref.read(isLoadingProvider.notifier).state = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final isAnonymously = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

      if (isAnonymously) {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

        ref.read(isLoadingProvider.notifier).state = false;
        if (context.mounted) _showSuccess('success', "Phone number verified and account converted!");
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
        ref.read(isLoadingProvider.notifier).state = false;
        if (context.mounted) _showSuccess('success', "Account successfully!");
      }
    } catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      ref.read(errorMessageProvider.notifier).state = e.toString();

      if (context.mounted) _showSuccess('error', e.toString());
    }
  }

  void _showSuccess(String action, String message) {
    onLeaving(action, message);
  }
}
