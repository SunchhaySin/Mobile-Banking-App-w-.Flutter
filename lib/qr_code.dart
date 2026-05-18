import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodePage extends StatelessWidget {
  final String username;
  const QRCodePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pretty QR Code"),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: PrettyQrView.data(
            data: "https://mobilebanking-bankend-node-js.onrender.com/qr/topup?username=$username",
            errorCorrectLevel: QrErrorCorrectLevel.M,
            decoration: const PrettyQrDecoration(
              shape: PrettyQrSmoothSymbol(
                color: Color.fromARGB(255, 3, 1, 3),
                roundFactor: 1.0, 
              ),
            ),
          ),
        ),
      ),
    );
  }
}
