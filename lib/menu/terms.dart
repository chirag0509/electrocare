import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:electrocare/repository/database/handleMenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final color = ColorController.instance;

  final menuController = Get.put(HandleMenu());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
      ),
      drawer: DrawerCom.instance.drawer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Terms & Conditions",
                style:
                    TextStyle(fontSize: w * 0.06, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: menuController.getTerms(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(children: [
                              WidgetSpan(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.label_important,
                                  size: w * 0.04,
                                  color: color.primary,
                                ),
                              )),
                              TextSpan(
                                  text: snapshot.data![index]['point'],
                                  style: TextStyle(
                                      color: color.black, fontSize: w * 0.035)),
                            ])),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "Loading...",
                      textAlign: TextAlign.justify,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
