import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/shared/components/components.dart';

class TransactionDetailsScreen extends StatelessWidget {
  ActivityModel trans;
  TransactionDetailsScreen({required this.trans, super.key});

  @override
  Widget build(BuildContext context) {
    ParentCubit.get(context).getDataFromTransactionsTable(trans.trans_id);
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Details',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 600,
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, left: 10, top: 20.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Invoice ID:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                trans.trans_id,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('Date:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(getDate(trans.date),
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 400,
                            child: ListView.separated(
                                itemBuilder: (context, index) => ProductItem(
                                    product: ParentCubit.get(context)
                                        .products[index]),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 5),
                                itemCount:
                                    ParentCubit.get(context).products.length),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Row(
                            children: [
                              Text('TOTAL:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                width: 5,
                              ),
                              Text('${trans.activity}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
