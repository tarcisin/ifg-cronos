import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

import 'package:flutter/Services.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/components/chart.dart';
import 'package:expenses/models/transaction.dart';
import 'package:file_picker/file_picker.dart';

//main() => runApp(ExpensesApp());

class TelaDeArquivos extends StatelessWidget {
  TelaDeArquivos({Key? key}) : super(key: key);
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
      
    
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = true;
  final List<Transaction> _transactions = [];

  _addTransaction(String title, double value, DateTime date, IconData icon) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
      icon: icon,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }


  

  // Mapeamento de extensão de arquivo para ícone
  final Map<String, IconData> _fileIconMapping = {
    'txt': Icons.description,
    'doc': Icons.book,
    'pdf': Icons.picture_as_pdf,
    'jpg': Icons.image,
    'png': Icons.image,
    'mp3': Icons.music_note,
    'mp4': Icons.video_call,
    // Adicione mais extensões e ícones conforme necessário
  };
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return _fileIconMapping[extension] ??
        Icons.insert_drive_file; // Ícone padrão para tipos desconhecidos
  }

  _abreNavegadorDeArquivos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // O usuário selecionou um ou mais arquivos.
      List<File> files = result.files.map((file) => File(file.path!)).toList();

      // Faça algo com os arquivos selecionados, como exibir seus caminhos.
      for (var file in files) {
        dynamic tamanhoDoArquivo = await file.length() + 0.0;
        return _addTransaction(
          file.uri.pathSegments.last,
          tamanhoDoArquivo,
          DateTime.now(),
          _getFileIcon(file.uri.pathSegments.last),
        );
      }
    } else {
      // O usuário cancelou a seleção de arquivos.
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    bool isLandScape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    final appBar = AppBar(
      title: Text(
        'Meus Arquivos',
        style: TextStyle(
          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        ),
      ),
      actions: [],
    );
    final avaliableHeigh = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  "Exibir armazenamento",
                  style: TextStyle(
                      color: Colors.green[400], // Cor do texto
                      fontSize: 15.0, // Tamanho da fonte
                      fontWeight:
                          FontWeight.bold, // Espessura da fonte (negrito)

                      fontFamily: 'Roboto'), // Família da fonte
                ),
                Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    })
              ],
            ),
            // Planos_DropDown(context),
            _showChart
                ? Container(
                    height: avaliableHeigh * (isLandScape ? 0.3 : 0.7),
                    child: Chart(_transactions))
                : SizedBox(height: avaliableHeigh * 0.03),
            Container(
                height: avaliableHeigh * 0.7,
                child: TransactionList(_transactions, _removeTransaction)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload),
        onPressed: () async => await _abreNavegadorDeArquivos(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
