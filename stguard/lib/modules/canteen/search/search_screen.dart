import 'package:flutter/material.dart';

import 'package:st_tracker/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
   SearchScreen({super.key});
    TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Column(
      children: [
        Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DefaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Search must not be empty';
                      }
                      return null;
                    },
                    label: 'Search',
                    prefix: Icons.search,
                  ),
                ),
                
      ],
    ),);
  }
}