import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Track Your Expenses",
          body:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          image: Center(
            child: Image.asset(
              "assets/images/track_expenses.png",
              height: 200,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.all(24),
          ),
        ),
        PageViewModel(
          title: "Set Budgets",
          body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
          image: Center(
            child: Image.asset(
              "assets/images/set_budgets.png",
              height: 200,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.all(24),
          ),
        ),
        PageViewModel(
          title: "Achieve Financial Goals",
          body: "Plan and save to reach your financial milestones faster.",
          image: Center(
            child: Image.asset(
              "assets/images/financial_goals.png",
              height: 200,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(fontSize: 16),
            imagePadding: EdgeInsets.all(24),
          ),
        ),
      ],
      onDone: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onSkip: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      showSkipButton: true,
      skip: Text(
        "Skip",
        style: TextStyle(color: Colors.purple),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.purple,
      ),
      done: const Text(
        "Done",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
