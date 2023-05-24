import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  final CollectionReference teachersCollection =
      FirebaseFirestore.instance.collection('teachers');

  LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft, // Wrap the AppBar title with Center widget
          child: Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: teachersCollection
              .orderBy('rating', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final teachers = snapshot.data!.docs;

              return ListView.builder(
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  final teacher = teachers[index];
                  final name = teacher['name'] as String;
                  final rating = teacher['rating'] ?? 0.0;

                  if (index < 3) {
                    return _buildPodiumItem(name, rating, index + 1);
                  } else {
                    return _buildTeacherItem(name, rating, index + 1);
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
    );
  }

  Widget _buildPodiumItem(String name, double rating, int rank) {
    Color backgroundColor = Colors.brown; // Bronze for the third place
    if (rank == 1) {
      backgroundColor = Colors.amber[400]!; // Gold for the first place
    } else if (rank == 2) {
      backgroundColor = Colors.blueGrey[200]!; // Silver for the second place
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: backgroundColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: CircleAvatar(
          child: Text(rank.toString()),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white, // White text color for visibility
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Rating: ${rating.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildTeacherItem(String name, double rating, int rank) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(rank.toString()),
        ),
        title: Text(name),
        subtitle: Text('Rating: ${rating.toStringAsFixed(2)}'),
      ),
    );
  }
}
