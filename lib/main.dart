import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:invoicegen_flutter_app/injection_container.dart';
import 'package:invoicegen_flutter_app/core/theme/app_theme.dart';
import 'package:invoicegen_flutter_app/presentation/cubit/theme_cubit.dart';
import 'package:invoicegen_flutter_app/presentation/pages/auth/login_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/splash/splash_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/onboarding_main_screen.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_event.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_state.dart';
import 'package:invoicegen_flutter_app/domain/repositories/auth_repository.dart';
import 'package:invoicegen_flutter_app/presentation/pages/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = getIt<SharedPreferences>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit(prefs)),
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = AuthBloc(getIt<AuthRepository>());
            authBloc.add(const CheckAuthEvent());
            return authBloc;
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final clientNotifier = ValueNotifier(getIt<GraphQLClient>());

          return GraphQLProvider(
            client: clientNotifier,
            child: Consumer(
              builder: (context, ref, child) {
                final onboardingState = ref.watch(onboardingProvider);

                return MaterialApp(
                  title: 'InvoiceGen',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.isDarkMode
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  home: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return const DashboardScreen();
                      } else if (state is AuthUnauthenticated) {
                        if (!onboardingState.isCompleted) {
                          return const OnboardingMainScreen();
                        } else {
                          return const LoginScreen();
                        }
                      } else if (state is AuthLoading) {
                        return const SplashScreen(
                          message: 'Checking authentication...',
                        );
                      } else if (state is AuthError) {
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
                                  onPressed: () => context.read<AuthBloc>().add(
                                    const CheckAuthEvent(),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SplashScreen();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
