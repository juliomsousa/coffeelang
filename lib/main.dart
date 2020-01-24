import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Text reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lorem =
      "What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

  List<String> markedWords = [];

  void markWord(String word) {
    setState(() {
      markedWords.add(word.toLowerCase());
    });
    print(markedWords);
  }

  bool isMarkedWord(String word) {
    return markedWords.contains(word.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    
    final textSpans = <TextSpan>[];

    lorem.splitMapJoin(
      RegExp('\\w+'),
      onMatch: (m) {
        final matchStr = m.group(0);

        textSpans.add(
          TextSpan(
              // recognizer: DoubleTapGestureRecognizer()..onDoubleTap = () => null,
              // ..onDoubleTap = () => print(matchStr),
              text: matchStr,
              style: isMarkedWord(matchStr)
                  ? TextStyle(
                      background: Paint()..color = Colors.blue.withOpacity(0.4))
                  : null),
        );
        return matchStr;
      },
      onNonMatch: (string) {
        textSpans.add(TextSpan(
          text: string,
        ));
        return string;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SelectableText.rich(
              TextSpan(
                style: TextStyle(fontSize: 30, color: Colors.black),
                children: textSpans,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => print('hello'),
              ),
            ),
            RaisedButton(
              child: Text('add word'),
              onPressed: () async {
                ClipboardData data =
                    await Clipboard.getData(Clipboard.kTextPlain);
                print('copied ${data.text}');
                markWord(data.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
