

final String createItemRating = r'''
  mutation CreateItemRating(
    $itemId: ID!,
    $description: String!,
    $value: RatingValue!
  ) {
    rateItem(
      itemId: $itemId,
      description: $description,
      value: $value
    ) {
      __typename
      id
      description
      value
    }
  }
''';

final String updateItemRating = r'''
  mutation UpdateItemRating(
    $ratingId: ID!,
    $description: String!,
    $value: RatingValue!
  ) {
    updateItemRating(
      ratingId: $ratingId,
      description: $description,
      value: $value
    ) {
      __typename
      id
      description
      value
    }
  }
''';

final String deleteItemRating = r'''
  mutation DeleteItemRating(
    $ratingId: ID!
  ) {
    deleteItemRating(
      ratingId: $ratingId
    ) {
      __typename
      id
      description
      value
    }
  }
''';