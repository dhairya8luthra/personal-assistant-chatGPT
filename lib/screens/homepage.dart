import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:personal_assistant/pallete.dart';
import 'package:personal_assistant/screens/feature_box.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:personal_assistant/openai_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animate_do/animate_do.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  @override
  void initState(){
    super.initState();
    initSpeechToText();
  }
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {
      
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(child: const Text("Your Assistant")),
        leading: const Icon(Icons.menu),
        ),
      body: SingleChildScrollView(
        child: Column(children: [
          //picture
          ZoomIn(
            child: Stack(children: [
              Center(
                child: Container(
                  height:120,
                  width:120,
                  margin: const EdgeInsets.only(top:4),
                  decoration: const BoxDecoration(
                    color:Pallete.assistantCircleColor,
                     shape: BoxShape.circle,),
                ),
              ),
              Container(
                height: 123,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:AssetImage(
                    'assets/images/virtualAssistant.png',
                  ),
                  ),
                ),
              )
            ],),
          ),
        FadeInRight(
          child: Visibility(
            visible: generatedContent == null && generatedImageUrl == null,
            child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 40
                ).copyWith(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.borderColor,
                  ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                ),
                
                ),
                child:  Padding(
                  padding:  EdgeInsets.symmetric(vertical:10.0),
                  
                  child: Text(generatedContent == null
                              ? 'Greetings, what task can I do for you?'
                              : generatedContent!,
                          style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: Pallete.mainFontColor,
                            fontSize: generatedContent == null ? 25 : 18,
                          ),),
                  ),
                ),
          ),
        ),
        if(generatedImageUrl!=null)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect
            ( borderRadius: BorderRadius.circular(20),
              child: Image.network(generatedImageUrl!)),
          ),
        Visibility(
           visible: generatedContent == null && generatedImageUrl == null,
           child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10,left: 32),
            child:  const Text(
              'Here are a few features',
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.mainFontColor,
                fontSize:18,
                fontWeight: FontWeight.bold,
              ),
              ),
                 ),
         ),
        Visibility(
          visible: generatedContent == null && generatedImageUrl == null,
          child: Column(
            children: [
              SlideInLeft(
                child: featureBox(
                  color:Pallete.firstSuggestionBoxColor,
                  headerText: 'ChatGPT',
                  descriptionText:'The revolutionary Large Language Model from Open AI'
                ),
              ),
              SlideInLeft(
                child: featureBox(
                  color:Pallete.secondSuggestionBoxColor,
                  headerText: 'Dall-E',
                  descriptionText:'Get inspired and stay creative with your personal assistant powered by Dall-E'
                ),
              ), 
              SlideInLeft(
                child: featureBox(
                  color:Pallete.thirdSuggestionBoxColor,
                  headerText: 'Smart Voice Assistant',
                  descriptionText:'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT'
                ),
              ),  ],
          ),
        )
        ]),
      ),
    floatingActionButton: ZoomIn(
      child: FloatingActionButton(
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
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child:Icon(
            speechToText.isListening?Icons.stop:Icons.mic)),
    ),  
    );
  }
}
