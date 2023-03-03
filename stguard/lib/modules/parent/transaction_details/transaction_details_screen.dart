import 'package:flutter/material.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
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
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: const Text('Total Price',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text('${trans.activity}',
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
                            Container(
                              width: 100,
                              child: const Text('Date',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
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
                    ),const SizedBox(height: 5,),
                    const Divider(
                              color: Colors.black,
                            ),
                            const SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              child: const Text('Name', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),)),
                              const SizedBox(width: 10,),
                            Container(
                              width: 80,
                              child: const Text('Unit Price', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),)),
                              const SizedBox(width: 10,),
                            const Text('Count', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        
                        SizedBox(
                          height: 500,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                              itemBuilder: (context, index) => ProductItem(
                                  product: ParentCubit.get(context)
                                      .products[index]),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 5),
                              itemCount:
                                  ParentCubit.get(context).products.length),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
   
  }
}
