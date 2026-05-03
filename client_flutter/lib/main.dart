import 'package:flutter/material.dart';

import 'ui/widgets/left_panel.dart';
import 'ui/widgets/right_panel.dart';

void main() {
  runApp(const DbTematicaApp());
}

class DbTematicaApp extends StatelessWidget {
  const DbTematicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DbTemática',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MainSplitView(),
    );
  }
}

class MainSplitView extends StatelessWidget {
  const MainSplitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DbTemática')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: const LeftPanel(),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: const RightPanel(),
            ),
          ],
        ),
      ),
    );
  }
}
