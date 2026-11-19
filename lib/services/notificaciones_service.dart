import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class NotificacionesService {
  NotificacionesService._();
  static final NotificacionesService instance = NotificacionesService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inicializado = false;

  Future<void> inicializar() async {
    if (_inicializado) return;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(settings: initSettings);

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }

      _inicializado = true;
    } catch (e) {
      debugPrint('NotificacionesService inicializar error: $e');
    }
  }

  Future<void> mostrarAlertaCercania() async {
    try {
      await inicializar();

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'nordland_pedidos_cercania',
        'Alertas de Pedido Cercano',
        channelDescription:
            'Aviso de repartidor a menos de 200 metros de tu ubicación.',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.show(
        id: 200,
        title: '¡Tu pedido Norland está a menos de 200 metros!',
        body: 'Prepara la recepción.',
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint('Error mostrando notificación: $e');
    }
  }

  Future<void> vibrarAlertaLarga() async {
    try {
      final bool tieneVibrador = await Vibration.hasVibrator();
      if (tieneVibrador) {
        final bool soportePersonalizado =
            await Vibration.hasCustomVibrationsSupport();
        if (soportePersonalizado) {
          await Vibration.vibrate(
            pattern: <int>[0, 600, 250, 1200],
            intensities: <int>[0, 255, 0, 255],
          );
        } else {
          await Vibration.vibrate(duration: 1500);
        }
      }
    } catch (e) {
      debugPrint('Error activando vibración: $e');
    }
  }
}
