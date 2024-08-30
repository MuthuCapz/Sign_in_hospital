import 'package:flutter/material.dart';
import 'package:signin/screens/signin_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              OnboardingPage(
                image: 'assets/images/onboarding11.png',
                title: 'Keep patients records along with you!',
                description:
                    'Lorem ipsum dolor sit amet consectetur. Cras in convallis in dignissim orci tempus quam praesent. Tincidunt est tristique ut interdum nec et et ornare est. Ultricies potenti nisl non consectetur nulla lobortis orci tortor elit. Ac felis ullamcorper sapien amet in tortor aliquam.',
              ),
              OnboardingPage(
                image: 'assets/images/onboarding22.png',
                title: 'Schedule appointments in less than 1 minute!',
                description:
                    'Lorem ipsum dolor sit amet consectetur. Cras in convallis in dignissim orci tempus quam praesent. Tincidunt est tristique ut interdum nec et et ornare est. Ultricies potenti nisl non consectetur nulla lobortis orci tortor elit. Ac felis ullamcorper sapien amet in tortor aliquam.',
              ),
              OnboardingPage(
                image: 'assets/images/onboarding33.png',
                title: 'Never miss an appointment Now!',
                description:
                    'Lorem ipsum dolor sit amet consectetur. Cras in convallis in dignissim orci tempus quam praesent. Tincidunt est tristique ut interdum nec et et ornare est. Ultricies potenti nisl non consectetur nulla lobortis orci tortor elit. Ac felis ullamcorper sapien amet in tortor aliquam.',
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (_currentPage == 2) {
                  // Navigate to SignInPage if on the last page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                } else {
                  // Otherwise, move to the next page
                  _controller.nextPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Backward Arrow Icon only on 2nd and 3rd pages
          _currentPage > 0
              ? IconButton(
                  onPressed: () {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                )
              : SizedBox(width: 60), // Placeholder to maintain alignment
          Row(
            children: [
              _buildDotIndicator(0),
              _buildDotIndicator(1),
              _buildDotIndicator(2),
            ],
          ),
          IconButton(
            onPressed: () {
              if (_currentPage == 2) {
                // Navigate to SignInPage if on the last page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              } else {
                // Otherwise, move to the next page
                _controller.nextPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(), // Add a Spacer to push content downwards
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Spacer(), // Add another Spacer to balance the content
        ],
      ),
    );
  }
}
