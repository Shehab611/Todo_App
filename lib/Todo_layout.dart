// ignore_for_file: file_names, body_might_complete_normally_nullable

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class TodoLayout extends StatelessWidget {
   TodoLayout({Key? key}) : super(key: key);
 final TextEditingController titleController = TextEditingController();
 final TextEditingController timeController = TextEditingController();
 final  TextEditingController dateController = TextEditingController();
 final  scaffoldKey = GlobalKey<ScaffoldState>();
 final  frmKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {
        if (state is InsertState) Navigator.pop(context);
      },
      builder: (context, state) {
        TodoCubit cubit = BlocProvider.of(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style:const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (v) {cubit.changeindex(v);},
            items:const [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Task'),
              BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archived')
            ],
          ),
          body: (state is! LoadingDataState)
              ? cubit.modules[cubit.currentIndex]
              :const Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButton: FloatingActionButton(
              child: cubit.fbicon,
              onPressed: () {
                if (cubit.isbtmsheetopen) {
                  if (frmKey.currentState!.validate()) {
                    cubit.insertTodatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                        padding:const EdgeInsets.all(20),
                        child: Form(
                          key: frmKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Date must be enter';
                                  }
                                },
                                decoration: const InputDecoration(
                                  suffixIcon:
                                  Icon(Icons.text_fields_sharp),
                                  labelText: 'Task title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Date must be enter';
                                  }
                                },
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text =
                                        value!.format(context);
                                  });
                                },
                                decoration: const InputDecoration(
                                  suffixIcon:
                                  Icon(Icons.watch_later_outlined),
                                  labelText: 'Task Time',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Date must be enter';
                                  }
                                },
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse(
                                          '2025-12-30'))
                                      .then((value) {
                                    dateController.text =
                                    "${value!.day}-${value.month}-${value.year}";
                                  });
                                },
                                decoration: const InputDecoration(
                                  suffixIcon:
                                  Icon(Icons.date_range_outlined),
                                  labelText: 'Task Date',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 30)
                      .closed
                      .then((value) {
                    cubit.changesheet(const Icon(Icons.edit), false);
                    if (titleController.text.isNotEmpty) titleController.clear();
                    if (timeController.text.isNotEmpty) timeController.clear();
                    if (dateController.text.isNotEmpty) dateController.clear();
                  });
                  cubit.changesheet(const Icon(Icons.add), true);
                }
              }),
        );
      },
    );
  }
}
