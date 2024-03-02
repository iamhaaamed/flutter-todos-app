import 'package:flutter/material.dart';
import 'package:flutter_todos_app/common/styles/color_palettes.dart';
import 'package:flutter_todos_app/di/injection_container.dart';
import 'package:flutter_todos_app/screens/login_page.dart';
import 'package:flutter_todos_app/services/shared_preferences_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final SharedPreferencesService _sharedPreferencesService =
      getIt<SharedPreferencesService>();

  final PageController _controller = PageController();
  final int _numPages = 3;
  int _currentPage = 0;

  void _completeOnboardingAndNavigateToHome(BuildContext context) {
    _sharedPreferencesService.setOnboardingViewed(true);
    Navigator.pushReplacementNamed(
      context,
      LoginPage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _numPages,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color:
                      index % 2 == 0 ? ColorPalettes.blue : ColorPalettes.green,
                  child: Center(
                    child: Text(
                      'Page ${index + 1}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: ColorPalettes.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: _controller,
            count: _numPages,
            effect: const ExpandingDotsEffect(
                // dotColor: Colors.grey,
                // activeDotColor: Colors.blue,
                // dotHeight: 12,
                // dotWidth: 12,
                // spacing: 8,
                // expansionFactor: 2,
                ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Go to the next page
              if (_currentPage < _numPages - 1) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              } else {
                _completeOnboardingAndNavigateToHome(context);
              }
            },
            child: Text(
              _currentPage < _numPages - 1 ? 'Next Page' : 'Done',
            ),
          ),
          Opacity(
            opacity: _currentPage != 2 ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _completeOnboardingAndNavigateToHome(context);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: ColorPalettes.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
