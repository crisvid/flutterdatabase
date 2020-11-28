class Estudiantes {
  int id;
  String nombre;
  double nota1;
  double nota2;
  double nota3;
  double notaFinal;




  Estudiantes(this.id, this.nombre, this.nota1, this.nota2, this.nota3, this.notaFinal);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'nota1': nota1,
      'nota2': nota2,
      'nota3': nota3,
      'notaFinal': notaFinal,


    };
    return map;
  }

  Estudiantes.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
    nota1 = map['nota1'];
    nota2 = map['nota2'];
    nota3 = map['nota3'];
    notaFinal = map['notaFinal'];

  }
}
