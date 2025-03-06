import 'package:in_app_review/in_app_review.dart';

class RateUsService {
  static final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview(); // ✅ Opens in-app review popup
    } else {
      await _inAppReview.openStoreListing(); // ✅ Opens Play Store or App Store
    }
  }
}
