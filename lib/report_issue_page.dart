import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';


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
  String? _capturedImagePath;
  bool _isSubmitButtonEnabled = false;
  bool _isSubmitting = false;
  AppLanguage _selectedLanguage = AppLanguage.english;


  final String _mockLocation = "Anna Salai, Chennai";
  final DateTime _mockDate = DateTime(2025, 9, 25, 15, 35, 54);
  final double _mockLatitude = 13.082700;
  final double _mockLongitude = 80.270700;
  final String _mockWardZone = "Ward 142 • Zone 10";
  final String _mockCategory = "Pothole";

  void _handleLanguageChange(AppLanguage? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedLanguage = newLanguage;

        print("Language changed to: $_selectedLanguage");
      });
    }
  }

  void _simulateCapturePhoto() {
    setState(() {

      _capturedImagePath = 'https://afma.org.au/wp-content/uploads/2022/11/iStock-95658927-scaled.jpg'; // Placeholder image
      _isSubmitButtonEnabled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo Captured!')),
    );
  }

  void _simulateRecordVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recording Voice... (mock)')),
    );

  }

  void _submitComplaint() async {
    if (!_isSubmitButtonEnabled) return;

    setState(() {
      _isSubmitting = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitting...')),
    );


    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      _isSubmitting = false;
    });

    _showSubmissionDialog();
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                          if (_capturedImagePath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                _capturedImagePath!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 150,
                                      color: Colors.grey.shade800,
                                      child: const Center(
                                        child: Icon(Icons.broken_image,
                                            color: Colors.white54),
                                      ),
                                    ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Text('Location',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          Text(_mockLocation,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 10),
                          const Text('Photo Metadata',
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
                          const Text(
                              'Voice/Text Description (optional)',
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
                                  _capturedImagePath = null;
                                  _isSubmitButtonEnabled = false;
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        title: const Text(
          'Civic Complaints',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                const Text(
                  'Language',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
              'Upload Photo',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _simulateCapturePhoto,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: _capturedImagePath == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Tap to upload photo',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.network(
                    _capturedImagePath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade800,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),


            Text(
              'Voice Input',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _simulateRecordVoice,
              icon: const Icon(Icons.mic, color: Colors.white),
              label: const Text(
                'Record (mock)',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 30),




            SizedBox(height: 50),
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
                  : const Text(
                'Submit Complaint',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}