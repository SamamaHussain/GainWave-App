import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GymChatBot extends StatefulWidget {
  const GymChatBot({super.key});

  @override
  State<GymChatBot> createState() => _GymChatBotState();
}

class _GymChatBotState extends State<GymChatBot> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;

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

    try {
      final content = [
        Content.text(
          "You are a fitness expert. Respond to this query in a friendly tone: $userInput",
        ),
      ];
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: dotenv.env['API_KEY']?? "Not found", // Replace with secure storage for your API key
      );
      final response = await model.generateContent(content);

      setState(() {
        messages.add({
          "sender": "bot",
          "message": response.text ?? "I couldn't find an answer. Please try again.",
        });
      });
    } catch (e) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": "Error: ${e.toString()}",
        });
      });
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
          toolbarHeight: 80,
          backgroundColor: secondaryBG,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundColor: primaryBG,
                child: Icon(
                  Icons.personal_injury_rounded, // Replace with the icon of your choice
                  size: 35.0, // You can adjust the size of the icon
                  color: textMain, // You can adjust the color of the icon
                ),
              ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("GainWave Mentor",
              style: GoogleFonts.roboto(
                fontSize: 22,
                color: textMain,
              ),
              ),
              SizedBox(height: 2,),
              if (isLoading)
                Text("typing...",
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: accentMain,
              ),),
              if(isLoading==false)
              Text("Online",
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: Colors.grey,
              ),),
            ],
          ),
          actions: <Widget>[
            IconButton(onPressed: () {
              
            }, icon: Icon(Icons.more_vert_rounded))
          ]
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 30, 5, 0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textMain),borderRadius: BorderRadius.circular(50),),
                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textMain),borderRadius: BorderRadius.circular(50),),
                          hintStyle: GoogleFonts.roboto(color: Colors.grey),
                          hintText: "Ask your fitness question",
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(50),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: getGymAdvice,
                      backgroundColor: accentMain,
                      child: const Icon(Icons.send,color: primaryBG,),
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
