enum Currency {
  Lira('₺'),
  Euro('€'),
  Dollar('\$');

  final String sign;

  const Currency(this.sign);
}

class CategoricalExpenses {
  final String category;
  final int amount;
  final Currency currency;

  CategoricalExpenses(this.category, this.amount, this.currency);
}
