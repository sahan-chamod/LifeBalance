import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_balance/db/ReportsModel.dart';
import 'package:life_balance/firebase/user_helper.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  List<ReportsModel> data = [];
  Map<String, File?> imageFiles = {};

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  Future<void> refreshItems() async {
    List<ReportsModel> datas = await fetchAllDocs();
    setState(() {
      data = datas;
    });

    for (var report in datas) {

      if (report.filePath != null) {
        // https://upcdn.io/FW25cKz/raw/uploads/2024/12/26/4k6wpiBn4d-1-intro-photo-final.jpg
        File? file = await fetchImage(report.filePath!);
        print('$file  refreshItems');
        setState(() {
          imageFiles[report.filePath!] = file;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
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
                        "Report History",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final report = data[index];
                    final file = imageFiles[report.filePath];
                    return GestureDetector(
                      onTap: () {
                        if (file != null) {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: file != null
                              ? DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          )
                              : null,
                          color: file == null ? Colors.grey[300] : null,
                        ),
                        child: file == null
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          final result =await Navigator.pushNamed(context, AppRoutes.addReportHistory);
          if (result == true) {
            refreshItems();
          }
        },
        foregroundColor: AppColors.primaryColor,
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,),),
    );
  }
}
