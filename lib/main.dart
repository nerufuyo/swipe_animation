import 'package:flutter/material.dart';
import 'package:swipe_animation/presentation/screen/home_screen.dart';
import 'package:swipe_animation/presentation/screen/ticket_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swipe Animation',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case TicketScreen.routeName:
            final String id = settings.arguments as String;
            return MaterialPageRoute(
                builder: (context) => TicketScreen(id: id));

          default:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
        }
      },
    );
  }
}
