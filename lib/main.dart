import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swift_cards/models/loyalty_card.dart';
import 'package:swift_cards/models/notification_model.dart';
import 'package:swift_cards/providers/card_provider.dart';
import 'package:swift_cards/providers/notification_provider.dart';
import 'package:swift_cards/screens/home_screen.dart';
import 'package:swift_cards/services/local_storage_service.dart';
import 'package:swift_cards/services/notification_service.dart';
import 'package:swift_cards/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(LoyaltyCardAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  
  // Open boxes
  await Hive.openBox<LoyaltyCard>('loyalty_cards');
  await Hive.openBox<NotificationModel>('notifications');
  
  // Initialize services
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  final notificationService = NotificationService(localStorageService);
  final syncService = SyncService(localStorageService);
  
  // Initialize notifications
  await notificationService.init();
  
  runApp(MyApp(
    localStorageService: localStorageService,
    notificationService: notificationService,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final NotificationService notificationService;
  final SyncService syncService;

  const MyApp({
    Key? key,
    required this.localStorageService,
    required this.notificationService,
    required this.syncService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CardProvider(
            localStorageService: localStorageService,
            syncService: syncService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(notificationService),
        ),
      ],
      child: MaterialApp(
        title: 'Swift Cards',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
