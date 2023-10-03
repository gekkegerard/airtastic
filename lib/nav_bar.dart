import 'package:flutter/material.dart';

class nav_bar extends StatelessWidget {
  const nav_bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          UserAccountsDrawerHeader(
            accountName: Text('Airtastic'),
            accountEmail: Text('Airtastic@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/ozon.jpeg'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
//https://www.youtube.com/watch?v=SLR8U55FpFQ