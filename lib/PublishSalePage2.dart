import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishSalePage2 extends StatefulWidget {
  const PublishSalePage2({Key? key}) : super(key: key);

  @override
  State<PublishSalePage2> createState() => _PublishSalePage2State();
}

class _PublishSalePage2State extends State<PublishSalePage2> {
  final minTitleChars = 6;

  List<AssetEntity>? result = [];
  late int resultLength = result!.length;
  String value = "";

  var titleController = TextEditingController();
  var categoryController = TextEditingController();
  var priceController = TextEditingController();
  var conditionController = TextEditingController();
  var detailsController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var categoryList = <String>["Book", "Electronics", "Other"];
  String? selectedCategory;

  var conditionList = <String>["New", "Almost New", "Good", "Fine", "Worn-out"];
  String? selectedCondition;

  bool noPhoto = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.arrow_back, size: 30)),
                ),
                Center(
                  child: Text(
                    "Publish Sale",
                    style: TextStyle(fontSize: 25),
                  ),
                )
              ]),
            ),
            Divider(
              height: 0,
              thickness: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: titleController,
                            maxLength: 50,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              labelText: "Title",
                            ),
                            validator: (textInput) {
                              if (textInput != null) {
                                if (textInput.isEmpty) {
                                  return "Please enter a title";
                                }
                                if (textInput.length < minTitleChars) {
                                  return "Your title should have at least $minTitleChars characters";
                                }
                                return null;
                              }
                              return "Invalid Input";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: categoryController,
                            readOnly: true,
                            showCursor: false,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                labelText: "Category"),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () async {
                                        FocusScope.of(context).unfocus();
                                        return true;
                                      },
                                      child: AlertDialog(
                                        titlePadding: EdgeInsets.all(0),
                                        contentPadding: EdgeInsets.all(0),
                                        title: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 20,
                                          ),
                                          child: Text("Select Category"),
                                        ),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  categoryController.text =
                                                      "Books";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Text(
                                                        "Books",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  categoryController.text =
                                                      "Electronic Devices";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Text(
                                                        "Electronic Devices",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  categoryController.text =
                                                      "Other";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Text(
                                                        "Other",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              )
                                            ]),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            validator: (categorySelection) {
                              if (categorySelection != null) {
                                if (categorySelection.isEmpty) {
                                  return "Please select a category";
                                }
                                return null;
                              }
                              return "Invalid Input";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: priceController,
                            style: TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                suffixText: "TL",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                labelText: "Price"),
                            validator: (textInput) {
                              if (textInput != null) {
                                if (textInput.isEmpty) {
                                  return "Please set a price";
                                }
                              }
                              return "Invalid Input";
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Photos  $resultLength/5"),
                              noPhoto
                                  ? Text(
                                      "Add at least one photo",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Text(""),
                            ],
                          ),
                        ),
                        Container(
                          height: 120,
                          margin: EdgeInsets.only(left: 6, bottom: 8),
                          child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    side: BorderSide(
                                        color: Colors.black45, width: 2)),
                                child: SizedBox(
                                  width: 120,
                                  child: insideCard(resultLength, index),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: conditionController,
                            scrollPadding: EdgeInsets.all(100),
                            readOnly: true,
                            showCursor: false,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                labelText: "Condition of Product"),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      FocusScope.of(context).unfocus();
                                      return true;
                                    },
                                    child: AlertDialog(
                                      titlePadding: EdgeInsets.all(0),
                                      contentPadding: EdgeInsets.all(0),
                                      title: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 20,
                                        ),
                                        child: Text("Condition of Product"),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              conditionController.text = "New";
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    "New",
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 18),
                                                  ),
                                                )),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              conditionController.text =
                                                  "Almost New";
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    "Almost New",
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 18),
                                                  ),
                                                )),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              conditionController.text = "Good";
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  "Good",
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              conditionController.text =
                                                  "Not Bad";
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  "Not Bad",
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              conditionController.text =
                                                  "Worn Out";
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  "Worn Out",
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            validator: (textInput) {
                              if (textInput != null) {
                                if (textInput.isEmpty) {
                                  return "Please select a condition for your product";
                                }
                                return null;
                              }
                              return "Invalid Input";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: detailsController,
                            style: TextStyle(fontSize: 18),
                            scrollPadding: EdgeInsets.all(100),
                            maxLength: 1000,
                            minLines: 2,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                labelText: "Details"),
                            validator: (textInput) {
                              if (textInput != null) {
                                if (textInput.isEmpty ||
                                    textInput.length < 10) {
                                  return "Need to be at least 10 characters";
                                }
                              }
                              return "Invalid Input";
                            },
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 8,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    bool? validate = formKey.currentState?.validate();
                    if (resultLength == 0 && !noPhoto) {
                      setState(() {
                        noPhoto = true;
                      });
                    } else if (resultLength != 0 && noPhoto) {
                      setState(() {
                        noPhoto = false;
                      });
                    }
                    if (validate! && !noPhoto) {
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Publish",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget? insideCard(int length, int index) {
    if (index < length) {
      return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Image(
                    image: AssetEntityImageProvider(result![index]),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          result!.removeAt(index);
                          resultLength--;
                        });
                      },
                      child: Text(
                        "Remove",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Image(
          image: AssetEntityImageProvider(result![index]),
          fit: BoxFit.cover,
        ),
      );
    } else if (index == length) {
      return GestureDetector(
        onTap: () async {
          List<AssetEntity>? result1 = await AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
                maxAssets: 5 - resultLength,
                textDelegate: EnglishAssetPickerTextDelegate()),
          );
          setState(() {
            result = result! + result1!;
            resultLength = result!.length;
            if (resultLength != 0) {
              noPhoto = false;
            }
          });
        },
        child: Center(
            child: Icon(
          Icons.add,
          size: 40,
        )),
      );
    } else {
      return null;
    }
  }
}
