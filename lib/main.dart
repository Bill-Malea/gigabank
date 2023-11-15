import 'package:flutter/material.dart';
import 'package:gigabank/model/address.dart';
import 'model/country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purple,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 17,
            )),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var address = Address(
    country: '',
    municipality: '',
    prefecture: "",
    apartment: '',
    streetAddress: '',
  );
  final TextEditingController countryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Country> dummyCountries = [
    Country(name: 'United States', flagUrl: 'https://example.com/us-flag.png'),
    Country(name: 'United Kingdom', flagUrl: 'https://example.com/uk-flag.png'),
    Country(name: 'Canada', flagUrl: 'https://example.com/canada-flag.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Address'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _showExitDialog(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please enter information as written on your ID document',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                _buildCountryInput(),
                const SizedBox(height: 16.0),
                _buildInputField('Prefecture', address.prefecture),
                const SizedBox(height: 16.0),
                _buildInputField('Municipality', address.municipality),
                const SizedBox(height: 16.0),
                _buildInputField('Street Address', address.streetAddress),
                const SizedBox(height: 16.0),
                _buildInputField('Apartment', address.apartment),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      print(address.country);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String value) {
    return TextFormField(
      initialValue: value,
      onChanged: (text) {
        setState(() {
          switch (label) {
            case 'Prefecture':
              address.prefecture = text;
              break;
            case 'Municipality':
              address.municipality = text;
              break;
            case 'Street Address':
              address.streetAddress = text;
              break;
            case 'Apartment':
              address.apartment = text;
              break;
          }
        });
      },
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 15, 194, 207), width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildCountryInput() {
    return Autocomplete<Country>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return dummyCountries
            .where((country) =>
                country.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()) ||
                country.flagUrl
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: (Country value) {
        setState(() {
          address.country = value.name;
          countryController.text = value.name;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Country',
            suffixIcon: Icon(Icons.search),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 15, 194, 207), width: 2.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a country';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 4.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final country = options.elementAt(index);

              return ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        country.flagUrl,
                        width: 24.0,
                        height: 24.0,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
                    ),
                    Text(country.name),
                    const SizedBox(width: 8.0),
                  ],
                ),
                onTap: () {
                  onSelected(country);
                },
              );
            },
          ),
        );
      },
    );
  }
}

Future<List<Country>> fetchData() async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    Country(
        name: 'United States', flagUrl: 'https://restcountries.com/v3/iso/USA'),
    Country(name: 'kenya', flagUrl: 'https://restcountries.com/v3/iso/USA'),
    Country(
        name: 'United States', flagUrl: 'https://restcountries.com/v3/iso/USA'),
  ];
}

void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Pop twice to exit the app
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      );
    },
  );
}
