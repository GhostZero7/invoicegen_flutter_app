import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invoicegen_flutter_app/core/constants/api_endpoints.dart';

class GraphQLConfig {
  final SharedPreferences _prefs;

  GraphQLConfig(this._prefs);

  HttpLink get httpLink =>
      HttpLink('${ApiEndpoints.baseUrl}${ApiEndpoints.graphql}');

  AuthLink get authLink {
    return AuthLink(
      getToken: () async {
        final token = _prefs.getString('access_token');
        return token == null ? null : 'Bearer $token';
      },
    );
  }

  Link get link => authLink.concat(httpLink);

  GraphQLClient getClient() {
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  ValueNotifier<GraphQLClient> initClient() {
    return ValueNotifier(getClient());
  }
}
