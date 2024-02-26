enum Currency {
  Lira('₺'),
  Euro('€'),
  Dollar('\$');

  final String sign;

  const Currency(this.sign);
}

class CategoricalExpense {
  final String category;
  final int amount;
  final Currency currency;

  CategoricalExpense(this.category, this.amount, this.currency);
}
