import 'package:application_assignment3/widget/task_card.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  final List<String> _filters = ['All', 'Pending', 'In Progress', 'Completed'];
  List<Task> _tasks = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  List<Task> get _filteredTasks {
    if (_selectedFilter == 'All') return _tasks;
    return _tasks.where((task) => task.status == _selectedFilter).toList();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _apiService.getTasks(widget.user.id);
      if (mounted) setState(() => _tasks = tasks);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Remove "${task.title}" from your task list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final response = await _apiService.deleteTask(
      taskId: task.id,
      userId: widget.user.id,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'] ?? 'Task deleted')),
    );
    if (response['success'] == true) _loadTasks();
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.name),
              accountEmail: Text(widget.user.email),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh Tasks'),
              onTap: () {
                Navigator.pop(context);
                _loadTasks();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: Column(
          children: [
            SizedBox(
              height: 58,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _filters.length,
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTasks.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 150),
                        Icon(
                          Icons.assignment_outlined,
                          size: 70,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Center(child: Text('No tasks found')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return TaskCard(
                          task: task,
                          onEdit: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTaskScreen(
                                  task: task,
                                  userId: widget.user.id,
                                ),
                              ),
                            );
                            if (changed == true) _loadTasks();
                          },
                          onDelete: () => _deleteTask(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final changed = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(userId: widget.user.id),
            ),
          );
          if (changed == true) _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
