import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omni_ledger/features/ads/data/ad_constants.dart';
import 'package:omni_ledger/features/ads/presentation/bloc/ad_event.dart';
import 'package:omni_ledger/features/ads/presentation/bloc/ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  AdBloc() : super(const AdInitial()) {
    on<LoadBannerAdEvent>(_loadBannerAd);
  }

  BannerAd? _bannerAd;
  bool _isLoading = false;
  int _loadAttempts = 0;
  Timer? _retryTimer;

  static const int _maxAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 4);

  Future<void> _loadBannerAd(
    LoadBannerAdEvent event,
    Emitter<AdState> emit,
  ) async {
    if (_isLoading) return;
    if (state is AdLoaded) return;
    if (_loadAttempts >= _maxAttempts) {
      debugPrint('[AdBloc] Max ad load attempts reached, giving up.');
      return;
    }

    _isLoading = true;
    _loadAttempts++;
    emit(const AdLoading());

    debugPrint('[AdBloc] Loading banner ad '
        '(unit: ${AdConstants.bannerAdUnitIdForEnvironment}, '
        'attempt: $_loadAttempts/$_maxAttempts)');

    final ad = BannerAd(
      adUnitId: AdConstants.bannerAdUnitIdForEnvironment,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('[AdBloc] Banner ad loaded.');
          _isLoading = false;
          _loadAttempts = 0;
          emit(AdLoaded(ad as BannerAd));
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdBloc] Banner ad failed to load: '
              'code=${error.code} message=${error.message}');
          ad.dispose();
          _isLoading = false;
          _bannerAd = null;

          if (_loadAttempts < _maxAttempts) {
            emit(const AdFailed());
            _retryTimer?.cancel();
            _retryTimer = Timer(_retryDelay, () {
              debugPrint('[AdBloc] Retrying banner ad load...');
              add(const LoadBannerAdEvent());
            });
          } else {
            emit(const AdFailed());
          }
        },
      ),
    );

    _bannerAd = ad;
    ad.load();
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    _bannerAd = null;
    return super.close();
  }
}