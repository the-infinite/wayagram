import 'dart:io';

import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';

Future<void> convertContestantToPDF(
    List<MyContestContestantModel> modelList, String approvedContestant) async {
  final pdf = Document();
  final img1 = await rootBundle.load('assets/images/book.png');
  final img2 = await rootBundle.load('assets/images/person.png');
  final img3 = await rootBundle.load('assets/images/cup.png');
  final img4 = await rootBundle.load('assets/images/award1.png');
  final img5 = await rootBundle.load('assets/images/award2.png');
  final imageBytes1 = img1.buffer.asUint8List();
  final imageBytes2 = img2.buffer.asUint8List();
  final imageBytes3 = img3.buffer.asUint8List();
  final imageBytes4 = img4.buffer.asUint8List();
  final imageBytes5 = img5.buffer.asUint8List();

  Image book = Image(MemoryImage(imageBytes1));
  Image person = Image(MemoryImage(imageBytes2));
  Image cup = Image(MemoryImage(imageBytes3));
  Image award1 = Image(MemoryImage(imageBytes4));
  Image award2 = Image(MemoryImage(imageBytes5));
  final font = await rootBundle.load("assets/fonts/SF-Pro-Display-Medium.otf");

  // index to determine position
  int index = 0;
  final ttf = Font.ttf(font);
  pdf.addPage(MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const EdgeInsets.all(0),
    build: (Context context) => [
      Container(
          child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 50),
                            Text(
                              'Contestant Data',
                              style: Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                      color: PdfColor.fromHex('#000000'),
                                      fontSize: 18.0,
                                      font: ttf,
                                      fontWeight: FontWeight.bold),
                            ),
                          ])),
                  SizedBox(height: 20),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Overview',
                        style: Theme.of(context).defaultTextStyle.copyWith(
                            fontSize: 16.0,
                            font: ttf,
                            fontWeight: FontWeight.normal),
                      )),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: PdfColor.fromHex('#FFFFFF'),
                        width: 1.5,
                      ),
                      color: PdfColor.fromHex('#FFFFFF'),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      _buildStatCard("Number of Application\nsubmitted",
                          modelList.length.toString(), book),
                      _buildStatCard("Number of Approved\nContestants",
                          approvedContestant, person),
                    ]),
                  ),
                  SizedBox(height: 10),
                  ...modelList.map((e) {
                    index++;
                    return Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Row(children: [
                            Text(
                              e.contestApplicant?.fullName ?? "",
                              style: Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                      color: PdfColor.fromHex('#0F57C5'),
                                      fontSize: 16.0,
                                      font: ttf,
                                      fontWeight: FontWeight.normal),
                            ),
                            if (index == 1)
                              _positionWidget(
                                  PdfColor.fromHex('#FFF0EB'), cup, "1st"),
                            if (index == 2)
                              _positionWidget(
                                  PdfColor.fromHex('#F0F2F5'), award1, "2nd"),
                            if (index == 3)
                              _positionWidget(
                                  PdfColor.fromHex('#FEF6E7'), award2, "3rd"),
                          ]),
                          Text(
                            "${e.votes} votes",
                            style: Theme.of(context).defaultTextStyle.copyWith(
                                fontSize: 16.0,
                                font: ttf,
                                fontWeight: FontWeight.normal),
                          )
                        ]));
                  }),
                ],
              ))),
    ],
  ));

  final path =
      "${WayaFileHelper.getFileSubdirectory(await WayaFileHelper.getMediaDirectory(), "file")}/contestant_list.pdf";

  File contestantFile = File(path);
  contestantFile.writeAsBytesSync(await pdf.save());

  Share.shareXFiles([
    XFile(path),
  ], text: 'Contestants');

  final pdfBytes = await pdf.save();
  await contestantFile.writeAsBytes(pdfBytes.toList());
}

Widget _buildStatCard(String title, String value, Widget widget) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PdfColor.fromHex('#FFF0EB'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12, color: PdfColor.fromHex('#667185'))),
              Container(
                width: 50, // Must be equal to height for a perfect circle
                height: 50,
                decoration: BoxDecoration(
                  color: PdfColor.fromHex('#FF652E'), // Background color
                  shape: BoxShape.circle, // Makes the container circular
                  border: Border.all(
                    color:
                        PdfColor.fromHex('#FFFFFF'), // Optional: Border color
                    width: 3.0, // Optional: Border width
                  ),
                ),
                child: SizedBox(height: 5, width: 5, child: widget),
              )
            ],
          ),
          SizedBox(height: 10),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

Widget _positionWidget(PdfColor pdfColor, Widget widget, String position) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: pdfColor,
        ),
        color: pdfColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        SizedBox(height: 15, width: 15, child: widget),
        Text(
          position,
          style: TextStyle(
              color: PdfColor.fromHex('#FFFFFF'),
              fontSize: 16.0,
              // font: ttf,
              fontWeight: FontWeight.normal),
        )
      ]));
}
