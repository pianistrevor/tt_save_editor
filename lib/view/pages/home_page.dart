import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FilledButton(onPressed: () {}, child: const Text('Press me')),
        ]),
      );
}
