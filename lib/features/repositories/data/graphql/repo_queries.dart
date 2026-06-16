const String getUserReposQuery = r'''
  query GetUserRepos($login: String!, $first: Int!, $after: String) {
    user(login: $login) {
      repositories(
        first: $first
        after: $after
        orderBy: { field: UPDATED_AT, direction: DESC }
        ownerAffiliations: OWNER
        privacy: PUBLIC
      ) {
        totalCount
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          name
          description
          url
          stargazerCount
          forkCount
          isPrivate
          updatedAt
          primaryLanguage {
            name
            color
          }
        }
      }
    }
  }
''';
