import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produto.dart';

class DBHelper {
  static Database? _db;
  // Memória temporária para funcionar no Google Chrome
  static final List<Produto> _produtosWeb = [];
  static int _nextWebId = 1;

  static Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'gestao_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produtos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            precoCusto REAL,
            precoVenda REAL,
            quantidadeEstoque INTEGER
          )
        ''');
      },
    );
  }

  static Future<int> inseriProduto(Produto produto) async {
    if (kIsWeb) {
      final novoProduto = Produto(
        id: _nextWebId++,
        nome: produto.nome,
        precoCusto: produto.precoCusto,
        precoVenda: produto.precoVenda,
        quantidadeEstoque: produto.quantidadeEstoque,
      );
      _produtosWeb.add(novoProduto);
      return novoProduto.id!;
    }
    final db = await database;
    return await db!.insert('produtos', produto.toMap());
  }

  static Future<List<Produto>> getProdutos() async {
    if (kIsWeb) {
      return List.from(_produtosWeb);
    }
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }

  static Future<void> registrarVenda(Produto produto, int qtd) async {
    if (kIsWeb) {
      int index = _produtosWeb.indexWhere((p) => p.id == produto.id);
      if (index != -1) {
        final p = _produtosWeb[index];
        _produtosWeb[index] = Produto(
          id: p.id,
          nome: p.nome,
          precoCusto: p.precoCusto,
          precoVenda: p.precoVenda,
          quantidadeEstoque: p.quantidadeEstoque - qtd,
        );
      }
      return;
    }
    final db = await database;
    await db!.update(
      'produtos',
      {'quantidadeEstoque': produto.quantidadeEstoque - qtd},
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }
}
