import 'package:customer_app/FORM/form.dart';
import 'package:customer_app/START/design.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shortid/shortid.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../_SERVICE/setup.dart' show Setup, SetupService, fetchSetupByIdProvider;

final restpartiStartScreenProvider = StateProvider<int>((ref) => 0);

var schema = [
  FormSchema(
    fields: {
      'name': Field(type: FieldType.string, title: tr('#setup.edit.name'), helptext: tr('#setup.edit.name_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'mail': Field(type: FieldType.mail, title: tr('#setup.edit.mail'), helptext: tr('#setup.edit.mail_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'appkey': Field(type: FieldType.string, title: tr('#setup.edit.appkey'), helptext: tr('#setup.edit.appkey_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'submit': Field(type: FieldType.button, title: tr('submit'), value: null, validate: []),
    },
  ),
  FormSchema(
    fields: {
      'name': Field(type: FieldType.string, title: tr('#setup.edit.name'), helptext: tr('#setup.edit.name_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'offname': Field(type: FieldType.string, title: tr('#setup.edit.offname'), helptext: tr('#setup.edit.offname_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'mail': Field(type: FieldType.mail, title: tr('#setup.edit.mail'), helptext: tr('#setup.edit.mail_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'submit': Field(type: FieldType.button, title: tr('submit'), value: null, validate: []),
    },
  ),
  FormSchema(fields: {'submit': Field(type: FieldType.button, title: tr('shoporama.dk'), value: null, validate: [])}),
];

class RestpartiStartScreen extends ConsumerWidget {
  RestpartiStartScreen({super.key});

  final provider = StateProvider((ref) => -1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(restpartiStartScreenProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Setup", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), centerTitle: true, actions: null),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SelectShop(onTap: (value) => ref.read(provider.notifier).state = value),
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(provider);
                    return switch (state) {
                      -1 => Container(),

                      _ => Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all(color: itemBackgroundColor), borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                        child: DynamicForm(
                          formSchema: schema[state],
                          defaultValues: {},
                          onChanged: (p0) {},
                          onLookup: (fieldKey) async => {},
                          onFieldChanged: (key, value) => {},
                          onButtonTap: (values, defaultValues) async {
                            try {
                              switch (state) {
                                case 0:
                                  await onShoporamaSubmit(values, defaultValues);
                                  ref.invalidate(fetchSetupByIdProvider);
                                  break;
                                case 1:
                                  await onRestpartiSubmit(values, defaultValues);
                                  ref.invalidate(fetchSetupByIdProvider);
                                  break;
                                case 2:
                                  launchUrlString('https://shoporama.dk', mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
                                  break;
                                default:
                                  break;
                              }
                              if (state == 2) {
                                launchUrlString('https://shoporama.dk', mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
                              }
                            } catch (e) {
                              if (state == 2) {
                                launchUrlString('https://shoporama.dk', mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
                              } else if (context.mounted)
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'))));
                            }
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        ),
                      ),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onShoporamaSubmit(Map<String, dynamic> values, Map<String, dynamic> defaultValues) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? deviceId = await SetupService.getOrCreateUniqueId();

    defaultValues.addAll(values);
    defaultValues['id'] = shortid.generate();

    final setup = Setup.initFromForm(uid, defaultValues, getDeviceId: deviceId);
    await SetupService().initSetup(id: uid, setup: setup);
  }

  Future<void> onRestpartiSubmit(Map<String, dynamic> values, Map<String, dynamic> defaultValues) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? deviceId = await SetupService.getOrCreateUniqueId();

    defaultValues.addAll(values);

    final setup = Setup.initFromForm(uid, defaultValues, isRestparti: true, getDeviceId: deviceId);
    await SetupService().initSetup(id: uid, setup: setup);
  }
}

class SelectShop extends ConsumerWidget {
  final Function(int value) onTap;
  SelectShop({super.key, required this.onTap});

  final provider = StateProvider((ref) => -1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    void doTap(int i) {
      ref.read(provider.notifier).state = i;
      onTap(i);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Vælg opsætning:', style: h4Style),
        GFCheckboxListTile(
          titleText: 'Shoporama',
          color: Colors.white,
          subTitleText: 'Opret en webshop',
          avatar: GFAvatar(backgroundColor: primaryColor, child: Image.asset('assets/shoporama_logo.png', width: 42)),
          size: 25,
          activeBgColor: Colors.green,
          type: GFCheckboxType.circle,
          activeIcon: Icon(Icons.check, size: 15, color: Colors.white),
          onChanged: (value) => doTap(2),
          value: state == 2,
          inactiveIcon: null,
        ),
        SizedBox(height: 20),
        GFCheckboxListTile(
          titleText: 'Shoporama',
          color: Colors.white,
          subTitleText: 'Tilknyt Shoporama shop',
          avatar: GFAvatar(backgroundColor: primaryColor, child: Image.asset('assets/shoporama_logo.png', width: 42)),
          size: 25,
          activeBgColor: Colors.green,
          type: GFCheckboxType.circle,
          activeIcon: Icon(Icons.check, size: 15, color: Colors.white),
          onChanged: (value) => doTap(0),
          value: state == 0,
          inactiveIcon: null,
        ),
        GFCheckboxListTile(
          titleText: 'Restparti.dk',
          color: Colors.white,
          subTitleText: 'Bliv leverandør til Restparti.dk',
          avatar: GFAvatar(backgroundColor: primaryColor, child: Icon(Icons.shopping_basket_outlined, size: 33, color: Colors.white)),
          size: 25,
          activeBgColor: Colors.green,
          type: GFCheckboxType.circle,
          activeIcon: Icon(Icons.check, size: 15, color: Colors.white),
          onChanged: (value) => doTap(1),
          value: state == 1,
          inactiveIcon: null,
        ),
      ],
    );
  }
}
