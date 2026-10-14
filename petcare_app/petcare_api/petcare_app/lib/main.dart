import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// 1. TELA INICIAL


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade700, Colors.teal.shade200],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pets,
                size: 90,
                color: Colors.white,
              ),

              const SizedBox(height: 20),

              const Text(
                'Seja bem-vindo(a)!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              const Text(
                'Gerencie a saúde e a rotina dos seus animais de forma simples e organizada.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 50),

              // BOTÃO CADASTRAR PET
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal.shade800,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 24,
                  ),
                  label: const Text(
                    'Cadastrar Pet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroPetScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // BOTÃO PETS CADASTRADOS
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade900,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.list_alt,
                    size: 24,
                  ),
                  label: const Text(
                    'Pets Cadastrados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListaPetsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. TELA DE CADASTRO DE PET
// ==========================================

class CadastroPetScreen extends StatefulWidget {
  const CadastroPetScreen({super.key});

  @override
  State<CadastroPetScreen> createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _especieController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alergiaController = TextEditingController();
  final _cirurgiaController = TextEditingController();
  final _condicaoEspecialController = TextEditingController();

  String _sexoSelecionado = 'Masculino';
  String _porteSelecionado = 'Médio';
  String _castradoSelecionado = 'Sim';

  bool _carregando = false;

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
    });

    final url = Uri.parse(
      'http://localhost/petcare_api/salvar_pet.php',
    );

    try {
      final resposta = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nome": _nomeController.text,
          "especie": _especieController.text,
          "raca": _racaController.text,
          "idade": _idadeController.text,
          "sexo": _sexoSelecionado,
          "peso": _pesoController.text,
          "porte": _porteSelecionado,
          "castrado": _castradoSelecionado,
          "alergia": _alergiaController.text,
          "cirurgia": _cirurgiaController.text,
          "condicao_especial": _condicaoEspecialController.text,
        }),
      );

      final resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200 &&
          resultado['sucesso'] == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet cadastrado com sucesso! 🎉'),
            backgroundColor: Colors.green,
          ),
        );

        _limparCampos();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: ${resultado['mensagem']}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro de conexão com o servidor: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _especieController.clear();
    _racaController.clear();
    _idadeController.clear();
    _pesoController.clear();
    _alergiaController.clear();
    _cirurgiaController.clear();
    _condicaoEspecialController.clear();

    setState(() {
      _sexoSelecionado = 'Masculino';
      _porteSelecionado = 'Médio';
      _castradoSelecionado = 'Sim';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Pet'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pet',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _especieController,
                decoration: const InputDecoration(
                  labelText: 'Espécie (ex: Cachorro, Gato)',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _racaController,
                decoration: const InputDecoration(
                  labelText: 'Raça',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade (ex: 3 anos)',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(
                  labelText: 'Peso (ex: 30 kg)',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 20),

              const Text(
                'Sexo:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Masculino'),
                      value: 'Masculino',
                      groupValue: _sexoSelecionado,
                      onChanged: (value) {
                        setState(() {
                          _sexoSelecionado = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Feminino'),
                      value: 'Feminino',
                      groupValue: _sexoSelecionado,
                      onChanged: (value) {
                        setState(() {
                          _sexoSelecionado = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _porteSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Porte do Pet',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Mini',
                    child: Text('Mini'),
                  ),
                  DropdownMenuItem(
                    value: 'Pequeno',
                    child: Text('Pequeno'),
                  ),
                  DropdownMenuItem(
                    value: 'Médio',
                    child: Text('Médio'),
                  ),
                  DropdownMenuItem(
                    value: 'Grande',
                    child: Text('Grande'),
                  ),
                  DropdownMenuItem(
                    value: 'Gigante',
                    child: Text('Gigante'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _porteSelecionado = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              const Text(
                'Castrado:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Sim'),
                      value: 'Sim',
                      groupValue: _castradoSelecionado,
                      onChanged: (value) {
                        setState(() {
                          _castradoSelecionado = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Não'),
                      value: 'Não',
                      groupValue: _castradoSelecionado,
                      onChanged: (value) {
                        setState(() {
                          _castradoSelecionado = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _alergiaController,
                decoration: const InputDecoration(
                  labelText: 'Alergias',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _cirurgiaController,
                decoration: const InputDecoration(
                  labelText: 'Cirurgias prévias',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _condicaoEspecialController,
                decoration: const InputDecoration(
                  labelText: 'Situação / Condição Especial',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Este campo é obrigatório'
                        : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _carregando ? null : _salvarPet,
                  child: _carregando
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Salvar Pet no Banco',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. TELA DE PETS CADASTRADOS
// ==========================================

class ListaPetsScreen extends StatefulWidget {
  const ListaPetsScreen({super.key});

  @override
  State<ListaPetsScreen> createState() =>
      _ListaPetsScreenState();
}

class _ListaPetsScreenState extends State<ListaPetsScreen> {
  List<dynamic> _pets = [];
  bool _carregando = true;
  String _erro = '';

  @override
  void initState() {
    super.initState();
    _buscarPets();
  }

  Future<void> _buscarPets() async {
    final url = Uri.parse(
      'http://localhost/petcare_api/listar_pets.php',
    );

    try {
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final resultado = jsonDecode(resposta.body);

        if (resultado['sucesso'] == true) {
          setState(() {
            _pets = resultado['dados'];
            _carregando = false;
          });
        } else {
          setState(() {
            _erro = 'Erro ao carregar dados.';
            _carregando = false;
          });
        }
      } else {
        setState(() {
          _erro = 'Erro de comunicação com o servidor.';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro: $e';
        _carregando = false;
      });
    }
  }

  Future<void> _excluirPet(int id) async {
    final url = Uri.parse(
      'http://localhost/petcare_api/excluir_pet.php',
    );

    try {
      final resposta = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      final resultado = jsonDecode(resposta.body);

      if (resposta.statusCode == 200 &&
          resultado['sucesso'] == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        _buscarPets();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: ${resultado['mensagem']}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de conexão: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmarExclusao(
    int id,
    String nome,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Cadastro'),
        content: Text(
          'Tem certeza de que deseja remover o cadastro de $nome?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _excluirPet(id);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ABRIR DETALHES DO PET
  // ==========================================

  void _abrirDetalhesPet(dynamic pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesPetScreen(
          pet: pet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets Cadastrados'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),

      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _erro.isNotEmpty
              ? Center(
                  child: Text(
                    _erro,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                )
              : _pets.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum pet cadastrado ainda.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _pets.length,
                      itemBuilder: (context, index) {
                        final pet = _pets[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          // ==================================
                          // PET CLICÁVEL
                          // ==================================

                          child: ListTile(
                            onTap: () {
                              _abrirDetalhesPet(pet);
                            },

                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.teal.shade700,
                              foregroundColor: Colors.white,
                              child: Text(
                                pet['nome'] != null &&
                                        pet['nome']
                                            .toString()
                                            .isNotEmpty
                                    ? pet['nome']
                                        .toString()[0]
                                        .toUpperCase()
                                    : 'P',
                              ),
                            ),

                            title: Text(
                              pet['nome'] ?? 'Sem Nome',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            subtitle: Text(
                              '${pet['especie']} • ${pet['raca']} • ${pet['idade']}',
                            ),

                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _confirmarExclusao(
                                int.parse(
                                  pet['id'].toString(),
                                ),
                                pet['nome'],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

// ==========================================
// 4. TELA DE DETALHES DO PET
// ==========================================

class DetalhesPetScreen extends StatelessWidget {
  final dynamic pet;

  const DetalhesPetScreen({
    super.key,
    required this.pet,
  });

  // ==========================================
  // COMPONENTE PARA MOSTRAR CADA INFORMAÇÃO
  // ==========================================

  Widget _informacao(
    String titulo,
    dynamic valor,
    IconData icone,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icone,
          color: Colors.teal.shade700,
          size: 28,
        ),

        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          valor == null ||
                  valor.toString().isEmpty
              ? 'Não informado'
              : valor.toString(),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pet['nome'] ?? 'Detalhes do Pet',
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          // ==================================
          // ÍCONE DO PET
          // ==================================

          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade700,
              child: const Icon(
                Icons.pets,
                size: 55,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ==================================
          // NOME
          // ==================================

          Center(
            child: Text(
              pet['nome'] ?? 'Sem Nome',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ==================================
          // INFORMAÇÕES DO PET
          // ==================================

          _informacao(
            'Espécie',
            pet['especie'],
            Icons.pets,
          ),

          _informacao(
            'Raça',
            pet['raca'],
            Icons.category,
          ),

          _informacao(
            'Idade',
            pet['idade'],
            Icons.cake,
          ),

          _informacao(
            'Sexo',
            pet['sexo'],
            Icons.wc,
          ),

          _informacao(
            'Peso',
            pet['peso'],
            Icons.monitor_weight,
          ),

          _informacao(
            'Porte',
            pet['porte'],
            Icons.straighten,
          ),

          _informacao(
            'Castrado',
            pet['castrado'],
            Icons.health_and_safety,
          ),

          _informacao(
            'Alergias',
            pet['alergia'],
            Icons.warning_amber,
          ),

          _informacao(
            'Cirurgias Prévias',
            pet['cirurgia'],
            Icons.local_hospital,
          ),

          _informacao(
            'Situação / Condição Especial',
            pet['condicao_especial'],
            Icons.medical_information,
          ),

          const SizedBox(height: 10),

          // ==================================
          // BOTÃO VOLTAR
          // ==================================

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Voltar para Pets Cadastrados',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}