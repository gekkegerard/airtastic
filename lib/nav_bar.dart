import 'package:flutter/material.dart';
import 'package:airtastic/pages/home.dart';

class nav_bar extends StatelessWidget {
  const nav_bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Airtastic'),
            accountEmail: Text('Airtastic@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/ozon.jpeg'),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1562614799-bd2424a406e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.replay_outlined),
            title: const Text('Connected devices'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/connected_devices');
            },
          ),
          ListTile(
            leading: const Icon(Icons.thermostat),
            title: const Text('Temperature'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Temperature');
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Humidity'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Humidity');
            },
          ),
          ListTile(
            leading: const Icon(Icons.dangerous),
            title: const Text('Ozon'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Ozon');
            },
          ),
          ListTile(
            leading: const Icon(Icons.co2),
            title: const Text('Carbon dioxide'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/CO2');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/About');
            },
          ),
        ],
      ),
    );
  }
}
//https://www.youtube.com/watch?v=SLR8U55FpFQ