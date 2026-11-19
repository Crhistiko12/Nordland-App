import '../models/producto.dart';

abstract final class CatalogoService {
  static const List<Producto> productos = <Producto>[
    // -------------------------------------------------------------------------
    // AGUA
    // -------------------------------------------------------------------------
    Producto(
      id: 'agua-20l',
      nombre: 'Agua Norland 20L',
      categoria: CategoriaProducto.agua,
      presentacion: 'Bidón 20 L',
      precio: 25.00,
      precioMayorista: 20.00,
      etiqueta: 'Familiar',
      imagen: 'assets/images/PRODUCTOS/AGUA/agua-20-ltr-1-244x300.jpg',
      descripcion:
          'Agua purificada y ozonizada en botellón retornable de 20 litros. '
          'Máxima pureza y frescura para el hogar y la oficina.',
    ),

    // -------------------------------------------------------------------------
    // HELADOS
    // -------------------------------------------------------------------------
    Producto(
      id: 'helado-vasito-90ml',
      nombre: 'Helado en Vasito 90ml',
      categoria: CategoriaProducto.helados,
      presentacion: 'Vasito 90 ml',
      precio: 5.00,
      precioMayorista: 4.00,
      etiqueta: 'Individual',
      imagen: 'assets/images/PRODUCTOS/HELADOS/helado-vasito-90ml-2-244x300.jpg',
      descripcion:
          'Cremoso y refrescante helado vegetal en porción individual, '
          'ideal para una pausa dulce a cualquier hora.',
    ),
    Producto(
      id: 'helado-1l',
      nombre: 'Helado Norland 1L',
      categoria: CategoriaProducto.helados,
      presentacion: 'Pote 1 L',
      precio: 25.00,
      precioMayorista: 20.00,
      etiqueta: 'Más vendido',
      imagen: 'assets/images/PRODUCTOS/HELADOS/helado-1ltr-2-244x300.jpg',
      descripcion:
          'Helado artesanal elaborado a base de soya con textura suave y cremosa. '
          'El tamaño perfecto para compartir en familia.',
    ),
    Producto(
      id: 'helado-3750ml',
      nombre: 'Helado Familiar 3750ml',
      categoria: CategoriaProducto.helados,
      presentacion: 'Balde 3.75 L',
      precio: 75.00,
      precioMayorista: 62.00,
      etiqueta: 'Formato Ahorro',
      imagen: 'assets/images/PRODUCTOS/HELADOS/helado-3750ml-2-244x300.jpg',
      descripcion:
          'Gran formato de 3.75 litros para eventos, celebraciones o negocios. '
          'Rendidor, delicioso y 100% vegetal.',
    ),

    // -------------------------------------------------------------------------
    // LECHES
    // -------------------------------------------------------------------------
    Producto(
      id: 'leche-soya-original',
      nombre: 'Leche de Soya Original',
      categoria: CategoriaProducto.leches,
      presentacion: 'Botella 1 L',
      precio: 12.00,
      precioMayorista: 9.50,
      etiqueta: 'Más vendido',
      imagen: 'assets/images/PRODUCTOS/LECHES/leche-sabor-original-244x300.jpg',
      descripcion:
          'Bebida de soya tradicional pasteurizada, sin lactosa ni colesterol. '
          'Excelente fuente de proteína vegetal para toda la familia.',
    ),
    Producto(
      id: 'leche-soya-chocolate',
      nombre: 'Leche de Soya Chocolate',
      categoria: CategoriaProducto.leches,
      presentacion: 'Botella 1 L',
      precio: 13.50,
      precioMayorista: 11.00,
      etiqueta: 'Favorito',
      imagen: 'assets/images/PRODUCTOS/LECHES/leche-chocolate-1.jpg',
      descripcion:
          'El balance perfecto entre la nutrición de la soya y el exquisito '
          'sabor a chocolate. Ideal para desayunos y meriendas.',
    ),
    Producto(
      id: 'leche-soya-frutilla',
      nombre: 'Leche de Soya Frutilla',
      categoria: CategoriaProducto.leches,
      presentacion: 'Botella 1 L',
      precio: 13.50,
      precioMayorista: 11.00,
      imagen: 'assets/images/PRODUCTOS/LECHES/leche-frutilla.jpg',
      descripcion:
          'Bebida vegetal con refrescante sabor a frutilla. Una alternativa '
          'nutritiva, deliciosa y colorida para niños y adultos.',
    ),
    Producto(
      id: 'leche-almendras',
      nombre: 'Leche de Almendras',
      categoria: CategoriaProducto.leches,
      presentacion: 'Botella 1 L',
      precio: 18.00,
      precioMayorista: 15.00,
      etiqueta: 'Línea Premium',
      imagen: 'assets/images/PRODUCTOS/LECHES/leche-almendras-1.jpg',
      descripcion:
          'Bebida vegetal elaborada con almendras seleccionadas. Sabor delicado, '
          'fácil digestión y baja en calorías.',
    ),

    // -------------------------------------------------------------------------
    // YOGURTS
    // -------------------------------------------------------------------------
    Producto(
      id: 'yogurt-natural-900ml',
      nombre: 'Yogurt Natural 900ml',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Botella 900 ml',
      precio: 14.00,
      precioMayorista: 11.50,
      etiqueta: 'Sin azúcar',
      imagen: 'assets/images/PRODUCTOS/YOGURTS/Yogurt-Natural-244x300.jpg',
      descripcion:
          'Yogurt de soya natural con cultivos probióticos vivos. Sin azúcar '
          'añadida, ideal para mezclar con frutas, cereales o granola.',
    ),
    Producto(
      id: 'yogurt-frutilla-900ml',
      nombre: 'Yogurt de Frutilla 900ml',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Botella 900 ml',
      precio: 14.50,
      precioMayorista: 12.00,
      etiqueta: 'Más vendido',
      imagen:
          'assets/images/PRODUCTOS/YOGURTS/Yogurt-Frutilla-900-ml-2-244x300.jpg',
      descripcion:
          'Delicioso yogurt bebible de soya con pulpa y sabor a frutilla. '
          'Aporta energía, probióticos y nutrición en cada vaso.',
    ),
    Producto(
      id: 'yogurt-durazno-900ml',
      nombre: 'Yogurt de Durazno 900ml',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Botella 900 ml',
      precio: 14.50,
      precioMayorista: 12.00,
      imagen: 'assets/images/PRODUCTOS/YOGURTS/Yogurt-Durazno-900-ml-244x300.jpg',
      descripcion:
          'Cremoso yogurt de soya con el sabor suave y dulce del durazno. '
          'Una opción refrescante y saludable para el día a día.',
    ),
    Producto(
      id: 'yogurt-mora-900ml',
      nombre: 'Yogurt de Mora 900ml',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Botella 900 ml',
      precio: 14.50,
      precioMayorista: 12.00,
      imagen: 'assets/images/PRODUCTOS/YOGURTS/Yogurt-Mora-900-ml-244x300.jpg',
      descripcion:
          'Intenso sabor a mora silvestre en una base de yogurt vegetal '
          'probiótico. Excelente equilibrio entre dulzor y acidez.',
    ),
    Producto(
      id: 'yogurt-mango-900ml',
      nombre: 'Yogurt de Mango 900ml',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Botella 900 ml',
      precio: 14.50,
      precioMayorista: 12.00,
      etiqueta: 'Nuevo',
      imagen: 'assets/images/PRODUCTOS/YOGURTS/Yogurt-Mango-900-ml-244x300.jpg',
      descripcion:
          'Sabor tropical a mango maduro combinado con la cremosidad '
          'de nuestro yogurt de soya. Irresistible y refrescante.',
    ),
    Producto(
      id: 'yogurt-limon-900ml',
      nombre: 'Yogurt de Limón 900ml',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Botella 900 ml',
      precio: 14.50,
      precioMayorista: 12.00,
      imagen: 'assets/images/PRODUCTOS/YOGURTS/Yogurt-Limon-900-ml-244x300.jpg',
      descripcion:
          'Toque cítrico y fresco de limón en un yogurt ligero de soya. '
          'La opción más refrescante para días calurosos.',
    ),
    Producto(
      id: 'yogurt-frutilla-2l',
      nombre: 'Yogurt de Frutilla 2L',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Galón 2 L',
      precio: 26.00,
      precioMayorista: 21.00,
      etiqueta: 'Familiar',
      imagen:
          'assets/images/PRODUCTOS/YOGURTS/yogurt-2ltr-frutilla-1-244x300.jpg',
      descripcion:
          'Presentación familiar de 2 litros de yogurt vegetal de frutilla. '
          'Rendidor, cremoso y con probióticos para toda la familia.',
    ),
    Producto(
      id: 'yogurt-durazno-2l',
      nombre: 'Yogurt de Durazno 2L',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Galón 2 L',
      precio: 26.00,
      precioMayorista: 21.00,
      etiqueta: 'Familiar',
      imagen:
          'assets/images/PRODUCTOS/YOGURTS/yogurt-2ltr-durazno-1-244x300.jpg',
      descripcion:
          'Gran formato de 2 litros con delicioso sabor a durazno. '
          'Ideal para los desayunos de la semana.',
    ),
    Producto(
      id: 'yogurt-mora-2l',
      nombre: 'Yogurt de Mora 2L',
      categoria: CategoriaProducto.yogurts,
      presentacion: 'Galón 2 L',
      precio: 26.00,
      precioMayorista: 21.00,
      etiqueta: 'Familiar',
      imagen: 'assets/images/PRODUCTOS/YOGURTS/yogurt-2ltr-mora-1-244x300.jpg',
      descripcion:
          'Formato familiar de 2 litros sabor mora. Sabor auténtico y '
          'propiedades digestivas de los probióticos de soya.',
    ),
  ];

  static List<CategoriaProducto> get categorias => CategoriaProducto.values;

  static List<Producto> filtrar({
    CategoriaProducto? categoria,
    String texto = '',
  }) {
    final String consulta = _normalizar(texto);

    return productos
        .where((Producto producto) {
          if (categoria != null && producto.categoria != categoria) {
            return false;
          }
          if (consulta.isEmpty) return true;

          final String contenido = _normalizar(
            '${producto.nombre} ${producto.presentacion} '
            '${producto.categoria.etiqueta}',
          );
          return contenido.contains(consulta);
        })
        .toList(growable: false);
  }

  static String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }
}
