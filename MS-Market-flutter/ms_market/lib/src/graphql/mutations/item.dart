const String createItem = r'''
  mutation CreateItem(
    $ownerId: ID!
    $name: String!,
    $description: String!,
    $contractCategory: ContractCategory!
    $itemCategory: ItemCategory!,
    $expiresAt: String
  ) {
    createItem(
      ownerId: $ownerId,
      name: $name,
      description: $description,
      contractCategory: $contractCategory,
      itemCategory: $itemCategory,
      expiresAt: $expiresAt
    ) {
      __typename
      id
      name
      description
      createdAt
      expiresAt
      itemCategory
      contractCategory
      imageToken {
        token
      }
    }
  }
''';

const String updateItem = r'''
  mutation UpdateItem(
    $id: ID!
    $name: String,
    $description: String,
    $contractCategory: ContractCategory
    $itemCategory: ItemCategory,
    $expiresAt: String
  ) {
    updateItem(
      id: $id,
      name: $name,
      description: $description,
      contractCategory: $contractCategory,
      itemCategory: $itemCategory,
      expiresAt: $expiresAt
    ) {
      __typename
      id
      name
      description
      createdAt
      expiresAt
      itemCategory
      contractCategory
      imageToken {
        token
      }
    }
  }
''';

const String deleteItem = r'''
  mutation DeleteItem($itemId: ID!) {
    deleteItem(itemId: $itemId) {
      __typename
      id
    }
  }
''';