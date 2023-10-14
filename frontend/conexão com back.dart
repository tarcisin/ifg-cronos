import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import "dart:convert";
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 56, 183, 73)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> uploadFile(File file) async {
    const String servidor = "http://localhost:3000/files";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(servidor));

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Upload bem-sucedido');
        return true;
      } else {
        print('Falha no upload: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante o upload: $e');
    }
    return false;
  }

  Future<dynamic> pegaPlanos() async {
    const String servidor = "http://localhost:3000/planos";
    try {
      final response = await http.get(
        Uri.parse(servidor),
      );
      if (response.statusCode == 200) {
        print('conexão bem-sucedida');

        return json.decode(response.body);
      } else {
        print('Falha : ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante o upload: $e');
    }
  }

  Future<dynamic> criaConta(
      final String email, final String senha, final String idPlano) async {
    const String servidor = "http://localhost:3000/user";
    final response = await http.post(
      Uri.parse(servidor),
      body: {'email': email, "senha": senha, "idPlano": idPlano},
    );

    if (response.statusCode == 201) {
      print(response.body);
    } else {
      print(response.body + " " + response.statusCode.toString());

      return false;
    }
    return json.decode(response.body);
  }

  Future<dynamic> login(final String email, final String senha) async {
    const String servidor = "http://localhost:3000/user/login";
    final response = await http.post(
      Uri.parse(servidor),
      body: {'email': email, "senha": senha},
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body + " " + response.statusCode.toString());

      return false;
    }
    return json.decode(response.body);
  }

  void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  // O usuário selecionou um ou mais arquivos.
                  List<File> files =
                      result.files.map((file) => File(file.path!)).toList();

                  // Faça algo com os arquivos selecionados, como exibir seus caminhos.
                  for (var file in files) {
                    uploadFile(file);
                  }
                }
              },
              child: Text('Selecionar Arquivos'),
            ),
            SizedBox(
              width: 30,
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                dynamic planos = await pegaPlanos();
                print(planos);
              },
              child: Text('Ver planos'),
            ),
            SizedBox(
              width: 30,
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                dynamic resposta = await criaConta("capeta@gmail.com",
                    "12345678900", "65184f8e524b4a0d44d56439");
                print(resposta);
              },
              child: Text('Criar conta'),
            ),
            SizedBox(
              width: 30,
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                dynamic resposta = await login("capeta@gmail.com",
                    "12345678900");
                print(resposta);
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.upload_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
