import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produto.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
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
        await db.execute('''
          CREATE TABLE vendas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            produtoId INTEGER,
            nomeProduto TEXT,
            quantidade INTEGER,
            valorTotal REAL,
            data TEXT
          )
        ''');
      },
    );
  }

  static Future<int> inseriProduto(Produto produto) async {
    final db = await database;
    return await db.insert('produtos', produto.toMap());
  }

  static Future<List<Produto>> getProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }

  static Future<void> registrarVenda(Produto produto, int qtd) async {
    final db = await database;
    double total = produto.precoVenda * qtd;
    
    await db.insert('vendas', {
      'produtoId': produto.id,
      'nomeProduto': produto.nome,
      'quantidade': qtd,
      'valorTotal': total,
      'data': DateTime.now().toIso8601String(),
    });

    await db.update(
      'produtos',
      {'quantidadeEstoque': produto.quantidadeEstoque - qtd},
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }
}
