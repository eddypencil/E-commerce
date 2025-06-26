import 'package:e_commerce/features/users/presentation/cubit/user_cubit.dart';
import 'package:e_commerce/features/users/presentation/cubit/user_state.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserCubit>()..fetchUser(),
      child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserLoaded) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    backgroundImage: NetworkImage(
                      state.user.image,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.user.username,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.user.email,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ProfileListItem(
                          icon: Icons.shopping_bag,
                          text: 'My Orders',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.favorite,
                          text: 'Wishlist',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.settings,
                          text: 'Settings',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.help_outline,
                          text: 'Help & Support',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          onTap: () {},
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text(
                "Network error",
                style: GoogleFonts.onest(color: Colors.grey,fontSize: 42),
              ),
            ),
          );
        }
      }),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const ProfileListItem({super.key, 
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(text, style: TextStyle(color: color ?? Colors.black)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
