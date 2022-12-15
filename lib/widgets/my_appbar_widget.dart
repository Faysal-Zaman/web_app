import 'package:flutter/material.dart';

class MyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBarWidget({super.key});

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
      title: _selectedIndex == 0
          ? const Text(
              "Attendence System",
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            )
          : const Text(
              "Task Management System",
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
      centerTitle: true,
      elevation: 0,
      leading: SizedBox(
        width: 100,
        height: 100,
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 13, 71, 161),
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
