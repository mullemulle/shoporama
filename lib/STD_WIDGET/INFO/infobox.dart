import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../COMMON/package.dart';

class NothingFound extends StatelessWidget {
  final IconData? icon;
  final String? overrideText;
  final TextStyle? style;
  const NothingFound({super.key, this.icon, this.overrideText, this.style});

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? defaults.textStyle(null).get('standarderrorfont');

    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.folder_off_outlined, //Icons.published_with_changes_sharp,
            size: 30,
            color: textStyle.color,
          ),
          const SizedBox(width: 10),
          Text(
            overrideText ?? tr('#error.nothing_found'),
            style: style ?? defaults.textStyle(null).get('standarderrorfont'),
          ),
        ],
      ),
    );
  }
}

class SignInNeeded extends StatelessWidget {
  final IconData? icon;
  final String? overrideText;
  final Function()? onSignOnNeeded;
  const SignInNeeded({super.key, this.icon, this.overrideText, this.onSignOnNeeded});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async => onSignOnNeeded == null ? null : onSignOnNeeded!(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.person, //Icons.published_with_changes_sharp,
                size: 30,
                color: Colors.white),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  overrideText ?? tr('#signinPlease'),
                  style: defaults.textStyle(null).get('titlefont'),
                ),
                Text(
                  overrideText ?? tr('#gotoSignin'),
                  style: defaults.textStyle(null).get('standardfont').copyWith(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FailedInfoBox extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;
  final String? overrideText;
  const FailedInfoBox({super.key, this.error, this.stackTrace, this.overrideText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_off_outlined, //Icons.published_with_changes_sharp,
                size: 30,
                color: Theme.of(context).dividerTheme.color,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  overrideText ?? tr('#error_found'),
                  maxLines: 4,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          if (error != null)
            Text(
              error!.toString(),
              maxLines: 4,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}

class NeedSelect extends StatelessWidget {
  final String? overrideText;
  NeedSelect({super.key, this.overrideText});

  final textStyle = defaults.textStyle(null).get('standarderrorfont');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.select_all,
            size: 200,
            color: textStyle.color,
          ),
          Text(
            overrideText ?? tr('errorNeedSelect'),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

Future<String?> confirmInput(
  BuildContext context, {
  required String title,
  required String content,
  String? defaultValue,
  Widget? textOK,
  Widget? textCancel,
  int maxLines = 1,
  TextInputType inputType = TextInputType.text,
  required Function(String? value) onValidate,
  List<TextInputFormatter>? inputFormatters,
}) async {
  Completer<String?> completer = Completer<String?>();

  final controller = TextEditingController();
  final titleStyle = defaults.textStyle(null).get('popup_titlefont');
  final textStyle = defaults.textStyle(null).get('popup_inputfont');
  final buttonStyle = defaults.textStyle(null).get('popup_buttonfont');
  var width = MediaQuery.of(context).size.width;

  await showDialog<bool>(
    context: context,
    builder: (BuildContext innerContext) => PopScope(
      child: AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        //contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        title: Text(title.translate(context), style: titleStyle),
        content: SizedBox(
          width: width - 40,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(content, style: textStyle),
            TextFormField(
              inputFormatters: inputFormatters,
              validator: (value) => onValidate(value),
              keyboardType: inputType,
              obscureText: false,
              enableSuggestions: false,
              autocorrect: false,
              maxLines: maxLines,
              style: defaults.textStyle(null).get('inputfont'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                contentPadding: const EdgeInsets.only(top: 18, bottom: 8, left: 12, right: 12),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                //hintText: tr(translationPreString + e.name.capitalize()),
              ),
              controller: controller..text = defaultValue ?? '',
              //onTap: () => ref.read(keyboardVisibleProvider.notifier).state = true,
              onChanged: (value) => onValidate(value),
            )
          ]),
        ),
        actions: <Widget>[
          TextButton(
            child: textCancel ?? Text(tr('#input.popup.button.cancel'), style: buttonStyle),
            onPressed: () {
              Navigator.pop(innerContext);
              completer.complete(null);
            },
          ),
          TextButton(
            child: textOK ?? Text(tr('#input.popup.button.ok'), style: buttonStyle),
            onPressed: () {
              completer.complete(controller.text);
              Navigator.pop(innerContext);
            },
          ),
        ],
      ),
      /*
      onPopInvoked: (didPop) async {
        Navigator.pop(context);
        completer.complete(null);
      },
      */
    ),
  );

  return completer.future;
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  required Widget content,
  Widget? textOK,
  Widget? textCancel,
  bool progressivButton = false,
}) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (innerContext) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: <Widget>[
          if (textCancel != null || !progressivButton)
            TextButton(
              child: textCancel ?? Text(tr('cancel')), // Assuming tr() is not available
              onPressed: () {
                Navigator.pop(innerContext, false);
              },
            ),
          if (textOK != null || !progressivButton)
            TextButton(
              child: textOK ?? Text(tr('yes')), // Assuming tr() is not available
              onPressed: () {
                Navigator.pop(innerContext, true);
              },
            ),
        ],
      );
    },
  );

  return isConfirm ?? false;
}

class ConfirmInputResponse {
  final String action;
  final String result;
  ConfirmInputResponse({required this.action, required this.result});
}
