//Converts any currency to USD and then to desired currency
String convertAnyToAny(
    Map<String, num>? exchangeRates, String? amount, String? fromCurrency, String? toCurrency) {
  if (exchangeRates == null || amount == null || fromCurrency == null || toCurrency == null) {
    return ""; // Or handle the null case appropriately
  }
  var doubleVal = double.tryParse(amount);
  if (doubleVal == null) return "";
  if (!exchangeRates.containsKey(fromCurrency) || !exchangeRates.containsKey(toCurrency)) {
    return ""; // Handle the case where currency conversion rates are not available
  }
  String output =
      (doubleVal / exchangeRates[fromCurrency]! * exchangeRates[toCurrency]!).toStringAsFixed(5);
  return output;
}
