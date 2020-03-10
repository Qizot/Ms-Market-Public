

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsOfUse extends StatelessWidget {
  final TextStyle _header = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warunki korzystania z serwisu", style: TextStyle(color: Colors.grey[600])),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Text("Wstęp", style: _header),
            SizedBox(height: 10),
            Text(introduction),
            Divider(),
            Text("Jak to działa", style: _header),
            SizedBox(height: 10),
            Text(usage),
            Divider(),
            Text("Warunki", style: _header),
            SizedBox(height: 10),
            Text(terms)
          ],
        )
      )
    );
  }
}


String introduction = '''
Aplikacja MS Market służy jako tablica ogłoszeniowa miasteczka studenckiego AGH
gdzie można udostępniać różnego rodzaju przedmioty innym studentom.
Użytkownik rejestruje przedmiot po czym inny użytkownik 
może go wyszukać oraz wysłać prośbę o wypożyczenie.
W planach jest również możliwość wystawienia przedmiotów na sprzedaż.
''';

String usage = '''
Ile razy zdarzyło ci się znaleźć post na grupie akademika, 
lub tudzież miasteczka studenckiego
gdzie ktoś szukał otwieracza do wina, miksera, jacuzzi?

Od teraz będziesz mógł zostać personalnym wybawicielem tych zbłąkanych dusz,
zajerestruj każdy przedmiot w twoim polu widzenia (który należy do ciebie) i 
oczekuj aż komuś się przyda.
''';

String terms = '''
Aplikacja pozyskuje dane o użytkownikach po przez
publiczne API miasteczka studenckiego AGH, 
które jest udostępniane przez firmę DSNET.

Logując się zgadzasz się na pobranie przez aplikację 
twoich danych dotyczących zakwaterowania 

na miasteczku studenckim oraz
zapisania ich w bazie danych w celu późniejszej 
autoryzacji z systemem aplikacji.

Do pobieranych danych należą:
- imię
- naziwsko
- email
- nummer akademika oraz pokój w którym jesteś zakwaterowany/na

Aplikacja nie ma dostępu do twojego loginu ani hasła, co zapewnia
właśnie korzystanie z miasteczkowego API.

W każdej chwili użytkownik może zadecydować o usunięciu swojego konta.
Usunięte zostaną wtedy wszystkie dane osobiste danego użytkownika oraz wszystkie
informacje, które aplikacja zdołała stworzyć o użytkowniku od momentu pierwszego logowania,
należą do nich m.in. dodane przedmioty, recencje, historia wypożyczeń.
''';