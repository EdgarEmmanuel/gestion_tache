import 'package:gestion_tache/http/http_task.dart';
import 'package:gestion_tache/interfaces/Default/models/task.dart';
import 'package:gestion_tache/interfaces/admin/add_task_public.dart';
import 'package:gestion_tache/interfaces/auth/rememberMe.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tache/http/http_task_firebase.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;
import 'package:intl/intl.dart';

import '../auth/auth.dart';

class AccueilAdmin extends StatefulWidget {
  const AccueilAdmin({super.key});

  @override
  State<AccueilAdmin> createState() => _AccueilAdminState();
}

class _AccueilAdminState extends State<AccueilAdmin> {
  int taskEchue = 0;
  int taskEnCours = 0;
  int taskNotEnCours = 0;
  int taskNumber = 0;
  Future<List<Task>>? tasks;

  void _deleteLoginCredentials() {
    rememberMe.logOut();
  }

  void _goBack() async {
    globals.task = null;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AccueilAdmin()));
  }

  @override
  void initState() {
    super.initState();

    if (globals.isFirebase) {
      tasks = HttpFirebase.getTasksPublic();
      HttpFirebase.fetchTasksNumberPublic().then((value) {
        setState(() {
          taskNumber = value;
        });
      });

      HttpFirebase.fetchTasksNumberEchuePublic().then((value) {
        setState(() {
          taskEchue = value;
        });
      });

      HttpFirebase.fetchTasksNumberEnCoursPublic().then((value) {
        setState(() {
          taskEnCours = value;
        });
      });

      HttpFirebase.fetchTasksNumberNotEnCoursPublic().then((value) {
        setState(() {
          taskNotEnCours = value;
        });
      });
    } else {
      tasks = HttpTask.fetchTasks();
      HttpTask.fetchTasksNumber().then((value) {
        setState(() {
          taskNumber = value;
        });
      });

      HttpTask.fetchTasksEchueNumber().then((value) {
        setState(() {
          taskEchue = value;
        });
      });

      HttpTask.fetchTasksEnCoursNumber().then((value) {
        setState(() {
          taskEnCours = value;
        });
      });

      HttpTask.fetchTasksNotEnCoursNumber().then((value) {
        setState(() {
          taskNotEnCours = value;
        });
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToAddDartPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddTaskPublic()));
  }

  void refresh() {
    setState(() {
      if (globals.isFirebase) {
        tasks = HttpFirebase.getTasksPublic();
      } else {
        tasks = HttpTask.fetchTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Accueil Administrateur",
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontFamily: 'Raleway'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: null,
            icon: const Icon(
              Icons.home,
            ),
            color: Theme.of(context).primaryColor,
          ),
          actions: [
            IconButton(
              style: const ButtonStyle(),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                _deleteLoginCredentials();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Auth()));
              },
              icon: const Icon(
                Icons.logout_rounded,
              ),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  constraints:
                      const BoxConstraints(minWidth: 350, minHeight: 100),
                  color: const Color.fromARGB(255, 68, 21, 151),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bienvenue Administrateur ${globals.user?.displayName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Nombre de tâche total : ${taskNumber}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            "Tache echue : ${taskEchue}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            "Tache en cours : ${taskEnCours}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Text(
                            "Tache qui ne sont pas en cours : ${taskNotEnCours}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Liste des Tâches Publiques",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                      child: FutureBuilder<List<Task>>(
                          future: tasks,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              if (snapshot.data?.isEmpty == true) {
                                return const SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 20),
                                      Text("Il n'y a  aucune tâche publique "),
                                    ],
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(8),
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      return TaskItemAdmin(
                                          task:
                                              snapshot.data!.elementAt(index));
                                    });
                              }
                            }
                            return const SizedBox.shrink();
                          }),
                    ),
                  
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 80.0,
          shape: const CircularNotchedRectangle(),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Home',
                backgroundColor: Theme.of(context).primaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today),
                label: 'Calendar',
                backgroundColor: Theme.of(context).primaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.chat_bubble_outline),
                label: 'Business',
                backgroundColor: Theme.of(context).primaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: 'School',
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10.0,
          onPressed: _goToAddDartPage,
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}

class TaskItemAdmin extends StatelessWidget {
  final Task task;
  const TaskItemAdmin({super.key, required this.task});

  String formatDate() {
    var f = DateFormat("dd / MM / yyyy hh:mm:ss").format(task.date_echeance);
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title),
              const SizedBox(height: 10.0),
              Text(formatDate())
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              globals.task = task;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTaskPublic()));
            },
            icon: const Icon(Icons.arrow_forward_ios),
            label: const Text(""),
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
              foregroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
