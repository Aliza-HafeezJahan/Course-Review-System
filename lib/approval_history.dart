import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class ApprovalHistoryPage extends StatefulWidget {
  ApprovalHistoryPage({Key? key}) : super(key: key);

  @override
  _ApprovalHistoryPageState createState() => _ApprovalHistoryPageState();
}

class _ApprovalHistoryPageState extends State<ApprovalHistoryPage> {
  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  List<Map<String, dynamic>> _checkedReviews = [];
  Map<String, dynamic> data = {};

  var db = FirebaseFirestore.instance;

  void fetchReviews() async {
    final reviewCollection = db.collection('reviews');
    final reviewDocs = await reviewCollection.get();
    final approvedReviews =
        reviewCollection.where("status", isEqualTo: "Approved").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
          setState(() {
            data = docSnapshot.data();
            data["docID"] = docSnapshot.id;

            _checkedReviews.add(data);
            _checkedReviews
                .sort((a, b) => b['approvedOn'].compareTo(a['approvedOn']));
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    final deniedReviews =
        reviewCollection.where("status", isEqualTo: "Denied").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
          setState(() {
            data = docSnapshot.data();
            data["docID"] = docSnapshot.id;

            _checkedReviews.add(data);
            _checkedReviews
                .sort((a, b) => b['approvedOn'].compareTo(a['approvedOn']));
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    // print(pendingReviews);
    // final pendingReviews =
    //     reviewDocs.docs.map((doc) => doc.data()['name'] as String).toList();
    // courseNames.sort();
    // setState(() {
    //   _checkedReviews = pendingReviews;
    // });
    // if (pendingReviews.isEmpty) {
    //   //Navigator.of(context).pop(); // go back to previous screen
    // }
  }

  void removeReview(int index) {
    setState(() {
      _checkedReviews.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approval History'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _checkedReviews.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    _checkedReviews[index]['review'],
                    // style: TextStyle(
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 18.0,
                    // ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        "User: " + _checkedReviews[index]['userEmail'],
                        // style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "Course: " + _checkedReviews[index]['course'],
                        // style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.undo),
                        onPressed: () {
                          _checkedReviews[index]['status'] = "Pending";
                          _checkedReviews[index]['approvedOn'] = "";

                          db
                              .collection("reviews")
                              .doc(_checkedReviews[index]["docID"])
                              .update({"status": "Pending", "approvedOn": ""});

                          removeReview(index);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
