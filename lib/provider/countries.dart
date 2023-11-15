import 'package:flutter/foundation.dart';
import '../model/country.dart';

class CountryProvider extends ChangeNotifier {
  List<Country> _countries = [];

  List<Country> get countries => _countries;

  Future<void> getCountries() async {
    final countries = [
      Country(name: 'Afghanistan', flagUrl: 'https://flagcdn.com/24x18/af.png'),
      Country(name: 'Austria', flagUrl: 'https://flagcdn.com/24x18/at.png'),
      Country(name: 'Germany', flagUrl: 'https://flagcdn.com/24x18/de.png'),
      Country(name: 'Sweden', flagUrl: 'https://flagcdn.com/24x18/ax.png'),
      Country(name: 'Serbia', flagUrl: 'https://flagcdn.com/24x18/se.png'),
    ];

    _countries = countries;
    notifyListeners();
  }
}
