import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //Importar el paquete para hacer peticiones http
import 'dart:convert';

void main() {
  //MyApp se toma como el widget raiz
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //Definir la estructura y apariencia de la aplicacion
    return MaterialApp( //Widget que define la parte superior de la jerarquia de widgets
      title: 'Rick and Morty App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(), //Pagina de inicio de la aplicacion
    );
  }
}
//Clase que hereda de stateful widget, por tanto, puede cambiar su contenido durante la ejecucion
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState(); //Crear una instancia de la clase _MyHomePageState
  //Donde se almacena y gestiona el estado de la pagina
}

class _MyHomePageState extends State<MyHomePage> {
  //Almacenar datos del personaje y el estado de busqueda
  String characterName = "";
  String characterImage = "";
  List<String> characterInfo = [];
  bool characterNotFound = false;

  @override
  Widget build(BuildContext context) { //construimos la interfaz de usuario con el build
    return Scaffold( //Proporciona una estructura basica para la pagina
      appBar: AppBar( //Mostrar la barra de la aplicacion
        title: Text('Buscador de Rick and Morty'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView( //Contenido principal de la pagina 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( //Organizar los elementos en una columna vertical
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField( //Campo de entrada de texto
                onChanged: (value) {
                  characterName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre del Personaje',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton( //Boton elevado que se activa cuando el usuario presiona "buscar"
                onPressed: () {
                  searchCharacter(); //Al ser presionado se llama al metodo "searchCharacter"
                },
                child: Text('Buscar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
              SizedBox(height: 16.0),
              if (characterNotFound)
                Text(
                  'Personaje no encontrado :"v',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 30.0,
                  ),
                ),
              if (characterImage.isNotEmpty) //Mostrar imagen del personaje si la variable no essta vacia
                Image.network(
                  characterImage,
                  width: 250,
                  height: 250,
                ),
              Column( //Mostrar la informacion del personaje 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: characterInfo
                    .map((info) => Text(
                          info,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchCharacter() async { //Metodo asincrono que se llama cuando el usuario da al boton buscar
    final response = await http.get(
        Uri.parse('https://rickandmortyapi.com/api/character/?name=$characterName')); //url base

    if (response.statusCode == 200) { //Si la respuesta tiene un estado 200, entonces fue exitosa
      final data = json.decode(response.body);
      if (data['results'].isEmpty) {
        setState(() {
          characterNotFound = true;
          characterImage = "";
          characterInfo = [];
        });
      } else {
        final character = data['results'][0];
        setState(() {
          characterNotFound = false;
          characterImage = character['image'];
          characterInfo = [ //Metemos la informacion que rescatemenos en un array
            'Nombre: ${character['name']}',
            'Especie: ${character['species']}',
            'Género: ${character['gender']}',
            'Origen: ${character['origin']['name']}',
            'Ubicación: ${character['location']['name']}',
            'Estado: ${character['status']}',
            'Número de episodios: ${character['episode'].length}',
          ];
        });
      }
    } else {
      // Manejo de errores de solicitud HTTP
      setState(() {
        characterNotFound = true;
        characterImage = "";
        characterInfo = [];
      });
    }
  }
}


