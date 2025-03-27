import 'package:flutter/material.dart';
import 'text_encryption_screen.dart';
import 'image_encryption_screen.dart';
import 'secure_chat_screen.dart';
import 'file_checker_screen.dart';
import 'authentication_screen.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    AuthenticationScreen(),
    TextEncryptionScreen(),
    ImageEncryptionScreen(),
    SecureChatScreen(),
    FileCheckerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Authentication',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Text Encryption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image Encryption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Secure Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'File Checker',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Our App!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Explore the features below:',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextEncryptionScreen()),
                    );
                  },
                  icon: Icon(Icons.security),
                  label: Text('Text Encryption/Decryption'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageEncryptionScreen()),
                    );
                  },
                  icon: Icon(Icons.image),
                  label: Text('Image Encryption'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecureChatScreen()),
                    );
                  },
                  icon: Icon(Icons.chat),
                  label: Text('Secure Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FileCheckerScreen()),
                    );
                  },
                  icon: Icon(Icons.check),
                  label: Text('File Checker'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}