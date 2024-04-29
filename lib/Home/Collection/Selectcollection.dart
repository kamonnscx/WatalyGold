import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforHistory.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Result_ana.dart';

class SelectCollection extends StatefulWidget {
  final Collection collect;
  final VoidCallback? refreshs;
  const SelectCollection({super.key, required this.collect, this.refreshs});

  @override
  State<SelectCollection> createState() => _SelectCollectionState();
}

class _SelectCollectionState extends State<SelectCollection> {
  List<Result> _resultincollection = [];

  @override
  void initState() {
    super.initState();
    _loadResultinColletion();
  }

  Future<void> _loadResultinColletion() async {
    _resultincollection =
        await Result_DB().fetchCountReinCol(widget.collect.collection_id);
    print(_resultincollection!.length);
    setState(() {});
  }

  void refresh() {
    print('Refreshing data...');
    _loadResultinColletion();
  }

  @override
  Widget build(BuildContext context) {
    // นับจำนวน result.quality แต่ละค่า
    int gradeCount1 = 0;
    int gradeCount2 = 0;
    int gradeCount3 = 0;
    int gradeCount4 = 0;

    for (var result in _resultincollection) {
      switch (result.quality) {
        case "ขั้นพิเศษ":
          gradeCount1++;
          break;
        case "ขั้นที่ 1":
          gradeCount2++;
          break;
        case "ขั้นที่ 2":
          gradeCount3++;
          break;
        case "ไม่เข้าข่าย":
          gradeCount4++;
          break;
        default:
          break;
      }
    }
    return Scaffold(
      appBar: AppbarMains(
        name: widget.collect.collection_name,
        refresh: widget.refreshs!,
      ),
      backgroundColor: Color(0xffF2F6F5),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Cradformangograde(G2PrimaryColor, "assets/images/grade 1.svg",
                      "ขั้นพิเศษ", gradeCount1),
                  Cradformangograde(Color(0xFF86BD41),
                      "assets/images/grade 2.svg", "ขั้นที่ 1", gradeCount2),
                  Cradformangograde(Color(0xFFB6AC55),
                      "assets/images/grade 3.svg", "ขั้นที่ 2", gradeCount3),
                  Cradformangograde(Color(0xFFB68955),
                      "assets/images/grade 4.svg", "ไม่เข้าข่าย", gradeCount4),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _resultincollection.isNotEmpty
                  ? ListView.builder(
                      itemCount: _resultincollection.length,
                      itemBuilder: (context, index) {
                        final result = _resultincollection[index];
                        print("${result.collection_id} คือ id ของคอ");
                        DateTime createdAt = DateTime.parse(result.created_at);
                        final formattedDate = DateFormat('dd MMM yyyy', 'th_TH')
                            .format(createdAt);
                        return CradforHistory(
                            date: formattedDate,
                            results: result,
                            number: index + 1,
                            refreshCallback: refresh,
                            statusdelete: 1);
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.collections_rounded,
                            size: 50, color: GPrimaryColor),
                        SizedBox(
                          height: 25,
                        ),
                        Text("ยังไม่มีผลการวิเคราะห์ในคอลเลคชันของคุณ"),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  Card Cradformangograde(Color color, String image, String grade, int count) {
    return Card(
      color: color,
      surfaceTintColor: color,
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 100,
        height: 130,
        child: Column(
          children: [
            SvgPicture.asset(
              image,
              colorFilter: ColorFilter.mode(WhiteColor, BlendMode.srcIn),
              semanticsLabel: '$grade',
              height: 60,
              width: 60,
            ),
            Text(
              "เกรด $grade",
              style: TextStyle(fontSize: 13, color: WhiteColor),
            ),
            Text(
              "$count",
              style: TextStyle(fontSize: 13, color: WhiteColor),
            ),
            Text(
              "รายการ",
              style: TextStyle(fontSize: 13, color: WhiteColor),
            )
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
