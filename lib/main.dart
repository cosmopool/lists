import "package:flutter/material.dart";
import "package:lists/pages/home_page.dart";

void main() {
  runApp(const MainAppWidget());
}

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueGrey);

    return MaterialApp(
      title: "Lists",
      theme: ThemeData(colorScheme: colorScheme),
      home: const HomePage(title: "Home"),
    );
  }
}
