import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onRatingChanged;
  final String teacherId;

  const RatingStars({
    Key? key,
    required this.initialValue,
    required this.onRatingChanged,
    required this.teacherId,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.initialValue;
  }

  void _updateRating(int newRating) async {
    setState(() {
      rating = newRating;
    });

    widget.onRatingChanged(newRating);

    // Update the rating in Firestore
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the current user is not logged in
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('teachers').doc(widget.teacherId); // Use the teacherId
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        List<dynamic> ratings = data['ratings'] ?? [];

        // Find the current user's rating in the list
        int currentUserIndex = ratings.indexWhere((rating) => rating['userId'] == currentUser.uid);

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
          0,
          (int total, rating) => total + rating['rating'] as int,
        );

        // Calculate the new average rating
        double newAverageRating = newTotalRating.toDouble() / ratings.length;

        // Update the rating fields in the document
        docRef.update({
          'ratings': ratings,
          'rating': newAverageRating,
          'ratingCount': ratings.length,
          'totalRating': newTotalRating,
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: const Color.fromARGB(255, 242, 226, 79),
          ),
          onPressed: () => _updateRating(index + 1),
        ),
      ),
    );
  }
}
