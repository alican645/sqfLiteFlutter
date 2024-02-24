import 'package:sqflite_kullanim/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DbHelper{
  Database? _database;


  Future<Database> openDb() async{
    //eğer uygulama lk açıldığında elimizde bir database yoksa
    //bir database oluşturup onu açtığımız blok

    //openDatabase(path,version:,onCreate: )>> SQLite veritabanını açmak
    //ve kullanıma hazır hale getirmek için kullanılır
    //
    // path: Veritabanının fiziksel olarak saklanacağı dosya yolunu belirtir.
    // version: Veritabanı şemasının versiyonunu belirtir. Bu, veritabanı şemasında değişiklik yaptığınızda kullanışlıdır.
    // onConfigure: Veritabanı yapılandırılmadan önce çalışacak bir fonksiyonu belirtir.
    //
    // onCreate: Veritabanı oluşturulduğunda çalışacak bir fonksiyonu belirtir.>>
    //oluşturulmuş bir veri tabanı yoksa oluşturan fonksiyon olarak da açıklayabiliriz.
    //
    // onUpgrade ve onDowngrade: Veritabanı sürümü yükseltildiğinde veya düşürüldüğünde çalışacak fonksiyonları belirtir.
    // onOpen: Veritabanı açıldığında çalışacak bir fonksiyonu belirtir.



    if(_database==null){
      return await openDatabase(await join(await getDatabasesPath().toString()),version: 1,onCreate: (db, version) async{
        //veri tabanı oluşturan ve oluşturulan veritabanına bir tablo ekleyen kod satırı
        await db.execute("create table student(id integer primary key,name text,surname text,age integer)");
      },) ;
    }
    return _database!;
  }


  //veri tabanına eklenen  tüm ögeleri bir liste olarak döndüren fonksiyon
  Future<List> getStudentMap() async{
    Database db=await openDb();
    var result=await db.query("student");
    return result;
  }
//yukarıdaki fonksiyonun çıktısı aşağıdaki gibi olur yani liste içerisinde
//map yapıları döndürür.
  // [
  // {'id': 1, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
  // {'id': 2, 'name': 'Jane', 'surname': 'Smith', 'studentNumber': '67890'},
  // ]

// eğer döndürülen liste içerisinde map yapıları değil de Student sınıfından olan nesnelerin
// olmasını istiyorsak  bu fonksiyon aşağıdaki sekilde yazılır.


  //database içerisine eklenen map şeklindeki student modellerini Student nesnesine
  //çevirerek bir listeye ekleyen ve bu listeyi döndüren fonskiyon komutu
  Future<List<Student>> getStudent() async{
    List<Student>? students=[];
    Database db=await openDb();

    //database içerisindeki map şeklindeki srudent modellirini liste olarak çağıran datır
    var result=await db.query("student");
    // bu listenin çıktısı aşağıdaki şekildedir.
    // [{'id': 1, 'name': 'John', 'surname': 'Doe', 'studentNumber': '12345'},
    // {'id': 2, 'name': 'Jane', 'surname': 'Smith', 'studentNumber': '67890'},]

    // Liste içerisindeki her bir student map modelini Student nesnesine çeviren kod bloğu
    for(int count=0;count<result.length;count++){
      students.add(Student.toStudent(result[count]));
    }
      return  students;

  }


/*
*insert fonksiyonlarında neden map yaıpısı isteniyor.
*Map yapısı ile Tablo Arasındaki Bağlantı
*Tablo oluşturan girdi>>CREATE TABLE student(id INTEGER PRIMARY KEY,age INTEGER,name TEXT,surName TEXT "
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        *
*                                            *                       *            *        ****>>map yapsındaki "surName" key ifadesi = tabloda oluşturulan "surName" kolon
*                                            *                       *            ****>>map yapsındaki "name" key ifadesi = tabloda oluşturulan "name" kolon
*                                            *                       ****>>map yapsındaki "age" key ifadesi = tabloda oluşturulan "age" kolon
*                                            ****>>map yapsındaki "id" key ifadesi = tabloda oluşturulan "id" kolon
*
* map yapısı {
* "id":"valueID"
* "age":"valueAge"
* "name":"valueName
* "surName":"valueSurname"
*
* }
*
*
*
*/

// add ve delete işlemleri sql fonskiyonlarını yerine getirsede integer bir değer döndürürler
// bu değer bir ise işlem gerçekleşti sıfır ise işlem gerçekleşmedi olarak kabul edilir.

  // Future<int> yazılan programa göre değişebilir eğer istenen sonuçlara göre bir durum olucaksa örneğin bir ya da sıfır durumu gibi int olarak kullanılabilir.
  // Ama bu durum önemsenmiyorsa Future<void> şeklinde de kullanılabilir.
  Future<int> insertStudent(Student student) async{
    Database db= await openDb();

    //istenilen Student nesnesini map formatına dönüştürür ve db ye ekler
    var result=await db.insert("student", student.toMap());
    return result;
  }

  Future<int> deleteStudent(int id) async{
    Database db=await openDb();
    var result=db.rawDelete("delete from student where id=$id");
    return result;
  }


  // update işlemi aslında bir bakıma insert işlemine benzer where ile
  // hangi sütun değerine göre update işlemi yapılacağı belirlenir
  // örneğin where="id=?" yazıldı ise id sütunu için gerilen değere göre işlem yapılır.
  // whereArgs ile hangi satır da update işlemi yapılacağı belirlenir.
  //whereArgs=3 ise id'nin 3 olduğu satırda update işlemi yapılır .
  Future<int> update(Student student) async{
    Database db= await openDb();
    var result= await db.update("student", student.toMap(),where:"id=?",whereArgs: [student.id]);
    return result;
  }


}