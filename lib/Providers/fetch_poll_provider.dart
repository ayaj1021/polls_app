import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FetchPollsProvider extends ChangeNotifier {
  List<DocumentSnapshot> _pollsList = [];
  List<DocumentSnapshot> _usersPollsList = [];

  DocumentSnapshot? _individualPoll;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<DocumentSnapshot> get pollsList => _pollsList;
  List<DocumentSnapshot> get usersPollsList => _usersPollsList;
  DocumentSnapshot get individualPoll => _individualPoll!;

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference pollCollection =
      FirebaseFirestore.instance.collection("polls");
//Fetch all polls
  void fetchAllPolls() async {
    pollCollection.get().then((value) {
      if (value.docs.isEmpty) {
        _pollsList = [];
        _isLoading = false;
        notifyListeners();
      } else {
        final data = value.docs;
        _pollsList = data;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  //Fetch user polls
  void fetchUserPolls() async {
    pollCollection.where("authorId", isEqualTo: user!.uid).get().then((value) {
      if (value.docs.isEmpty) {
        _usersPollsList = [];
        _isLoading = false;
        notifyListeners();
      } else {
        final data = value.docs;
        _usersPollsList = data;
        _isLoading = false;
        notifyListeners();

        // final data = value.docs;

        // final isExist = data
        //     .firstWhere(
        //       (element) => element["author"]["uid"] == user!.uid,
        //     )
        //     .exists;
        // print(isExist);
        // if (isExist == true) {
        //   _usersPollsList = data;
        //   _isLoading = false;
        //   notifyListeners();
        // } else {
        //   _usersPollsList = [];
        //   _isLoading = false;
        //   notifyListeners();
        // }
      }
    });
  }

  //Fetch individual polls
  void fetchIndividualPolls(String id) async {
    pollCollection.doc(id).get().then((value) {
      if (!value.exists) {
        _individualPoll = value;
        _isLoading = false;
        notifyListeners();
      } else {
        final data = value;
        _individualPoll = data;
        _isLoading = false;
        notifyListeners();
      }
    });
  }
}
