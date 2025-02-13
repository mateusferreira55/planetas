import 'package:flutter/material.dart';
import 'package:myapp/controle/controle_planeta.dart';
import 'package:myapp/telas/tela_planeta.dart';

import 'modelo/planeta.dart';

void main() {
  runApp(const MyApp()); // Inicializa o meu aplicativo
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget raiz do meu aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'App - Planetas',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title; // Título da página principal do aplicativo

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Controle para gerenciar os planetas
  List<Planeta> _planetas = []; // Lista de planetas a serem exibidos

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas(); // Carrega os planetas ao iniciar
  }

  // Atualiza a lista de planetas
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  // Navega para a tela de inclusão de um novo planeta
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Navega para a tela de edição de um planeta existente
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Exclui um planeta pelo ID
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
              title: Text(planeta.nome), // Exibe o nome do planeta
              subtitle: Text(planeta.apelido ?? ""), // Exibe o apelido (se houver)
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>_alterarPlaneta(context, planeta), // Botão de edição
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _excluirPlaneta(planeta.id!), // Botão de exclusão
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context); // Botão para adicionar um novo planeta
        },
        child: const Icon(Icons.add),
     ),
);
}
}