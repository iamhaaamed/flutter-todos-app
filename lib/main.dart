import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_todos_app/auth/data/service/shared_preferences_service.dart';
import 'package:flutter_todos_app/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_todos_app/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_todos_app/auth/presentation/view/login_page.dart';
import 'package:flutter_todos_app/auth/presentation/view/onboarding_page.dart';
import 'package:flutter_todos_app/di/injection_container.dart';
import 'package:flutter_todos_app/di/injection_container.dart' as di;
import 'package:flutter_todos_app/profile/presentation/view/profile_page.dart';
import 'package:flutter_todos_app/todo/presentation/cubit/todo_cubit.dart';
import 'package:flutter_todos_app/todo/presentation/view/home_page.dart';
import 'package:flutter_todos_app/todo/presentation/view/todo_details_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await di.init('http://localhost:3000/');

  // Retrieve SharedPreferencesService to check if onboarding has been viewed
  final sharedPreferencesService = getIt<SharedPreferencesService>();
  final onboardingViewed = await sharedPreferencesService.isOnboardingViewed();

  runApp(MyApp(onboardingViewed: onboardingViewed));

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool onboardingViewed;

  const MyApp({super.key, required this.onboardingViewed});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<TodosCubit>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            // if (state is AuthState ) {
            //   return const MyAppWithBottomNavigationBar();
            // } else {
            //   return const OnboardingPage();
            // }
            return const MyAppWithBottomNavigationBar();
          },
        ),
        routes: {
          '/onboarding': (context) => const OnboardingPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/todoDetails': (context) => const TodoDetailsPage(),
        },
      ),
    );
  }
}

class MyAppWithBottomNavigationBar extends StatefulWidget {
  const MyAppWithBottomNavigationBar({super.key});

  @override
  _MyAppWithBottomNavigationBarState createState() =>
      _MyAppWithBottomNavigationBarState();
}

class _MyAppWithBottomNavigationBarState
    extends State<MyAppWithBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
