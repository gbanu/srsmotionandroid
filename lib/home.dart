import 'package:flutter/material.dart';
import 'package:untitled/counter_text.dart';

class _HomePageState extends State<HomePage> {
  int count = 0;

  void _increment() {
    setState((){ //calls build()-method
      count++;}
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
          child: CounterText(count)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: Icon(Icons.add),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}