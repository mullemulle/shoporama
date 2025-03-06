import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue, FirebaseException, FirebaseFirestore, SetOptions;
import 'package:customer_app/FORM/form.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortid/shortid.dart';

part 'setup.g.dart';

enum SetupType { restparti, shop }

@JsonSerializable()
class Setup {
  final String id;
  final SetupType setupType;
  final Map<String, dynamic> setup;
  String? appKey;
  int? supplierId;
  final List<String> members;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? access;

  Setup({
    required this.id,
    required this.setupType,
    required this.setup,
    this.appKey,
    this.supplierId,
    required this.members, //
  });

  factory Setup.fromJson(Map<String, dynamic> json) => _$SetupFromJson(json);

  Map<String, dynamic> toJson() => _$SetupToJson(this);

  factory Setup.initFromForm(String uid, Map<String, dynamic> json, {bool isRestparti = false, String? getDeviceId}) => Setup(
    id: uid,
    setupType: isRestparti ? SetupType.restparti : SetupType.shop,
    setup: json,
    //    devices: getDeviceId == null ? [] : [getDeviceId],
    members: [uid], //
  );

  int get warningCount => access == null ? 0 : access!.keys.where((key) => key.startsWith('device')).length;
}

// **************************************************************************
// SERVICE
// **************************************************************************

class SetupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath;
  SetupService({this.collectionPath = 'users'}) {
    log('SetupService - initialize');
  }

  Future<void> initSetup({required String id, required Setup setup}) async {
    log('SetupService.initSetup');
    try {
      final json = setup.toJson();

      await _firestore.collection(collectionPath).doc(id).set(json, SetOptions(merge: false));
    } on FirebaseException catch (e) {
      log('initSetup - Firestore error: ${e.message}');
      rethrow;
    } catch (e) {
      log('initSetup - Unexpected error: $e');
      rethrow;
    }
  }

  Future<Setup?> fetchById(String? uid) async {
    log('SetupService.fetchById: $uid');

    String? deviceId = await SetupService.getOrCreateUniqueId();

    if (uid == null) return null;
    try {
      final doc = await _firestore.collection(collectionPath).doc(uid).get();
      if (doc.exists) {
        final setup = Setup.fromJson(doc.data()!);

        if (setup.appKey != null) {
          setup.access = await updateDeviceId(appKey: setup.appKey!, deviceId: deviceId, userId: uid);
        }

        return setup;
      } else {
        throw Exception('Document with ID $uid does not exist.');
      }
    } on FirebaseException catch (e) {
      log('Firestore error: ${e.message}');
      rethrow; // Pass the error up the chain if needed
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateDeviceId({required String appKey, required String deviceId, required String userId}) async {
    log('SetupService.updateDeviceId');
    try {
      final doc = await _firestore.collection('devices').doc(appKey).get();

      final did = 'device_$deviceId';
      final uid = 'user_$userId';

      final result = doc.exists ? doc.data()! : {did: 0, uid: deviceId};
      final int count = doc.exists && doc.data()!.containsKey(did) ? doc.data()![did] as int : 0;

      final json = {did: count + 1, uid: deviceId};

      await _firestore.collection('devices').doc(appKey).set(json, SetOptions(merge: true));

      result.addAll(json);

      return result;
    } catch (_) {}

    return {};
  }

  static Future<String> getOrCreateUniqueId() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'device_unique_id';

    String? deviceId = prefs.getString(key);
    if (deviceId == null) {
      deviceId = shortid.generate();
      await prefs.setString(key, deviceId);
    }
    return deviceId;
  }
}

// **************************************************************************
// RIVERPOD
// **************************************************************************

@Riverpod(keepAlive: true)
SetupService setupService(SetupServiceRef ref) => SetupService();

@Riverpod(keepAlive: true)
Future<Setup?> fetchSetupById(FetchSetupByIdRef ref, {required String? uid}) {
  return ref.watch(setupServiceProvider).fetchById(uid);
}
