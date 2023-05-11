import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/layout/teacher/teacher_home_screen.dart';
import 'package:stguard/modules/parent/grades/Exam_Rseult.dart';
import 'package:stguard/shared/components/components.dart';

import '../../../Queries/all_queries.dart';
import '../../../layout/teacher/cubit/cubit.dart';
import '../add_grades/add_note.dart';

List<dynamic> examsss = [];

class grades extends StatefulWidget {
  const grades({super.key});

  @override
  State<grades> createState() => _gradesState();
}

String? Tcountry;
String? Tschool;
List<dynamic> students_names = [];

String? studentName;
List<dynamic> Subjects = [];
TextEditingController number_Controller = TextEditingController();
String? subject;
String? exam;
String? repeated_name;
String? Class;

class _gradesState extends State<grades> {
  @override
  void initState() {
    TeacherCubit.get(context).getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCubit, TeacherStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Grades'),
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                navigateTo(context, const TeacherHomeScreen());
                setState(() {
                  TeacherCubit.get(context).classes.clear();
                  students_names.clear();
                  Subjects.clear();
                  examsss.clear();
                  Class = null;
                  studentName = null;
                  exam = null;
                  subject = null;
                });
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Class",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                              hintText: "Please Select",
                            )),
                            validator: (v) =>
                                v == null ? "Please Select" : null,
                            items: TeacherCubit.get(context)
                                .classes
                                .cast<String>(),
                            onChanged: (value) {
                              setState(() {
                                students_names.clear();
                                Class = value;
                                studentName = null;
                                exam = null;
                                subject = null;
                                getStudentsNames();
                              });
                            },
                            selectedItem: Class,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Student Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                              hintText: "Please Select",
                            )),
                            validator: (v) =>
                                v == null ? "Please Select" : null,
                            items: students_names.cast<String>(),
                            onChanged: (value) {
                              setState(() {
                                studentName = value;
                                Exam();
                              });
                            },
                            selectedItem: studentName,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Exam",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: DropdownSearch<String>(
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                hintText: "Please Select",
                              )),
                              validator: (v) =>
                                  v == null ? "Please Select" : null,
                              items: examsss.cast<String>(),
                              onChanged: (value) {
                                setState(() {
                                  exam = value;
                                });
                              },
                              selectedItem: exam,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: [
                        const Text(
                          "Subject",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0, bottom: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: DropdownSearch<String>(
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                hintText: "Please Select",
                              )),
                              validator: (v) =>
                                  v == null ? "Please Select" : null,
                              items: Subjects.cast<String>(),
                              onChanged: (value) {
                                setState(() {
                                  subject = value;
                                });
                              },
                              selectedItem: subject,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Exam Score',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            maxLength: 3,
                            controller: number_Controller,
                            decoration:
                                const InputDecoration(labelText: 'Enter score'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                              LimitRangeTextInputFormatter(0, 100)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Grade',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        number_Controller.text.isEmpty
                            ? const Text(
                                '-',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            : Text(grade()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Add Note',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              navigateTo(context, const note());
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Note',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      textController.text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MaterialButton(
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (number_Controller.text.isEmpty) {
                          ShowToast(
                              message: 'score is required',
                              state: ToastStates.ERROR);
                        } else if (subject == null) {
                          ShowToast(
                              message: 'subject is required',
                              state: ToastStates.ERROR);
                        } else if (exam == null) {
                          ShowToast(
                              message: 'exam is required',
                              state: ToastStates.ERROR);
                        } else {
                          var student = await FirebaseFirestore.instance
                              .collection('Countries')
                              .doc(Tcountry)
                              .collection('Schools')
                              .doc(Tschool)
                              .collection('classes')
                              .doc(Class)
                              .collection('Grades')
                              .doc('grades')
                              .collection(exam!)
                              .doc(exam!)
                              .collection(subject!)
                              .where('Student name', isEqualTo: studentName)
                              .limit(1)
                              .get();
                          student.docs.forEach((element) {
                            repeated_name = element.reference.id;
                          });

                          if (student.docs.isNotEmpty) {
                            await FirebaseFirestore.instance
                                .collection('Countries')
                                .doc(Tcountry)
                                .collection('Schools')
                                .doc(Tschool)
                                .collection('classes')
                                .doc(Class)
                                .collection('Grades')
                                .doc('grades')
                                .collection(exam!)
                                .doc(exam!)
                                .collection(subject!)
                                .doc(repeated_name)
                                .set({
                              'grade': grade(),
                              'score': number_Controller.text,
                              'note': textController.text,
                              'Student name': studentName,
                              'subject': subject
                            });
                            ShowToast(
                                message: 'grade is updated',
                                state: ToastStates.SUCCESS);
                            setState(() {
                              textController = TextEditingController();
                              number_Controller = TextEditingController();
                              Class = null;
                              student_name = null;
                              exam = null;
                              subject = null;
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection('Countries')
                                .doc(Tcountry)
                                .collection('Schools')
                                .doc(Tschool)
                                .collection('classes')
                                .doc(Class)
                                .collection('Grades')
                                .doc('grades')
                                .collection(exam!)
                                .doc(exam!)
                                .collection(subject!)
                                .add({
                              'grade': grade(),
                              'score': number_Controller.text,
                              'note': textController.text,
                              'Student name': studentName,
                              'subject': subject
                            });
                            ShowToast(
                                message: 'grades are submitted successfully',
                                state: ToastStates.SUCCESS);
                            setState(() {
                              textController = TextEditingController();
                              number_Controller = TextEditingController();
                              Class = null;
                              studentName = null;
                              exam = null;
                              subject = null;
                            });
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ))
   ;
      },
       );
  }
}

String grade() {
  String Grade = "";
  int score = int.parse(number_Controller.text);
  if (score < 50) {
    Grade = "F";
  } else if (55 > score && score > 49) {
    Grade = "D";
  } else if (60 > score && score > 54) {
    Grade = "D+";
  } else if (65 > score && score > 59) {
    Grade = "C-";
  } else if (70 > score && score > 64) {
    Grade = "C";
  } else if (75 > score && score > 69) {
    Grade = "C+";
  } else if (80 > score && score > 74) {
    Grade = "B-";
  } else if (85 > score && score > 79) {
    Grade = "B";
  } else if (90 > score && score > 84) {
    Grade = "B+";
  } else if (95 > score && score > 89) {
    Grade = "A-";
  } else if (101 > score && score > 94) {
    Grade = "A";
  }
  return Grade;
}

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max,
      {this.defaultIfEmpty = false})
      : assert(min < max);

  final int min;
  final int max;
  final bool defaultIfEmpty;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int? value = int.tryParse(newValue.text);
    String? enforceValue;
    if (value != null) {
      if (value < min) {
        enforceValue = min.toString();
      } else if (value > max) {
        enforceValue = max.toString();
      }
    } else {
      if (defaultIfEmpty) {
        enforceValue = min.toString();
      }
    }
    // filtered interval result
    if (enforceValue != null) {
      return TextEditingValue(
          text: enforceValue,
          selection: TextSelection.collapsed(offset: enforceValue.length));
    }
    // value that fit requirements
    return newValue;
  }
}
