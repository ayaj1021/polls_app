import 'package:flutter/material.dart';
import 'package:poll_application/Providers/db_provider.dart';
import 'package:poll_application/Styles/colors.dart';
import 'package:poll_application/Utils/message.dart';
import 'package:provider/provider.dart';

class AddPollPage extends StatefulWidget {
  const AddPollPage({super.key});

  @override
  State<AddPollPage> createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add poll"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Form field
                      FormWidget(
                        labelText: "Questions",
                        controller: questionController,
                      ),
                      FormWidget(
                        labelText: "Option 1",
                        controller: option1Controller,
                      ),
                      FormWidget(
                        labelText: "Option 2",
                        controller: option2Controller,
                      ),
                      FormWidget(
                        labelText: "Duration",
                        controller: durationController,
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.utc(2025))
                              .then((value) {
                            if (value == null) {
                              durationController.clear();
                            } else {
                              durationController.text = value.toString();
                            }
                          });
                        },
                      ),

                      //Create button
                      Consumer<DbProvider>(
                          builder: (context, dbProvider, child) {
                        WidgetsBinding.instance
                            .addPersistentFrameCallback((_) {
                          if (dbProvider.message != "") {
                            if (dbProvider.message.contains("Poll Created")) {
                              success(context, message: dbProvider.message);
                              dbProvider.clear();
                            } else {
                              error(context, message: dbProvider.message);
                              dbProvider.clear();
                            }
                          }
                        });
                        return GestureDetector(
                          onTap: dbProvider.status == true
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    //Save to database
                                    List<Map> options = [
                                      {
                                        "answer": option1Controller.text.trim(),
                                        "percent": 0,
                                      },
                                      {
                                        "answer": option2Controller.text.trim(),
                                        "percent": 0,
                                      },
                                    ];
                                   
                                    dbProvider.addPoll(
                                        question:
                                            questionController.text.trim(),
                                        duration:
                                            durationController.text.trim(),
                                        options: options);
                                  }
                                },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                              color: dbProvider.status == true
                                  ? AppColors.greyColor
                                  : AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dbProvider.status == true
                                  ? "Please wait..."
                                  : 'Post poll',
                            ),
                          ),
                        );
                      })
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
    required this.labelText,
    required this.controller,
    this.onTap,
  });
  final String labelText;
  final TextEditingController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onTap: onTap,
        readOnly: onTap == null ? false : true,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Input is required";
          }
          return null;
        },
        decoration: InputDecoration(
            errorBorder: const OutlineInputBorder(),
            labelText: labelText,
            border: const OutlineInputBorder()),
      ),
    );
  }
}
