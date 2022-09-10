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

  late ESenseManager eSenseManager;
  late StreamSubscription subscription;

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
    if (countQuestions > 0) {
      tts.speak(sessionQuestions[currentQuestionIndex].question);
    }

    eSenseManager = ESenseManager("eSense-0362");
    _connectToESense();
    subscription = eSenseManager.sensorEvents.listen(
      (event) {
        print('SENSOR event: $event');
      },
      onError: (err) {
        print(err);
      },
      cancelOnError: false,
    );
  }

  Future<void> _connectToESense() async {
    await eSenseManager.disconnect();
    bool hasSuccessfulConnected = await eSenseManager.connect();
    print("hasSuccessfulConnected: $hasSuccessfulConnected");
  }

  Future<void> _startListening() async {
    StreamSubscription subscription =
        eSenseManager.sensorEvents.listen((event) {
      print('SENSOR event: $event');
    });
    bool hasSuccessfulConnected = await eSenseManager.connect();
    print("hasSuccessfulConnected: $hasSuccessfulConnected");
  }

  List<double> _handleAccel(SensorEvent event) {
    if (event.accel != null) {
      return [
        event.accel![0].toDouble(),
        event.accel![1].toDouble(),
        event.accel![2].toDouble(),
      ];
    } else {
      return [0.0, 0.0, 0.0];
    }
  }

  List<double> _handleGyro(SensorEvent event) {
    if (event.gyro != null) {
      return [
        event.gyro![0].toDouble(),
        event.gyro![1].toDouble(),
        event.gyro![2].toDouble(),
      ];
    } else {
      return [0.0, 0.0, 0.0];
    }
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
      currentQuestionIndex++;
      isAnswerVisible = false;
    });
    if (currentQuestionIndex < countQuestions) {
      tts.speak(sessionQuestions[currentQuestionIndex].question);
    } else {
      tts.speak('You studied all questions!');
    }

    print(sessionQuestions.map((element) => element.status).toList());
  }

  void showAnswer() {
    setState(() {
      isAnswerVisible = true;
    });
    tts.speak(sessionQuestions[currentQuestionIndex].answer);
  }

  void increaseStatus(int index) {
    int statusIdx = sessionQuestions[index].status.index;
    if (statusIdx < 4) {
      setState(() {
        sessionQuestions[index].status = Status.values[++statusIdx];
      });
    }
    nextQuestion();
  }

  void decreaseStatus(int index) {
    int statusIdx = sessionQuestions[index].status.index;
    if (statusIdx > 0) {
      setState(() {
        sessionQuestions[index].status = Status.values[--statusIdx];
      });
    }
    nextQuestion();
  }

  void onSessionFinish() {
    Navigator.pop(context, sessionQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SRS session"),
        ),
        body: Column(children: [
          if (currentQuestionIndex == countQuestions) ...[
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
                      return Text("Counter: ${snapshot.data}");

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
                if (currentQuestionIndex == countQuestions) ...[
                  BottomBarButton(
                      onPressed: onSessionFinish, text: 'Finish Session'),
                ] else ...[
                  if (isAnswerVisible) ...[
                    BottomBarButton(
                        onPressed: () {
                          increaseStatus(currentQuestionIndex);
                        },
                        text: 'Easy'),
                    BottomBarButton(
                        onPressed: () {
                          decreaseStatus(currentQuestionIndex);
                        },
                        text: 'Hard'),
                  ] else ...[
                    BottomBarButton(onPressed: showAnswer, text: 'Show answer'),
                  ],
                ]
              ],
            )));
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
