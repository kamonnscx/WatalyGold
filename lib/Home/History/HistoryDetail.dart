import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Home/History/ShareHistory.dart';
import 'package:watalygold/ShareResults.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Appbar_main_exit.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/Image.dart';
import 'package:watalygold/models/Result_ana.dart';

class HistoryDetail extends StatefulWidget {
  final Result results;
  final Map<int, List<Images>>? resultimage;

  const HistoryDetail({
    super.key,
    required this.results,
    this.resultimage,
  });
  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  @override
  void initState() {
    super.initState();
    fetchImage(widget.results.result_id);
  }

  List<Images> _results = [];

  final ValueNotifier<List<Images>> _imageList = ValueNotifier([]);

  double calculateAverageBrownSpot(List<Images> imagesList) {
    if (imagesList.isEmpty) return 0.0; // ตรวจสอบว่าไม่มีข้อมูลในลิสต์หรือไม่
    double totalBrownSpot =
        imagesList.fold(0.0, (sum, item) => sum + item.brown_spot);
    return totalBrownSpot;
  }

  double calculateAverageFlawsPercent(List<Images> imagesList) {
    if (imagesList.isEmpty) return 0.0; // ตรวจสอบว่าไม่มีข้อมูลในลิสต์หรือไม่
    double totalFlawsPercent =
        imagesList.fold(0.0, (sum, item) => sum + item.flaws_percent);
    return totalFlawsPercent;
  }

  String checkMangoGrade(double weight) {
    if (weight >= 450) {
      return "ขั้นพิเศษ";
    } else if (weight > 350 && weight <= 449) {
      return "ขั้นที่ 1";
    } else if (weight > 250 && weight <= 349) {
      return "ขั้นที่ 2";
    } else {
      return "ไม่เข้าข่าย";
    }
  }

  String checkMangobrownSpots(double brownSpots) {
    if (brownSpots <= 10) {
      return "ขั้นพิเศษ";
    } else if (brownSpots <= 30) {
      return "ขั้นที่ 1";
    } else if (brownSpots <= 40) {
      return "ขั้นที่ 2";
    } else {
      return "ไม่เข้าข่าย";
    }
  }

  String checkMangoFlawsPercent(double maxBlemishes) {
    if (maxBlemishes <= 2) {
      return "ขั้นพิเศษ";
    } else if (maxBlemishes <= 4) {
      return "ขั้นที่ 1";
    } else if (maxBlemishes <= 5) {
      return "ขั้นที่ 2";
    } else {
      return "ไม่เข้าข่าย";
    }
  }

  Future<void> fetchImage(int result_id) async {
    _imageList.value = await Image_DB().fetchImageinResult(result_id);
    stdout.writeln(_imageList.value.length);
    return;
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, Color> gradeColor = {
      "ขั้นพิเศษ": Color(0xFF42BD41),
      "ขั้นที่ 1": Color(0xFF86BD41),
      "ขั้นที่ 2": Color(0xFFB6AC55),
      "ไม่เข้าข่าย": Color(0xFFB68955),
    };
    return ValueListenableBuilder(
      valueListenable: _imageList,
      builder: (context, images, child) {
        double averageBrownSpot = calculateAverageBrownSpot(images);
        double averageFlawsPercent = calculateAverageFlawsPercent(images);
        return Scaffold(
            appBar: const Appbarmain(name: "วิเคราะห์คุณภาพ"),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: images.isNotEmpty
                        ? CarouselSlider.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index, realIndex) {
                              final image = images[index];
                              debugPrint(
                                  "จุดตำหนื" + image.brown_spot.toString());
                              debugPrint("จุดกระสีน้ำตาล" +
                                  image.flaws_percent.toString());
                              debugPrint(
                                  "น้ำหนัก + ${image.image_weight.toDouble()}");
                              // debugPrint("จุดตำหนื"+image.brown_spot.toString());
                              return Container(
                                child: Image.file(
                                  File(image.image_url),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 300,
                            ),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/plain-grey-background-ydlwqztavi78gl24.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(20),
                      ),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    color: WhiteColor,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: gradeColor[widget.results.quality],
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          width: double.infinity,
                          height: 35,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Text(
                              "จากผลการวิเคราะห์คุณภาพพบว่า :",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25, top: 10),
                              child: Text(
                                "เกรดระดับ ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                widget.results.quality,
                                style: TextStyle(
                                    color: gradeColor[widget.results.quality],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, top: 5, bottom: 10, right: 15),
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.results.another_note,
                                  style: TextStyle(
                                      color: gradeColor[widget.results.quality],
                                      fontSize: 17),
                                  // overflow: TextOverflow.ellipsis,
                                  // maxLines: 2,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Colors.white, Color(0xFFF2F6F5)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 8,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(10),
                      ),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    color: WhiteColor,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: Color(0xFF069D73),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          width: double.infinity,
                          height: 35,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "รายละเอียด",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.straighten,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "ความยาว : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                widget.results.lenght.toStringAsFixed(2) +
                                    " เซนติเมตร",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.straighten,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "ความกว้าง : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                widget.results.width.toStringAsFixed(2) +
                                    " เซนติเมตร",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.scale,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "น้ำหนัก : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                "${widget.results.weight.toStringAsFixed(2)} กรัม",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 17),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         widget.results.weight.toStringAsFixed(2) +
                            //             " กรัม",
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 18),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         "เกรดระดับ : " +
                            //             checkMangoGrade(
                            //                 widget.results.weight.toDouble()),
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.brightness_1,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "พื้นที่จุดตำหนิ : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 17),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "${averageFlawsPercent.toStringAsFixed(2)} ตารางเซนติเมตร",
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 18),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         "เกรดระดับ : " +
                            //             checkMangoFlawsPercent(
                            //                 averageFlawsPercent.toDouble()),
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                "${averageFlawsPercent.toStringAsFixed(2)} ตารางเซนติเมตร",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 140,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Icon(
                                      Icons.bubble_chart_rounded,
                                      size: 25,
                                      color: GPrimaryColor,
                                    ),
                                    title: Text(
                                      "พื้นที่จุดกระสีน้ำตาล : ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 17),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "${averageBrownSpot.toStringAsFixed(2)} เปอร์เซ็นต์",
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 18),
                            //       ),
                            //       SizedBox(height: 5),
                            //       Text(
                            //         "เกรดระดับ : " +
                            //             checkMangobrownSpots(
                            //                 averageBrownSpot.toDouble()),
                            //         style: TextStyle(
                            //             color: Color(0xFF42BD41), fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 17),
                              child: Text(
                                "${averageBrownSpot.toStringAsFixed(2)} เปอร์เซ็นต์",
                                style: TextStyle(
                                    color: Color(0xFF42BD41), fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(10),
                      ),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    color: WhiteColor,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: Color(0xFF069D73),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          width: double.infinity,
                          height: 35,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Center(
                              child: Text(
                                "แบ่งปันผลการวิเคราะห์ให้กับเพื่อนของคุณ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                      width: 2, color: GPrimaryColor),
                                  backgroundColor: WhiteColor),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShareHistoryePage(
                                      grade: widget.results.quality,
                                      anotherNote: widget.results.another_note,
                                      images: _imageList.value,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.share,
                                    color: GPrimaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'แบ่งปันผลการวิเคราะห์ของคุณ',
                                    style: TextStyle(
                                      color: GPrimaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
