import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> _contacts = new List<Contact>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContactsPermission();
    refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _contacts != null
          ? Container(
              child: ListView.builder(
                itemCount: _contacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact c = _contacts[index];
                  var list = c.phones.toList();
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: (c.avatar != null)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(c.avatar))
                            : CircleAvatar(
                                child: Text(c.displayName[0],
                                    style: TextStyle(color: Colors.black)),
                              ),
                        title: Text(c.displayName ?? ""),
                        subtitle: list.length >= 1 && list[0]?.value != null
                            ? Text(list[0].value)
                            : Text(''),
                        trailing: Checkbox(value: false, onChanged: (bool) {}),
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.graphic_eq),
        label: Text('Fire in the hole!'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  refreshContacts() async {
    var contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.where((item) => item.displayName != null).toList();
      _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    });
  }

  void getContactsPermission() {
    SimplePermissions.requestPermission(Permission.ReadContacts);
  }
}
