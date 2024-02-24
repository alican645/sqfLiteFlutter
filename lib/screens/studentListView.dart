import 'package:flutter/material.dart';
import 'package:sqflite_kullanim/dbHelper.dart';
import 'package:sqflite_kullanim/models/models.dart';

import 'addStudentPage.dart';
import 'editStudentPage.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  List<String> list = [];
  DbHelper dbHelper = DbHelper();
  List<Student> studentList = [];
  @override

  //initState fonksiyonu uygulama ilk açıldığında çalışan fonksiyondur.
  //başka yerlerde tekrar çağırılmaması gerekir.

  // initState içerisindeki işlemler başka bir fonksiyon ile de çağırılabilir
  // bu şekilde init state farklı yerlerde çalışmış olmaz initState içerisindeki
  // fonksiyon başka yerlerde çağırılmış olur.
  void initState() {
    super.initState();
    // uygulama ilk açıldığında aslında bir database ouşturmamız , eğer databasemiz varsa bu databasi
    // açmamız gereki burda data base açma fonksiyonunu kullanmamamızın nedeni
    // zaten dbHelper nesnesindeki db işlemlerinin gerçekleştiği fonksiyonlarda bunu gerçekleştirdik
    // örneğin getStudents() fonssiyonu içerisindeki getStudent() dbHelper fonksiyonu şu şekildedir
    //Future<List<Student>> getStudent() async{
    //     List<Student>? students=[];
    //     Database db=await openDb();
    //     var result=await db.query("student");
    //     for(int count=0;count<result.length;count++){
    //       students.add(Student.toStudent(result[count]));
    //     }
    //       return  students;
    //   }

    getStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //db mize model ekleme işlemi yapılıyor ama güncel db studentList'e döndürülmüyor bu yüzden
          //studentList tekrardan güncellemek için getStudent fonskiyonu burada da çağırıyoruz

          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStudentPage(),
              ));
          //buradaki koşul bloğu şu anlama geliyor AddStudentPage de yapılan işlemler tamamlandıktan sonra geriye navigator.pop bir result döndür
          // eğer bu result "Result" ifadesine eşit ise getStudent fonksiyonunu çalıştır.
          if (result == "Result") {
            //db mize model ekleme işlemi AddStudentPage de yapılıyor ama güncel db studentList'e döndürülmüyor bu yüzden
            //studentList tekrardan güncellemek için getStudent fonskiyonu burada da çağırıyoruz

            //widget ağacını yeniden yapılandırmak için set state önemlidir.
            getStudent();
          }
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: studentList.length,
          itemBuilder: (context, index) => ElevatedButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditStudentPage(student: studentList[index],))

                    );
              if (result=="Result"){
                getStudent();
              }
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                color: Colors.green,
                child: Row(
                  children: [
                    Icon(Icons.person),
                    Text(studentList[index].toMap()["name"].toString())
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getStudent() async {
    var result = dbHelper.getStudent();
    result.then((value) {
      //value değerini setstate ile beraber listeye aktarıyoruz ki widget tree tekrardan yapılandırılsın.
      setState(() {
        studentList = value;
      });
    });
  }
}
