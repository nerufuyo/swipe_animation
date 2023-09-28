import 'package:flutter/material.dart';
import 'package:swipe_animation/presentation/screen/home_screen.dart';
import 'package:swipe_animation/presentation/screen/ticket_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TicketScreen(id: id),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;
                final tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
        }
      },
    );
  }
}
