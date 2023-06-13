import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: BlocBuilder<ParentCubit, ParentStates>(
        builder: (context, state) {
          return ConditionalBuilder(
            condition: ParentCubit.get(context).notifications != null,
            builder: (context) =>state is GetNotificationsLoadingState || ParentCubit.get(context).deleteLoading?
            const Center(child: CircularProgressIndicator()):
             ConditionalBuilder(
              condition: ParentCubit.get(context).notifications!.isNotEmpty,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final notification =
                                ParentCubit.get(context).notifications![index];
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) => ParentCubit.get(context).deleteNotification(notification.id),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    isThreeLine: true,
                                    leading: const ImageIcon(AssetImage('assets/images/notification-bell.png'), 
                                    size: 30,
                                    color: defaultColor,),
                                    title: Text(notification.title,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                                    subtitle: Text(notification.body,style:Theme.of(context).textTheme.bodySmall ),),
                                    const SizedBox(height: 5,),
                                   Row(
                                     children: [const Spacer(),
                                       Text(getDate(notification.date), 
                                       style:Theme.of(context).textTheme.bodyMedium, overflow:TextOverflow.ellipsis),
                                     ],
                                   ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>  Divider(color: defaultColor.withOpacity(0.8),),
                          itemCount:
                              ParentCubit.get(context).notifications!.length),
                    Divider(color: defaultColor.withOpacity(0.8),)
                    ],
                  ),
                ),
              ),
              fallback: (context) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/images/no_activity.png',
                        ),
                        height: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Notifications Available',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage(
                        'assets/images/no_activity.png',
                      ),
                      height: 200,
                      color: defaultColor.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No Notifications Available',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
