import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omni_ledger/features/ads/data/ad_constants.dart';
import 'package:omni_ledger/features/ads/presentation/bloc/ad_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/splash/presentation/bloc/splash_bloc.dart';

import 'app.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await MobileAds.instance.initialize();
  debugPrint('[Ads] Mobile Ads SDK initialized.');

  if (kDebugMode) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: [AdConstants.androidEmulatorTestDevice],
      ),
    );
    debugPrint('[Ads] Using test banner unit '
        '(id: ${AdConstants.bannerAdUnitIdTest}) in debug mode.');
  } else {
    debugPrint('[Ads] Using production banner unit '
        '(id: ${AdConstants.bannerAdUnitId}).');
  }

  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<ItemBloc>(create: (_) => di.sl<ItemBloc>()),
        BlocProvider<BillingBloc>(create: (_) => di.sl<BillingBloc>()),
        BlocProvider<HistoryBloc>(create: (_) => di.sl<HistoryBloc>()),
        BlocProvider<SplashBloc>(create: (_) => di.sl<SplashBloc>()),
        BlocProvider<AdBloc>(create: (_) => di.sl<AdBloc>()),
      ],
      child: const MyApp(),
    );
  }
}
