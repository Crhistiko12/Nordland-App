# Nordland · Tienda y Puntos de Venta

Aplicación Flutter de Nordland para comprar productos para el hogar o surtir un
negocio, y para encontrar los puntos de venta oficiales en Bolivia. Incluye
autenticación con correo/contraseña y Google, mapa de comercios y la base para
el catálogo, el carrito y el seguimiento de pedidos.

## Stack

- Flutter + Material 3
- Firebase Core, Authentication y Cloud Firestore
- Google Sign-In
- `flutter_map` con tiles de OpenStreetMap
- `flutter_local_notifications` y `vibration` para alertas de entrega
- `google_fonts`: Fredoka (títulos) y Nunito (cuerpo)
- `intl` para el cronómetro de 24 horas

## Estructura

```
lib/
├── main.dart
├── config/       # Variables de entorno de Firebase y Google
├── models/       # Puntos de venta, productos, categorías y distancias
├── screens/      # Acceso, inicio, catálogo, mapa y registro
├── services/     # Auth, Firebase, catálogo, mapas y directorio
├── theme/        # Identidad visual Nordland
├── utils/        # Validaciones y formato de precios
└── widgets/      # Logo, pines, tarjetas y componentes de marca
```

## Configurar Firebase

La app intenta inicializar Firebase en `main.dart`. Si falta configuración,
muestra una pantalla con el error y un botón para reintentar.

### Web o configuración por variables

```bash
flutter run -d chrome \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_AUTH_DOMAIN=... \
  --dart-define=GOOGLE_WEB_CLIENT_ID=...
```

Opcionalmente se aceptan `FIREBASE_STORAGE_BUCKET`,
`FIREBASE_MEASUREMENT_ID`, `GOOGLE_ANDROID_CLIENT_ID` y
`GOOGLE_IOS_CLIENT_ID`.

### Android

1. Coloca `google-services.json` en `android/app/`. El plugin de Google
   Services se aplica automáticamente cuando ese archivo existe.
2. Habilita Google en Firebase Authentication y registra la huella SHA-1 del
   equipo. Si no usas `google-services.json`, pasa
   `GOOGLE_WEB_CLIENT_ID` como `serverClientId` de Google Sign-In.

### iOS

1. Agrega `GoogleService-Info.plist` al target Runner.
2. En `ios/Runner/Info.plist`, agrega `GIDClientID` con el `CLIENT_ID` y el
   esquema de URL con el `REVERSED_CLIENT_ID`.
3. Habilita Google en Firebase Authentication.

### Web

Además de las variables, agrega el dominio desde el que se ejecuta la app en
**Authentication > Settings > Authorized domains** de Firebase. El acceso con
Google en web usa el popup de Firebase Auth.

## Ejecutar

```bash
flutter pub get
flutter run
```

Compilar web:

```bash
flutter build web --release
```

## Catálogo

El inicio incluye saludo personalizado, búsqueda, banner de puntos de venta,
las cuatro categorías oficiales (AGUA, HELADOS, LECHES y YOGURTS) y una grilla
de productos con filtro por categoría. Cada producto abre una ficha con precio
unitario, precio de revendedor y descripción.

Los productos están definidos en `lib/services/catalogo_service.dart` con precios
en bolivianos (Bs.), formatos individuales y familiares, y enlaces directos a sus
imágenes oficiales.

### Imágenes de productos

Las imágenes reales de los productos se encuentran organizadas por categoría en:

```
assets/images/PRODUCTOS/
├── AGUA/
├── HELADOS/
├── LECHES/
└── YOGURTS/
```

Todas las rutas están declaradas en `pubspec.yaml`. En caso de que alguna imagen
falle o no esté disponible, los componentes visuales recurren automáticamente a un
respaldo estilizado con el color e icono oficial de la categoría.

## Estado actual

- Bienvenida con identidad Nordland.
- Login y registro con correo/contraseña, validaciones y Google.
- Sesión persistente mediante `authStateChanges`.
- Inicio con búsqueda, categorías, catálogo oficial (17 productos) y ficha de producto.
- Mapa de puntos de venta y registro de comercios existente.
- Carrito de compras con `Provider` y `CartService` (cálculo de subtotal y total en Bs., aumento/disminución y Badge dinámico en AppBar).
- Seguimiento de pedido en tiempo real con cronómetro regresivo de 24 horas (`Timer.periodic`).
- Alerta sensorial de cercanía (< 200m) con vibración háptica (`vibration`), notificación local (`flutter_local_notifications`) y diálogo en pantalla.
- Registro de revendedor en Firestore: preparado como dependencia.

El nombre de marca utilizado es **Nordland**, según el manual oficial de marca
adjunto (no "Norland").
