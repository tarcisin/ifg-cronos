import 'package:flutter/material.dart';


class FormularioLogin extends StatefulWidget {
  final void Function(String, String) onSubmit;

  FormularioLogin(this.onSubmit, {Key? key}) : super(key: key) {
   
  }

  @override
  State<FormularioLogin> createState() => _formularioLoginState();
}

class _formularioLoginState extends State<FormularioLogin> {
  final _emailontroller = TextEditingController();
  final _senhaController = TextEditingController();

  _submitForm() {
    final email = _emailontroller.text;
    final senha = (_senhaController.text);
    if (email.isEmpty || senha == "") {
      return;
    }

    widget.onSubmit(email, senha);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Fazer Login', // Título
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20, // Tamanho da fonte do título
                  fontWeight: FontWeight.bold, // Estilo de fonte em negrito
                )),
            TextField(
              controller: _emailontroller,
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _senhaController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button?.color,
                    ),
                  ),
                  onPressed: _submitForm,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red), // Cor de fundo do botão
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button?.color,
                    ),
                  ),
                  onPressed: ()=>Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
