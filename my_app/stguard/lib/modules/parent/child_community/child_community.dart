import 'package:flutter/material.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/modules/parent/class_updates/class_updates.dart';
import 'package:stguard/modules/parent/member_settings/member_settings.dart';
import 'package:stguard/shared/components/components.dart';

class MemberCommunityScreen extends StatelessWidget {
  StudentModel student;
  MemberCommunityScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
                "${student.name!.split(' ')[0]}'s Community",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            DefaultButton3(
                width: double.infinity,
                height: 120,
                image: 'assets/images/settings.png',
                text:'Settings',
                imageWidth: 60,
                imageHeight: 60,
                sizedboxWidth: 20,
                textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                onPressed:() => navigateTo(context, MemberSettingsScreen(student: student)),)
          ,SizedBox(height: 20,),
          DefaultButton3(
                width: double.infinity,
                height: 120,
                image: 'assets/images/class_updates.png',
                text:'Class Updates',
                imageWidth: 60,
                imageHeight: 60,
                sizedboxWidth: 20,
                textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                onPressed:() => navigateTo(context, ClassUpdatesScreen(student: student,)),)
          ],
        ),
      ),
    );
  }
}
