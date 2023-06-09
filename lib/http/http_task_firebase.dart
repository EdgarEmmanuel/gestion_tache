import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_tache/interfaces/Default/models/task.dart';

class HttpFirebase {
  HttpFirebase();

  static Future<List<Task>> getTaskByUser(userID) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    List<Task> taskList = [];

    QuerySnapshot querySnapshot = await tasks.get();
    for (var doc in querySnapshot.docs) {
      if (userID == doc['userID']) {
        try {
          var task = Task(
            id: doc['id'].toString(),
            title: doc['title'],
            description: doc['description'],
            date_echeance: doc['date_echeance'].toDate(),
            doc_id: doc.id,
          );
          taskList.add(task);
        } catch (e) {
          print('Error creating task: $e');
        }
      }
    }

    return taskList;
  }

  static Future<List<Task>> getTasksPublic() async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    List<Task> taskList = [];

    QuerySnapshot querySnapshot = await tasks.get();
    for (var doc in querySnapshot.docs) {
      if (doc["userID"] == "0") {
        try {
          var task = Task(
            id: doc['id'].toString(),
            title: doc['title'],
            description: doc['description'],
            date_echeance: doc['date_echeance'].toDate(),
            doc_id: doc.id,
          );
          taskList.add(task);
        } catch (e) {
          print('Error creating task: $e');
          taskList = [];
        }
      }
    }

    return taskList;
  }

  static Future<int> fetchTasksNumber(userID) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == userID) {
            number += 1;
          }
        }));

    return number;
  }

  static Future<int> fetchTasksNumberEchueForUser(userID) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == userID) {
            var dateEcheance = (doc['date_echeance'] as Timestamp).toDate();
            if (dateEcheance.isBefore(DateTime.now())) {
              number += 1;
            }
          }
        }));

    return number;
  }

  static Future<int> fetchTasksEnCoursNumberForUser(userID) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == userID) {
            var dateEcheance = (doc['date_echeance'] as Timestamp).toDate();
            if (dateEcheance.isAtSameMomentAs(DateTime.now())) {
              number += 1;
            }
          }
        }));

    return number;
  }

  static Future<int> fetchTasksNumberNotEnCoursForUser(userID) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == userID) {
            var dateEcheance = (doc['date_echeance'] as Timestamp).toDate();
            if (dateEcheance.isAfter(DateTime.now())) {
              number += 1;
            }
          }
        }));

    return number;
  }

  static Future<int> fetchTasksNumberPublic() async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == "0") {
            number += 1;
          }
        }));

    return number;
  }

  static Future<int> fetchTasksNumberEchuePublic() async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == "0") {
            var dateEcheance = (doc['date_echeance'] as Timestamp).toDate();
            if (dateEcheance.isBefore(DateTime.now())) {
              number += 1;
            }
          }
        }));

    return number;
  }

  static Future<int> fetchTasksNumberEnCoursPublic() async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == "0") {
            var dateEcheance = (doc['date_echeance'] as Timestamp).toDate();
            if (dateEcheance.isAtSameMomentAs(DateTime.now())) {
              number += 1;
            }
          }
        }));

    return number;
  }

  static Future<int> fetchTasksNumberNotEnCoursPublic() async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var number = 0;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == "0") {
            var dateEcheance = (doc['date_echeance'] as Timestamp).toDate();
            if (dateEcheance.isBefore(DateTime.now())) {
              number += 1;
            }
          }
        }));

    return number;
  }

  static Future<bool> addTaskByUser(Task task, String? userID) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    QuerySnapshot querySnapshot = await tasks.get();
    var number = 0;
    for (var doc in querySnapshot.docs) {
      if (doc["userID"] != 0) {
        number += 1;
      }
    }
    try {
      await tasks.add({
        'id': number,
        'title': task.title,
        'description': task.description,
        'date_echeance': task.date_echeance,
        'userID': userID,
      });
      return true;
    } catch (exception) {
      return false;
    }
  }

  static Future<bool> deleteTask(id) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    try {
      await tasks.doc(id).delete();
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> updateTask(id, Task task) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    try {
      await tasks.doc(id).update({
        'title': task.title,
        'description': task.description,
        'date_echeance': task.date_echeance,
      });
      return true;
    } catch (error) {
      return false;
    }
  }


  static Future<bool> updateTaskPublicByAdmin(id, Task task, userAdmin) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    try {
      await tasks.doc(id).update({
        'title': task.title,
        'description': task.description,
        'date_echeance': task.date_echeance,
        'modify_by_user': userAdmin
      });
      return true;
    } catch (error) {
      return false;
    }
  }
}
