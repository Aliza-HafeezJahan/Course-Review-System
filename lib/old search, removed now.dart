import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'std_course_details.dart';

class StudentSearch extends StatefulWidget {
  final String searchQuery;

  const StudentSearch({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  var db = FirebaseFirestore.instance;

  List<String> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    final courseCollection = db.collection('courses');
    final courseDocs = await courseCollection.get();
    final courseNames =
        courseDocs.docs.map((doc) => doc.data()['name'] as String).toList();
    setState(() {
      courses = courseNames
          .where((name) =>
              name.toLowerCase().contains(widget.searchQuery.toLowerCase()))
          .toList();
    });
    if (courses.isEmpty) {
      //Navigator.of(context).pop(); // go back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = widget.searchQuery;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: courses.isEmpty
          ? Center(
              child: Text(
                'Sorry, no results were found for your search.',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final courseName = courses[index];
                return ListTile(
                  title: Text(courseName),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/std_course_details',
                      arguments: {
                        'name': courseName,
                        'description': "Implement desc from DB",
                        'resources': "Implement resource from DB",
                        // Add any other course information here
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
