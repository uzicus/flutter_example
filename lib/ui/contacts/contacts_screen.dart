import 'package:flutter/material.dart';
import 'package:flutter_app/entity/contact.dart';
import 'package:flutter_app/localization.dart';
import 'package:flutter_app/ui/contacts/contacts_bloc.dart';
import 'package:flutter_app/ui/widgets/container_scroll_view.dart';

class ContactsScreen extends StatefulWidget {

  final ContactsBloc _contactsBloc = ContactsBloc();

  @override
  State<StatefulWidget> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactsScreen> {

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    // init load
    widget._contactsBloc.fetchAllContacts();

    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).contactsTitle),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: widget._contactsBloc.fetchAllContacts,
        child: StreamBuilder(
            stream: widget._contactsBloc.allContacts,
            builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isNotEmpty) {
                  return _buildContactList(snapshot.data);
                } else {
                  return ContainerScrollView(
                    child: Center(
                      child: Text(Localization.of(context).contactsEmptyTitle),
                    )
                  );
                }
              } else if (snapshot.hasError) {
                return ContainerScrollView(
                    child: Center(
                      child: Text(snapshot.error),
                    )
                );
              }

              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget _buildContactList(List<Contact> contacts) {
    return ListView.builder(
        padding: kMaterialListPadding,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          var item = contacts[index];
          return ListTile(
            title: Text(item.displayName),
            subtitle: Text(item.mobileNumber),
          );
        });
  }

  @override
  void dispose() {
    widget._contactsBloc.dispose();
    super.dispose();
  }
}
