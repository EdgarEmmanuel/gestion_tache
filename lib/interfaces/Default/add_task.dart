import 'package:flutter/material.dart';
import 'package:gestion_tache/http/http_task.dart';
import 'package:gestion_tache/interfaces/Default/accueil.dart';
import 'package:date_field/date_field.dart';
import 'package:gestion_tache/interfaces/Default/models/task.dart';
import '../../globals/globals.dart' as globals;

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  final _formGlobalKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  DateTime date_echeance = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (globals.task != null) {
      setState(() {
        title = globals.task!.title;
        description = globals.task!.description;
        date_echeance = globals.task!.date_echeance;
      });
    }
  }

  void _goBack() async {
    //   HttpFirebase.getTaskByUser(0);

   // var response = await HttpFirebase.updateTask("zVIatS9wpcVUMqyr3ece", t);
    // DocumentReference response = await HttpFirebase.addTaskByUser(t, "1");
    //  var response = await HttpFirebase.deleteTask("ZX9ISmFL0anFKriuUczH");
    //   print(response);
    //pour que le task qui est dans global soit réinitialiser si on retourne a l'acceuil , autre il risque de conserver les donnés du precendent task et dés qu'on esssaye d'ajouter un task , c'est se task la qui va se charger
    globals.task = null;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Accueil()));
  }

  void _taskDeletion() async {
    var r = await HttpTask.deleteTask(globals.task?.doc_id);
    //  print(r.body);
    r.statusCode != 500 ? _goBack() : print("Echec de la suppresion ! ");
  }

  void _updateTask() async {
    Task task = Task(
        id: globals.task?.id,
        title: title,
        description: description,
        date_echeance: date_echeance,
        doc_id: globals.task?.doc_id);

    //print(task);

    var r = await HttpTask.updateTask(task);
    r.statusCode != 500 ? _goBack() : print("Echec de la mise a jour ! ");
  }

  void _saveTask() async {
    Task task = Task(
        id: null,
        title: title,
        description: description,
        date_echeance: date_echeance);

    var r = await HttpTask.addTask(task);

    r.statusCode != 500 ? _goBack() : print("erreur lors de l'ajout ! ");
  }

  bool isValidText(String text) {
    // Vérifie si la chaîne contient au moins une lettre
    bool hasLetter = false;
    for (int i = 0; i < text.length; i++) {
      if (text[i].toLowerCase() != text[i].toUpperCase()) {
        hasLetter = true;
        break;
      }
    }

    // Vérifie si la chaîne contient uniquement des caractères autorisés
    const allowedChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\n \"-_?)&('><:,.!;+-àâéèêëîïôœùûüç*/%£\$";
    bool hasOnlyAllowedChars = true;
    for (int i = 0; i < text.length; i++) {
      if (!allowedChars.contains(text[i])) {
        hasOnlyAllowedChars = false;
        break;
      }
    }

    return hasLetter && hasOnlyAllowedChars;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: globals.task == null
            ? const Text('Creer une nouvelle tache')
            : const Text("Details de la Tache"),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Form(
                key: _formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Titre',
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      initialValue: title,
                      validator: (value) {
                        if (value?.trim() == null ||
                            value!.isEmpty ||
                            isValidText(value.trim()) == false) {
                          return 'Saisir un titre valide';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'le titre de votre tache',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Text(
                      'Description',
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      initialValue: description,
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      validator: (value) {
                        if (value?.trim() == null ||
                            value!.isEmpty ||
                            isValidText(value.trim()) == false) {
                          return 'Saisir une description valide';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Ceci est un text qui ne fut point généré mais ecrit pas moi Ousseynou hihi :)',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 35.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Text(
                      'Date Echeance',
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Choisir une date',
                      ),
                      initialValue: date_echeance,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 40)),
                      initialDate: DateTime.now(),
                      //autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          date_echeance = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    globals.task == null
                        ? ElevatedButton(
                            onPressed: () {
                              if (_formGlobalKey.currentState!.validate()) {
                                _saveTask();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              'Ajouter'.toUpperCase(),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formGlobalKey.currentState!.validate()) {
                                    // modifier
                                    _updateTask();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  'Modifier'.toUpperCase(),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _taskDeletion();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColorDark,
                                ),
                                child: Text(
                                  'Supprimer'.toUpperCase(),
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
