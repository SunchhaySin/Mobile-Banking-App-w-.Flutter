import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  final int userId;
  const WalletPage({super.key, required this.userId});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<dynamic> transactions = [];
  late int userID;
  double currentBalance = 0.0;
  String accountNumber = "";

  @override
  void initState() {
    super.initState();
    userID = widget.userId;
    fetchTransactions();
    fetchBalance();
  }

  Future<void> fetchTransactions() async {
    final url = Uri.parse('https://mobilebanking-bankend-node-js.onrender.com/transactions/$userID');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          transactions = data['transactions'];
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to fetch transactions')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error connecting to server')));
    }
  }

  Future<void> fetchBalance() async {
    final url = Uri.parse('https://mobilebanking-bankend-node-js.onrender.com/balance/$userID');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          currentBalance = double.parse(data['current_balance'].toString());
          accountNumber = data['account_number'] ?? "";
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to fetch balance')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error connecting to server')));
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                "Mobile Savings Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.fromARGB(255, 212, 192, 11),
                    width: 3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Available Balance",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "฿${currentBalance.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Account #: $accountNumber",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Balance History
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Balance History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.fromARGB(255, 212, 192, 11),
                      width: 3,
                    ),
                  ),
                  child: transactions.isEmpty
                      ? Center(
                          child: Text(
                            "No transactions yet",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final txn = transactions[index];
                            final isMoneyIn = txn["type"] == "money_In";
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isMoneyIn
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color: isMoneyIn
                                            ? Colors.green
                                            : Colors.red,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        txn["description"] ?? "",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "฿${txn["transaction_amount"]}",
                                    style: TextStyle(
                                      color: isMoneyIn
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
