import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'models/produto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Estoque',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  void _carregarProdutos() async {
    final dados = await DBHelper.getProdutos();
    setState(() {
      _produtos = dados;
    });
  }

  void _exibirDialogoCadastro() {
    final nomeController = TextEditingController();
    final custoController = TextEditingController();
    final vendaController = TextEditingController();
    final qtdController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cadastrar Produto'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Produto')),
              TextField(controller: custoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Preço de Custo (R\$)')),
              TextField(controller: vendaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Preço de Venda (R\$)')),
              TextField(controller: qtdController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Estoque Inicial')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nomeController.text.isNotEmpty) {
                await DBHelper.inseriProduto(Produto(
                  nome: nomeController.text,
                  precoCusto: double.tryParse(custoController.text) ?? 0.0,
                  precoVenda: double.tryParse(vendaController.text) ?? 0.0,
                  quantidadeEstoque: int.tryParse(qtdController.text) ?? 0,
                ));
                _carregarProdutos();
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Salvar'),
          )
        ],
      ),
    );
  }

  void _registrarVenda(Produto p) {
    final qtdController = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Vender: ${p.nome}'),
        content: TextField(
          controller: qtdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantidade'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              int qtd = int.tryParse(qtdController.text) ?? 0;
              if (qtd > 0 && qtd <= p.quantidadeEstoque) {
                await DBHelper.registrarVenda(p, qtd);
                _carregarProdutos();
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Confirmar Venda'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Estoque e Vendas')),
      body: _produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado.'))
          : ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: (ctx, i) {
                final p = _produtos[i];
                bool estoqueBaixo = p.quantidadeEstoque <= 3;
                return Card(
                  color: estoqueBaixo ? Colors.red.shade50 : Colors.white,
                  child: ListTile(
                    title: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Venda: R\$ ${p.precoVenda.toStringAsFixed(2)} | Estoque: ${p.quantidadeEstoque}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (estoqueBaixo)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.warning, color: Colors.red),
                          ),
                        ElevatedButton(
                          onPressed: p.quantidadeEstoque > 0 ? () => _registrarVenda(p) : null,
                          child: const Text('Vender'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogoCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
