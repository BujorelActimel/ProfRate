import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'rating_stars.dart';
import 'leaderborad_page.dart';
import 'settings_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference teachersCollection =
      FirebaseFirestore.instance.collection('teachers');

  List<DocumentSnapshot> teachers = [];
  List<DocumentSnapshot> filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    teachersCollection.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          teachers = snapshot.docs;
          filteredTeachers = snapshot.docs;
        });
      }
    });
  }


  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void _updateRating(DocumentReference docRef, int newRating) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the current user is not logged in
      return;
    }

    docRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          List<dynamic> ratings = data['ratings'] ?? [];

          // Find the current user's rating in the list
          int currentUserIndex = ratings
              .indexWhere((rating) => rating['userId'] == currentUser.uid);

          // If the current user has previously rated, update their rating
          if (currentUserIndex != -1) {
            ratings[currentUserIndex]['rating'] = newRating;
          } else {
            // If the current user has not previously rated, add their rating to the list
            ratings.add({
              'userId': currentUser.uid,
              'rating': newRating,
            });
          }

          // Calculate the new total rating based on all the individual ratings
          int newTotalRating = ratings.fold<int>(
              0, (int total, rating) => total + rating['rating'] as int);

          // Calculate the new average rating
          double newAverageRating = newTotalRating.toDouble() / ratings.length;

          // Update the rating fields in the document
          teachersCollection.doc(docRef.id).update({
            'ratings': ratings,
            'rating': newAverageRating,
            'ratingCount': ratings.length,
            'totalRating': newTotalRating,
          });
        }
      }
    });
  }

  void _searchTeachers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredTeachers = teachers;
      });
    } else {
      setState(() {
        filteredTeachers = teachers.where((teacher) {
          final name = teacher['name'] as String;
          final subject = teacher['subject'] as String;
          return name.toLowerCase().contains(query.toLowerCase()) ||
              subject.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _navigateToLeaderboardPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaderboardPage()),
    );
  }

  void _openOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: const Text('Prof-Rate'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Logged in as:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    user.email!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Leaderboard'),
              onTap: _navigateToLeaderboardPage,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: _openOptions,
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: signUserOut,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Explore and Rate!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 45, 64, 81),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: _searchTeachers,
                decoration: const InputDecoration(
                  labelText: 'Search Teachers or Subjects',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTeachers.length,
                itemBuilder: (context, index) {
                  final teacher = filteredTeachers[index];
                  final name = teacher['name'] as String;
                  final rating = teacher['rating'] ?? 0.0;
                  final subject = teacher['subject'] as String;
                  final imageUrl = teacher['imageUrl'];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Handle card tap action
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: imageUrl != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Subject: $subject',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${teacher['ratingCount']} ratings)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            RatingStars(
                              initialValue: rating.toInt(),
                              onRatingChanged: (newRating) =>
                                  _updateRating(teacher.reference, newRating),
                              teacherId: teacher.id,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
