import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/ads/presentation/bloc/ad_bloc.dart';
import 'package:omni_ledger/features/ads/presentation/bloc/ad_event.dart';
import 'package:omni_ledger/features/ads/presentation/bloc/ad_state.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AdBloc>().add(const LoadBannerAdEvent());
      }
    });
  }

  void _loadAd() {
    context.read<AdBloc>().add(const LoadBannerAdEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdBloc, AdState>(
      listener: (context, state) {
        debugPrint('[Ads] AdState changed to: ${state.runtimeType}');
      },
      child: BlocBuilder<AdBloc, AdState>(
        builder: (context, state) {
          if (state is AdLoaded) {
            final ad = state.bannerAd;
            final size = ad.size;
            debugPrint('[Ads] Rendering AdLoaded banner '
                '(${size.width.toInt()}x${size.height.toInt()}).');
            return ColoredBox(
              color: Colors.white,
              child: Center(
                child: SizedBox(
                  width: size.width.toDouble(),
                  height: size.height.toDouble(),
                  child: AdWidget(ad: ad),
                ),
              ),
            );
          }

          if (state is AdLoading) {
            return Container(
              width: double.infinity,
              height: 50,
              color: AppConstants.containerColor,
              alignment: Alignment.center,
              child: Text(
                'Ad loading…',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.neutralColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          if (state is AdFailed) {
            if (kDebugMode) {
              return GestureDetector(
                onTap: _loadAd,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppConstants.containerColor,
                    border: Border.all(color: AppConstants.dangerColor),
                  ),
                  child: const Text(
                    'Banner ad unavailable · tap to retry',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.dangerColor,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}