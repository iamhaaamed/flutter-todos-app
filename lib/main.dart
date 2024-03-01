import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_todos_app/di/injection_container.dart';
import 'package:flutter_todos_app/screens/home_page.dart';
import 'package:flutter_todos_app/screens/onboarding_page.dart';
import 'package:flutter_todos_app/di/injection_container.dart' as di;
import 'package:flutter_todos_app/services/shared_preferences_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await di.init();

  // Retrieve SharedPreferencesService to check if onboarding has been viewed
  final sharedPreferencesService = getIt<SharedPreferencesService>();
  final onboardingViewed = await sharedPreferencesService.isOnboardingViewed();

  runApp(MyApp(onboardingViewed: onboardingViewed));

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool onboardingViewed;

  const MyApp({super.key, required this.onboardingViewed});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: onboardingViewed ? const HomePage() : const OnboardingPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
    );
  }
}
