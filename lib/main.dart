import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'core/network/auth_api.dart';
import 'features/auth/application/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthApi('http://10.239.85.112:8000/api/auth'), // TODO: Set base URL
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'POSEA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)),
      routerConfig: AppRouter.router,
    );
  }
}
