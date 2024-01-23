import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poll_application/Providers/db_provider.dart';
import 'package:poll_application/Providers/fetch_poll_provider.dart';
import 'package:poll_application/Screens/BottomNavPages/MyPolls/add_new_polls.dart';
import 'package:poll_application/Styles/colors.dart';
import 'package:poll_application/Utils/message.dart';
import 'package:poll_application/Utils/router.dart';
import 'package:provider/provider.dart';

class MyPollPage extends StatefulWidget {
  const MyPollPage({super.key});

  @override
  State<MyPollPage> createState() => _MyPollPageState();
}

class _MyPollPageState extends State<MyPollPage> {
  bool _isFetched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FetchPollsProvider>(
          builder: (context, fetchPollsProvider, child) {
        if (_isFetched == false) {
          fetchPollsProvider.fetchUserPolls();

          Future.delayed(const Duration(microseconds: 1), () {
            _isFetched = true;
          });
        }
        return SafeArea(
          child: fetchPollsProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : fetchPollsProvider.usersPollsList.isEmpty
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
                                ...List.generate(
                                    fetchPollsProvider.usersPollsList.length,
                                    (index) {
                                  final data =
                                      fetchPollsProvider.usersPollsList[index];

                                  log(data.data().toString());
                                  Map author = data["author"];
                                  Map poll = data["poll"];
                                  Timestamp date = data["dateCreated"];
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
                                          trailing: Consumer<DbProvider>(
                                              builder:
                                                  (context, dbProvider, child) {
                                            WidgetsBinding.instance
                                                .addPersistentFrameCallback(
                                                    (_) {
                                              if (dbProvider.message != "") {
                                                if (dbProvider.message
                                                    .contains("Poll Deleted")) {
                                                  success(context,
                                                      message:
                                                          dbProvider.message);
                                                  fetchPollsProvider
                                                      .fetchUserPolls(); 
                                                  dbProvider.clear();
                                                } else {
                                                  error(context,
                                                      message:
                                                          dbProvider.message);
                                                  dbProvider.clear();
                                                }
                                              }
                                            });
                                            return IconButton(
                                              onPressed:
                                                  dbProvider.deleteStatus == true
                                                      ? null
                                                      : () {
                                                          dbProvider.deletePoll(
                                                              pollId: data.id);
                                                        },
                                              icon: dbProvider.deleteStatus == true
                                                  ? const CircularProgressIndicator()
                                                  : const Icon(
                                                      Icons.delete_outline),
                                            );
                                          }),
                                        ),
                                        Text(poll["question"]),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        ...List.generate(options.length,
                                            (index) {
                                          final dataOption = options[index];
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(children: [
                                              Expanded(
                                                  child: Stack(
                                                children: [
                                                  LinearProgressIndicator(
                                                    minHeight: 30,
                                                    backgroundColor:
                                                        AppColors.whiteColor,
                                                    value:
                                                        dataOption["percent"] /
                                                            100,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text(
                                                        dataOption["answer"]),
                                                  )
                                                ],
                                              )),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text("${dataOption["percent"]}%"),
                                            ]),
                                          );
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          nextPage(context, const AddPollPage());
        },
        label: const Text('Create a new poll'),
      ),
    );
  }
}
