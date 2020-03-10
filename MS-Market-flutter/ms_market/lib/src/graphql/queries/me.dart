const String meInfo = r'''
  query MeInfo() {
    me {
      __typename
      id
      name
      surname
      dormitory
      room
      email
    }
  }
''';

const String meRecentReviews = r'''
  query RecentReviews($limit: Int!) {
    me {
      recentReviews(limit: $limit) {
        __typename
        id
        item {
          __typename
          id
          name
        }
        rating {
          __typename
          description
          value
        }
      }
    }
  }
''';

const String meBorrowedItems = r''' 
  query BorrowedItems(
    $limit: Int!,
    $statuses: [BorrowStatus!]!
  ) {
     me {
      borrowRequests(filter: {limit: $limit, statuses: $statuses}) {
        __typename
        id
        status
        createdAt
        updatedStatusAt
        item {
          id
          name
          description
          owner {
            id
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