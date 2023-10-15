import 'package:flutter/material.dart';
import 'planos_DropDown.dart';

class FormularioCadastro extends StatefulWidget {
  final void Function(String, String, String) onSubmit;
  final Map<String, String> planos;
  Dropdown? _dropdown;
  FormularioCadastro(this.onSubmit, this.planos, {Key? key}) : super(key: key) {
    _dropdown = Dropdown(planos);
  }

  @override
  State<FormularioCadastro> createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  final _emailontroller = TextEditingController();
  final _senhaController = TextEditingController();
  String _idPlano = "";

  _submitForm() {
    final email = _emailontroller.text;
    final senha = (_senhaController.text);
    _idPlano = widget._dropdown!.selectedvalue!;
    if (email.isEmpty || senha == "" || _idPlano == "") {
      return;
    }

    widget.onSubmit(email, senha, _idPlano);
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
            Text('Cadastrar nova conta', // Título
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
            widget._dropdown!,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    'Criar nova conta',
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
