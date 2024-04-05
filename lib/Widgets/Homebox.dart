import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/ExportPrice/ExportPrice.dart';
import 'package:watalygold/models/category.dart';
import 'package:watalygold/Home/Knowledge/MainKnowledge.dart';
import 'package:watalygold/Home/Quality/MainAnalysis.dart';
import 'package:camera/camera.dart';
import 'CategoryCard.dart';

class Homebox extends StatefulWidget {
  final List<CameraDescription> camera;
  final Function(int) changeWidgetOption;
  const Homebox(
      {Key? key, required this.camera, required this.changeWidgetOption})
      : super(key: key);

  @override
  State<Homebox> createState() => _HomeboxState();
}

class _HomeboxState extends State<Homebox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
            shrinkWrap: true,
            itemCount: categoryList.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KnowledgeMain()));
                  }
                  if (index == 1) {
                    widget.changeWidgetOption(1);
                  }
                  if (index == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KnowledgeMain()));
                  }
                  if (index == 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TakePictureScreen(camera: widget.camera)));
                  }
                },
                child: CategoryCard(
                  category: categoryList[index],
                ),
              );
            })
      ],
    );
  }
}
