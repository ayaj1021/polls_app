// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poll_application/Providers/db_provider.dart';
import 'package:poll_application/Providers/fetch_poll_provider.dart';
import 'package:poll_application/Screens/main_activity_page.dart';
import 'package:poll_application/Styles/colors.dart';
import 'package:poll_application/Utils/message.dart';
import 'package:poll_application/Utils/router.dart';
import 'package:provider/provider.dart';

class IndividualPollPage extends StatefulWidget {
  final String? id;

  const IndividualPollPage({super.key, required this.id});

  @override
  State<IndividualPollPage> createState() => _IndividualPollPageState();
}

class _IndividualPollPageState extends State<IndividualPollPage> {
  bool _isFetched = false;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        nextPageRemoveUntil(context, const MainActivityPage());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.id!),
          centerTitle: true,
        ),
        body: Consumer<FetchPollsProvider>(
            builder: (context, fetchPollsProvider, child) {
          if (_isFetched == false) {
            fetchPollsProvider.fetchIndividualPolls(widget.id!);

            Future.delayed(const Duration(microseconds: 1), () {
              _isFetched = true;
            });
          }
          return SafeArea(
            child: fetchPollsProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : !fetchPollsProvider.individualPoll.exists
                    ? const Center(
                        child: Text("No polls at the moment"),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ...List.generate(1, (index) {
                                    final data =
                                        fetchPollsProvider.individualPoll;

                                    log(data.data().toString());
                                    Map author = data["author"];
                                    Map poll = data["poll"];
                                    Timestamp date = data["dateCreated"];
                                    List voters = poll["voters"];

                                    List<dynamic> options =
                                        data["poll"]["options"];

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.greyColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                author["profileImage"],
                                              ),
                                            ),
                                            title: Text(author["name"]),
                                            subtitle: Text(
                                              DateFormat.yMEd().format(
                                                date.toDate(),
                                              ),
                                            ),
                                            // trailing: IconButton(
                                            //     onPressed: () {},
                                            //     icon: const Icon(Icons.share)),
                                          ),
                                          Text(poll["question"]),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          ...List.generate(options.length,
                                              (index) {
                                            final dataOption = options[index];
                                            return Consumer<DbProvider>(builder:
                                                (context, dbProvider, child) {
                                              WidgetsBinding.instance
                                                  .addPersistentFrameCallback(
                                                      (_) {
                                                if (dbProvider.message != "") {
                                                  if (dbProvider.message
                                                      .contains(
                                                          "Votes Recorded")) {
                                                    success(context,
                                                        message:
                                                            dbProvider.message);
                                                    fetchPollsProvider
                                                        .fetchAllPolls();
                                                    dbProvider.clear();
                                                  } else {
                                                    error(context,
                                                        message:
                                                            dbProvider.message);
                                                    dbProvider.clear();
                                                  }
                                                }
                                              });
                                              return GestureDetector(
                                                onTap: () {
                                                  //Update vote
                                                  if (voters.isEmpty) {
                                                    log("No vote");
                                                    dbProvider.votePoll(
                                                        pollId: data.id,
                                                        pollData: data,
                                                        previousTotalVotes:
                                                            poll["total_votes"],
                                                        selectedOptions:
                                                            dataOption[
                                                                "answer"]);
                                                  } else {
                                                    final isExist =
                                                        voters.firstWhere(
                                                            (element) =>
                                                                element[
                                                                    "uid"] ==
                                                                user!.uid,
                                                            orElse: () {});
                                                    if (isExist == null) {
                                                      log("User does not exist");
                                                      dbProvider.votePoll(
                                                          pollId: data.id,
                                                          pollData: data,
                                                          previousTotalVotes:
                                                              poll[
                                                                  "total_votes"],
                                                          selectedOptions:
                                                              dataOption[
                                                                  "answer"]);
                                                    } else {
                                                      error(context,
                                                          message:
                                                              "You have already voted");
                                                    }
                                                    log(isExist.toString());
                                                  }
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(children: [
                                                    Expanded(
                                                        child: Stack(
                                                      children: [
                                                        LinearProgressIndicator(
                                                          minHeight: 30,
                                                          backgroundColor:
                                                              AppColors
                                                                  .whiteColor,
                                                          value: dataOption[
                                                                  "percent"] /
                                                              100,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          height: 30,
                                                          child: Text(
                                                              dataOption[
                                                                  "answer"]),
                                                        )
                                                      ],
                                                    )),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                        "${dataOption["percent"]}%"),
                                                  ]),
                                                ),
                                              );
                                            });
                                          }),
                                          Text(
                                              "Total votes: ${poll["total_votes"]}"),
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          );
        }),
      ),
    );
  }
}
