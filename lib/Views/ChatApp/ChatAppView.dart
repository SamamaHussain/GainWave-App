// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:gain_wave_app/utillities/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class GymChatBot extends StatefulWidget {
//   const GymChatBot({super.key});

//   @override
//   State<GymChatBot> createState() => _GymChatBotState();
// }

// class _GymChatBotState extends State<GymChatBot> {
//   final List<Map<String, String>> messages = [];
//   final TextEditingController _textController = TextEditingController();
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//   }

//   Future<void> _loadMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? savedMessages = prefs.getString('chat_messages');
//     if (savedMessages != null) {
//       final List decoded = jsonDecode(savedMessages);
//       setState(() {
//         messages.addAll(decoded.map<Map<String, String>>((e) => Map<String, String>.from(e)));
//       });
//     }
//   }

//   Future<void> _saveMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('chat_messages', jsonEncode(messages));
//   }

//   void getGymAdvice() async {
//     final userInput = _textController.text.trim();
//     if (userInput.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter your question or request.")),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       messages.add({"sender": "user", "message": userInput});
//       _textController.clear();
//     });
//     _saveMessages(); // Save after user sends

//     try {
//       final content = [
//         Content.text(
//           "You are a fitness expert. Respond to this query in a friendly tone: $userInput",
//         ),
//       ];
//       final model = GenerativeModel(
//         model: 'gemini-1.5-flash',
//         apiKey: dotenv.env['API_KEY'] ?? "Not found",
//       );
//       final response = await model.generateContent(content);

//       setState(() {
//         messages.add({
//           "sender": "bot",
//           "message": response.text ?? "I couldn't find an answer. Please try again.",
//         });
//       });
//       _saveMessages(); // Save after bot responds
//     } catch (e) {
//       setState(() {
//         messages.add({
//           "sender": "bot",
//           "message": "Error: ${e.toString()}",
//         });
//       });
//       _saveMessages();
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget buildChatBubble(String message, String sender) {
//     final isUser = sender == "user";
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 4.0,
//               offset: const Offset(0, 4),
//             ),
//           ],
//           color: isUser ? accentMain : secondaryBG,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16.0),
//             topRight: const Radius.circular(16.0),
//             bottomLeft: isUser ? const Radius.circular(16.0) : Radius.zero,
//             bottomRight: isUser ? Radius.zero : const Radius.circular(16.0),
//           ),
//         ),
//         child: Text(
//           message,
//           style: GoogleFonts.roboto(
//             color: isUser ? primaryBG : textMain,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: primaryBG,
//         appBar: AppBar(
//           elevation: 5,
//           toolbarHeight: 80,
//           backgroundColor: primaryBG,
//           leading: const Padding(
//             padding: EdgeInsets.only(left: 30),
//             child: CircleAvatar(
//               backgroundColor: Colors.black,
//               child: Icon(
//                 Icons.personal_injury_rounded,
//                 size: 35.0,
//                 color: accentMain,
//               ),
//             ),
//           ),
//           title: Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "GainWave Mentor",
//                   style: GoogleFonts.roboto(
//                     fontSize: 22,
//                     color: textMain,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 if (isLoading)
//                   Text(
//                     "typing...",
//                     style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       fontStyle: FontStyle.italic,
//                       color: accentMain,
//                     ),
//                   ),
//                 if (!isLoading)
//                   Text(
//                     "Online",
//                     style: GoogleFonts.roboto(
//                       fontSize: 13,
//                       color: Colors.grey,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           actions: [
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//     physics: const BouncingScrollPhysics(),
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[messages.length - 1 - index];
//                     return buildChatBubble(message["message"]!, message["sender"]!);
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         style: GoogleFonts.roboto(color: Colors.white),
//                         controller: _textController,
//                         decoration: InputDecoration(
//                           fillColor: secondaryBG,
//                           filled: true,
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: textMain),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           disabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: textMain),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           hintStyle: GoogleFonts.roboto(color: Colors.grey),
//                           hintText: "Ask your fitness question",
//                           border: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.white),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     FloatingActionButton(
//                       onPressed: getGymAdvice,
//                       backgroundColor: accentMain,
//                       child: const Icon(Icons.send, color: primaryBG),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GymChatBot extends StatefulWidget {
  const GymChatBot({super.key});

  @override
  State<GymChatBot> createState() => _GymChatBotState();
}

