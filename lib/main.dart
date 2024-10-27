import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_todos_app/features/auth/data/repositories/shared_preferences_repository_impl.dart';
import 'package:flutter_todos_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_todos_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_todos_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_todos_app/features/auth/presentation/pages/onboarding_page.dart';
import 'package:flutter_todos_app/common/di/injection_container.dart';
import 'package:flutter_todos_app/common/di/injection_container.dart' as di;
import 'package:flutter_todos_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_todos_app/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:flutter_todos_app/features/todo/presentation/pages/home_page.dart';
import 'package:flutter_todos_app/features/todo/presentation/pages/todo_details_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await di.init();

  // Retrieve SharedPreferencesService to check if onboarding has been viewed
  final sharedPreferencesRepository = getIt<SharedPreferencesRepositoryImpl>();
  final onboardingViewed =
      await sharedPreferencesRepository.isOnboardingViewed();

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
