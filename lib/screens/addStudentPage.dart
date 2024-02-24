import 'package:flutter/material.dart';
import 'package:sqflite_kullanim/dbHelper.dart';
import 'package:sqflite_kullanim/models/models.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  DbHelper dbHelper = DbHelper();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerSurname = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrenci Ekle"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: "İsim"),
            controller: _controllerName,
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Soyisim"),
            controller: _controllerSurname,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Yaş"),
            controller: _controllerAge,
          ),
          TextButton(
              onPressed: () {
                dbHelper.insertStudent(Student(
                    name: _controllerName.text.toString(),
                    surname: _controllerSurname.text.toString(),
                    age: int.tryParse(_controllerAge.text.toString())));
              Navigator.pop(context,"Result");
                },

              child: Text("Kaydet"))
        ],
      ),
    );
  }
}
