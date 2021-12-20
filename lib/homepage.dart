import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';

Functions func = Functions();

List<Widget> pages = [AllItems(), BookMarkedItems()];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _index);
  }

  void onPageChanged(int page) {
    setState(() {
      _index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
        ],
      ),
      body: PageView(
        children: pages,
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}

class AllItems extends StatefulWidget {
  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  List<String> items = [];
  List<bool> bookmark = [];

  @override
  void initState() {
    Map<String, bool> book = func.bookmarks;

    items = book.keys.toList();
    bookmark = book.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Items"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              trailing: IconButton(
                onPressed: () async {
                  await func.update(
                      func.auth.currentUser!.email.toString(), items[index]);
                  setState(() {
                    bookmark[index] = !bookmark[index];
                    print(bookmark[index]);
                  });
                },
                icon: bookmark[index]
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border_outlined),
              ),
            );
          }),
    );
  }
}

class BookMarkedItems extends StatefulWidget {
  @override
  _BookMarkedItemsState createState() => _BookMarkedItemsState();
}

class _BookMarkedItemsState extends State<BookMarkedItems> {
  List<String> bookmarked = [];

  @override
  void initState() {
    Map<String, bool> book = func.bookmarks;

    bookmarked.clear();
    List<String> items = book.keys.toList();
    List<bool> bookmark = book.values.toList();
    for (int i = 0; i < items.length; i++) {
      if (bookmark[i]) bookmarked.add(items[i]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked Items"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: bookmarked.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bookmarked[index]),
            );
          }),
    );
  }
}
