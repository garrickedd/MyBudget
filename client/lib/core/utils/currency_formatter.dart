import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatVND(int amount) {
    final format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  static int parseVND(String formatted) {
    final cleanString = formatted.replaceAll(RegExp(r'[^\d]'), '');
    return int.parse(cleanString);
  }
}
