import 'package:flutter/material.dart';

class note extends StatefulWidget {
  const note({super.key});

  @override
  State<note> createState() => _noteState();
}

TextEditingController textController = TextEditingController();

class _noteState extends State<note> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        centerTitle: true,
      ),
      body: Container(
        child: TextField(
          controller: textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(hintText: 'Start typing the note'),
        ),
      ),
    );
  }
}
