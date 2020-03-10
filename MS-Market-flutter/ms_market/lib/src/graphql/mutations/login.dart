const String login = r'''
  mutation Login($code: String!) {
    login(code: $code) {
      __typename
      token
      tokenType
      ttl
    }
  }
''';