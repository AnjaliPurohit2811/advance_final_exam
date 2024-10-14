import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/getx_controller.dart';
import '../details/add_detail.dart';

class HomeScreen extends StatelessWidget {
  final TaskController _noteController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Task Manage'),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.cloud_upload),
            onPressed: _noteController.backupTask,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Task',
                border: OutlineInputBorder(),
              ),
              onChanged: _noteController.searchTask,
            ),
          ),
          Obx(() {
            if (_noteController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: ListView.builder(
                itemCount: _noteController.tasks.length,
                itemBuilder: (context, index) {
                  final note = _noteController.tasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListTile(
                      leading: IconButton(onPressed: () {
                        _noteController.updatedTask(note['id'], note['tasks']);
                        Get.to(AddDetail());
                        Get.snackbar('Task Updated', 'The task has been updated successfully.');
                      }, icon: Icon(Icons.edit)),
                      title: Text(note['title'] ?? 'Untitled'),
                      subtitle: Text(note['category'] ?? 'No Category'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _noteController.deleteTask(note['id']);
                          Get.snackbar('Task Deleted',
                              'The task has been deleted successfully.');
                        },
                      ),


                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddDetail()),
        shape: OvalBorder(side: BorderSide(color: Colors.white60, width: 2)),
        backgroundColor: Color(0xff130160),
        foregroundColor: Colors.white,
        child: Icon(CupertinoIcons.add),
      ),
    );
  }

}