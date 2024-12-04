class Despesa {
  String? categoria;
  String? descricao;
  String? valor;

  Despesa({
    this.categoria,
    this.descricao,
    this.valor,
  });

  String? getCategoria() {
    return categoria;
  }

  String? getDescricao() {
    return descricao;
  }

  String? getValor() {
    return valor;
  }

}