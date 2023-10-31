import 'package:flutter/material.dart';

class nav_bar extends StatelessWidget {
  const nav_bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const ListTile(
              title: Text(
                "Airtastic",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
      ),
    );
  }
}
//https://www.youtube.com/watch?v=SLR8U55FpFQ