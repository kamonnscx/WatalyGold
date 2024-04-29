import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforHistory.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Image.dart';
import 'package:watalygold/models/Result_ana.dart';

class HomeHistory extends StatefulWidget {
  const HomeHistory({super.key});

  @override
  State<HomeHistory> createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  TextEditingController _controller = TextEditingController();

  List<Result> _results = [];
  List<Result> _originalresults = [];
  List<Collection> _collection = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    _collection = await Collection_DB().fetchAll();
    print(_collection.length);
    setState(() {});
  }

  Future<void> _loadResults() async {
    _originalresults = await Result_DB().fetchAll();
    _results = _originalresults;
    print(_results.length);
    setState(() {});
  }

  void refreshList() {
    _loadResults();
    _loadCollections();
    setState(() {}); // เรียกใช้ฟังก์ชันนี้เพื่ออัปเดตรายการ
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    fillColor: WhiteColor,
                    filled: true,
                    hintText: "ค้นหาการวิเคราะห์",
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color(0xff767676),
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: searchHistory,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    print("${result.collection_id} คือ id ของคอ");
                    DateTime createdAt = DateTime.parse(result.created_at);
                    final formattedDate =
                        DateFormat('dd MMM yyyy', 'th_TH').format(createdAt);
                    return CradforHistory(
                      date: formattedDate,
                      results: result,
                      refreshCallback: () => refreshList(),
                      collection: _collection,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchHistory(String query) async {
    if (query.isEmpty) {
      setState(() => _results = _originalresults);
    } else {
      final suggestions = _results.where((result) {
        final resultQuality = result.quality.toString();
        final input = query.toLowerCase();
        return resultQuality.toLowerCase().contains(input);
      }).toList();
      setState(() => _results = suggestions);
    }
  }
}
