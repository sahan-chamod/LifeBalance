import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_balance/firebase/Login_helper.dart';
import 'package:life_balance/firebase/user_helper.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:life_balance/routes/routes.dart';
import 'package:life_balance/utils/app_colors.dart';
import 'package:life_balance/provider/user.proivder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late UserProvider userProvider;
  File? file;
  String? name;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.userOtherDetails();
    if (userProvider.user?.displayName != null) {
      name = userProvider.user?.displayName ?? "";
    }

    if (userProvider.user != null) {
      print(userProvider.profileImage);
      _loadImage(userProvider.profileImage);
    }

  }

  Future<void> addNewProImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      userProvider.updateProfileImage(image.path);
      setState(() {
        file = File(image.path);
      });
    }
  }

  Future <void> logout()async{
    await _firebaseService.logoutUser();
  }

  Future<void> _loadImage(String? url) async {
    final filePath = '$url';
    final imageFile = await fetchImage(filePath);
    setState(() {
      file=imageFile;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImage(userProvider.profileImage);
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _profilePhoto(file,addNewProImage))
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          name ?? "",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    CustomListTile(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      route: AppRoutes.userProfile,
                    ),
                    CustomListTile(
                      icon: Icons.history,
                      title: 'Customer History',
                      route: AppRoutes.customerHistory,
                    ),
                    CustomListTile(
                      icon: Icons.lock,
                      title: 'Privacy Policy',
                      route: AppRoutes.privacyPolicy,
                    ),
                    CustomListTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      route: AppRoutes.userSettings,
                    ),
                    _logOut(context,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(Icons.home, 0),
            _buildNavBarItem(Icons.chat_bubble_outline, 1),
            _buildNavBarItem(Icons.person_outline, 2),
            _buildNavBarItem(Icons.calendar_today_outlined, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index,
      {bool hasNotification = false}) {
    return GestureDetector(
      onTap: () {
        if(index==0){
          Navigator.pushNamed(context, AppRoutes.home);
        }
        if(index==2){
          Navigator.pushNamed(context, AppRoutes.profile);
        }

      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                size: 30,
                color: index==2 ? Colors.white : Colors.white70,
              ),
              if (hasNotification)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _logOut(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.logout,
          color: AppColors.primaryColor,
          size: 24,
        ),
      ),
      title: const Text(
        "LogOut",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.blueGrey,
        size: 18,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
            barrierColor: Colors.blue.withOpacity(0.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Logout",style: TextStyle(color:  AppColors.primaryColor,fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  const Text(
                    'Are you sure you want to log out?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child:    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:const Color(0xFFCAD6FF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text('Cancel',style: TextStyle(color: AppColors.primaryColor,),),
                      )) ,
                      SizedBox(width: 20,),
                      Expanded(child: ElevatedButton(
                        onPressed: ()async {
                        await  logout();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(AppRoutes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text('Yes, Logout',style: TextStyle(color: Colors.white),),
                      ),)
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFCAD6FF),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.blueGrey,
        size: 18,
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

Widget _profilePhoto(File? file, Function addNewProImage) {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: file != null ? FileImage(file) : null,
          backgroundColor: Colors.grey.shade300,
          child: file == null
              ? const Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          )
              : null,
        ),

      ],
    ),
  );
}


