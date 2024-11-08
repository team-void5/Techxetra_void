import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Immutable; //Imported this for using the 'immutable' keyword.

@immutable
class PostRepository {
	final _auth = FirebaseAuth.instace;` // '\_auth' variable to store the Firebase's authorisation instance that we will create. Keep in mind that it is **final** (only assigned value once)
	final _firestore = FirebaseFirestore.instance;` // '\_firestore' variable to store the Firebase's firestore instance that we will create. Keep in mind that it is **final** (only assigned value once)
	final _storage = FirebaseStorage.instance;` // '\_storage' variable to store the Firebase's storage instance that we will create. Keep in mind that it is **final** (only assigned value once)

// Make POST section [START]

   Future<String?> makePost({ required String content, required File file, required String postType }) async // Create a function to make posts, having 3 must-give parameters with 'content' meaning the caption and all text content along with it, 'file' meaning the actual file, 'postType' signifying whether it the post is an image or video.
      {
      try
      {
         final postId = const Uuid().vi1(); // Variable named 'postId' to generate and store the uid for the respective post.
         final posterId = auth.currentUser!.uid; // Variable named 'posterId' to store the uid of user who posted.
         final now = DateTime.now(); // Variable named ' now' to store the current date & time.

         // Post file to storage

         final fileUid = const Uuid().v1(); // Variable 'fileUid' to generate and store the uid for the respective file.
         final path = \_storage.ref(postType).child(fileUid); // Variable 'path' to store the path of the fileUid by referencing the storage instance.
         final taskSnapshot = await path.putFile(file); // Variable 'taskSnapshot' stores the result of the upload operation. The 'putFile()' function waits until it is uploaded and then only store the result.
         final downloadUrl =await taskSnapshot.ref.getDownloadURL(); // Variable 'downloadUrl' to store the download URL after generating it.

         // Create our post

         Post post = Post(
            postId: postId,
            posterId: posterId,
            content: content,
            postType: postType,
            fileUrl: downloadUrl,
            createdAt: now,
            likes: const [],
         );

         // Post to firestore

         _firestore
            .collection(FirebaseCollectionNames.posts)
            .doc(postId)
            .set(post.toMap());

         return null;
      }
      catch (e)
      {
         return e.toString();
      }
  }

  // Like a post
  Future<String?> likeDislikePost({
    required String postId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;

      if (likes.contains(authorId)) {
        // we already liked the post
        _firestore
            .collection(FirebaseCollectionNames.posts)
            .doc(postId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayRemove([authorId])
        });
      } else {
        // we need to like the post
        _firestore
            .collection(FirebaseCollectionNames.posts)
            .doc(postId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayUnion([authorId])
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // make comment
  Future<String?> makeComment({
    required String text,
    required String postId,
  }) async {
    try {
      final commentId = const Uuid().v1();
      final authorId = _auth.currentUser!.uid;
      final now = DateTime.now();

      // Create our post
      Comment comment = Comment(
        commentId: commentId,
        authorId: authorId,
        postId: postId,
        text: text,
        createdAt: now,
        likes: const [],
      );

      // Post to firestore
      _firestore
          .collection(FirebaseCollectionNames.comments)
          .doc(commentId)
          .set(comment.toMap());

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Like a post
  Future<String?> likeDislikeComment({
    required String commentId,
    required List<String> likes,
  }) async {
    try {
      final authorId = _auth.currentUser!.uid;

      if (likes.contains(authorId)) {
        // we already liked the post
        _firestore
            .collection(FirebaseCollectionNames.comments)
            .doc(commentId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayRemove([authorId])
        });
      } else {
        // we need to like the post
        _firestore
            .collection(FirebaseCollectionNames.comments)
            .doc(commentId)
            .update({
          FirebaseFieldNames.likes: FieldValue.arrayUnion([authorId])
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}