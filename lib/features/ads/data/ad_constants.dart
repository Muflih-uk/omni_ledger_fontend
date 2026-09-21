import 'package:flutter/foundation.dart';

class AdConstants {
  static const String appId = 'ca-app-pub-8642204998611566~9531094362';
  static const String bannerAdUnitId = 'ca-app-pub-8642204998611566/5975826882';
  static const String bannerAdUnitIdTest = 'ca-app-pub-3940256099942544/6300978111';

  static const String androidEmulatorTestDevice = '33BE2250B43518CCDA7DE426D04EE231';

  static String get bannerAdUnitIdForEnvironment =>
      kDebugMode ? bannerAdUnitIdTest : bannerAdUnitId;
}