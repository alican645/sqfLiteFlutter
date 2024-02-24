


// class Student{
//   int? id;
//   String? name;
//   String? surname;
//   int? age;
//
// //Student nesnesi eklenirken kullanılır
//   Student({required this.name,required this.surname,required this.age});
//
// //nesneler üzerinde update ya da delete işlemi yapılırken kullanılır.
//   Student.withID({required this.id,required this.name,required this.surname,required this.age});
//
//   Map<String,dynamic> toMap(){
//     return {
//       "id":this.id,
//       "name":this.name,
//       "surname":this.surname,
//       "age":this.age
//     };
//   }
//   Student.toStudent(Map map){
//     this.id = int.parse(map["id"].toString());
//     this.name = map["name"];
//     this.surname = map["surname"];
//     this.age = int.parse(map["age"].toString());
//   }
// }
class Student {
  int? id;
  String? name;
  String? surname;
  int? age;

  Student({this.name, this.surname, this.age});

  //nesneler üzerinde update ya da delete işlemi yapılırken kullanılır.
  Student.withID({this.id,required this.name,this.surname,this.age});

  Student.toStudent(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    age = json['age'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['age'] = this.age;
    return data;
  }
}