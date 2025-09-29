import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

enum AppLanguage {
  english,
  tamil,
  hindi,
  telugu,
  kannada,
}

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {

  static const String n8nImageWebhookUrl = 'https://nivas007.app.n8n.cloud/webhook/c8a1b9c1-68b9-44d1-bead-e0665e6d82f6';
  static const String n8nVideoWebhookUrl = 'https://nivas007.app.n8n.cloud/webhook/67f80d02-625a-4994-94af-e12d568040ce';


  File? _capturedImageFile;
  File? _capturedVideoFile;

  bool get _isSubmitButtonEnabled => _capturedImageFile != null || _capturedVideoFile != null;
  bool _isSubmitting = false;
  AppLanguage _selectedLanguage = AppLanguage.english;


  final String _mockLocation = "Anna Salai, Chennai";
  final DateTime _mockDate = DateTime(2025, 9, 25, 15, 35, 54);
  final double _mockLatitude = 13.082700;
  final double _mockLongitude = 80.270700;
  final String _mockWardZone = "Ward 142 • Zone 10";
  final String _mockCategory = "Pothole";


  final Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.english: {
      'appTitle': 'Civic Complaints',
      'language': 'Language',
      'photoSection': '1. Attach Photo (Required)',
      'videoSection': '2. Attach Video (Optional)',
      'tapToSelectImage': 'Tap to capture/select image',
      'tapToSelectVideo': 'Tap to capture/select video',
      'submitComplaint': 'Submit Complaint',
      'selectSource': 'Select Media Source',
      'capturePhoto': 'Capture Photo (Camera)',
      'selectPhoto': 'Select Photo (Gallery)',
      'captureVideo': 'Record Video (Camera)',
      'selectVideo': 'Select Video (Gallery)',
      'imageAttached': 'Image Attached (Tap to view metadata)',
      'videoAttached': 'Video Attached',
      'startingSubmission': 'Starting submission process...',
      'imageSentSuccess': 'Image sent to n8n successfully!',
      'videoSentSuccess': 'Video sent to n8n successfully!',
      'imageSentFailed': 'Image submission failed!',
      'videoSentFailed': 'Video submission failed!',
      'complaintSubmitted': 'Complaint submitted successfully!',
      'submissionError': 'Submission completed with errors. Check logs.',
    },
    AppLanguage.tamil: {
      'appTitle': 'குடிமைப் புகார்கள்',
      'language': 'மொழி',
      'photoSection': '1. புகைப்படம் இணைக்கவும் (கட்டாயம்)',
      'videoSection': '2. வீடியோ பதிவேற்றவும் (விருப்பம்)',
      'tapToSelectImage': 'படத்தை எடுக்க/தேர்ந்தெடுக்க தட்டவும்',
      'tapToSelectVideo': 'வீடியோ எடுக்க/தேர்ந்தெடுக்க தட்டவும்',
      'submitComplaint': 'புகாரை சமர்ப்பிக்கவும்',
      'selectSource': 'ஊடக மூலத்தைத் தேர்ந்தெடுக்கவும்',
      'capturePhoto': 'புகைப்படம் எடுக்கவும் (கேமரா)',
      'selectPhoto': 'புகைப்படம் தேர்ந்தெடுக்கவும் (கேலரி)',
      'captureVideo': 'வீடியோ பதிவு செய்யவும் (கேமரா)',
      'selectVideo': 'வீடியோ தேர்ந்தெடுக்கவும் (கேலரி)',
      'imageAttached': 'படம் இணைக்கப்பட்டது (தரவுகளைக் காண தட்டவும்)',
      'videoAttached': 'வீடியோ இணைக்கப்பட்டது',
      'startingSubmission': 'சமர்ப்பிப்பு செயல்முறை தொடங்குகிறது...',
      'imageSentSuccess': 'படம் n8n-க்கு வெற்றிகரமாக அனுப்பப்பட்டது!',
      'videoSentSuccess': 'வீடியோ n8n-க்கு வெற்றிகரமாக அனுப்பப்பட்டது!',
      'imageSentFailed': 'படம் சமர்ப்பிப்பு தோல்வியடைந்தது!',
      'videoSentFailed': 'வீடியோ சமர்ப்பிப்பு தோல்வியடைந்தது!',
      'complaintSubmitted': 'புகார் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!',
      'submissionError': 'சமர்ப்பிப்பு பிழைகளுடன் முடிந்தது. பதிவுகளைச் சரிபார்க்கவும்.',
    },
    AppLanguage.hindi: {
      'appTitle': 'नागरिक शिकायतें',
      'language': 'भाषा',
      'photoSection': '1. फोटो संलग्न करें (आवश्यक)',
      'videoSection': '2. वीडियो अपलोड करें (वैकल्पिक)',
      'tapToSelectImage': 'छवि कैप्चर/चुनने के लिए टैप करें',
      'tapToSelectVideo': 'वीडियो कैप्चर/चुनने के लिए टैप करें',
      'submitComplaint': 'शिकायत जमा करें',
      'selectSource': 'मीडिया स्रोत चुनें',
      'capturePhoto': 'फोटो कैप्चर करें (कैमरा)',
      'selectPhoto': 'फोटो चुनें (गैलरी)',
      'captureVideo': 'वीडियो रिकॉर्ड करें (कैमरा)',
      'selectVideo': 'वीडियो चुनें (गैलरी)',
      'imageAttached': 'छवि संलग्न है (मेटाडेटा देखने के लिए टैप करें)',
      'videoAttached': 'वीडियो संलग्न है',
      'startingSubmission': 'जमा करने की प्रक्रिया शुरू हो रही है...',
      'imageSentSuccess': 'छवि सफलतापूर्वक n8n को भेजी गई!',
      'videoSentSuccess': 'वीडियो सफलतापूर्वक n8n को भेजा गया!',
      'imageSentFailed': 'छवि जमा करना विफल रहा!',
      'videoSentFailed': 'वीडियो जमा करना विफल रहा!',
      'complaintSubmitted': 'शिकायत सफलतापूर्वक जमा हो गई!',
      'submissionError': 'त्रुटियों के साथ जमा करना पूर्ण हुआ। लॉग्स जांचें।',
    },
    AppLanguage.telugu: {
      'appTitle': 'పౌర ఫిర్యాదులు',
      'language': 'భాష',
      'photoSection': '1. ఫోటోను జత చేయండి (అవసరం)',
      'videoSection': '2. వీడియోను అప్‌లోడ్ చేయండి (ఐచ్ఛికం)',
      'tapToSelectImage': 'చిత్రాన్ని తీయడానికి/ఎంచుకోవడానికి నొక్కండి',
      'tapToSelectVideo': 'వీడియోను తీయడానికి/ఎంచుకోవడానికి నొక్కండి',
      'submitComplaint': 'ఫిర్యాదును సమర్పించండి',
      'selectSource': 'మీడియా మూలాన్ని ఎంచుకోండి',
      'capturePhoto': 'ఫోటో తీయండి (కెమెరా)',
      'selectPhoto': 'ఫోటోను ఎంచుకోండి (గ్యాలరీ)',
      'captureVideo': 'వీడియో రికార్డ్ చేయండి (కెమెరా)',
      'selectVideo': 'వీడియోను ఎంచుకోండి (గ్యాలరీ)',
      'imageAttached': 'చిత్రం జత చేయబడింది (మెటాడేటాను చూడటానికి నొక్కండి)',
      'videoAttached': 'వీడియో జత చేయబడింది',
      'startingSubmission': 'సమర్పణ ప్రక్రియ ప్రారంభమవుతోంది...',
      'imageSentSuccess': 'చిత్రం n8n కు విజయవంతంగా పంపబడింది!',
      'videoSentSuccess': 'వీడియో n8n కు విజయవంతంగా పంపబడింది!',
      'imageSentFailed': 'చిత్ర సమర్పణ విఫలమైంది!',
      'videoSentFailed': 'వీడియో సమర్పణ విఫలమైంది!',
      'complaintSubmitted': 'ఫిర్యాదు విజయవంతంగా సమర్పించబడింది!',
      'submissionError': 'సమర్పణ లోపాలతో పూర్తయింది. లాగ్‌లను తనిఖీ చేయండి.',
    },
    AppLanguage.kannada: {
      'appTitle': 'ನಾಗರಿಕ ದೂರುಗಳು',
      'language': 'ಭಾಷೆ',
      'photoSection': '1. ಫೋಟೋ ಲಗತ್ತಿಸಿ (ಅಗತ್ಯವಿದೆ)',
      'videoSection': '2. ವೀಡಿಯೊ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ (ಐಚ್ಛಿಕ)',
      'tapToSelectImage': 'ಚಿತ್ರವನ್ನು ಸೆರೆಹಿಡಿಯಲು/ಆಯ್ಕೆ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ',
      'tapToSelectVideo': 'ವೀಡಿಯೊ ಸೆರೆಹಿಡಿಯಲು/ಆಯ್ಕೆ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ',
      'submitComplaint': 'ದೂರು ಸಲ್ಲಿಸಿ',
      'selectSource': 'ಮಾಧ್ಯಮ ಮೂಲವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
      'capturePhoto': 'ಫೋಟೋ ಸೆರೆಹಿಡಿಯಿರಿ (ಕ್ಯಾಮೆರಾ)',
      'selectPhoto': 'ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ (ಗ್ಯಾಲರಿ)',
      'captureVideo': 'ವೀಡಿಯೊ ರೆಕಾರ್ಡ್ ಮಾಡಿ (ಕ್ಯಾಮೆರಾ)',
      'selectVideo': 'ವೀಡಿಯೊ ಆಯ್ಕೆಮಾಡಿ (ಗ್ಯಾಲರಿ)',
      'imageAttached': 'ಚಿತ್ರ ಲಗತ್ತಿಸಲಾಗಿದೆ (ಮೆಟಾಡೇಟಾ ವೀಕ್ಷಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ)',
      'videoAttached': 'ವೀಡಿಯೊ ಲಗತ್ತಿಸಲಾಗಿದೆ',
      'startingSubmission': 'ಸಲ್ಲಿಸುವ ಪ್ರಕ್ರಿಯೆ ಪ್ರಾರಂಭವಾಗುತ್ತಿದೆ...',
      'imageSentSuccess': 'ಚಿತ್ರವನ್ನು n8n ಗೆ ಯಶಸ್ವಿಯಾಗಿ ಕಳುಹಿಸಲಾಗಿದೆ!',
      'videoSentSuccess': 'ವೀಡಿಯೊವನ್ನು n8n ಗೆ ಯಶಸ್ವಿಯಾಗಿ ಕಳುಹಿಸಲಾಗಿದೆ!',
      'imageSentFailed': 'ಚಿತ್ರ ಸಲ್ಲಿಕೆ ವಿಫಲವಾಗಿದೆ!',
      'videoSentFailed': 'ವೀಡಿಯೊ ಸಲ್ಲಿಕೆ ವಿಫಲವಾಗಿದೆ!',
      'complaintSubmitted': 'ದೂರು ಯಶಸ್ವಿಯಾಗಿ ಸಲ್ಲಿಸಲಾಗಿದೆ!',
      'submissionError': 'ದೋಷಗಳೊಂದಿಗೆ ಸಲ್ಲಿಕೆ ಪೂರ್ಣಗೊಂಡಿದೆ. ಲಾಗ್‌ಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.',
    },
  };


  String _translate(String key) {
    return _translations[_selectedLanguage]?[key] ?? _translations[AppLanguage.english]![key]!;
  }


  void _handleLanguageChange(AppLanguage? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedLanguage = newLanguage;
        print("Language changed to: $_selectedLanguage");
      });
    }
  }

  MediaType _getMediaType(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return MediaType('image', extension == 'png' ? 'png' : 'jpeg');
    }
    if (extension == 'mp4') {
      return MediaType('video', 'mp4');
    }
    return MediaType('application', 'octet-stream');
  }

  Future<void> _captureImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (pickedFile != null) {
      setState(() {
        _capturedImageFile = File(pickedFile.path);
        _capturedVideoFile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo Captured/Selected!')),
      );
    }
  }

  Future<void> _captureVideo(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: source);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (pickedFile != null) {
      setState(() {
        _capturedVideoFile = File(pickedFile.path);
        _capturedImageFile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video Captured/Selected!')),
      );
    }
  }

  void _showMediaSelectionDialog(bool isImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translate('selectSource')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(isImage ? Icons.camera_alt : Icons.videocam),
                title: Text(isImage ? _translate('capturePhoto') : _translate('captureVideo')),
                onTap: () => isImage ? _captureImage(ImageSource.camera) : _captureVideo(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(isImage ? Icons.photo_library : Icons.video_library),
                title: Text(isImage ? _translate('selectPhoto') : _translate('selectVideo')),
                onTap: () => isImage ? _captureImage(ImageSource.gallery) : _captureVideo(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _sendFileToN8n({
    required String webhookUrl,
    required File file,
    required String fileKey,
    required String filenameKey,
  }) async {
    final Uri uri = Uri.parse(webhookUrl);
    final request = http.MultipartRequest('POST', uri);

    try {
      final contentType = _getMediaType(file.path);

      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          contentType: contentType,
        ),
      );
      request.fields[filenameKey] = file.path.split('/').last;
    } catch (e) {
      print("Error preparing file '$fileKey' for upload: $e");
      return false;
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('$fileKey successfully sent to n8n! Status: ${response.statusCode}');
        return true;
      } else {
        print('Failed to send $fileKey. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Network error when sending $fileKey: $e');
      return false;
    }
  }

Future<void> uploadToFastAPI(File file) async {
  var uri = Uri.parse("http://127.0.0.1:8000/extract/"); // FastAPI endpoint
  var request = http.MultipartRequest('POST', uri);

  request.files.add(
    await http.MultipartFile.fromPath(
      'file', 
      file.path,
    ),
  );

  var response = await request.send();

  if (response.statusCode == 200) {
    print("File uploaded successfully!");
  } else {
    print("Failed with status: ${response.statusCode}");
  }
}

  void _submitComplaint() async {
    if (!_isSubmitButtonEnabled || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_translate('startingSubmission'))),
    );

    bool overallSuccess = true;
    File? fileToSend = _capturedImageFile ?? _capturedVideoFile;
    bool isImage = _capturedImageFile != null;

    if (fileToSend != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sending ${isImage ? 'image' : 'video'} file...')),
      );

      final String webhookUrl = isImage ? n8nImageWebhookUrl : n8nVideoWebhookUrl;

      final String fileKey = isImage ? 'image_file' : 'video_file';
      final String filenameKey = isImage ? 'image_filename' : 'video_filename';

      bool sendSuccess = await _sendFileToN8n(
        webhookUrl: webhookUrl,
        file: fileToSend,
        fileKey: fileKey,
        filenameKey: filenameKey,
      );

      if (sendSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isImage ? _translate('imageSentSuccess') : _translate('videoSentSuccess'))),
        );
      } else {
        overallSuccess = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isImage ? _translate('imageSentFailed') : _translate('videoSentFailed'))),
        );
      }
    }

    setState(() {
      _isSubmitting = false;
    });

    if (overallSuccess && fileToSend != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translate('complaintSubmitted'))),
      );
      _showSubmissionDialog();
    } else if (fileToSend != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translate('submissionError'))),
      );
    }
  }

  void _showImageZoomDialog(File imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    Map<String, IfdTag> exifData = {};
    try {
      exifData = await readExifFromBytes(await imageFile.readAsBytes());
    } catch (e) {
      print("Error reading EXIF data: $e");
    }

    if (mounted) Navigator.of(context).pop();

    String dateTaken = exifData['DateTimeOriginal']?.toString() ?? exifData['DateTime']?.toString() ?? 'N/A';
    String model = exifData['Model']?.toString() ?? 'N/A';
    String gpsInfo = (exifData.containsKey('GPSLatitude') && exifData.containsKey('GPSLongitude')) ? 'Available (Precise)' : 'Not Available';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('File Metadata (Extracted EXIF)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.white38),
                    _buildMetaText('Capture Date', dateTaken),
                    _buildMetaText('Camera Model', model),
                    _buildMetaText('GPS Data', gpsInfo),
                    _buildMetaText('File Path', imageFile.path.split('/').last),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Close', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        File? fileToShow = _capturedImageFile ?? _capturedVideoFile;
        bool isImage = _capturedImageFile != null;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Captured Media', style: TextStyle(
                              color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),

                          if (fileToShow != null)
                            _buildMediaPreview(
                                file: fileToShow,
                                isImage: isImage,
                                title: isImage ? _translate('imageAttached') : _translate('videoAttached')),

                          const SizedBox(height: 16),
                          const Text('Location',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          Text(_mockLocation,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 10),
                          const Text('Photo Metadata (Mock)',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          _buildMetaDataRow('Date',
                              '${_mockDate.year}-${_mockDate.month.toString().padLeft(2, '0')}-${_mockDate.day.toString().padLeft(2, '0')} ${_mockDate.hour.toString().padLeft(2, '0')}:${_mockDate.minute.toString().padLeft(2, '0')}:${_mockDate.second.toString().padLeft(2, '0')}'),
                          _buildMetaDataRow(
                              'Latitude', _mockLatitude.toString()),
                          _buildMetaDataRow(
                              'Longitude', _mockLongitude.toString()),
                          _buildMetaDataRow('Ward & Zone', _mockWardZone),
                          const SizedBox(height: 16),
                          const Text('Category (AI Suggested)',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          Text(_mockCategory,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 16),
                          const Text('Text Description (optional)',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          TextField(
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Add notes...',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _capturedImageFile = null;
                                  _capturedVideoFile = null;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                              child: const Text('OK',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          print('Edit button tapped');
                        },
                        icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                        label: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetaText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon, String text, double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white54, size: 40),
            Text(
                text,
                textAlign:TextAlign.center,
                style: const TextStyle(
                    color: Colors.white54
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview({required File file, required bool isImage, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: GestureDetector(
              onTap: isImage ? () => _showImageZoomDialog(file) : null,
              child: isImage
                  ? _buildPlaceholder(Icons.folder_open, 'Image File Attached\n(Tap to View EXIF)', 120)
                  : _buildPlaceholder(Icons.videocam, 'Video Attached (No Preview)', 120),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _translate('appTitle'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              print('Profile tapped');
            },
          ),
          PopupMenuButton<AppLanguage>(
            icon: Row(
              children: [
                Text(
                  _translate('language'),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
            onSelected: _handleLanguageChange,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
              const PopupMenuItem<AppLanguage>(
                value: AppLanguage.english,
                child: Text('English'),
              ),
              const PopupMenuItem<AppLanguage>(
                value: AppLanguage.tamil,
                child: Text('தமிழ் (Tamil)'),
              ),
              const PopupMenuItem<AppLanguage>(
                value: AppLanguage.hindi,
                child: Text('हिन्दी (Hindi)'),
              ),
              const PopupMenuItem<AppLanguage>(
                value: AppLanguage.telugu,
                child: Text('తెలుగు (Telugu)'),
              ),
              const PopupMenuItem<AppLanguage>(
                value: AppLanguage.kannada,
                child: Text('ಕನ್ನಡ (Kannada)'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _translate('photoSection'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showMediaSelectionDialog(true),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: _capturedImageFile == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo_camera, color: Colors.white54, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      _translate('tapToSelectImage'),
                      style: const TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.file(
                    _capturedImageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(Icons.broken_image, 'Image Error', 200),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              _translate('videoSection'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showMediaSelectionDialog(false),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: _capturedVideoFile == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam, color: Colors.white54, size: 30),
                    const SizedBox(height: 5),
                    Text(
                      _translate('tapToSelectVideo'),
                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: _buildPlaceholder(Icons.videocam, 'Video Attached', 100),
                ),
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: _isSubmitButtonEnabled && !_isSubmitting ? _submitComplaint : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                _translate('submitComplaint'),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}