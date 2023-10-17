import "package:expenses/components/formulárioCadastro.dart";
import "package:expenses/conexãoComBack/conexãoComBack.dart";
import 'package:flutter/material.dart';
import 'package:flutter/Services.dart';
import 'components/telaDeArquivos.dart';
import 'package:expenses/components/formulárioLogin.dart';
import 'package:expenses/components/Alerta.dart';
import "dart:convert";

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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

_abrirLogin(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (_) {
      return FormularioLogin(_dadosLogin, context);
    },
  );
}

_abrirCadastro(BuildContext context) async {
  dynamic planos = await pegaPlanos();
  if (planos == false) {
    Alerta(context, "Não foi possível acessar o servidor",
        "Verifique sua conexão e tente novamente");
    return;
  }
  Map<String, String> mapPlanos = {};
  for (dynamic i in planos) {
    mapPlanos[i['name']] = i['_id'];
  }

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (_) {
      return FormularioCadastro(_dadosCadastro, mapPlanos, context);
    },
  );
}

_dadosCadastro(
    String email, String senha, String idPlano, BuildContext context) async {
  print(email + " " + senha + " " + idPlano);
  dynamic b = await criaConta(email, senha, idPlano);

  if (b.statusCode != 201) {
    if (b.body[0] == '{') {
      Alerta(context, "Erro ao criar conta!", json.decode(b.body)["mensagem"]);
      return;
    }
    Alerta(context, "Erro ao criar conta!", b.body.toString());
    return;
  }
  Alerta(context, "Sucesso!", "Sua conta foi criada!");
  return;
}

_dadosLogin(String email, String senha, BuildContext context) async {
  dynamic resposta = await login(email, senha);
  if (resposta.body[0] == '{') {
    dynamic decode = json.decode(resposta.body);
    if (decode["usuarioLogado"] == true) {
      Alerta(context, "Sucesso!", decode["mensagem"]);
      Navigator.of(context).pop();

      // Redirecionar para Tela2
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaDeArquivos()),
      );

      return;
    }
    Alerta(context, "Atenção!", decode["mensagem"]);
    return;
  }
  Alerta(context, "Atenção!", resposta.body);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                    _abrirCadastro(context);
                    // Adicione aqui a ação a ser executada quando o botão "Login" for pressionado.
                  },
                  child: Text('Cadastrar'),
                ),
                SizedBox(height: 35.0), // Espaçamento entre os botões
                ElevatedButton(
                  onPressed: () {
                    _abrirLogin(context);

                    //  Navigator.of(context).push(
                    //  MaterialPageRoute(
                    //    builder: (context) => TelaDeArquivos(),
                    //   ),
                    // );
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
