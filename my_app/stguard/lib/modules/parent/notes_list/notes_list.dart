import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/modules/parent/note_details/note_details_screen.dart';
import 'package:stguard/shared/components/components.dart';

class NotesListsScreen extends StatelessWidget {
  const NotesListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => NoteItem(
                        note: ParentCubit.get(context).notes[index],
                        onTap: () => navigateTo(
                            context,
                            NoteDetailScreen(
                                note: ParentCubit.get(context).notes[index])),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: ParentCubit.get(context).notes.length),
            ),
          ),
        );
      },
    );
  }
}
