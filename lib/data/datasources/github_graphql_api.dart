import 'package:flutter_interview/core/entities/repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GithubGraphQLApi {
  final GraphQLClient client;

  GithubGraphQLApi(this.client);

  Future<Map<String, dynamic>> fetchTrendingRepositories({int first = 20, String? after}) async {
    const String query = """
      query(\$first: Int, \$after: String) {
        search(query: "stars:>50", type: REPOSITORY, first: \$first, after: \$after) {
          edges {
            node {
              ... on Repository {
                name
                description
                primaryLanguage {
                  name
                }
              }
            }
          }
          pageInfo {
            endCursor
            hasNextPage
          }
        }
      }
    """;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(query),
      variables: {
        'first': first,
        'after': after,
      },
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    

    final List<Repository> repositories = (result.data?['search']['edges'] as List)
        .map((edge) => Repository(
              name: edge['node']['name'],
              description: edge['node']['description'],
              language: edge['node']['primaryLanguage']?['name'] ?? 'Unknown',
            ))
        .toList();

    final pageInfo = result.data?['search']['pageInfo'];

    return {
      'repositories': repositories,
      'endCursor': pageInfo['endCursor'],
      'hasNextPage': pageInfo['hasNextPage'],
    };
  }
}