import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showSimpleNotification() async {
    if (Platform.isAndroid) {
      final bool? granted =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();
      if (granted == false) {
        SnackBar(
          content: const Text('Permissão para notificações negada.'),
          duration: const Duration(seconds: 2),
        );
        return;
      }
    }
  }

     /// Muestra una notificación persistente mientras el cronómetro esté en funcionamiento
  Future<void> showRunningNotification(String elapsedTime) async {
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
      const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
                            'running_channel',
                            'Cronómetro en marcha',
        channelDescription: 'Notificación persistente mientras el cronómetro funciona',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true, 
        autoCancel: false,
        playSound: false,
        showWhen: false,
    );

     // const NotificationDetails platformChannelSpecifics = NotificationDetails(
    //   android: androidPlatformChannelSpecifics,
    // );
     const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

     await _flutterLocalNotificationsPlugin.show(
      1,
      'Cronómetro en ejecución',
      'Tiempo transcurrido: $elapsedTime',
      platformDetails,
    );
  }   

  Future<void> showLapNotification(String lapTime, String totalTime) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'lap_channel',
      'Vueltas',
      channelDescription: 'Notificaciones de vueltas registradas',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      2,
      'Nueva vuelta registrada',
      'Tiempo vuelta: $lapTime | Total: $totalTime',
      platformDetails,
    );
  }

  /// Notificación por si el cronómetro está pausado demasiado tiempo
  Future<void> showPauseReminder() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'pause_channel',
      'Recordatorio de pausa',
      channelDescription: 'Sugiere reanudar el cronómetro tras una pausa prolongada',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      3,
      '¿Deseas reanudar?',
      'El cronómetro lleva más de 10 segundos en pausa.',
      platformDetails,
    );
  }

  /// Cancela todas las notificaciones 
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

}


