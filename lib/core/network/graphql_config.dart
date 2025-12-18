import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:invoicegen_flutter_app/core/constants/api_endpoints.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.graphql}',
  );

  static ValueNotifier<GraphQLClient> initClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which handles caching.
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    return client;
  }

  static GraphQLClient getClient() {
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
