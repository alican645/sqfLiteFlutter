import 'package:flutter/material.dart';

import '../dbHelper.dart';
import '../models/models.dart';

class EditStudentPage extends StatefulWidget {
  // update işlemi bir bakıma öğrenci ekleme işlemine sadece yeni bir öğrenci değil
  // var olan öğrencinin üstüne yeni öğrenci koyulur bunun için bize id işlemi lazımdır
  // önceki sayfadan öğrenci bilgilerini "studentList[index].toMap()["name"].toString()"
  // şeklinde alıp burada güncelleyebilirdik ama bu sefer bu şekilde id parametresini çekemezdik
  // çekilen parametler builder içerisindeki index parametresi olabilirdi
  // bu seferde Student nesnelerini listedeki yerlerine göre çıkarma ve ya düzenleme işlemi
  // yapılırdı. Bu da ileride Student nesnesi id'si ve liste indexi arasında bir karmaşıklağa yol açar
  // Student nesnesi id'si zaten veri tabanı sayeside kendiliğinden oluşuyor ve sadece o nesneye özel oluyor .
  // yani bir nevi kimlik gibi bir şey oluyor.

  // şuna dikkat!!! liste indexi ve id her zaman birbirini takip etmez çok işlem geçirmiş bir veri tabanın map olarak çıktısı şu şekilde olabilir
  // [
  // {'id': 1, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
  // {'id': 3, 'name': 'Jane', 'surname': 'Smith', 'studentNumber': '67890'},
  // {'id': 5, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
  // {'id': 9, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
  // ]

  //yani bir listenin 2. indexindeki nesnenin idsi 2 olmak zorunda değildir çünkü
  //veri tabanı isert ve delete işlemlerinden geçiyor bu yüzden
  //listedeki indexi değil de nesnenin kimliği olan id yi kullanmak daha kesin bir sonuç verir.
  Student student;

  EditStudentPage(
      {required this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  DbHelper dbHelper = DbHelper();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerSurname = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();
  @override
  void initState() {
    super.initState();
    // page ilk oluşturulduğunda
    // initState içinde widget değerlerini kullanarak kontrolcüleri başlat.
    _controllerName.text = widget.student.name.toString();
    _controllerSurname.text = widget.student.surname.toString();
    _controllerAge.text = widget.student.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenciyi Düzenle"),
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
                dbHelper.update(
                  Student.withID(
                    id: widget.student.id,
                    name: _controllerName.text.toString(),
                    surname: _controllerSurname.text.toString(),
                    age: int.tryParse(_controllerAge.text.toString()),
                  ),
                );
                Navigator.pop(context,"Result");
              },
              child: Text("Kaydet")),
          TextButton(
              onPressed: () {
                dbHelper.deleteStudent(widget.student.id!);
                Navigator.pop(context,"Result");
              },
              child: Text("Sil")),
        ],
      ),
    );
  }
}
