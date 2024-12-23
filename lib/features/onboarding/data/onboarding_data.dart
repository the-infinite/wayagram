class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

final List<OnboardingData> onboardingViewData = [
  OnboardingData(
    title: 'Stream, Chat and Stay \n Connected',
    description: 'Share moments, comment, and connect \n with friends',
    image: 'assets/images/onboarding/o-first.png',
  ),
  OnboardingData(
    title: 'Discover a Unique Social \n MarketPlace',
    description:
        'Browse Products, Services, and exclusive \n deals in our marketplace',
    image: 'assets/images/onboarding/o-second.png',
  ),
  OnboardingData(
    title: 'Secure Payment with Wallet \n Services',
    description:
        'Fund your wallet, send money, and manage \n transactions easily',
    image: 'assets/images/onboarding/o-third.png',
  ),
];
