const String getUser = r'''
  query GetUser($userId: String!) {
    user(id: $userId) {
      __typename
      id
      name
      surname
      email
      dormitory
      room
    }
  }
''';