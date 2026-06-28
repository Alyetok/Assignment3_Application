import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';

class AddTaskScreen extends StatefulWidget {
  final int userId;

  const AddTaskScreen({super.key, required this.userId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _apiService = ApiService();
  final _statuses = ['Pending', 'In Progress', 'Completed'];
  String _status = 'Pending';
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selectedDate != null) {
      _dueDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final response = await _apiService.addTask(
      userId: widget.userId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDateController.text,
      status: _status,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'] ?? 'Task saved')),
    );
    if (response['success'] == true) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDate,
                validator: (value) => value == null || value.isEmpty ? 'Due date is required' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: _statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => setState(() => _status = value ?? 'Pending'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveTask,
                child: Text(_isSaving ? 'Saving...' : 'Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
