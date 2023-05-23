import 'package:gestion_tache/interfaces/Default/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpTask {
  static const String BASE_URL = "http://10.0.2.2:5050/";

  static Future<List<Task>> fetchTasks() async {
    String endpoint = "api/v1/tasks";
    List<Task> tasks = [];
    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    List jsonParsed = jsonDecode(response.body);
    for (int i = 0; i < jsonParsed.length; i++) {
      //print(jsonParsed[i]);
      tasks.add(Task.fromJson(jsonParsed[i]));
    }
    return tasks;
  }

  static Future<List<Task>> fetchTasksForUser(userID) async {
    String endpoint = "api/v1/tasks/user/${userID}";
    List<Task> tasks = [];
    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    List jsonParsed = jsonDecode(response.body);
    for (int i = 0; i < jsonParsed.length; i++) {
      tasks.add(Task.fromJson(jsonParsed[i]));
    }
    return tasks;
  }

  static Future<int> fetchTasksNumberForUser(userID) async {
    String endpoint = "api/v1/tasks/private/user/${userID}";
    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    var number = json.decode(response.body);
    return number['number'];
  }

  static Future<int> fetchTasksEchueNumberForUser(userID) async {
    String endpoint = "api/v1/tasks/private/echue/user/${userID}";
    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    var number = json.decode(response.body);
    return number['number'];
  }

  static Future<int> fetchTasksEnCoursNumberForUser(userID) async {
    String endpoint = "api/v1/tasks/private/encours/user/${userID}";

    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    var number = json.decode(response.body);
    return number['number'];
  }

  static Future<int> fetchTasksNotEnCoursNumberForUser(userID) async {
    String endpoint = "api/v1/tasks/private/notencours/user/${userID}";

    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    var number = json.decode(response.body);
    return number['number'];
  }

  static Future<int> fetchTasksNumber() async {
    String endpoint1 = "api/v1/tasks/number";

    final response1 = await http.get(Uri.parse(BASE_URL + endpoint1));
    var number = json.decode(response1.body);
    return number['number'];
  }

  static Future<int> fetchTasksEchueNumber() async {
    String endpoint1 = "api/v1/tasks/public/echue";

    final response1 = await http.get(Uri.parse(BASE_URL + endpoint1));
    var number = json.decode(response1.body);
    return number['number'];
  }

  static Future<int> fetchTasksEnCoursNumber() async {
    String endpoint1 = "api/v1/tasks/public/encours";

    final response1 = await http.get(Uri.parse(BASE_URL + endpoint1));
    var number = json.decode(response1.body);
    return number['number'];
  }

  static Future<int> fetchTasksNotEnCoursNumber() async {
    String endpoint1 = "api/v1/tasks/public/notencours";

    final response1 = await http.get(Uri.parse(BASE_URL + endpoint1));
    var number = json.decode(response1.body);
    return number['number'];
  }

  static Future<bool> deleteTask(id) async {
    try {
      String endpoint = "api/v1/tasks/private/delete/$id";

      await http.delete(
        Uri.parse(BASE_URL + endpoint),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addTask(Task task, id) async {
    try {
      String endpoint = "api/v1/tasks/private";
      var url = Uri.parse(BASE_URL + endpoint);

      await http.post(url, body: task.toBody(id));

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addTaskPublicByAdmin(Task task, id) async {
    try {
      String endpoint = "api/v1/tasks/public/create";
      var url = Uri.parse(BASE_URL + endpoint);

      await http.post(url, body: task.toBody(id));

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTask(Task task) async {
    try {
      String endpoint = "api/v1/tasks/private";
      var url = Uri.parse(BASE_URL + endpoint);

      await http.patch(url, body: task.toBodyUpdate());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTaskPublicByAdmin(Task task, userAdmin) async {
    try {
      String endpoint = "api/v1/tasks/public/user/${userAdmin}";
      var url = Uri.parse(BASE_URL + endpoint);

      await http.patch(url, body: task.toBodyUpdate());
      return true;
    } catch (e) {
      return false;
    }
  }
}
