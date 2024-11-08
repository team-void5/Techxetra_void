import 'package:facebook_clone/core/constants/firebase_field_names.dart';
import 'package:flutter/foundation.dart' show immutable; //Imported this for using the 'immutable' keyword.

@immutable
class Post { // Create the immutable Post class
  final String postId; // Variable named 'postId' to store the uid for the respective post.
  final String posterId; // Variable named 'posterId' to store the uid of user who posted.
  final String content; // Variable named 'content' to store the caption and all text content along with it.
  final String postType; // Variable named 'postType' to store the type of the post (Image or Video).
  final String fileUrl; // Variable named 'fileUrl' to store the url of the file uploaded.
  final DateTime createdAt; // Variable named 'createdAt' to store the date & time of the post's creation.
  final List<String> likes; // 

  const Post({ // Constructor to gather the values upon first initialisation.
    required this.postId,
    required this.posterId,
    required this.content,
    required this.postType,
    required this.fileUrl,
    required this.createdAt,
    required this.likes,
  });

  Map<String, dynamic> toMap() // Creates a function named 'toMap()' to return the values as a key:value pair.
  { 
    return <String, dynamic>{
      FirebaseFieldNames.postId: postId, 
      FirebaseFieldNames.posterId: posterId,
      FirebaseFieldNames.content: content,
      FirebaseFieldNames.fileUrl: fileUrl,
      FirebaseFieldNames.datePublished: createdAt.millisecondsSinceEpoch,
      FirebaseFieldNames.likes: likes,
      FirebaseFieldNames.postType: postType,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) // Constructor to gather the values upon initialisation, but handles missing values better.
  {
    return Post(
      postId: map[FirebaseFieldNames.postId] ?? '', // 'postId' variable stores the value associated with in, in the given input.
      posterId: map[FirebaseFieldNames.posterId] ?? '',
      content: map[FirebaseFieldNames.content] ?? '',
      postType: map[FirebaseFieldNames.postType] ?? '',
      fileUrl: map[FirebaseFieldNames.fileUrl] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[FirebaseFieldNames.datePublished] ?? 0), // 'createdAt' stores the data & time value associated with it, in the given input.
      likes: List<String>.from(
        (map[FirebaseFieldNames.likes] ?? []),
      ),
    );
  }
}