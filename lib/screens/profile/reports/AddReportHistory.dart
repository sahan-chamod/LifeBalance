import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:life_balance/firebase/user_helper.dart';
import 'package:life_balance/provider/user.proivder.dart';
import 'package:life_balance/utils/app_colors.dart';
import 'dart:io';

class AddReportHistory extends StatefulWidget {
  @override
  State<AddReportHistory> createState() => _AddReportHistoryState();
}

class _AddReportHistoryState extends State<AddReportHistory> {
  File? selectedFile;
  String? selectedFileName;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      setState(() {
        selectedFile = File(file.path!);
        selectedFileName = file.name;
      });
    }
  }

  Future<void> uploadDoc() async {
    if (selectedFile != null) {
      try {
        String? imagePath= await uploadImage(selectedFile!.path);
        await uploadDocument(imagePath);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Document uploaded successfully",
              style: TextStyle(fontSize: 20.0),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Document upload failed!",
              style: TextStyle(fontSize: 20.0),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildFilePreview() {
    if (selectedFile == null) {
      return const Center(
        child: Text(
          "No file selected",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      );
    }

    final isImage = selectedFileName?.endsWith('.jpg') == true ||
        selectedFileName?.endsWith('.jpeg') == true ||
        selectedFileName?.endsWith('.png') == true;

    if (isImage) {
      return Center(
        child: Image.file(
          selectedFile!,
          width: 400,
          height: 400,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Center(
        child: Text(
          "Selected file: $selectedFileName",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Add Report",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),
              _buildFilePreview(),
              const SizedBox(height: 40),
              if (selectedFile != null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF225FFF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: uploadDoc,
                        child: const Text(
                          "Upload",
                          style: TextStyle(color: Colors.white, fontSize: 19.0),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedFile == null
          ? FloatingActionButton.extended(
        onPressed: pickFile,
        icon: const Icon(Icons.attach_file, color: Colors.white),
        label: const Text(
          "Select File",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      )
          : null,
    );
  }
}
