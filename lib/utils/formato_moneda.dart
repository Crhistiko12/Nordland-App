String formatearPrecio(double valor) {
  final List<String> partes = valor.toStringAsFixed(2).split('.');
  return 'Bs ${partes[0]},${partes[1]}';
}
