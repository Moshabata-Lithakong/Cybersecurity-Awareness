import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/topic_model.dart';
import '../models/question_model.dart';

class AddTopicDialog extends StatefulWidget {
  final Topic? topic;

  const AddTopicDialog({super.key, this.topic});

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedDifficulty = 'beginner';
  final _estimatedTimeController = TextEditingController(text: '10');
  final List<TextEditingController> _objectiveControllers = [TextEditingController()];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _nameController.text = widget.topic!.name;
      _descriptionController.text = widget.topic!.description;
      _selectedDifficulty = widget.topic!.difficulty;
      _estimatedTimeController.text = widget.topic!.estimatedTime.toString();
      _objectiveControllers.clear();
      for (final objective in widget.topic!.learningObjectives) {
        _objectiveControllers.add(TextEditingController(text: objective));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        widget.topic == null ? 'Add New Topic' : 'Edit Topic',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Topic Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Difficulty',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'beginner', child: Text('🌱 Beginner', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'intermediate', child: Text('🚀 Intermediate', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'advanced', child: Text('🔥 Advanced', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (value) => setState(() => _selectedDifficulty = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estimatedTimeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Estimated Time (minutes)',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter estimated time';
                  final time = int.tryParse(value);
                  if (time == null || time <= 0) return 'Please enter a valid time';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Learning Objectives:', 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
              ),
              const SizedBox(height: 8),
              ..._objectiveControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Objective ${index + 1}',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (index == 0 && value!.isEmpty) {
                              return 'At least one objective is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_objectiveControllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeObjective(index),
                        ),
                    ],
                  ),
                );
              }).toList(),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addObjective,
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  label: const Text('Add Objective', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: _isSubmitting ? null : () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _isSubmitting = true);
              
              final objectives = _objectiveControllers
                  .where((controller) => controller.text.isNotEmpty)
                  .map((controller) => controller.text)
                  .toList();

              bool success;
              if (widget.topic == null) {
                success = await quizProvider.addTopic(
                  _nameController.text.trim(),
                  _descriptionController.text.trim(),
                  _selectedDifficulty,
                  int.parse(_estimatedTimeController.text),
                  objectives,
                );
              } else {
                success = await quizProvider.updateTopic(
                  widget.topic!.id,
                  _nameController.text.trim(),
                  _descriptionController.text.trim(),
                  _selectedDifficulty,
                  int.parse(_estimatedTimeController.text),
                  objectives,
                );
              }
              
              setState(() => _isSubmitting = false);
              
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.topic == null ? 'Topic created successfully' : 'Topic updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${quizProvider.error}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            }
          },
          child: _isSubmitting 
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                )
              : Text(widget.topic == null ? 'Create Topic' : 'Update Topic'),
        ),
      ],
    );
  }

  void _addObjective() {
    setState(() => _objectiveControllers.add(TextEditingController()));
  }

  void _removeObjective(int index) {
    if (_objectiveControllers.length > 1) {
      setState(() => _objectiveControllers.removeAt(index));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedTimeController.dispose();
    for (final controller in _objectiveControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class AddQuestionsDialog extends StatefulWidget {
  final List<Topic> topics;

  const AddQuestionsDialog({super.key, required this.topics});

  @override
  State<AddQuestionsDialog> createState() => _AddQuestionsDialogState();
}

class _AddQuestionsDialogState extends State<AddQuestionsDialog> {
  final List<Question> _questions = [];
  String? _selectedTopicId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Add Questions to Topic', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Topic Selection
            DropdownButtonFormField<String>(
              value: _selectedTopicId,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Select Topic *',
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              items: widget.topics.map((topic) {
                return DropdownMenuItem(
                  value: topic.id,
                  child: Text(
                    '${topic.icon} ${topic.name} (${topic.questionsCount} questions)',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedTopicId = value),
              validator: (value) => value == null ? 'Please select a topic' : null,
            ),
            const SizedBox(height: 20),
            
            if (_selectedTopicId != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questions (${_questions.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Question'),
                    onPressed: () => _showAddQuestionDialog(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              if (_questions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No questions added yet. Click "Add Question" to start.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ..._questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return QuestionListTile(
                    question: question,
                    index: index,
                    onEdit: () => _showEditQuestionDialog(index, question),
                    onDelete: () => _showDeleteQuestionDialog(index),
                  );
                }).toList(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: (_selectedTopicId != null && _questions.isNotEmpty && !_isSubmitting)
              ? () async {
                  setState(() => _isSubmitting = true);
                  
                  final success = await quizProvider.addQuestionsToTopic(_selectedTopicId!, _questions);
                  
                  setState(() => _isSubmitting = false);
                  
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Questions added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${quizProvider.error}'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                }
              : null,
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                )
              : Text('Save ${_questions.length} Questions'),
        ),
      ],
    );
  }

  void _showAddQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddQuestionDialog(
        onSave: (question) => setState(() => _questions.add(question)),
      ),
    );
  }

  void _showEditQuestionDialog(int index, Question question) {
    showDialog(
      context: context,
      builder: (context) => AddQuestionDialog(
        question: question,
        onSave: (updatedQuestion) {
          setState(() => _questions[index] = updatedQuestion);
        },
      ),
    );
  }

  void _showDeleteQuestionDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete Question', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this question?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _questions.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  final Question? question;
  final Function(Question) onSave;

  const AddQuestionDialog({super.key, this.question, required this.onSave});

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  int _correctAnswerIndex = 0;
  String _selectedDifficulty = 'medium';

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionController.text = widget.question!.questionText;
      _correctAnswerIndex = widget.question!.correctAnswer;
      _selectedDifficulty = widget.question!.difficulty;
      for (final option in widget.question!.options) {
        _optionControllers.add(TextEditingController(text: option));
      }
    } else {
      // Initialize with 4 empty options
      for (int i = 0; i < 4; i++) {
        _optionControllers.add(TextEditingController());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        widget.question == null ? 'Add New Question' : 'Edit Question',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _questionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Question *',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? 'Please enter a question' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Difficulty Level',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'easy', child: Text('⭐ Easy', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'medium', child: Text('⭐⭐ Medium', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'hard', child: Text('⭐⭐⭐ Hard', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (value) => setState(() => _selectedDifficulty = value!),
              ),
              const SizedBox(height: 20),
              const Text(
                'Answer Options *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the correct answer:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ..._optionControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _correctAnswerIndex,
                        onChanged: (value) => setState(() => _correctAnswerIndex = value!),
                        fillColor: MaterialStateProperty.all(Colors.white),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: _optionControllers.length > 2
                                ? IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
                                    onPressed: () => _removeOption(index),
                                  )
                                : null,
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter option text' : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (_optionControllers.length < 6)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addOption,
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    label: const Text('Add Another Option', style: TextStyle(color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final question = Question(
                id: widget.question?.id ?? '',
                questionText: _questionController.text.trim(),
                options: _optionControllers.map((c) => c.text.trim()).toList(),
                correctAnswer: _correctAnswerIndex,
                explanation: 'Explanation for ${_questionController.text}',
                difficulty: _selectedDifficulty,
                points: _selectedDifficulty == 'easy' ? 10 : _selectedDifficulty == 'medium' ? 15 : 20,
                topicId: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              widget.onSave(question);
              Navigator.pop(context);
            }
          },
          child: const Text('Save Question'),
        ),
      ],
    );
  }

  void _addOption() {
    if (_optionControllers.length < 6) {
      setState(() => _optionControllers.add(TextEditingController()));
    }
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers.removeAt(index);
        if (_correctAnswerIndex >= index && _correctAnswerIndex > 0) {
          _correctAnswerIndex--;
        }
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class QuestionListTile extends StatelessWidget {
  final Question question;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuestionListTile({
    super.key,
    required this.question,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDifficultyColor(question.difficulty),
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          question.questionText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Difficulty: ${question.difficulty}', style: const TextStyle(color: Colors.grey)),
            Text('Correct: ${question.options[question.correctAnswer]}', style: const TextStyle(color: Colors.green)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}