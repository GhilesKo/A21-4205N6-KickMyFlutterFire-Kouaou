import 'package:flutter/material.dart';
import 'package:ghiles_flutter_fire_tp/screens/creation.dart';
import 'package:ghiles_flutter_fire_tp/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ghiles_flutter_fire_tp/services/authentication.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(AuthService.user!.email!),
              accountEmail: Text(AuthService.user!.displayName!),
              currentAccountPicture: Image.network(AuthService.user!.photoURL ??
                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png")),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
            // ListTile(
          //   leading: Icon(Icons.add),
          //   title: Text('Creation'),
          //   onTap: () {
          //     Navigator.of(context).pushAndRemoveUntil(
          //         MaterialPageRoute(
          //             builder: (context) => const CreationScreen()),
          //         (Route<dynamic> route) => false);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text('signout'),
            onTap: () => {FirebaseAuth.instance.signOut()},
          ),
        ],
      ),
    );
  }
}
