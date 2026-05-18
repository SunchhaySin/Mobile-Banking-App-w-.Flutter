import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferPage extends StatefulWidget {
  final int userId;
  const TransferPage({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return TransferState();
  }
}

class TransferState extends State<TransferPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendTransfer() async {
    final recipientAccount = _accountController.text.trim();
    final amountText = _amountController.text.trim();

    if (recipientAccount.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter all fields")));
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter a valid amount")));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://mobilebanking-bankend-node-js.onrender.com/transfer');
    final body = jsonEncode({
      "senderId": widget.userId,
      "recipientAccount": recipientAccount,
      "amount": amount,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
        _accountController.clear();
        _amountController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Transfer failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error connecting to server')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 130,
              left: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                child: Column(
                  children: [
                    SizedBox(height: 120),
                    Text(
                      'Transfer!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    TextFormField(
                      controller: _accountController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter account Number',
                        labelStyle: TextStyle(color: Colors.white60),
                        hintText: 'Enter account Number',
                        hintStyle: TextStyle(color: Colors.white70),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _amountController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter amount',
                        labelStyle: TextStyle(color: Colors.white60),
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(color: Colors.white70),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        prefixIcon: Icon(Icons.money, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : sendTransfer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Send"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
