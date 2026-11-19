/// Tienda registrada localmente por un dueño de negocio.
class TiendaRegistrada {
  const TiendaRegistrada({
    this.id,
    required this.nombreTienda,
    required this.propietario,
    required this.telefono,
    required this.latitud,
    required this.longitud,
    required this.creadoEn,
    this.fotoFachada,
  });

  final int? id;
  final String nombreTienda;
  final String propietario;
  final String telefono;
  final double latitud;
  final double longitud;
  final String? fotoFachada;
  final DateTime creadoEn;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'nombre_tienda': nombreTienda,
      'propietario': propietario,
      'telefono': telefono,
      'latitud': latitud,
      'longitud': longitud,
      'foto_fachada': fotoFachada,
      'creado_en': creadoEn.toIso8601String(),
    };
  }

  factory TiendaRegistrada.fromMap(Map<String, Object?> map) {
    return TiendaRegistrada(
      id: map['id'] as int?,
      nombreTienda: map['nombre_tienda'] as String? ?? '',
      propietario: map['propietario'] as String? ?? '',
      telefono: map['telefono'] as String? ?? '',
      latitud: (map['latitud'] as num?)?.toDouble() ?? 0,
      longitud: (map['longitud'] as num?)?.toDouble() ?? 0,
      fotoFachada: map['foto_fachada'] as String?,
      creadoEn:
          DateTime.tryParse(map['creado_en'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
