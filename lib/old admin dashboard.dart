import 'package:flutter/material.dart';
import 'admin_search.dart';

class AdminDashboard extends StatelessWidget {
  final TextEditingController _searchQueryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Courses',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  //         onPressed: () {
                  //           Navigator.pushNamed(context, '/adminSearch');
                  //         },
                  //       ),
                  //     ),
                  //     onSubmitted: (String value) {
                  //       Navigator.pushNamed(context, '/adminSearch');
                  //     },
                  //   ),
                  // ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminSearch(
                          searchQuery: _searchQueryController.text,
                        ),
                      ),
                    );
                  },
                ),
              ),
              onSubmitted: (String value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSearch(searchQuery: value),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pendingReviews');
            },
            child: const Text('View Pending Reviews'),
          ),
          const SizedBox(height: 14.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pendingResources');
            },
            child: const Text('View Pending Resources'),
          ),
          const SizedBox(height: 14.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/approvalHistory');
            },
            child: const Text('Approval History'),
          ),
        ],
      ),
    );
  }
}
