import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  Note({super.key, required this.note});
  String note;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                 note.isEmpty? 'No notes available.': note,
                style:
                    const TextStyle(fontSize: 15),
              ),
              
            ],
          ),
        ));
  }
}
