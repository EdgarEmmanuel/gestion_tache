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
    String endpoint = "api/v1/tasks/private/user/${userID}";
    List<Task> tasks = [];
    final response = await http.get(Uri.parse(BASE_URL + endpoint));

    List jsonParsed = jsonDecode(response.body);
    for (int i = 0; i < jsonParsed.length; i++) {
      //print(jsonParsed[i]);
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

  static Future<http.Response> deleteTask(id) async {
    String endpoint = "api/v1/taskDelete/$id";

    return await http.delete(
      Uri.parse(BASE_URL + endpoint),
    );
  }

  static Future<http.Response> addTask(Task task) async {
    String endpoint = "api/v1/tasks";
    var url = Uri.parse(BASE_URL + endpoint);

    return await http.post(url, body: task.toBody());
  }

  static Future<http.Response> updateTask(Task task) async {
    String endpoint = "api/v1/tasks";
    var url = Uri.parse(BASE_URL + endpoint);

    return await http.patch(url, body: task.toBodyUpdate());
  }
}
