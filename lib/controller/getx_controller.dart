import '../helper/db_helper.dart';
import '../helper/firebase_helper.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  var tasks = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final DBHelper _dbHelper = DBHelper();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadTask();
  }

  void loadTask() async {
    isLoading.value = true;
    try {
      final dbTasks = await _dbHelper.getTask();
      tasks.assignAll(dbTasks);
    } catch (e) {
      // Handle the error (show a message or log it)
      Get.snackbar('Error', 'Failed to load tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addTask(Map<String, dynamic> task) async {
    try {
      await _dbHelper.createTask(task);
      loadTask();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }

  void updatedTask(int id, Map<String, dynamic> task) async {
    try {
      await _dbHelper.updateTask(id, task);
      loadTask();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e');
    }
  }

  void deleteTask(int id) async {
    try {
      await _dbHelper.deleteTask(id);
      loadTask();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  void backupTask() async {
    try {
      await _firebaseHelper.uploadTask(tasks);
      Get.snackbar('Success', 'Tasks backed up successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to backup tasks: $e');
    }
  }

  void restoreTask() async {
    try {
      final cloudTasks = await _firebaseHelper.fetchTask();
      for (var task in cloudTasks) {
        await _dbHelper.createTask(task);
      }
      loadTask();
    } catch (e) {
      Get.snackbar('Error', 'Failed to restore tasks: $e');
    }
  }

  void searchTask(String query) {
    final filteredTasks = tasks.where((task) =>
    task['title'].toLowerCase().contains(query.toLowerCase()) ||
        task['description'].toLowerCase().contains(query.toLowerCase())).toList();

    tasks.assignAll(filteredTasks);
  }

  void sortTask(String criteria) {
    if (criteria == 'date') {
      tasks.sort((a, b) {
        final dateA = a['dueDate'] != null ? DateTime.parse(a['dueDate']) : DateTime(0);
        final dateB = b['dueDate'] != null ? DateTime.parse(b['dueDate']) : DateTime(0);
        return dateB.compareTo(dateA);
      });
    } else if (criteria == 'category') {
      tasks.sort((a, b) {
        final categoryA = a['category'] ?? '';
        final categoryB = b['category'] ?? '';
        return categoryA.compareTo(categoryB);
      });
    }
  }
}
