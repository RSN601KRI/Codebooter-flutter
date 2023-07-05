import 'dart:io';
import 'package:codebooter_study_app/utils/Dimensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:provider/provider.dart';
import 'package:codebooter_study_app/AppState.dart';

import '../../../../utils/Colors.dart';
class DataMining extends StatefulWidget {
  const DataMining({Key? key}) : super(key: key);

  @override
  _DataMiningState createState() => _DataMiningState();
}

class _DataMiningState extends State<DataMining> {
  final String pdfUrl =
      'https://ia902708.us.archive.org/4/items/data-mining-and-warehousing/DATA%20MINING%20AND%20WAREHOUSING%20.pdf';
  late String localPath;
  bool isPdfDownloaded = false;
  String downloadMessage = "Click download icon to start download";

  @override
  void initState() {
    super.initState();
    checkPdfExistence();
  }

  Future<void> downloadPdf() async {
    final directory = await getApplicationSupportDirectory();
    localPath = '${directory.path}/dmw.pdf';
    final file = File(localPath);

    if (await file.exists()) {
      setState(() {
        isPdfDownloaded = true;
      });
    } else {
      final response = await HttpClient().getUrl(Uri.parse(pdfUrl));
      final downloadedFile = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(downloadedFile);
      await file.writeAsBytes(bytes);
      setState(() {
        isPdfDownloaded = true;
      });
    }
  }

  Future<void> checkPdfExistence() async {
    final directory = await getApplicationSupportDirectory();
    localPath = '${directory.path}/dmw.pdf';
    final file = File(localPath);

    if (await file.exists()) {
      setState(() {
        isPdfDownloaded = true;
      });
    } else {
      setState(() {
        isPdfDownloaded = false;
      });
    }
  }

  Future<void> deletePdf() async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
      setState(() {
        isPdfDownloaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor:
      appState.isDarkMode ? AppColors.primaryColor : Colors.white,
      appBar: AppBar(
        backgroundColor:
        appState.isDarkMode ? AppColors.primaryColor : Colors.white,
        iconTheme: IconThemeData(
          color: appState.isDarkMode ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (isPdfDownloaded) {
                deletePdf();
              } else {
                downloadPdf();
              }
            },
            icon: Icon(
              isPdfDownloaded ? Icons.delete : Icons.download,
              color: appState.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
        title:  Text(
          ' Data Mining & Warehousing Notes ',
          style: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black,),
        ),
      ),
      body: Center(
        child: isPdfDownloaded
            ? SfPdfViewer.file(File(localPath))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      downloadPdf();
                    },
                    icon: Icon(
                      Icons.download,
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                      size: dimension.val60,
                    ),
                  ),
                  SizedBox(
                    height: dimension.val20,
                  ),
                  Text(downloadMessage,
                      style: TextStyle(
                          color: appState.isDarkMode ? Colors.white : Colors.black,
                          fontSize: dimension.font20)),
                ],
              ),
      ),
    );
  }
}
