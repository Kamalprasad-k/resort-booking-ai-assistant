// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

/// Assistant screen with hotel-specific chat interface
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  // Ollama connection settings
  String _ollamaHost = "http://localhost:11434"; // Default Ollama address
  String _ollamaModel = "deepseek-r1:1.5b"; // Model name

  @override
  void initState() {
    super.initState();

    // Add welcome message
    _addBotMessage(
      "👋 Welcome to The Kiliyur Resort! I'm your dedicated assistant for our luxurious property in Yercaud’s Shevaroy Hills, Tamil Nadu. I can assist with room bookings, dining reservations, spa appointments, adventure activities, or anything else to make your stay unforgettable. How may I help you today? 🌴",
    );
  }

  // Off-topic detection
  bool _isOffTopic(String query) {
    final String queryLower = query.toLowerCase().trim();

    // Allow short queries, greetings, or general help requests
    if (queryLower.length <= 20 || queryLower.split(' ').length <= 3) {
      return false; // Likely a greeting or follow-up
    }

    // Allow common guest help inquiries
    final List<String> guestHelpIndicators = [
      "how can you assist",
      "what can you do",
      "what help will you",
      "how can you help",
      "what type of help",
    ];
    for (final indicator in guestHelpIndicators) {
      if (queryLower.contains(indicator)) {
        return false; // Treat as on-topic to allow a response
      }
    }

    // Direct hotel references - always on-topic
    final List<String> directHotelReferences = [
      "kiliyur resort",
      "kiliyur",
      "yercaud",
      "shevaroy hills",
      "tamil nadu resort",
    ];

    for (final ref in directHotelReferences) {
      if (queryLower.contains(ref)) {
        return false; // Explicitly about the hotel
      }
    }

    // Hotel-specific keywords
    final List<String> hotelSpecificKeywords = [
      // Room types
      "honeymoon haven",
      "deluxe suite",
      "beach bungalow",
      "emerald villa",
      "family suite",

      // Dining
      "valley view restaurant",
      "grill & spice terrace",
      "lagoon cafe",
      "sky lounge",
      "private dining",

      // Amenities
      "swimming pool",
      "spa",
      "fitness center",
      "free wi-fi",
      "parking",
      "room service",
      "conference hall",
      "garden",
      "bonfire",

      // Activities
      "low rope adventures",
      "glass sky walk",
      "atv ride",
      "trampoline park",
      "soft play area",
      "kids dirt bike",
      "kayaking",
      "canoeing",
      "water zorbing",
      "infinity pool",
      "floating breakfast",
      "misty mountain spa",
      "lakeside serenity spa",
      "royal shevaroy spa",
      "mountain awakening",
      "detox & rejuvenate",
    ];

    for (final keyword in hotelSpecificKeywords) {
      if (queryLower.contains(keyword)) {
        return false; // Strong signal it's about the hotel
      }
    }

    // General hotel-related keywords
    final List<String> hotelGeneralKeywords = [
      "resort",
      "accommodation",
      "stay",
      "vacation",
      "holiday",
      "room",
      "suite",
      "villa",
      "bungalow",
      "booking",
      "reservation",
      "rate",
      "price",
      "cost",
      "check-in",
      "check-out",
      "availability",
      "restaurant",
      "dining",
      "food",
      "menu",
      "pool",
      "spa",
      "gym",
      "activity",
      "adventure",
      "tour",
      "service",
      "staff",
      "concierge",
      "housekeeping",
      "package",
      "event",
      "wedding",
      "conference",
      "birthday",
    ];

    bool hasHotelKeyword = false;
    for (final keyword in hotelGeneralKeywords) {
      if (queryLower.contains(keyword)) {
        hasHotelKeyword = true;
        break;
      }
    }

    if (hasHotelKeyword) {
      return false; // Likely hotel-related
    }

    // Off-topic keywords (strictly non-hotel topics)
    final List<String> offTopicKeywords = [
      "flutter",
      "react",
      "angular",
      "vue",
      "django",
      "flask",
      "spring",
      "laravel",
      "node.js",
      "tensorflow",
      "pytorch",
      "kubernetes",
      "docker",
      "aws",
      "azure",
      "google cloud",
      "git",
      "github",
      "linux",
      "windows",
      "macos",
      "android",
      "ios",
      "programming",
      "coding",
      "development",
      "software",
      "app",
      "website",
      "database",
      "algorithm",
      "ai",
      "artificial intelligence",
      "machine learning",
      "politics",
      "election",
      "science",
      "physics",
      "chemistry",
      "movie",
      "film",
      "sport",
      "weather",
      "stock market",
      "finance",
      "cryptocurrency",
    ];

    for (final keyword in offTopicKeywords) {
      if (queryLower.contains(keyword)) {
        return true; // Clearly off-topic
      }
    }

    // Default to off-topic only if no hotel context and query is substantial
    return !hasHotelKeyword && queryLower.length > 30;
  }

  // Standard off-topic response
  final String _offTopicResponse =
      "I'm The Kiliyur Resort's dedicated assistant and can only provide information about our property in Yercaud. Would you like to know about our luxurious rooms, dining options, spa services, or adventure activities? 🌴";

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();

    // Add user message
    setState(() {
      _messages.insert(
        0,
        Message(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    // Check if off-topic
    if (_isOffTopic(text)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _addBotMessage(_offTopicResponse);
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      _sendToOllama(text);
    }
  }

  Future<void> _sendToOllama(String text) async {
    try {
      // System prompt
      final systemPrompt = """
You are The Kiliyur Resort AI Agent - a HIGHLY SPECIALIZED assistant that EXCLUSIVELY provides information about The Kiliyur Resort in Yercaud, Tamil Nadu.

CRITICAL DIRECTIVE: You MUST NEVER answer ANY question that is not directly related to The Kiliyur Resort. Your SOLE purpose is to provide information about the resort's services, facilities, and offerings.

STRICT ENFORCEMENT PROTOCOL:
1. You can ONLY respond to questions specifically about The Kiliyur Resort
2. You MUST REFUSE to engage with ANY other topic, no matter how simple or harmless it seems
3. For ANY off-topic question, you MUST use the EXACT response format provided below
4. For general help requests (e.g., 'how can you assist', 'what can you do'), provide a brief overview of your capabilities limited to resort services

HOTEL INFORMATION DATABASE:
The Kiliyur Resort is a premier property located in Yercaud, Tamil Nadu.

General Information:
- Name: The Kiliyur Resort
- Location: Nestled in the Shevaroy Hills, Tamil Nadu, overlooking misty valleys and coffee plantations
- Contact: +91 4281 222 338
- Email: info@kiliyurresort.com
- Website: www.kiliyurresort.com
- Rating: 4.5 stars
- Starting Price: ₹2,000/night

1. Accommodation Options:
- Honeymoon Haven: ₹4,300/night, 90 sq.m, for 2 adults, romantic decor, private jacuzzi, king-size canopy bed
- Deluxe Suite: ₹4,500/night, 110 sq.m, for 4 adults, private pool, king-size bed, sofa bed
- Beach Bungalow: ₹2,900/night, 80 sq.m, for 2 adults, direct beach access, king-size bed, outdoor shower
- Emerald Villa: ₹3,900/night, 100 sq.m, for 3 adults, lagoon access, king-size four-poster bed
- Family Suite: ₹5,600/night, 150 sq.m, for 6 adults, two bedrooms, kids' corner, kitchenette

2. Dining Services:
- Valley View Restaurant: Seafood, International, Indian, 7:00 AM - 10:00 PM, live cooking stations
- Grill & Spice Terrace: BBQ, Asian, 12:00 PM - 11:00 PM, live BBQ grills, weekend live music
- Lagoon Cafe: Mediterranean, Light Bites, 8:00 AM - 8:00 PM, poolside ambiance
- Sky Lounge & Bar: Cocktails, Tapas, 4:00 PM - 11:00 PM, hilltop views
- Private Dining Experience: Specialty, By Reservation, custom themes, private butler

3. Amenities:
- Swimming Pool
- Restaurant
- Spa
- Fitness Center
- Free Wi-Fi
- Parking
- Room Service
- Conference Hall
- Garden
- Bonfire

4. Activities:
- Land Adventures: Low Rope Adventures, Glass Sky Walk, ATV Ride, Trampoline Park, Soft Play Area, Kids Dirt Bike Adventure
- Water Activities: Kayaking & Canoeing, Water Zorbing, Infinity Pool Swimming, Floating Breakfast Experience
- Spa Experiences: Misty Mountain Spa, Lakeside Serenity Spa, Royal Shevaroy Spa Suite
- Wellness Retreats: Mountain Awakening, Detox & Rejuvenate

5. Packages:
- Honeymoon Package: ₹15,000, 2 nights, romantic dinner, spa session, sightseeing
- Adventure Package: ₹12,000, 2 nights, adventure activities, bonfire, complimentary meals
- Family Getaway: ₹18,000, 2 nights, family activities, sightseeing, complimentary meals, indoor games

6. Events:
- Birthday Celebration: Up to 100 guests, themed decor, custom cake, catering
- Marriage Ceremony: Up to 300 guests, mandap setup, floral decor, wedding planner
- Conference Hall: 60-seater, projector, high-speed Wi-Fi, catering

7. Policies:
- Check-in: 12:00 PM
- Check-out: 11:00 AM
- Early check-in and late check-out subject to availability

MANDATORY RESPONSE FOR OFF-TOPIC QUESTIONS:
"I'm The Kiliyur Resort's dedicated assistant and can only provide information about our property in Yercaud. Would you like to know about our luxurious rooms, dining options, spa services, or adventure activities? 🌴"

SAMPLE RESPONSE FOR GENERAL HELP:
"As your dedicated assistant at The Kiliyur Resort, I can help you with room bookings, dining reservations, spa appointments, adventure activity planning, package details, and event arrangements. Please let me know what you'd like to explore! 🌴"

Your responses for ON-TOPIC questions should be:
- Warm, professional, and reflective of our premier status
- Informative and detailed about our offerings
- Exclusively focused on The Kiliyur Resort information
      """;

      final requestBody = {
        "model": _ollamaModel,
        "messages": [
          {"role": "system", "content": systemPrompt},
          {"role": "user", "content": text},
        ],
        "stream": false,
        "temperature": 0.1,
      };

      final response = await http.post(
        Uri.parse('$_ollamaHost/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final aiResponse = responseData['message']['content'];
        _addBotMessage(aiResponse);
      } else {
        _addBotMessage(
          "I'm having trouble connecting to my AI brain. Please make sure Ollama is running with '$_ollamaModel' model. You can start it with 'ollama run $_ollamaModel' 🌴",
        );
      }
    } catch (e) {
      _addBotMessage(
        "Connection error: Unable to reach Ollama. Please make sure Ollama is running on $_ollamaHost with model $_ollamaModel. Error: ${e.toString().substring(0, min(e.toString().length, 100))}... 🌴",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.insert(
        0,
        Message(text: text, isUser: false, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // void _showSettingsDialog() {
  //   final TextEditingController hostController = TextEditingController(
  //     text: _ollamaHost,
  //   );
  //   final TextEditingController modelController = TextEditingController(
  //     text: _ollamaModel,
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Ollama Settings'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: hostController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Ollama Host',
  //                 hintText: 'http://localhost:11434',
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: modelController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Model Name',
  //                 hintText: 'deepseek-r1:1.5b',
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 _ollamaHost = hostController.text;
  //                 _ollamaModel = modelController.text;
  //               });
  //               Navigator.pop(context);
  //               _addBotMessage(
  //                 "Settings updated. Now using model $_ollamaModel on $_ollamaHost",
  //               );
  //             },
  //             child: const Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Resort Assistant',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,

        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings, color: theme.colorScheme.primary),
        //     onPressed: _showSettingsDialog,
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: LinearProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Ask about our resort...',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                        onSubmitted: _isLoading ? null : _handleSubmitted,
                        enabled: !_isLoading,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () => _handleSubmitted(_textController.text),
                    backgroundColor: theme.primaryColor,
                    mini: true,
                    child: Icon(Icons.send, color: theme.colorScheme.onPrimary),
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

/// Message model class for chat functionality
class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? senderName;
  final String? senderAvatar;

  Message({
    required this.text,
    required this.isUser,
    String? senderName,
    String? senderAvatar,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now(),
       senderName = senderName ?? (isUser ? 'Guest' : 'The Kiliyur Resort'),
       senderAvatar =
           senderAvatar ??
           (isUser
               ? 'https://i.pinimg.com/736x/e4/16/42/e41642c478e813afc29be15ea5c38440.jpg'
               : 'https://images.unsplash.com/photo-1535378620166-273708d44e4c?q=80&w=3057&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
}

/// ChatBubble widget to display individual messages
class ChatBubble extends StatelessWidget {
  final Message message;
  final bool showTimestamp;
  final bool showSenderName;

  const ChatBubble({
    super.key,
    required this.message,
    this.showTimestamp = false,
    this.showSenderName = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Process the message to remove <think> tags if it's a bot message
    String displayText = message.text;
    if (!message.isUser) {
      final thinkPattern = RegExp(r'<think>[\s\S]*?</think>', multiLine: true);
      displayText = message.text.replaceAll(thinkPattern, '').trim();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(message.senderAvatar!),
                radius: 16,
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                if (showSenderName)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      message.senderName!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        message.isUser
                            ? theme.primaryColor
                            : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    displayText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          message.isUser
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (showTimestamp)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatTimestamp(message.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message.isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(message.senderAvatar!),
                radius: 16,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('HH:mm').format(timestamp);
  }
}

// Helper function for min
int min(int a, int b) {
  return a < b ? a : b;
}
