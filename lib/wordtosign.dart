import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordToSign extends StatefulWidget {
  const WordToSign({super.key});

  @override
  State<WordToSign> createState() => _WordToSignState();
}

class _WordToSignState extends State<WordToSign> {
  String inputText = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> signCards = inputText.toUpperCase().split('').map((char) {
      String? imagePath;


      if (RegExp(r'[A-Z]').hasMatch(char)) {
        imagePath = 'assets/images/$char.png';
      }

      else if (RegExp(r'[0-9]').hasMatch(char)) {
        imagePath = 'assets/images/$char.png';
      }

      if (imagePath != null) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomImageView(imagePath: imagePath!),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 60,
                    height: 50,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    char,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return const SizedBox(); // Skip unsupported characters
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "WORD TO SIGN",
          style: GoogleFonts.montserrat(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.translate, size: 80, color: Colors.black),
            Text(
              "Translate words/letters to sign",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter a word',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.black12,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: signCards,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ZoomImageView extends StatelessWidget {
  final String imagePath;

  const ZoomImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
