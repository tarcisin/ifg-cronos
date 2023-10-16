import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  Map<String, String> planos;
  Dropdown(this.planos);
  @override
  String? selectedvalue;
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String selectedOption = "";

  // Método para obter o valor selecionado
  void setSelectedValue() {
    widget.selectedvalue = widget.planos[selectedOption];
    
  }

  @override
  Widget build(BuildContext context) {
    if (selectedOption == "") {
      selectedOption = widget.planos.keys.toList()[0]!;
    }
    setSelectedValue();

    return Align(
      alignment: Alignment.centerLeft, // Alinhar à esquerda
      child: Row(
        children: <Widget>[
          Text("Plano:    "),
          DropdownButton<String>(
            value: selectedOption,

            onChanged: (String? newValue) {
              widget.planos.remove("Selecionar");
              setState(() {
                selectedOption = newValue!;
                setSelectedValue();
              });
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ), // Ícone personalizado
            elevation: 1,

            items: widget.planos.keys
                .toList()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
