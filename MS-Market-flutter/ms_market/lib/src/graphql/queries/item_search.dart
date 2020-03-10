const String dormitoryItemSearch = r'''
  query DormitoryItemsSearch(
    $query: String!,
    $limit: Int!,
    $dormitories: [String!]
  ){
    dormitoryItemsSearch(
      query: $query,
      limit: $limit,
      dormitories: $dormitories
    ) {
      dormitory
      results {
        score
        item {
          __typename
          id
          name
          description
          itemCategory
          contractCategory
          owner {
            name
            surname
            dormitory
            room
          }
        }
      }
    }
  }
''';