final String incomingBorrowRequests = r'''
  query IncomingBorrowRequests(
    $limit: Int!,
    $statuses: [BorrowStatus!]!
  ) {
    incomingBorrowRequests(
      limit: $limit,
      statuses: $statuses
    ) {
      __typename
      id
      status
      updatedStatusAt
      createdAt
      item {
        id
        name
        owner {
          id
          name
          surname
          dormitory
          room
        }
      }
      user {
        id
        name
        surname
      }
    }
  }
''';