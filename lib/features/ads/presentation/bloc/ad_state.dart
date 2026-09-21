import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdState {
  const AdState();
}

class AdInitial extends AdState {
  const AdInitial();
}

class AdLoading extends AdState {
  const AdLoading();
}

class AdLoaded extends AdState {
  final BannerAd bannerAd;

  const AdLoaded(this.bannerAd);
}

class AdFailed extends AdState {
  const AdFailed();
}