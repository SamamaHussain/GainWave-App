import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GymChatBot extends StatefulWidget {
  const GymChatBot({super.key});

  @override
  State<GymChatBot> createState() => _GymChatBotState();
}

class _GymChatBotState extends State<GymChatBot> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedMessages = prefs.getString('chat_messages');
    if (savedMessages != null) {
      final List decoded = jsonDecode(savedMessages);
      setState(() {
        messages.addAll(decoded.map<Map<String, String>>((e) => Map<String, String>.from(e)));
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', jsonEncode(messages));
  }

  void getGymAdvice() async {
    final userInput = _textController.text.trim();
    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your question or request.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      messages.add({"sender": "user", "message": userInput});
      _textController.clear();
    });
    _saveMessages(); // Save after user sends

    try {
      final content = [
        Content.text(
          "You are a fitness expert. Respond to this query in a friendly tone: $userInput",
        ),
      ];
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: dotenv.env['API_KEY'] ?? "Not found",
      );
      final response = await model.generateContent(content);

      setState(() {
        messages.add({
          "sender": "bot",
          "message": response.text ?? "I couldn't find an answer. Please try again.",
        });
      });
      _saveMessages(); // Save after bot responds
    } catch (e) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": "Error: ${e.toString()}",
        });
      });
      _saveMessages();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildChatBubble(String message, String sender) {
    final isUser = sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4.0,
              offset: const Offset(0, 4),
            ),
          ],
          color: isUser ? accentMain : secondaryBG,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isUser ? const Radius.circular(16.0) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16.0),
          ),
        ),
        child: Text(
          message,
          style: GoogleFonts.roboto(
            color: isUser ? primaryBG : textMain,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        appBar: AppBar(
          elevation: 5,
          toolbarHeight: 80,
          backgroundColor: primaryBG,
          leading: const Padding(
            padding: EdgeInsets.only(left: 30),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.personal_injury_rounded,
                size: 35.0,
                color: accentMain,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GainWave Mentor",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    color: textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                if (isLoading)
                  Text(
                    "typing...",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: accentMain,
                    ),
                  ),
                if (!isLoading)
                  Text(
                    "Online",
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
    physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return buildChatBubble(message["message"]!, message["sender"]!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.roboto(color: Colors.white),
                        controller: _textController,
                        decoration: InputDecoration(
                          fillColor: secondaryBG,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: textMain),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: textMain),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          hintStyle: GoogleFonts.roboto(color: Colors.grey),
                          hintText: "Ask your fitness question",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: getGymAdvice,
                      backgroundColor: accentMain,
                      child: const Icon(Icons.send, color: primaryBG),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}