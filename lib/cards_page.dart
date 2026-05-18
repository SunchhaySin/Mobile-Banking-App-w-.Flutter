import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardsPage extends StatefulWidget {
  final int userId;
  const CardsPage({super.key, required this.userId});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> cardNumberKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> expiryDateKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> cvvCodeKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> cardHolderKey =
      GlobalKey<FormFieldState<String>>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  List<Map<String, String>> cards = [];
  int currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  void setCardData(int index) {
    final c = cards[index];
    cardNumber = c['cardNumber']!;
    expiryDate = c['expiryDate']!;
    cardHolderName = c['cardHolderName']!;
    cvvCode = c['cvvCode']!;
  }

  Future<void> fetchCards() async {
    final url = Uri.parse("https://mobilebanking-bankend-node-js.onrender.com/cards/${widget.userId}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cardsJson = data['cards'];

        setState(() {
          cards = cardsJson
              .map<Map<String, String>>(
                (c) => {
                  "cardId": c['cardID'].toString(),
                  "cardNumber": c['card_number'] ?? '',
                  "expiryDate": c['expiry'] ?? '',
                  "cardHolderName": c['card_holder'] ?? '',
                  "cvvCode": c['cvv'] ?? '',
                },
              )
              .toList();

          if (cards.isNotEmpty) {
            setCardData(0);
          }
        });
      } else {
        print("Failed to fetch cards: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching cards: $e");
    }
  }

  Future<void> saveCard() async {
    if (!formKey.currentState!.validate()) {
      // Form is not valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields correctly")),
      );
      return;
    }

    final Map<String, dynamic> cardData = {
      "user_id": widget.userId,
      "card_number": cardNumber.replaceAll(' ', ''),
      "expiry": expiryDate,
      "card_holder": cardHolderName,
      "cvv": cvvCode,
    };

    final url = Uri.parse("https://mobilebanking-bankend-node-js.onrender.com/cards");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(cardData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Card saved successfully!")));
        // Optionally clear the form
        setState(() {
          cardNumber = '';
          expiryDate = '';
          cardHolderName = '';
          cvvCode = '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save card. Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> deleteCard() async {
    if (cards.isEmpty) return; // no cards to delete
    final cardToDelete = cards[currentCardIndex];
    final cardId = cardToDelete['cardId'];

    if (cardId == null) return;

    final url = Uri.parse("https://mobilebanking-bankend-node-js.onrender.com/cards/$cardId");
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Card deleted successfully!")));

        // Remove the card locally
        setState(() {
          cards.removeAt(currentCardIndex);

          // Reset displayed card
          if (cards.isNotEmpty) {
            if (currentCardIndex >= cards.length) {
              currentCardIndex = cards.length - 1;
            }
            setCardData(currentCardIndex);
          } else {
            cardNumber = '';
            expiryDate = '';
            cardHolderName = '';
            cvvCode = '';
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete card. Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 80),
          CreditCardWidget(
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    showBackView: false,
                    obscureCardNumber: false,
                    isHolderNameVisible: true,
                    cardBgColor: Colors.grey,
                    onCreditCardWidgetChange: (brand) {},
                  ),

          CreditCardForm(
            formKey: formKey,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            cardNumberKey: cardNumberKey,
            cvvCodeKey: cvvCodeKey,
            expiryDateKey: expiryDateKey,
            cardHolderKey: cardHolderKey,
            onCreditCardModelChange: (CreditCardModel data) {
              setState(() {
                cardNumber = data.cardNumber;
                expiryDate = data.expiryDate;
                cardHolderName = data.cardHolderName;
                cvvCode = data.cvvCode;
                isCvvFocused = data.isCvvFocused;
              });
            },
            obscureCvv: true,
            obscureNumber: true,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            enableCvv: true,
            autovalidateMode: AutovalidateMode.always,
            inputConfiguration: const InputConfiguration(
              cardNumberDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
                labelStyle: TextStyle(color: Colors.white60),
                hintText: 'XXXX XXXX XXXX XXXX',
                hintStyle: TextStyle(color: Colors.white70),
                isDense: true,
              ),
              expiryDateDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expired Date',
                labelStyle: TextStyle(color: Colors.white60),
                hintText: 'XX/XX',
                hintStyle: TextStyle(color: Colors.white70),
                isDense: true,
              ),
              cvvCodeDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                labelStyle: TextStyle(color: Colors.white60),
                hintText: 'XXX',
                hintStyle: TextStyle(color: Colors.white70),
                isDense: true,
              ),
              cardHolderDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Holder',
                labelStyle: TextStyle(color: Colors.white60),
                isDense: true,
              ),
              // Add TextStyle for the actual input text
              cardNumberTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              expiryDateTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              cvvCodeTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              cardHolderTextStyle: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  await saveCard();
                },
                child: const Text(
                  "Save Card",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: deleteCard,
                child: const Text(
                  "Delete Card",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
