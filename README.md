# 📱 Flutter Billing App (Clean Architecture + BLoC)

This project follows a **scalable, feature-first Clean Architecture** using:

* BLoC (State Management)
* Dio (API client)
* SharedPreferences (Local storage)
* GetIt (Dependency Injection)
* go_router (Routing)

---

# 📁 Project Structure

```
lib/
│
├── core/                     # Shared/common logic (global)
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │
│   ├── error/
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── dio_interceptors.dart
│   │
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │
│   ├── storage/
│   │   ├── local_storage.dart   # SharedPreferences wrapper
│   │
│   └── theme/
│       ├── app_theme.dart
│
├── features/                 # Feature-based modules
│
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   ├── usecases/
│   │   │       └── login_usecase.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   ├── pages/
│   │   │   │   └── login_page.dart
│   │   │   ├── widgets/
│
│   ├── items/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│
│   ├── billing/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── bill_model.dart
│   │   │   │   └── bill_item_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── billing_remote_datasource.dart
│   │   │   ├── repositories/
│   │   │       └── billing_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── bill.dart
│   │   │   │   └── bill_item.dart
│   │   │   ├── usecases/
│   │   │       ├── create_bill.dart
│   │   │       ├── get_bills.dart
│   │   │
│   │   ├── presentation/
│   │       ├── bloc/
│   │       │   ├── billing_bloc.dart
│   │       │   ├── billing_event.dart
│   │       │   └── billing_state.dart
│   │       ├── pages/
│   │       │   ├── billing_page.dart
│   │       │   └── billing_summary_page.dart
│
│   ├── history/              # 🔥 Your new feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── history_remote_datasource.dart
│   │   │   ├── repositories/
│   │   │       └── history_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── usecases/
│   │   │       └── get_history.dart
│   │   │
│   │   ├── presentation/
│   │       ├── bloc/
│   │       │   ├── history_bloc.dart
│   │       │   ├── history_event.dart
│   │       │   └── history_state.dart
│   │       ├── pages/
│   │       │   └── history_page.dart
│   │       ├── widgets/
│   │           ├── history_tabs.dart
│   │           └── filter_widget.dart
│
├── injection_container.dart  # Dependency Injection (VERY IMPORTANT)
├── main.dart
```

---

# ❌ Error Handling

```dart
class ServerException implements Exception {}
class CacheException implements Exception {}

class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
```

---

# 🧰 Utils

```dart
class Validators {
  static String? validatePhone(String value) {
    if (value.isEmpty) return 'Phone required';
    return null;
  }
}

class DateUtilsHelper {
  static String format(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
```


---

# 🔌 Dependency Injection (GetIt)

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  // Core
  sl.registerLazySingleton(() => LocalStorage(sl()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // Interceptor
  sl.registerLazySingleton(() => AppInterceptor(sl()));

  // Attach interceptor
  sl<Dio>().interceptors.add(sl<AppInterceptor>());

  // Example Bloc
  sl.registerFactory(() => AuthBloc());
}
```

---

# ⚙️ How Dependency Injection Works

1. `GetIt` acts as a **service locator**.
2. All dependencies are registered in `init()`.
3. You can access anywhere using:

```dart
final dio = sl<DioClient>();
```

### Types:

* `registerLazySingleton` → one instance (shared)
* `registerFactory` → new instance every time

---

# 🚦 Routing using go_router

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => HistoryPage(),
    ),
  ],
);
```

### Usage in App:

```dart
MaterialApp.router(
  routerConfig: router,
);
```

### Navigation:

```dart
context.go('/home');
```

---

# 🔁 How Everything Connects

1. UI → triggers BLoC event
2. BLoC → calls UseCase
3. UseCase → calls Repository
4. Repository → calls Dio (API)
5. Response → back to UI via BLoC state

---

# ✅ Best Practices

* Keep UI clean (no business logic)
* Use BLoC for all state handling
* Centralize API logic in Dio
* Use interceptors for auth
* Use DI everywhere (no manual object creation)

---

# 🚀 Future Improvements

* Add Hive for offline caching
* Add pagination in history
* Add unit testing
* Add dark mode

---

**You now have a production-ready scalable Flutter architecture 🚀**
