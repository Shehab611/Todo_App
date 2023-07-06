import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';


class ArchivedTasks extends StatelessWidget {
 const ArchivedTasks({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TodoCubit cubit = BlocProvider.of(context);
        var tasks = cubit.archivedtasks;
        switch(tasks.length){
            case 0:
              return const Center(child: Text('There is no any archived tasks'));
            case >0:
              return ListView.separated(
                  itemBuilder: (context, index) => Dismissible(key: const Key('1'),
                    background: Container(
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            Text('Move to trash',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Confirmation"),
                            content: const Text(
                                "Are you sure you want to delete this item?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    cubit.deletedata(tasks[index]['id']);
                                  },
                                  child: const Text("Delete")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Text("${tasks[index]['time']}"),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${tasks[index]['title']}'),
                                Text('${tasks[index]['date']}'),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                cubit.updatedata(
                                    'done',tasks[index]['id'] );
                              },
                              icon:const  Icon(Icons.done,color:Colors.green ,)),
                          IconButton(onPressed: () {cubit.updatedata(
                              'archived',tasks[index]['id']);}, icon:const Icon(Icons.archive,color: Colors.black45,))
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      color: Colors.grey[300],
                      height: 1.5,
                      width: double.infinity,
                    ),
                  ),
                  itemCount: tasks.length);
          }
       throw 'Not implemented exception';
      },
    );
  }
}
