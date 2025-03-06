import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'INFO/infobox.dart';

class SnapshotWall extends StatelessWidget {
  final dynamic snapshot;
  final Builder child;
  final Widget? Function()? onEmpty;
  final bool acceptEmpty;
  const SnapshotWall({super.key, required this.child, required this.snapshot, this.onEmpty, this.acceptEmpty = false});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
      return const Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
        child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0)),
      );
    }

    try {} catch (_) {}

    bool exists = false;
    if (snapshot is AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>) {
      exists = snapshot.data != null && snapshot.hasData && snapshot.data.exists;
    } else if (snapshot is AsyncSnapshot<Object?>) {
      exists = snapshot.data != null && snapshot.hasData;
    }

    if (!exists && acceptEmpty == false) {
      return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
        child: onEmpty == null ? const NothingFound() : onEmpty!() ?? const NothingFound(),
      );
    }

    return child;
  }
}
