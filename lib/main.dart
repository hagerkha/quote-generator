import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment('dart.vm.product'),
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Rajdhani',
        ),
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<String> _quotes = [
    "All I required to be happy was friendship and people I could admire.",
  ];
  List<String> _favoriteQuotes = [];

  void _nextQuote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newQuote = "";
        return AlertDialog(
          title: Text('Enter New Quote'),
          content: TextField(
            onChanged: (value) {
              newQuote = value;
            },
            decoration: InputDecoration(hintText: "Type your quote here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newQuote.isNotEmpty) {
                  setState(() {
                    _quotes.add(newQuote);
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _toggleFavorite(String quote) {
    setState(() {
      if (_favoriteQuotes.contains(quote)) {
        _favoriteQuotes.remove(quote);
      } else {
        _favoriteQuotes.add(quote);
      }
    });
  }

  void _goToFavoritesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteQuotesScreen(
          favoriteQuotes: _favoriteQuotes,
          toggleFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff7800FFF),
              Color(0xFF7c44bb),
              Color(0xFF8844bc),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: _goToFavoritesPage,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${_favoriteQuotes.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _goToFavoritesPage,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFcdbbf1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple),
                  ),
                  child: Center(
                    child: Text(
                      'Click here to view favorite quotes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _quotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _quotes[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _nextQuote,
                              child: Text('Generate other quote'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.purple, // لون النص
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _favoriteQuotes.contains(_quotes[index])
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.purple,
                                ),
                                onPressed: () => _toggleFavorite(_quotes[index]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteQuotesScreen extends StatefulWidget {
  final List<String> favoriteQuotes;
  final Function(String) toggleFavorite;

  FavoriteQuotesScreen({
    required this.favoriteQuotes,
    required this.toggleFavorite,
  });

  @override
  _FavoriteQuotesScreenState createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredQuotes = [];

  @override
  void initState() {
    super.initState();
    _filteredQuotes = widget.favoriteQuotes;
  }

  void _filterQuotes(String query) {
    setState(() {
      _filteredQuotes = widget.favoriteQuotes
          .where((quote) => quote.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
        Color(0xff7800FFF),
    Color(0xFF7c44bb),
    Color(0xFF8844bc),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: GestureDetector(
    onTap: () {
    Navigator.pop(context); // للعودة إلى الشاشة الرئيسية
    },
    child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Color(0xFFcdbbf1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.purple),
    ),
    child: Center(
    child: Text(
    'BACK TO HOME SCREEN',
    style: TextStyle(
    fontSize: 18,
    color: Colors.black,
    ),
    ),
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
    controller: _searchController,
    onChanged: _filterQuotes,
    decoration: InputDecoration(
    hintText: 'Type something here to search',
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.search),
    ),
    ),
    ),
    Expanded(
    child: ListView.builder(
    itemCount: _filteredQuotes.length,
    itemBuilder: (context, index) {
    return Container(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.purple),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Text(
    _filteredQuotes[index],
    style: TextStyle(fontSize: 18),
    textAlign: TextAlign.center,
    ),
    SizedBox(height: 8),
    ElevatedButton(
    onPressed: () {
    widget.toggleFavorite(_filteredQuotes[index]);
    setState(() {
    _filteredQuotes = widget.favoriteQuotes
        .where((quote) => quote.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
    });
    },
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Icon(
    Icons.favorite_border,
    color: Colors.purple,
    ),
    SizedBox(width: 4),
    Text(
    'Remove from Favorites',
    style: TextStyle(color: Colors.purple),
    ),
    ],

    ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
    ),
    ],
    ),
    );
    },
    ),
    ),
    ],
    ),
        ),
    );
  }
}
