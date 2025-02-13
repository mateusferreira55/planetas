// ignore: file_names
import 'package:flutter/material.dart';
import 'package:myapp/controle/controle_planeta.dart';

import '../modelo/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir; // Define se a tela está incluindo ou editando um planeta
  final Planeta planeta; // Objeto do planeta a ser cadastrado/editado
  final Function() onFinalizado; // Callback para atualizar a lista de planetas

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

  // Controladores para os campos de entrada
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Controle de dados

  late Planeta _planeta; // Planeta que será manipulado

  @override
  void initState() {
    _planeta = widget.planeta;
    // Preenchendo os campos com os dados do planeta (se já existir)
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // Liberando os recursos dos controladores
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  // Insere um novo planeta
  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  // Altera um planeta já existente
  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  // Valida e salva os dados do formulário
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Os dados do planeta foram ${widget.isIncluir ? 'incluídos' : 'alterados'} com sucesso!'),
        ),
      );
      Navigator.of(context).pop(); // Fecha a tela após salvar
      widget.onFinalizado(); // Atualiza a lista de planetas na tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo para o nome do planeta
                TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Informe o nome do planeta (mínimo 3 caracteres)';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _planeta.nome = value!;
                    }),
                // Campo para o tamanho do planeta
                TextFormField(
                    controller: _tamanhoController,
                    decoration:
                        const InputDecoration(labelText: 'Tamanho (em km)'),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o tamanho do planeta';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Informe um valor numérico válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _planeta.tamanho = double.parse(value!);
                    }),
                // Campo para a distância do planeta ao sol
                TextFormField(
                  controller: _distanciaController,
                  decoration:
                      const InputDecoration(labelText: 'Distância do sol (em UA)'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a distância do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Informe um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                // Campo opcional para o apelido do planeta
                TextFormField(
                  controller: _apelidoController,
                  decoration: const InputDecoration(labelText: 'Apelido'),
                  onSaved: (value) {
                    _planeta.apelido = value;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // Botões de Cancelar e Confirmar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(), // Fecha a tela
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm, // Salva os dados
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
     ),
);
}
}