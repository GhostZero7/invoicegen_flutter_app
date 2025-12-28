import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:invoicegen_flutter_app/core/network/graphql_config.dart';
import 'package:invoicegen_flutter_app/data/repositories/auth_repository.dart';
import 'package:invoicegen_flutter_app/domain/repositories/auth_repository.dart'
    as domain_auth;
import 'package:invoicegen_flutter_app/data/repositories/user_repository.dart';
import 'package:invoicegen_flutter_app/data/repositories/business_repository.dart';
import 'package:invoicegen_flutter_app/data/repositories/invoice_repository.dart';
import 'package:invoicegen_flutter_app/data/repositories/client_repository.dart';
import 'package:invoicegen_flutter_app/data/repositories/product_repository.dart';
import 'package:invoicegen_flutter_app/core/network/connection_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Dio client
  getIt.registerSingleton<Dio>(Dio());

  // GraphQL Client
  final gqlConfig = GraphQLConfig(sharedPreferences);
  getIt.registerSingleton<GraphQLClient>(gqlConfig.getClient());

  // Services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(sharedPreferences, getIt<GraphQLClient>()),
  );
  getIt.registerLazySingleton<ConnectionService>(
    () => ConnectionService(getIt<ApiService>()),
  );

  // Repositories - Register implementation with domain interface
  getIt.registerLazySingleton<domain_auth.AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<BusinessRepository>(
    () => BusinessRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<ApiService>()),
  );

  // BLoCs will be registered here when created
}
