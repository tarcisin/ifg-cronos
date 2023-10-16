import "dart:convert";
import "dart:io";
import 'package:http/http.dart' as http;

const String _hostName = "http://localhost:3000";

Future<dynamic> pegaPlanos() async {
  const String servidor = _hostName + "/planos";
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
  return false;
}

Future<bool> uploadFile(File file) async {
  const String servidor = _hostName + "files";
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

Future<dynamic> criaConta(
    final String email, final String senha, final String idPlano) async {
  const String servidor = _hostName + "/user";
  final response = await http.post(
    Uri.parse(servidor),
    body: {'email': email, "senha": senha, "idPlano": idPlano},
  );

  
  return (response);
}

Future<dynamic> login(final String email, final String senha) async {
  const String servidor = _hostName + "/user/login";
  final response = await http.post(
    Uri.parse(servidor),
    body: {'email': email, "senha": senha},
  );

  
  return response;
}
