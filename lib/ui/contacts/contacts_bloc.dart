import 'package:flutter_app/entity/contact.dart';
import 'package:flutter_app/model/contacts_model.dart';
import 'package:rxdart/rxdart.dart';

class ContactsBloc {
  final _contactsModel = ContactsModel();

  final _contactsFetcher = PublishSubject<List<Contact>>();

  Observable<List<Contact>> get allContacts => _contactsFetcher.stream;

  Future fetchAllContacts() async {
    PermissionState permissionState = await _contactsModel.canContactsRead();

    if (permissionState == PermissionState.GRANTED) {
      List<Contact> contacts = await _contactsModel.getContacts();
      _contactsFetcher.sink.add(contacts);
    } else {
      _contactsFetcher.sink.addError("Permission $permissionState!");
    }
  }

  dispose() {
    _contactsFetcher.close();
  }
}
