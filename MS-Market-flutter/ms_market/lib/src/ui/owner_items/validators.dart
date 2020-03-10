class Validators {
  static final validName = RegExp(r'^^.{3,50}$');
  static final validDescription = RegExp(r'^.{10,200}$');

  String validateItemName(String nickname) {
    if (!validName.hasMatch(nickname)) {
      return "Nazwa musi mieć od 3 do 50 liter";
    }
    return null;
  }

  String validateDescription(String description) {
    if (!validDescription.hasMatch(description)) {
      return "Opis musi mieć od 10 do 200 znaków";
    }
    return null;
  }
}