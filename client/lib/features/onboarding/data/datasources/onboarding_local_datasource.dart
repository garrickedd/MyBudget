import 'package:mybudget/features/onboarding/data/models/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> checkIfFirstLaunch();
  Future<void> setOnboardingCompleted();
  List<OnboardingModel> getOnboardingData();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> checkIfFirstLaunch() async {
    return sharedPreferences.getBool('onboarding_completed') ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool('onboarding_completed', true);
  }

  @override
  List<OnboardingModel> getOnboardingData() {
    return [
      OnboardingModel(
        image: 'assets/images/onboarding1.png',
        title: 'Quản lý tài chính thông minh',
        description:
            'Ứng dụng giúp bạn quản lý chi tiêu theo phương pháp 6 hũ hiệu quả',
      ),
      OnboardingModel(
        image: 'assets/images/onboarding2.png',
        title: 'Phân bổ ngân sách',
        description:
            'Dễ dàng phân chia thu nhập vào các hũ theo tỷ lệ bạn mong muốn',
        footer: 'Tối ưu hóa ngân sách cá nhân',
      ),
      OnboardingModel(
        image: 'assets/images/onboarding3.png',
        title: 'Theo dõi chi tiêu',
        description:
            'Thống kê và báo cáo chi tiết giúp bạn hiểu rõ dòng tiền của mình',
      ),
    ];
  }
}
