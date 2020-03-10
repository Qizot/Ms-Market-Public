final String deleteAccount = r'''
  mutation DeleteAccount($userId: ID!) {
    deleteUser(deleteMyself: true, userId: $userId) {
      deletedUserId
    }
  }
''';