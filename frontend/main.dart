import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'components/transaction_list.dart';
import 'components/chart.dart';
import 'models/transaction.dart';
import 'package:file_picker/file_picker.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.green,
          secondary: Colors.green,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          button: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

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

  //_openTransactionFormModal(BuildContext context) {
  //  showModalBottomSheet(
  //   context: context,
  ////  builder: (_) {
  //      return TransactionForm(_addTransaction);
  //  },
  // );
  // }

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
        dynamic tamanhoDoArquivo = await file.length()+0.0;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Arquivos'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),
            TransactionList(_transactions, _removeTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _abreNavegadorDeArquivos(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
