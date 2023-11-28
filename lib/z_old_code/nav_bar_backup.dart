import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.red[600], // Set the background color
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: ListTile(
                title: Text(
                  "Airtastic",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
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
            title: const Text('Ozone'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Ozone');
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