class _GymChatBotState extends State<GymChatBot> with WidgetsBindingObserver {
  final List<Map<String, String>> messages = [];
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  late GenerativeModel model;
  ChatSession? chat;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: dotenv.env['API_KEY'] ?? '',
    );
    _loadMessages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshChat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFirstLoad) {
      _refreshChat();
    }
    _isFirstLoad = false;
  }

  Future<void> _refreshChat() async {
    await _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedMessages = prefs.getString('chat_messages');
    
    setState(() {
      messages.clear(); // Clear existing messages to prevent duplicates
    });
    
    if (savedMessages != null) {
      final List decoded = jsonDecode(savedMessages);
      
      setState(() {
        messages.addAll(decoded.map<Map<String, String>>((e) => Map<String, String>.from(e)));
      });
    }

    // Start chat session with history
    List<Content> history = [];
    
    try {
      for (var msg in messages) {
        if (msg['sender'] == 'user') {
          history.add(Content.text(msg['message'] ?? ''));
        } else {
          // Add model responses as text content for history
          history.add(Content.text(msg['message'] ?? ''));
        }
      }
      
      chat = model.startChat(history: history);
    } catch (e) {
      debugPrint('Error setting up chat session: ${e.toString()}');
      // Fallback to a new chat session if something goes wrong
      chat = model.startChat();
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', jsonEncode(messages));
  }

  void getGymAdvice() async {
    final userInput = _textController.text.trim();
    if (userInput.isEmpty || chat == null) {
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
    _saveMessages();

    try {
      final response = await chat!.sendMessage(Content.text(userInput));
      final botReply = response.text ?? "I'm not sure, please try asking differently.";

      // Format the response as markdown to ensure proper rendering
      final formattedReply = _ensureMarkdownFormatting(botReply);
      
      setState(() {
        messages.add({"sender": "bot", "message": formattedReply});
      });
      _saveMessages();
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Error: ${e.toString()}"});
      });
      _saveMessages();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper method to ensure the AI response is formatted properly for markdown
  String _ensureMarkdownFormatting(String text) {
    // Replace consecutive newlines with proper markdown line breaks to preserve formatting
    String formatted = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    // Make sure lists are properly formatted
    formatted = formatted.replaceAll(RegExp(r'(\n|^)- '), '\n\n- ');
    
    // Ensure code blocks have proper spacing
    formatted = formatted.replaceAll(RegExp(r'(\w*)\n'), '\n\n');
    formatted = formatted.replaceAll(RegExp(r'\n'), '\n\n');
    
    return formatted;
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
        child: isUser 
          ? Text(
              message,
              style: GoogleFonts.roboto(
                color: primaryBG,
                fontSize: 16,
              ),
            )
          : MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 16,
                ),
                h1: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                h2: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                h3: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                strong: GoogleFonts.roboto(
                  color: textMain,
                  fontWeight: FontWeight.bold,
                ),
                em: GoogleFonts.roboto(
                  color: textMain,
                  fontStyle: FontStyle.italic,
                ),
                listBullet: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 16,
                ),
                code: GoogleFonts.sourceCodePro(
                  color: Colors.white,
                  fontSize: 14,
                  backgroundColor: Colors.black54,
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder to ensure messages are loaded before building the UI
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
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showClearChatDialog();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
          child: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center, 
                          size: 70, 
                          color: accentMain.withOpacity(0.5)
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Ask me anything about fitness!",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
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
                        onSubmitted: (_) => getGymAdvice(),
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

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBG,
        title: Text(
          "Clear Chat History",
          style: GoogleFonts.roboto(color: textMain),
        ),
        content: Text(
          "Are you sure you want to clear all chat messages?",
          style: GoogleFonts.roboto(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.roboto(color: accentMain),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
              // Re-initialize the chat session with empty history
              chat = model.startChat();
              _saveMessages();
              Navigator.pop(context);
            },
            child: Text(
              "Clear",
              style: GoogleFonts.roboto(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}