import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizHomePage(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.purple[900],
      ),
    );
  }
}

class QuizHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'asset/inn.jpg',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Learn Flutter the Fun Way!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  List<String> _feedback = [];
  bool _questionAnswered = false;
  int _correctAnswers = 0; //

  List<Map<String, dynamic>> _questions = [
    {
      'questionText': 'What does HTML stand for?',
      'answers': [
        'Hyper Text Markup Language',
        'Hyperlinks and Text Markup Language',
        'Home Tool Markup Language',
        'Hyper Tool Markup Language'
      ],
      'correctAnswer': 'Hyper Text Markup Language',
    },
    {
      'questionText': 'What is CSS used for?',
      'answers': [
        'Styling HTML elements',
        'Manipulating data',
        'Defining page structure',
        'Executing JavaScript code'
      ],
      'correctAnswer': 'Styling HTML elements',
    },
    {
      'questionText':
          'Which programming language is used for Flutter development?',
      'answers': ['Dart', 'Java', 'Python', 'JavaScript'],
      'correctAnswer': 'Dart',
    },
    {
      'questionText':
          'What is the main function of a database management system (DBMS)?',
      'answers': [
        'Managing and organizing data',
        'Displaying web content',
        'Running server-side scripts',
        'Creating user interfaces'
      ],
      'correctAnswer': 'Managing and organizing data',
    },
  ];

  void _answerQuestion(String selectedAnswer) {
    setState(() {
      if (_quizCompleted || _questionAnswered) {
        return;
      }
      if (selectedAnswer ==
          _questions[_currentQuestionIndex]['correctAnswer']) {
        _feedback.add('Correct!');
        _correctAnswers++;
      } else {
        _feedback.add(
            'Incorrect! Correct answer: ${_questions[_currentQuestionIndex]['correctAnswer']}');
      }
      _questionAnswered = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _feedback.clear();
        _questionAnswered = false;
      } else {
        _quizCompleted = true;
      }
    });
  }

  void _submitQuestion() {
    setState(() {
      _questionAnswered = true;
    });
  }

  void _submitQuiz() {
    setState(() {
      _quizCompleted = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _quizCompleted = false;
      _feedback.clear();
      _questionAnswered = false;
      _correctAnswers = 0; // Reset correct answers count
    });
  }

  List<Map<String, dynamic>> _incorrectlyAnsweredQuestions() {
    List<Map<String, dynamic>> incorrectQuestions = [];
    for (int i = 0; i < _questions.length; i++) {
      if (_feedback.length > i && !_feedback[i].startsWith('Correct')) {
        incorrectQuestions.add({
          'questionText': _questions[i]['questionText'],
          'correctAnswer': _questions[i]['correctAnswer'],
          'selectedAnswer':
              _feedback[i].replaceFirst('Incorrect! Correct answer: ', ''),
        });
      }
    }
    return incorrectQuestions;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz App'),
        ),
        body: _quizCompleted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Quiz Completed!',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Score: $_correctAnswers/${_questions.length}', // Display correct answers count
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  if (_incorrectlyAnsweredQuestions().isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Incorrectly Answered Questions:',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              _incorrectlyAnsweredQuestions().map((question) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Question: ${question['questionText']}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Your Answer: ${question['selectedAnswer']}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Correct Answer: ${question['correctAnswer']}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _restartQuiz,
                    child: Text('Restart Quiz'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Close the app when exit button is pressed
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text('Exit'),
                  ),
                ],
              )
            : Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      _questions[_currentQuestionIndex]['questionText'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 20.0),
                    ...(_questions[_currentQuestionIndex]['answers']
                            as List<String>)
                        .map((answer) {
                      return ElevatedButton(
                        onPressed: () => _answerQuestion(answer),
                        child: Text(answer),
                      );
                    }).toList(),
                    SizedBox(height: 20.0),
                    Text(
                      _feedback.isNotEmpty ? _feedback.last : '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentQuestionIndex > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentQuestionIndex--;
                                _feedback.clear();
                                _questionAnswered = false;
                              });
                            },
                            child: Text('Previous'),
                          ),
                        ElevatedButton(
                          onPressed: _questionAnswered
                              ? _nextQuestion
                              : _submitQuestion,
                          child: Text(_questionAnswered ? 'Next' : 'Submit'),
                        ),
                        ElevatedButton(
                          onPressed: _submitQuiz,
                          child: Text('Finish'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
