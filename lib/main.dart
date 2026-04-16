import 'package:flutter/material.dart';
import 'package:thirstyseed/subscription/presentation/select_plan_screen.dart';
import 'iam/presentation/login_screen.dart';
import 'iam/application/auth_service.dart';
import 'iam/infrastructure/data_sources/user_data_source.dart';

void main() {
  final authService = AuthService(dataSource: UserDataSource());
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thirsty Seed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoginScreen(authService: authService),
      onGenerateRoute: (settings) {
        if (settings.name == '/selectPlan') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args['userId'] != null) {
            return MaterialPageRoute(
              builder: (context) => SelectPlanScreen(userId: args['userId']),
            );
          }
        }
        switch (settings.name) {
          default:
            return MaterialPageRoute(builder: (_) => LoginScreen(authService: authService));
        }
      },
    );
  }
}

