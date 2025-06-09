import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mjpeg_stream/mjpeg_stream.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class ModelCall extends StatefulWidget {
  const ModelCall({super.key});

  @override
  State<ModelCall> createState() => _ModelCallState();
}

class _ModelCallState extends State<ModelCall> {
  final String flaskIP = '172.20.10.9'; // Your Flask IP here

  String predictedText = "No prediction yet";
  String translatedText = "Translation will appear here";
  Timer? _timer;
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final GoogleTranslator _translator = GoogleTranslator();

  String _selectedLanguage = 'hi'; // Default to Hindi

  final Map<String, String> _languages = {
    'Hindi': 'hi',
    'Assamese': 'as',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Chinese': 'zh-cn',
    'Japanese': 'ja'
    //'Manipuri': 'mni-Mtei'
  };

  @override
  void initState() {
    super.initState();

    _flutterTts.setLanguage("en-US");

    _flutterTts.setStartHandler(() => print("TTS started"));
    _flutterTts.setCompletionHandler(() => print("TTS completed"));
    _flutterTts.setErrorHandler((msg) => print("TTS error: $msg"));

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchLastPrediction();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> fetchLastPrediction() async {
    final url = Uri.parse('http://$flaskIP:5000/last_prediction');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prediction = data['prediction'] ?? "No prediction received";
        setState(() {
          predictedText = prediction;
          _textController.text = predictedText;
        });

        translateText(_selectedLanguage);
      } else {
        setState(() {
          predictedText = "Error: ${response.statusCode}";
          _textController.text = predictedText;
        });
      }
    } catch (e) {
      setState(() {
        predictedText = "Exception: $e";
        _textController.text = predictedText;
      });
    }
  }

  Future<void> translateText(String targetLanguageCode) async {
    if (_textController.text.isEmpty) return;

    try {
      var translation = await _translator.translate(
        _textController.text,
        to: targetLanguageCode,
      );
      setState(() {
        translatedText = translation.text;
      });
    } catch (e) {
      setState(() {
        translatedText = "Translation error: $e";
      });
    }
  }

  void _speak({bool translated = false}) async {
    final text = translated ? translatedText : _textController.text;
    if (text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1) {
        print("TTS speaking");
      } else {
        print("TTS failed to start");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "SIGN TO WORDS",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 6/7,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: MJPEGStreamScreen(
                  streamUrl: 'http://$flaskIP:5000/video_feed',
                  fit: BoxFit.contain,
                  showLiveIcon: false,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              readOnly: true,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Predicted Text",
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  translateText(value);
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Translated: $translatedText",
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _speak(translated: false),
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    label: Text(
                      "Speak Original",
                      style: GoogleFonts.montserrat(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _speak(translated: true),
                    icon: const Icon(Icons.translate, color: Colors.white),
                    label: Text(
                      "Speak Translation",
                      style: GoogleFonts.montserrat(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
