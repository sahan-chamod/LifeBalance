import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    if (userProvider.profileImage.isNotEmpty) {
      file = File(userProvider.profileImage);
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login
              },
              child: const Text(
                'Yes, Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
                Column(
                  children: [
                    Consumer<UserProvider>(
                      builder: (context, provider, _) {
                        return _profilePhoto(
                          provider.profileImage.isNotEmpty
                              ? File(provider.profileImage)
                              : null,
                          addNewProImage,
                        );
                      },
                    ),
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
                const SizedBox(height: 5),
                Column(
                  children: [
                    CustomListTile(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      route: AppRoutes.userProfile,
                    ),
                    CustomListTile(
                      icon: Icons.favorite,
                      title: 'Favorite',
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
                    CustomListTile(
                      icon: Icons.help,
                      title: 'Help',
                      route: AppRoutes.userSettings,
                    ),
                    _logOut(_showLogoutDialog,context)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              addNewProImage();
            },
            child: const CircleAvatar(
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

Widget _logOut(logOutAction,BuildContext context){
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
    title: Text(
      "LogOut",
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
      logOutAction();
    },
  )
  ;
}
