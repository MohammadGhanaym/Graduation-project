import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: BlocBuilder<ParentCubit, ParentStates>(
            builder: (context, state) {
              return Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text('Total Price',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(trans.activity,
                            style: const TextStyle(
                              fontSize: 18,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text('Date',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                            getDate(trans.date,
                                format: 'dd/MM/yyyy, hh:mm a'),
                            style: const TextStyle(fontSize: 15))
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 2,
                            child: Text(
                              'Unit Price',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Count',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ProductItem(
                            product:
                                ParentCubit.get(context).products[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemCount:
                            ParentCubit.get(context).products.length),
                   
                  ],
                )
              ],
            );
            },
           ),
        ),
      ),
    );
  }
}
