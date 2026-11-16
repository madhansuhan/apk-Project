import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Persistent Local Storage Service
  final storageService = await StorageService.getInstance();
  
  // Initialize Core Services
  final apiService = ApiService();
  final authService = AuthService(storageService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(apiService, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(storageService),
        ),
      ],
      child: const SankarConnectApp(),
    ),
  );
}

class SankarConnectApp extends StatelessWidget {
  const SankarConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
