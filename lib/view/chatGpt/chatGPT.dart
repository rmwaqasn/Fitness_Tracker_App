import 'package:animate_do/animate_do.dart';
import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:fitness_tracker_app/view/chatGpt/featureBox.dart';
import 'package:fitness_tracker_app/view/chatGpt/openAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatGPT extends StatefulWidget {
  const ChatGPT({super.key});

  @override
  State<ChatGPT> createState() => _ChatGPTState();
}

class _ChatGPTState extends State<ChatGPT> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('Fitness Assistant'),
        ),
       
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // virtual assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 130,
                      width: 140,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 133,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/virtualAssistant.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:AppColors.borderColor
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color:AppColors.mainFontColor,
                        fontSize: generatedContent == null ? 20 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color:AppColors.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // features list
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Row(
                children: [
                  Expanded(
                    child: SlideInLeft(
                      delay: Duration(milliseconds: start),
                      child: const FeatureBox(
                        color:AppColors.firstSuggestionBoxColor,
                        headerText: 'ChatGPT',
                        descriptionText:
                            'Suggest you fitness tips and ideas using OpenAI GPT 3.5',
                      ),
                    ),
                  ),
                  Expanded(
                    child: SlideInLeft(
                      delay: Duration(milliseconds: start + delay),
                      child: const FeatureBox(
                        color:AppColors.secondSuggestionBoxColor,
                        headerText: 'Dall-E',
                        descriptionText:
                            'Generate creative fitness pictures using DALL-E ',
                      ),
                    ),
                  ),
                  // SlideInLeft(
                  //   delay: Duration(milliseconds: start + 2 * delay),
                  //   child: const FeatureBox(
                  //     color:AppColors.thirdSuggestionBoxColor,
                  //     headerText: 'Smart Voice Assistant',
                  //     descriptionText:
                  //         'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          
          backgroundColor: AppColors.primaryColor1,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(
            
            speechToText.isListening ? Icons.stop : Icons.mic,color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}



















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class ChatGPT extends StatefulWidget {
//   const ChatGPT({Key? key}) : super(key: key);

//   @override
//   State<ChatGPT> createState() => _ChatGPTState();
// }

// class _ChatGPTState extends State<ChatGPT> {
//   late final TextEditingController promptController;
//   String responseTxt = '';
//   late ResponseModel? _responseModel;

//   @override
//   void initState() {
//     promptController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     promptController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Fitness',
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             PromptBldr(responseTxt: responseTxt),
//             TextFormFieldBldr(
//               promptController: promptController,
//               btnFun: completionFun,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//    completionFun() async {
//     setState(() => responseTxt = 'Loading...');

//     final response = await http.post(
//       Uri.parse('https://api.openai.com/v1/completions'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${dotenv.env['token']}'
//       },
//       body: jsonEncode(
//         {
//           "model": "text-davinci-003",
//           "prompt": promptController.text,
//           "max_tokens": 250,
//           "temperature": 0,
//           "top_p": 1,
//         },  
//       ),
//     );

//     setState(() {
//       _responseModel = ResponseModel.fromJson(jsonDecode(response.body));
//       responseTxt = _responseModel!.choices[0]['text'];
//       debugPrint(responseTxt);
//     });
//   }
// }

// class PromptBldr extends StatelessWidget {
//   const PromptBldr({Key? key, required this.responseTxt}) : super(key: key);
//   final String responseTxt;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.35,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Text(
//             responseTxt,
//             textAlign: TextAlign.start,
//             style: TextStyle(fontSize: 25, color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TextFormFieldBldr extends StatelessWidget {
//   const TextFormFieldBldr({
//     Key? key,
//     required this.promptController,
//     required this.btnFun,
//   }) : super(key: key);

//   final TextEditingController promptController;
//   final Function btnFun;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: promptController,
//               autofocus: true,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5.5),
//                   borderSide: BorderSide(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5.5),
//                   borderSide: BorderSide(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 hintText: 'Ask anything about fitness',
//                 hintStyle: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.grey.shade200,
//               border: Border.all(
//                 color: Colors.grey,
//               ),
//             ),
//             child: IconButton(
//               onPressed: () {
//                 btnFun();
//               },
//               icon: Icon(Icons.send, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



