import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[400],
                  child: Icon(
                    color: Colors.white,
                    Icons.notifications,
                    size: 20,
                  ),
                ),
                title: Text('Parent access request'),
                subtitle: Text("X added a request to add you as a child"),
                onTap: () {},
              ),
            );
          },
          itemCount: 5),
    );
  }
}
