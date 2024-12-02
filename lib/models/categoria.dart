class MonthlyLimit {
  final int month; // Mês (1 a 12)
  final int year;  // Ano
  double limit;
  double spent;

  MonthlyLimit({
    required this.month,
    required this.year,
    required this.limit,
    this.spent = 0.0,
  });

  set setLimit(double value) {
    limit = value;
  }
}

// nome
// data - limite, data - limite

class Category {
  final String name;
  final List<MonthlyLimit> monthlyLimits;

  Category({required this.name, required this.monthlyLimits});

  MonthlyLimit? getLimitForMonth(int month, int year) {
    try {
      return monthlyLimits.firstWhere(
        (limit) => limit.month == month && limit.year == year,
      );
    } catch (e) {
      return null; // Se não encontrar, retorna null
    }
  }

  void addExpense(Category category, double expense, int month, int year) {
    final limit = category.getLimitForMonth(month, year);
    if (limit == null) {
      print('Nenhum limite definido para ${category.name} em $month/$year.');
      return;
    }

    if (limit.spent + expense > limit.limit) {
      print('Limite mensal excedido para a categoria ${category.name}');
    } else {
      limit.spent += expense;
      print('Gasto adicionado. Total gasto: ${limit.spent}');
    }
  }
}
