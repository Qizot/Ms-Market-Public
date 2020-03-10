

final String getForeignItem = r'''
  query GetForeignItem($itemId: ID!) {
    item(id: $itemId) {
      __typename
      id
      name
      description
      itemCategory
      contractCategory
      createdAt
      expiresAt
      owner {
        id
        name
        surname
        dormitory
        room
      }
      ratings {
        id
        user {
          id
          name
          surname
        }
        description
        value
      }
      summary {
        average
        count
      }
    }
  }
''';