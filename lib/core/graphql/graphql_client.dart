import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/app_constants.dart';

part 'graphql_client.g.dart';

@riverpod
GraphQLClient graphQLClient(GraphQLClientRef ref) {
  final httpLink = HttpLink(
    AppConstants.githubGraphQLUrl,
    defaultHeaders: {
      'Authorization': 'bearer ${AppConstants.githubToken}',
      'Content-Type': 'application/json',
    },
  );

  final cache = GraphQLCache(store: InMemoryStore());

  return GraphQLClient(
    link: httpLink,
    cache: cache,
    defaultPolicies: DefaultPolicies(
      query: Policies(
        fetch: FetchPolicy.cacheFirst,
      ),
    ),
  );
}
