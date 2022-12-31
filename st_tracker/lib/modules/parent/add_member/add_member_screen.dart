import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';

class AddMember extends StatelessWidget {
  AddMember({super.key});
  var idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    navigateTo(context, ParentHomeScreen());
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Find your family member',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          DefaultFormField(
                              controller: idController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) return 'Enter student ID';
                                return null;
                              },
                              label: 'Student ID'),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                              onPressed: () {
                                ParentCubit.get(context)
                                    .addFamilyMember(idController.text);
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/add_member.png'),
                                    fit: BoxFit.contain)),
                          )
                        ])),
              ),
            ),
          ),
        );
      },
    );
  }
}
