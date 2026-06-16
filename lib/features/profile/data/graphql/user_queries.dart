const String getUserQuery = r'''
  query GetUser($login: String!) {
    user(login: $login) {
      avatarUrl
      name
      login
      bio
      company
      location
      followers {
        totalCount
      }
      following {
        totalCount
      }
      repositories(ownerAffiliations: OWNER) {
        totalCount
      }
    }
  }
''';
