import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_screen.dart';
import 'constants/theme.dart';
import 'providers/card_provider.dart';
import 'services/local_storage_service.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  
  final syncService = SyncService(localStorageService);
  await syncService.init();
  
  runApp(MyApp(
    localStorageService: localStorageService,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final SyncService syncService;

  const MyApp({
    super.key,
    required this.localStorageService,
    required this.syncService,
  });

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
      ],
      child: MaterialApp(
        title: 'Swift Cards',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppTheme.primaryColor,
            secondary: AppTheme.secondaryColor,
            error: AppTheme.errorColor,
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
