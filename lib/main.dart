import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicegen_flutter_app/injection_container.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:invoicegen_flutter_app/core/network/graphql_config.dart';
import 'package:invoicegen_flutter_app/core/theme/app_theme.dart';
import 'package:invoicegen_flutter_app/presentation/cubit/theme_cubit.dart';
import 'package:invoicegen_flutter_app/presentation/pages/auth/login_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/splash/splash_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/onboarding_welcome_screen.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_event.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_state.dart';
import 'package:invoicegen_flutter_app/domain/repositories/auth_repository.dart';
import 'package:invoicegen_flutter_app/presentation/pages/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final clientNotifier = ValueNotifier(getIt<GraphQLClient>());
    final prefs = getIt<SharedPreferences>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit(prefs)),
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = AuthBloc(getIt<AuthRepository>());
            // Check if user is already logged in
            authBloc.add(const CheckAuthEvent());
            return authBloc;
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return GraphQLProvider(
            client: clientNotifier,
            child: MaterialApp(
              title: 'InvoiceGen',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  print('Current Auth State: ${state.runtimeType}');

                  if (state is AuthAuthenticated) {
                    // User is logged in, show dashboard
                    return const DashboardScreen();
                  } else if (state is AuthUnauthenticated) {
                    // Check if user has seen onboarding
                    final hasSeenOnboarding =
                        prefs.getBool('has_seen_onboarding') ?? false;

                    if (!hasSeenOnboarding) {
                      // Show onboarding for first-time users
                      return const OnboardingWelcomeScreen();
                    } else {
                      // Show login screen for returning users
                      return const LoginScreen();
                    }
                  } else if (state is AuthLoading) {
                    return const SplashScreen(
                      message: 'Checking authentication...',
                    );
                  } else if (state is AuthError) {
                    // Handle error state
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            Text('Error: ${state.message}'),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  const CheckAuthEvent(),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // AuthInitial or unknown state
                    return const SplashScreen();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
