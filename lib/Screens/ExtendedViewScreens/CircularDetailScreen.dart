import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:minervaschool/Screens/HomeScreen/pdfviewer.dart';
import 'package:path/path.dart' as path;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:minervaschool/Screens/ExtendedViewScreens/Circulars.dart';
import 'package:minervaschool/Screens/HomeScreen/DocumentViewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class CircularDetailScreen extends StatefulWidget {
  final Circulars circulars;
  final List<Map<String, dynamic>> attachments;

  CircularDetailScreen({
    required this.circulars,
    required this.attachments,
  });

  @override
  _CircularDetailScreenState createState() => _CircularDetailScreenState();
}

class _CircularDetailScreenState extends State<CircularDetailScreen> {
  bool isDownloading = false;
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    print('Circulars title: ${widget.circulars.title}');
    print('Circulars subtitle: ${widget.circulars.subtitle}');
    print('Circulars content: ${widget.circulars.content}');
    print('Attachments: ${widget.attachments}');
  }

  // Add this method to check if content contains table tags
  bool _isTableContent(String content) {
    return content.contains('<table');
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = widget.circulars.content;
    String parsedContent = filterHtmlContent(htmlContent);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 50,
        flexibleSpace: Center(
          child: Image.asset(
            'assets/images/minerva.png',
            height: 55,
          ),
        ),
        actions: [
          if (widget.attachments.length == 1)
            IconButton(
              onPressed: () {
                print('Attachment data: ${widget.attachments[0]}');

                // Modify the URL for preview
                String previewUrl = widget.attachments[0]['url'] ?? '';
                // String fileType =
                //     widget.attachments[0]['ft'] ?? ''; // Get the file type
                String fileType = widget.attachments[0]['ft'] ??
                    widget.attachments[0]['title'] ??
                    ''; // Get the file type
                previewUrl = previewUrl.replaceFirst('action', 'preview');

                if (previewUrl.isNotEmpty && fileType.isNotEmpty) {
                  // Add prefix if necessary
                  if (!previewUrl.startsWith("https://mycampus.cloud/")) {
                    previewUrl = "https://mycampus.cloud/$previewUrl";
                  }

                  // If using 'p' and 't' keys
                  previewUrl = previewUrl.replaceFirst('action', 'preview');

                  print("PreviewURL: $previewUrl");
                  print("File type: $fileType");

                  if (fileType == '.pdf') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewer(pdfUrl: previewUrl),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentViewer(
                          documentUrl: previewUrl,
                          fileType: fileType,
                        ),
                      ),
                    );
                  }
                } else {
                  print('Error: Preview URL or file type is empty');
                }
              },
              icon: Icon(
                Icons.description,
                color: Colors.black,
              ),
            ),
          // Download Button
          if (widget.attachments.isNotEmpty)
            IconButton(
              onPressed: () {
                if (widget.attachments.isNotEmpty) {
                  String fileType = widget.attachments[0]['t'] ??
                      widget.attachments[0]['title'] ??
                      '';
                  List<String> allowedFileTypes = ['.PDF', '.pdf'];
                  if (allowedFileTypes.contains(fileType)) {
                    downloadAttachments(widget.attachments);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Sorry"),
                          content: Text(
                              "Kindly note that at the moment, only PDFs are available for download. To access the document, please click on the 'View Attachment' button.\n\nThank you for your understanding."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              icon: Icon(
                Icons.download,
                color: Colors.black,
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.circulars.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.circulars.subtitle,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 16.0),
                  _isTableContent(parsedContent)
                      ? Container(
                          height: 400,
                          child: InAppWebView(
                            initialData: InAppWebViewInitialData(
                              data: parsedContent,
                              mimeType: 'text/html',
                              encoding: 'utf-8',
                            ),
                          ),
                        )
                      : Html(data: parsedContent),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String filterHtmlContent(String htmlContent) {
    htmlContent = htmlContent.replaceAll(RegExp(r'<p.*?>|<\/p>'), '');
    if (htmlContent.contains('<table')) {
      int startIndex = htmlContent.indexOf('<table');
      int endIndex = htmlContent.indexOf('</table>') + '</table>'.length;
      return htmlContent.substring(startIndex, endIndex);
    } else {
      return htmlContent;
    }
  }

  Future<void> requestStoragePermission() async {
    print('Requesting storage permission...');

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      await downloadAttachments(widget.attachments);
    } else {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        print('Storage permission granted.');
        setState(() => isDownloading = true);
        await downloadAttachments(widget.attachments);

        setState(() => isDownloading = false);
      } else if (status.isPermanentlyDenied) {
        setState(() => isDownloading = false);
        print('Storage permission permanently denied.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission permanently denied')),
        );
      }
    }
  }

  Future<String?> pickDirectory() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath == null) {
      // User canceled or didn't pick a directory
      print('User canceled or didn\'t pick a directory');
    } else {
      // User picked a directory
      print('User picked directory: $directoryPath');
    }

    return directoryPath;
  }

  Future<void> _downloadFile(String url, String filePath) async {
    final response = await http.get(Uri.parse(url));

    // Debug logging: Print HTTP response headers
    print('HTTP Response Headers: ${response.headers}');

    if (response.statusCode == 200) {
      // Write the file to disk
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes,
          mode: FileMode.write); // Write in binary mode

      // Verify file integrity
      await verifyFile(filePath);

      // Open the downloaded file
    } else {
      print(
          'Error: Failed to download file, status code: ${response.statusCode}');
    }
  }

  Future<void> downloadAttachments(
      List<Map<String, dynamic>> attachments) async {
    setState(() {
      isDownloading = true;
    });

    try {
      for (var attachment in attachments) {
        final String? url = attachment['url'] ?? attachment['p'];
        final String? fileName = attachment['filename'] ?? attachment['dn'];

        if (url == null || fileName == null || fileName.isEmpty) {
          print('URL or file name is missing');
          continue;
        }

        final String downloadUrl = modifyDownloadUrl(url);

        print('Downloading attachment from URL: $downloadUrl');

        final directoryPath = await pickDirectory();
        if (directoryPath == null) {
          print('User canceled file picking');
          return;
        }

        final filePath = path.join(
            directoryPath, '$fileName.pdf'); // Append ".pdf" to the file name
        print("File path: $filePath");

        await _downloadFile(downloadUrl, filePath);

        // Show success dialog
        _showDownloadSuccessDialog(filePath);

        print("Download task completed for file: $fileName");
      }

      print("All tasks enqueued successfully");
    } catch (e) {
      print('Error downloading attachments: $e');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  Future<void> verifyFile(String filePath) async {
    // Calculate checksum of downloaded file
    List<int> bytes = await File(filePath).readAsBytes();
    String downloadedChecksum = sha256.convert(bytes).toString();

    // Compare with checksum of original file
    String originalChecksum = '...'; // Calculate checksum of original file
    if (downloadedChecksum == originalChecksum) {
      // Checksums match, file integrity verified
    } else {
      // Checksums don't match, file may be corrupted
      print('Downloaded file may be corrupted');
    }
  }

  void _showDownloadSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Download Successful",
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.bold, // You can adjust font weight as needed
              // You can also specify other text properties here such as color, etc.
            ),
          ),
        );
      },
    );
  }

  String modifyDownloadUrl(String? url) {
    if (url == null) return '';

    // Check if the URL already contains the prefix, if not, add it
    if (!url.startsWith('https://mycampus.cloud/')) {
      url = 'https://mycampus.cloud/$url';
    }

    // Replace 'action' with 'download' in the URL
    url = url.replaceFirst('action', 'download');

    return url;
  }
}
