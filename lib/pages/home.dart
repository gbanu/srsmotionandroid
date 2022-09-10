import 'package:flutter/material.dart';
import 'package:untitled/pages/add_question.dart';
import 'package:untitled/pages/session.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Space Repetition'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddQuestion(),
                    ),
                  );
                },
                child: Text('Add question'),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Session(),
            ),
          );
        },
          child: Icon(Icons.play_arrow),

    ),
    );
  }
}
