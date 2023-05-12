import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Courses'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('courses').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final courses = snapshot.data!.docs.map((doc) => doc.data()).toList();

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? courseData =
                  courses[index] as Map<String, dynamic>?;
              String name = courseData?['name'] ?? '';
              return ListTile(
                title: Text(name),
              );
            },
          );
        },
      ),
    );
  }
}
