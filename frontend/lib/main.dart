
import 'package:flutter/material.dart';
import 'package:flutter/Services.dart';
import 'components/telaDeArquivos.dart';

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
  bool _showChart = true;
 

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final appBar = AppBar(
      title: Text(
        'Bem-vindo ao CRONOS',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26 * MediaQuery.of(context).textScaleFactor,
        ),
      ),
      actions: [],
    );
    final avaliableHeigh = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bem-vindo ao CRONOS',
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Seu repositório online atemporal!',
              style: TextStyle(
                  fontSize: 25.0, color: Color.fromARGB(255, 68, 67, 67)),
            ),
            SizedBox(height: 60.0),
            // Espaçamento entre o título e os botões
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Adicione aqui a ação a ser executada quando o botão "Login" for pressionado.
                  },
                  child: Text('Cadastrar'),
                ),
                SizedBox(height: 35.0), // Espaçamento entre os botões
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TelaDeArquivos(),
                      ),
                    );
                    // Adicione aqui a ação a ser executada quando o botão "Nova Conta" for pressionado.
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.amber), // Define a cor do botão
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    ;
  }
}
