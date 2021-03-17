import 'package:flutter/material.dart';
import '../widgets/dividerWidget.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String text, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
      ),
      title: Text(
        text,
        style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 17),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
            height: 165,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                leading: Container(
                  height: 65,
                  width: 65,
                  child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Image.asset(
                        'assets/images/user_icon.png',
                      )),
                ),
                title: Text(
                  'Profile Name',
                  style: TextStyle(fontSize: 16, fontFamily: 'Brand-Bold'),
                ),
                subtitle: Text('Visit Profile'),
              ),
            )),
        DividerWidget(),
        SizedBox(
          height: 20,
        ),
        buildListTile('History', Icons.history, () {}),
        buildListTile('Visit Profile', Icons.person, () {}),
        buildListTile('About', Icons.info, () {}),
      ],
    ));
  }
}
