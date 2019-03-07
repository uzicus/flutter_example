import 'package:flutter/services.dart';
import 'package:flutter_app/entity/contact.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsModel {

  static const _methodChannel = const MethodChannel("contacts");

  Future<PermissionState> canContactsRead() async {
    var permissionStatus = await PermissionHandler().requestPermissions(
        [ PermissionGroup.contacts ]
    );

    switch (permissionStatus[PermissionGroup.contacts]) {
      case PermissionStatus.granted:
        return PermissionState.GRANTED;
      case PermissionStatus.denied:
        return PermissionState.DENIED;
      case PermissionStatus.disabled:
        return PermissionState.DENIED_NEVER_ASK;
      default:
        return PermissionState.DENIED;
    }
  }

  Future<List<Contact>> getContacts() async {
    try {
      final List result = await _methodChannel.invokeMethod("getContacts");

      return result.map((item) =>
          Contact(
              item["NAME"],
              item["MOBILE"]
          )
      ).toList();
    } on PlatformException catch (e) {
      print('Exception ' + e.toString());
    }

    return List();
  }

}

enum PermissionState {
  GRANTED,
  DENIED,
  DENIED_NEVER_ASK
}