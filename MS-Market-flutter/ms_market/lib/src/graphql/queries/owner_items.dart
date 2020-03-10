const String ownerItemList = r'''
  query OwnerItems() {
    me {
      __typename
      items {
        __typename
        id
        name
        description
        createdAt
        expiresAt
        itemCategory
        contractCategory
        summary {
          __typename
          average
        }
      }
    }
  }
''';

const String ownerItemDetailed = r'''
  query OwnerItemDetailed($itemId: String!) {
    item(id: $itemId) {
      __typename
      id
      name
      description
      createdAt
      expiresAt
      itemCategory
      contractCategory
      imageToken {
        id
        itemId
        token
      }
      ratings {
        __typename
        id
        description
        user {
          id
          name
          surname
        }
        value
      }
      summary {
        average
        count
        counts {
          count
          value
        }
      }
      borrowRequests {
        id
        status
        user {
          id
          name
          surname
        }
        createdAt
        updatedStatusAt
      }
    }
  }
''';