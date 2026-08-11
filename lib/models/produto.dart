class Produto {
  final int? id;
  final String nome;
  final double precoCusto;
  final double precoVenda;
  final int quantidadeEstoque;

  Produto({
    this.id,
    required this.nome,
    required this.precoCusto,
    required this.precoVenda,
    required this.quantidadeEstoque,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'precoCusto': precoCusto,
      'precoVenda': precoVenda,
      'quantidadeEstoque': quantidadeEstoque,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      precoCusto: map['precoCusto'],
      precoVenda: map['precoVenda'],
      quantidadeEstoque: map['quantidadeEstoque'],
    );
  }
}
