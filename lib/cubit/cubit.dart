// ignore_for_file: await_only_futures



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/presentation/archivedtasks.dart';
import 'package:todo/presentation/donetasks.dart';
import 'package:todo/presentation/tasks.dart';


class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(AppIntialstate());
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  var modules = [const Tasks(),const DoneTasks(), const ArchivedTasks()];
  int currentIndex = 0;
  Database? database;
  var titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  bool isbtmsheetopen = false;

  Icon fbicon =const Icon(Icons.edit);
  void changeindex(int index) {
    currentIndex = index;
    emit(BottomNavstate());
  }

  void changesheet(icon, bb) {
    fbicon = icon;
    isbtmsheetopen = bb;
    emit(BottomIconState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'create table tasks(id integer primary key,title text,date text,time text,status text) ')
            .then((value) {
         // print('table created');
        }).catchError((error) {
         // print('error in creating table');
        });
       // print('database created');
      },
      onOpen: (database) {
        getdata(database);
        //print('database opened');
      },
    ).then((value) {
      database = value;
      emit(CreateState());
    });
  }

  insertTodatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    late String x;
    x = "xxxxxxx";
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'insert into tasks(title,date,time,status) values("$title","$date","$time","new") ')
          .then((value) {
       // print('$value inserted succuses');
        getdata(database);
        emit(InsertState());
      }).catchError((error) {
       // print(' Error when inserting ${error.toString()}');
      });
      await x;
      return x;
    }).then((value) {});
  }

  void getdata(database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(LoadingDataState());
    database.rawQuery('select * from tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') newtasks.add(element);
        if (element['status'] == 'done') donetasks.add(element);
        if (element['status'] == 'archived') archivedtasks.add(element);
      });

      emit(GetState());
    });
  }

  void updatedata(String status, int id) async {
    await database!.rawUpdate(
      'update tasks set status = ? where id = ?',
      [status, id],
    ).then((value) {
      getdata(database);
      emit(UpdateState());
    });
  }
    void deletedata(int id) async {
    await database!.rawDelete(
      'delete from tasks where id = ?',
      [id],
    ).then((value) {
      getdata(database);
      emit(DeleteState());
    });
  }
}
