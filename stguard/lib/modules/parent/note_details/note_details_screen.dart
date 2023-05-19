import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/models/class_note.dart';
import 'package:stguard/shared/components/components.dart';

class NoteDetailScreen extends StatelessWidget {
  NoteModel note;

  NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Note Detail'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                   Text(
                    note.subject,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    getDate(note.datetime, format: 'yyyy-MM-dd hh:mm a'),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 30.0),
                  
                  
                  
                  Text(
                    note.content ?? 'No content available',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: note.files != null
                        ? note.files!.entries
                            .map(
                              (entry) => FutureBuilder<bool>(
                                future: ParentCubit.get(context)
                                    .checkFileExists(entry.key),
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                
                                    return DownloadItem(
                                      fileName: entry.key,
                                      fileUrl: entry.value,
                                      fileExists: snapshot.data ?? false,
                                    );
                                  
                                },
                              ),
                            )
                            .toList()
                        : [
                            const Text(
                              'No files available',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
