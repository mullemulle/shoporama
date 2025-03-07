import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/START/start_screen.dart' show startPageProvider;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;
import 'package:getwidget/getwidget.dart';

import '../START/design.dart';
import '../STD_WIDGET/package.dart';
import '../_SERVICE/setup.dart' show Setup, SetupService, fetchSetupByIdProvider, getDeviceIdsProvider;

class WarningUsers extends ConsumerWidget {
  final Setup setup;
  const WarningUsers({super.key, required this.setup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesState = ref.watch(getDeviceIdsProvider(appKey: setup.appKey!));

    return devicesState.when(
      data: (devices) {
        final thisDevice = devices['other_this_device'];
        final list = devices.keys.where((key) => key.startsWith('device')).toList();
        list.sort((b, a) => (devices[a]['updatedLocal'] as Timestamp).compareTo((devices[b]['updatedLocal'] as Timestamp)));

        return SingleChildScrollView(
          child: Column(
            children: [
              ...list.map((key) {
                return GFListTile(
                  titleText: key == thisDevice ? 'Denne enhed' : key,
                  color: Colors.white,
                  onTap: () async {
                    await onBlock(context, appKey: setup.appKey!, deviceId: key);
                    ref.invalidate(getDeviceIdsProvider);
                    ref.invalidate(startPageProvider);
                    ref.invalidate(fetchSetupByIdProvider);
                  },
                  subTitleText: DateFormat('yyyy-MM-dd – kk:mm').format(((devices[key]['updatedLocal']) as Timestamp).toDate()),
                  avatar: GFAvatar(backgroundColor: key == thisDevice ? Colors.green : primaryColor, child: Icon(key == thisDevice ? Icons.verified_user_outlined : Icons.unpublished_rounded, size: 33, color: Colors.white)),
                );
              }),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(body: NothingFound()),
      loading: () => Scaffold(body: const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0)))),
    );
  }

  Future onBlock(BuildContext context, {required String appKey, required String deviceId}) async {
    final result = await confirm(context, title: 'Block device', content: SizedBox(height: 65, child: Center(child: Icon(Icons.block_rounded, size: 55, color: Colors.red))));
    if (result) {
      SetupService().blockDeviceId(appKey: appKey, deviceId: deviceId);
    }
  }
}
