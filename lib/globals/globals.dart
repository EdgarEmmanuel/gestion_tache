library gestion_tache.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_tache/interfaces/Default/models/task.dart';

String username = "";
String password = "";
User? user;
String? errorMessage;
String? successMessage;
int? number = 0;
Task? task;
Map<String, dynamic> notification = {};
int? notificationNumber = 0;

bool isFirebase = false;
bool isAdmin = false;

Future<List<Task>>? tasks;
