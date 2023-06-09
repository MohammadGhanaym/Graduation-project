import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
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
            title:  Text('Notes', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),
            
            centerTitle: true,
          ),
          body: ConditionalBuilder(
            condition: ParentCubit.get(context).notes.isNotEmpty,
            builder: (context) => SingleChildScrollView(
              
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: 
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => 
                      DefaultClassListCard(onTap: () => navigateTo(
                                context,
                                NoteDetailScreen(
                                    note: ParentCubit.get(context).notes[index])),
                       title: ParentCubit.get(context).notes[index].title,
                       subtitle: ParentCubit.get(context).notes[index].subject, 
                       date: ParentCubit.get(context).notes[index].datetime),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: ParentCubit.get(context).notes.length),
              
              ),
            ),fallback: (context) => Center(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Image(image: AssetImage('assets/images/no_activity.png',
                  ), height: 200,),
                    const SizedBox(height: 20,),
                    Text('No Notes Available', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),),
          ),
        );
      },
    );
  }
}
