import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../models/question.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key, required this.questions}) : super(key: key);
  final List<Question> questions;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<Question> updatedQuestions = [];
  List<Question> sessionQuestions = [];
  int countQuestions = 0;
  int currentQuestionIndex = 0;
  bool isAnswerVisible = false;
  bool finished = false;

  late ESenseManager eSenseManager;
  late StreamSubscription subscriptionConnection;
  late StreamSubscription subscriptionEvents;

  static const CALIBRATION_SAMPLE_COUNT = 20;
  late int initialPositionX;
  late int initialPositionY;
  late int initialPositionZ;

  List<int> samplesX = [];
  List<int> samplesY = [];
  List<int> samplesZ = [];

  TextToSpeech tts = TextToSpeech();

  @override
  void initState() {
    DateTime now = DateTime.now();
    updatedQuestions =
        widget.questions.map((e) => updateIfRemembered(e)).toList();
    sessionQuestions =
        updatedQuestions.where((i) => (i.status != Status.remembered)).toList();
    countQuestions = sessionQuestions.length;
    currentQuestionIndex = 0;
    tts.setLanguage('en-US');
    if (countQuestions > 0) {
      tts.speak(sessionQuestions[currentQuestionIndex].question);
    } else {
      finished = true;
    }

    eSenseManager = ESenseManager("eSense-0362");
    _connectToESense();
    subscriptionConnection = eSenseManager.connectionEvents.listen(
        (event) {
          if (event.type == ConnectionType.connected) {
            subscriptionEvents = eSenseManager.sensorEvents.listen((event) {
              _handleNewSnapshot(event);
            });
          }
        }
    );
  }

  Future<void> _connectToESense() async {
    await eSenseManager.disconnect();
    bool hasSuccessfulConnected = await eSenseManager.connect();
    print("hasSuccessfulConnected to ESense: $hasSuccessfulConnected");
  }

  Question updateIfRemembered(Question question) {
    DateTime now = DateTime.now();
    if (question.createdDate.add(Duration(days: 30)).isBefore(now) &&
        question.status == Status.remembered) {
      question.createdDate = now;
      question.status = Status.good;
    }
    return question;
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex == countQuestions - 1) {
        finished = true;
      } else {
        currentQuestionIndex++;
      }
      isAnswerVisible = false;
    });
    if (!finished) {
      tts.speak(sessionQuestions[currentQuestionIndex].question);
    } else {
      tts.speak('You studied all questions!');
    }
  }

  void showAnswer() {
    setState(() {
      isAnswerVisible = true;
    });
    tts.speak(sessionQuestions[currentQuestionIndex].answer);
  }

  void increaseStatus() {
    int statusIdx = sessionQuestions[currentQuestionIndex].status.index;
    if (statusIdx < 4) {
      setState(() {
        sessionQuestions[currentQuestionIndex].status =
            Status.values[++statusIdx];
      });
    }
    nextQuestion();
  }

  void decreaseStatus() {
    int statusIdx = sessionQuestions[currentQuestionIndex].status.index;
    if (statusIdx > 0) {
      setState(() {
        sessionQuestions[currentQuestionIndex].status =
            Status.values[--statusIdx];
      });
    }
    nextQuestion();
  }

  void onSessionFinish() {
    Navigator.pop(context, sessionQuestions);
  }

  _handleNewSnapshot(event) {
    if(!finished) {
      if (!isAnswerVisible) {
        if (event.accel![1] > 3500) {
          showAnswer();
        }
      } else {
        if (event.accel![2] > 500) {
          decreaseStatus();
        } else if (event.accel![2] < -5000) {
          increaseStatus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SRS session"),
        ),
        body: Column(children: [
          if (finished) ...[
            TextContainer(text: 'You have studied all questions')
          ] else ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('${currentQuestionIndex + 1}/$countQuestions'),
              ),
            ),
            TextContainer(
                text: sessionQuestions[currentQuestionIndex].question),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            if (isAnswerVisible)
              TextContainer(text: sessionQuestions[currentQuestionIndex].answer)
            else
              Text(''),
          ],
          StreamBuilder<ConnectionEvent>(
              stream: eSenseManager.connectionEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.type) {
                    case ConnectionType.connected:
                      return Container();

                    case ConnectionType.unknown:
                      return ReconnectButton(
                        child: const Text("Connection: Unknown"),
                        onPressed: _connectToESense,
                      );
                    case ConnectionType.disconnected:
                      return ReconnectButton(
                        child: const Text("Connection: Disconnected"),
                        onPressed: _connectToESense,
                      );
                    case ConnectionType.device_found:
                      return const Center(
                          child: Text("Connection: Device found"));
                    case ConnectionType.device_not_found:
                      return ReconnectButton(
                        child: Text("Connection: Device not found"),
                        onPressed: _connectToESense,
                      );
                  }
                } else {
                  return const Center(
                      child: Text("Waiting for Connection Data..."));
                }
              })
        ]),
        bottomNavigationBar: BottomAppBar(
            color: Colors.grey.shade100,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (finished) ...[
                  BottomBarButton(
                      onPressed: onSessionFinish, text: 'Finish Session'),
                ] else ...[
                  if (isAnswerVisible) ...[
                    BottomBarButton(
                        onPressed: () {
                          increaseStatus();
                        },
                        text: 'Easy'),
                    BottomBarButton(
                        onPressed: () {
                          decreaseStatus();
                        },
                        text: 'Hard'),
                  ] else ...[
                    BottomBarButton(onPressed: showAnswer, text: 'Show answer'),
                  ],
                ]
              ],
            )));
  }

  @override
  void dispose() {
    subscriptionEvents.cancel();
    subscriptionConnection.cancel();
    eSenseManager.disconnect();
    super.dispose();
  }
}

class TextContainer extends StatelessWidget {
  const TextContainer({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          textScaleFactor: 2,
        ),
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const BottomBarButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}

class ReconnectButton extends StatelessWidget {
  const ReconnectButton(
      {Key? key, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        child,
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Connect To eSense"),
        )
      ]),
    );
  }
}
