import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signify/model_call.dart';
import 'package:signify/wordtosign.dart';
import 'package:signify/feedback.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'H A N Z I F Y',
          style: GoogleFonts.montserrat(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // App logo or image
            Icon(Icons.handshake_rounded, size: 80, color: Colors.black),
            const SizedBox(height: 20),
            CustomNavButton(
              text: "Sign to Word",
              subtitle: "Convert signs into words",
              icon: Icons.sign_language,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModelCall(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomNavButton(
              text: "Word to Sign",
              subtitle: "Translate words into signs",
              icon: Icons.translate,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WordToSign(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomNavButton(
              text: "Review",
              subtitle: "Help us improve",
              icon: Icons.star_rate,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => FeedbackPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavButton extends StatelessWidget {
  final String text;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomNavButton({
    required this.text,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
