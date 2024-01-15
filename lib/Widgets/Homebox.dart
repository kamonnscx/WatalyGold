import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/models/category.dart';
import 'package:watalygold/Home/Knowledge/Knowledge.dart';
import 'package:watalygold/Home/Quality/MainAnalysis.dart';
import 'package:camera/camera.dart';
import 'CategoryCard.dart';

class Homebox extends StatefulWidget {
  final List<CameraDescription> camera;
  const Homebox({Key? key, required this.camera}) : super(key: key);

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
                            builder: (context) =>
                                TakePictureScreen(camera: widget.camera)));
                  }
                  if (index == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KnowledgeMain()));
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
                            builder: (context) => const KnowledgeMain()));
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