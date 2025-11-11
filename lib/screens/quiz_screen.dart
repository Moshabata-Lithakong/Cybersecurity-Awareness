import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/quiz_provider.dart';
import 'package:cybersecurity_quiz_app/widgets/quiz_card.dart';
import 'package:cybersecurity_quiz_app/screens/results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _submitQuiz() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    
    try {
      final response = await quizProvider.submitQuiz();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(quizResult: response),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting quiz: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Submit Quiz?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to submit your answers?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Review',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitQuiz();
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          quizProvider.currentTopic?.name ?? 'Quiz',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => _showExitConfirmation(),
        ),
        actions: [
          if (quizProvider.isQuizComplete)
            IconButton(
              icon: const Icon(Icons.check_rounded, color: Colors.white),
              onPressed: _showSubmitConfirmation,
            ),
        ],
      ),
      body: quizProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: quizProvider.totalQuestions > 0
                      ? (quizProvider.currentQuestionIndex + 1) / quizProvider.totalQuestions
                      : 0,
                  backgroundColor: Colors.grey[800],
                  color: Colors.white,
                ),
                // Quiz Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quizProvider.totalQuestions,
                    itemBuilder: (context, index) {
                      return QuizCard(
                        question: quizProvider.currentQuestions[index],
                        questionNumber: index + 1,
                        totalQuestions: quizProvider.totalQuestions,
                        selectedAnswer: quizProvider.userAnswers[index],
                        onAnswerSelected: (answerIndex) {
                          quizProvider.answerQuestion(answerIndex);
                        },
                      );
                    },
                  ),
                ),
                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (quizProvider.currentQuestionIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              quizProvider.previousQuestion();
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Previous'),
                          ),
                        ),
                      if (quizProvider.currentQuestionIndex > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (quizProvider.currentQuestionIndex < quizProvider.totalQuestions - 1) {
                              quizProvider.nextQuestion();
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _showSubmitConfirmation();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            quizProvider.currentQuestionIndex < quizProvider.totalQuestions - 1
                                ? 'Next'
                                : 'Submit',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Exit Quiz?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your progress will be lost if you exit the quiz.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Exit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}