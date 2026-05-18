import 'package:flutter/material.dart';
import 'package:final_project/userLogin_screen.dart';
import 'package:final_project/wallet_page.dart';
import 'package:final_project/profile_page.dart';
import 'package:final_project/pay_page.dart';
import 'package:final_project/cards_page.dart';
import 'package:final_project/qr_code.dart';
import 'package:final_project/transfer_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeContent extends StatelessWidget {
  final String username;
  const HomeContent({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizedBox(height: 60)],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int userId;
  final String username;
  const HomePage({super.key, required this.userId, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _profileImage = null;
    _pages = [
      HomeContent(username: widget.username),
      WalletPage(userId: widget.userId),
      PayPage(),
      CardsPage(userId: widget.userId),
      ProfilePage(username: widget.username),
      TransferPage(userId: widget.userId),
    ];
    fetchProfileImage();
  }

  Future<void> fetchProfileImage() async {
    try {
      final url = Uri.parse(
        'https://mobilebanking-bankend-node-js.onrender.com/users/${widget.username}',
      );
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _profileImage = data['profileImage'];
        });
      }
    } catch (e) {
      print("Failed to fetch profile image: $e");
    }
  }

  Widget _buildQuickButton(IconData icon, String label) {
    return SizedBox(
      width: 150,
      height: 45,
      child: ElevatedButton(
        onPressed: () async {
          if (label == "QR Code") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QRCodePage(username: widget.username),
              ),
            );
          } else if (label == "Transfer") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransferPage(userId: widget.userId),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 200, 186, 206),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), SizedBox(width: 8), Text(label)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Vaultz",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: _currentIndex == 0
            ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white24,
                            backgroundImage:
                                _profileImage != null &&
                                    _profileImage!.isNotEmpty
                                ? NetworkImage(_profileImage!)
                                : AssetImage('assets/images/default_avatar.png')
                                      as ImageProvider,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Welcome back, ${widget.username}!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color.fromARGB(255, 212, 192, 11),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quick Acess Panel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildQuickButton(
                                    Icons.compare_arrows,
                                    "Transfer",
                                  ),
                                  SizedBox(width: 10),
                                  _buildQuickButton(Icons.qr_code, "QR Code"),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildQuickButton(Icons.payments, "Payment"),
                                  SizedBox(width: 10),
                                  _buildQuickButton(
                                    Icons.favorite,
                                    "Favorites",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, "Home", 0),
            _navItem(Icons.account_balance_wallet, "Wallet", 1),
            _navItem(Icons.payment, "Pay", 2),
            _navItem(Icons.credit_card, "Cards", 3),
            _navItem(Icons.person, "Profile", 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white24,
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isActive ? Colors.yellow : Colors.white),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.yellow : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
