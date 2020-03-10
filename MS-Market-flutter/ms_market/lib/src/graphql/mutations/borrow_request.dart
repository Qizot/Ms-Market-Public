final String createBorrowRequets = r'''
  mutation CreateBorrowRequest(
    $itemId: ID!
  ) {
    createBorrowRequest(
      itemId: $itemId
    ) {
      __typename
      id
      item {
        __typename
        id
        name
        owner {
          __typename
          id
          name
          surname
          dormitory
          room
        }
      }
      status
      createdAt
      updatedStatusAt
    }
  }
''';

final String updateBorrowRequest = r'''
  mutation UpdateBorrowRequest(
    $borrowRequestId: ID!,
    $status: BorrowStatus!
  ) {
    updateBorrowRequest(
      borrowRequestId: $borrowRequestId,
      status: $status
    ) {
       __typename
      id
      item {
        __typename
        id
        name
        owner {
          __typename
          id
          name
          surname
          dormitory
          room
        }
      }
      status
      createdAt
      updatedStatusAt
    }
  }
''';