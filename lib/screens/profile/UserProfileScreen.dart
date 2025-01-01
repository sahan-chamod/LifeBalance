import 'package:flutter/material.dart';
import 'package:life_balance/firebase/user_helper.dart';
import 'package:life_balance/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:life_balance/provider/user.proivder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserProvider userProvider;
  File? file;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.userOtherDetails();
      if (userProvider.user != null) {
        _nameController.text = userProvider.user?.displayName ?? '';
        _phoneNumber.text = userProvider.mobileNumber ?? '';
        _emailController.text = userProvider.user?.email ?? '';
        _dateController.text = userProvider.dateOfBirth ?? '';
        _loadImage(userProvider.profileImage);
      }

  }

  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _phoneNumber=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _dateController=TextEditingController();
  
  updateUserDetails()async{
    userProvider.updateUser(
        _nameController.text,
        _phoneNumber.text,
        _dateController.text,
        context
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile details updated successfully",style: TextStyle(
            fontSize:20.0
        ),),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );

  }

  Future<void>addNewProImage()async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
     String? imagePath= await uploadImage(image.path);
     if(imagePath!.isNotEmpty){
       await userProvider.updateProfileImage(imagePath);
       await _loadImage(imagePath);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text("Profile image updated successfully",style: TextStyle(
               fontSize:20.0
           ),),
           backgroundColor: Colors.green,
           duration: Duration(seconds: 4),
         ),
       );
     }

    }
  }

  Future<void> _loadImage(String? url) async {
    final filePath = '$url';
    print('$filePath filePath');
    final imageFile = await fetchImage(filePath);
    setState(() {
      file=imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                          "Profile",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 35.0,)
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: _profilePhoto(file,addNewProImage))
                  ],
                ),
              const SizedBox(height: 15,),
                _inputFields('Full Name', _nameController),
               const SizedBox(height: 15,),
                _inputFields('Phone Number', _phoneNumber),
               const SizedBox(height: 15,),
                _inputFields('Email', _emailController),
                const SizedBox(height: 15,),
                 const Text(
                  "Date Of Birth",
                  style:const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0,),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day.toString().padLeft(2, '0')} / ${pickedDate.month.toString().padLeft(2, '0')} / ${pickedDate.year}";
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                },
                  decoration: InputDecoration(
                    hintText: 'DD / MM / YYYY',
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 16),
                    filled: true,
                    fillColor: Color(0xFFECF1FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                    style:const TextStyle(fontSize: 16, color: Colors.blue)
                ),
                const SizedBox(height: 40.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          updateUserDetails();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF225FFF),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )
                        ),
                        child:const Text(
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                   ],
                )
              ],
            ),),
      )),
    );
  }
}

Widget _inputFields(String label, TextEditingController controller,
    {TextInputType keyboardType = TextInputType.text}){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
       const SizedBox(height: 8.0,),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFECF1FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
}

Widget _profilePhoto(File? file,addNewProImage) {

  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: file != null ? FileImage(file) : null,
          backgroundColor: Colors.grey.shade300,
          child: file == null
              ? Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              addNewProImage();
            },
            child:const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

