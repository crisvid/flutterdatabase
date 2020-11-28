import 'package:flutter/material.dart';
import 'estudiantes.dart';
import 'dart:async';
import 'DBHelper.dart';

class DBTestPage extends StatefulWidget {
  final String title;

  DBTestPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}

class _DBTestPageState extends State<DBTestPage> {

  Future<List<Estudiantes>> estudiantes;

  TextEditingController nombrecontroller = TextEditingController();
  TextEditingController nota1controller = TextEditingController();
  TextEditingController nota2controller = TextEditingController();
  TextEditingController nota3controller = TextEditingController();
  TextEditingController finalcontroller = TextEditingController();


  int estudianteId;
  String nombre;
  double nota1;
  double nota2;
  double nota3;
  double notaFinal;


  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;



  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      estudiantes = dbHelper.getEstudiantes();
    });
  }

  clearName() {
    nombrecontroller.text = '';
    nota1controller.text='';
    nota2controller.text='';
    nota3controller.text='';
    finalcontroller.text='';

  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        notaFinal = (nota1+nota2+nota3)/3;
        Estudiantes e = Estudiantes(estudianteId, nombre, nota1, nota2, nota3, notaFinal);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });

      } else {
        notaFinal = (nota1+nota2+nota3)/3;
        Estudiantes e = Estudiantes(null, nombre, nota1, nota2, nota3, notaFinal);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: nombrecontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => nombre = val,
            ),
            TextFormField(
              controller: nota1controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nota 1'),
              validator: (val) => val.length == 0 ? 'Ingrese la calificación' : null,
              onSaved: (val) => nota1 = double.parse(val),
            ),
            TextFormField(
              controller: nota2controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nota 2'),
              validator: (val) => val.length == 0 ? 'Ingrese la calificación' : null,
              onSaved: (val) => nota2 = double.parse(val),
            ),
            TextFormField(
              controller: nota3controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nota 3'),
              validator: (val) => val.length == 0 ? 'Ingrese la calificación' : null,
              onSaved: (val) => nota3 = double.parse(val),
            ),
            /*TextFormField(
              controller: finalcontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nota Final'),
              validator: (val) => val.length == 0 ? 'Ingrese la calificación' : null,
              onSaved: (val) => notaFinal = double.parse(val),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),

                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Estudiantes> estudiantes) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('Nombre'),
          ),
          DataColumn(
            label: Text('Nota Final'),
          ),
          DataColumn(
            label: Text('Eliminar'),
          )
        ],
        rows: estudiantes
            .map(
              (estudiantes) => DataRow(cells: [
            DataCell(
              Text(estudiantes.nombre),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  estudianteId = estudiantes.id;
                });
                nombrecontroller.text = estudiantes.nombre;
                nota1controller.text = estudiantes.nota1.toString();
                nota2controller.text = estudiantes.nota2.toString();
                nota3controller.text = estudiantes.nota3.toString();
              },
            ),

                DataCell(
                  Text(estudiantes.notaFinal.toStringAsFixed(2)),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      estudianteId = estudiantes.id;
                    });
                    finalcontroller.text = estudiantes.notaFinal.toString();
                  },
                ),

            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.delete(estudiantes.id);
                refreshList();
              },
            )),
          ]),
        )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: estudiantes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter SQLITE CRUD DEMO'),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}