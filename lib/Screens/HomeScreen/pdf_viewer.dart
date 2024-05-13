import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../Resources/app_colors.dart';
import '../../Resources/app_strings.dart';

class PDFView extends StatefulWidget {
  static const id = "PDFView";
  final String? pdf;
  const PDFView({Key? key, this.pdf}) : super(key: key);

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  String pdf = "";

  @override
  void initState() {
    super.initState();
  }

  ScrollController controller = ScrollController();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black)),
      ),
      body: widget.pdf != null
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      "https://docs.google.com/gview?embedded=true&url=${widget.pdf}")),
            )
          : Center(
              child: Text(
                AppStrings.noData,
              ),
            ),
    );
  }
}
