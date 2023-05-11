import 'package:flutter/material.dart';
import 'package:stguard/shared/components/components.dart';

import 'note.dart';

class SubjectCard extends StatelessWidget {
  final String subjectname;
  final String note;

  final String grade;
  final String mark;

  const SubjectCard(
      {super.key,
      required this.subjectname,
      required this.note,
      required this.grade,
      required this.mark});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        navigateTo(
            context,
            Note(
              note: note,
            ));
      },
      child: Container(
        height: height * 0.145,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 169, 166, 179),
                offset: Offset(2, 8),
                blurRadius: 10,
              ),
              BoxShadow(color: Color.fromARGB(255, 255, 255, 255))
            ]),

        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 13,
          ),
          child: Row(children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent,
              ),
              height: height * 0.15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Row(
                    children: [
                      Text(
                        subjectname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        '$mark/100',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 50,),
                      Text(
                        '$grade',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(top:10, right: 10, left: 10),
                  child: Text(
                        note.isEmpty? 'No notes available.': note,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      )
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
