import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/getx_controller.dart';

class AddDetail extends StatelessWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  final category = 'Work'.obs;  // Make category observable
  final TaskController _noteController = Get.find<TaskController>();

  void saveTask() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Title and Content cannot be empty.');
      return;
    }

    final note = {
      'title': titleController.text,
      'description': descriptionController.text,
      'dueDate': dueDateController.text.isNotEmpty ? dueDateController.text : DateTime.now().toString(),
      'category': category.value,
    };

    _noteController.addTask(note);
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
    Get.back();
  }

  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      dueDateController.text = pickedDate.toLocal().toString().split(' ')[0]; // Format as YYYY-MM-DD
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text('Add Task'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                controller: dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => selectDueDate(context),
              ),
            ),
            Obx(() => DropdownButton<String>(
              dropdownColor: Colors.grey.shade100,
              value: category.value,
              onChanged: (String? newValue) {
                category.value = newValue!;
              },
              items: <String>['Work', 'Personal', 'Miscellaneous']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
            SizedBox(height: 10),
            GestureDetector(
              onTap: saveTask,
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  color: Color(0xff130160),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
