import 'dart:developer';

import 'package:e_commerce/core/constants/Transtions.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:e_commerce/features/products/presentation/pages/BottomNavBarScreen.dart';
import 'package:e_commerce/features/products/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    context.read<AuthCubit>().checkIfLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthError || state is AuthInitial) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),
                    Text(
                      "Get Started Now",
                      style: GoogleFonts.onest(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 32.sp,
                      ),
                      maxLines: 2,
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "Create an account or login in to explore",
                        style: GoogleFonts.onest(
                          color: Colors.grey[500],
                          fontSize: 16.sp,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        style: GoogleFonts.onest(fontSize: 16.sp),
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.onest(
                              fontSize: 16.sp, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 8.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: PasswordTextWidget(
                          passwordController: _passwordController),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.onest(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    SizedBox(height: 16),
                    BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthLoaded) {
                          Navigator.pushReplacement(context,
                              SlideInPageRoute(page: BottomNavBarScreen()));
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                              state.error.toString(),
                              style: GoogleFonts.onest(fontSize: 14.sp),
                            )),
                          );
                        }
                      },
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Material(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(16.r),
                              child: ClipRect(
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    if (state is AuthLoading) {
                                    } else {
                                      if (_usernameController.text.isNotEmpty &&
                                          _passwordController.text.isNotEmpty) {
                                        context.read<AuthCubit>().login({
                                          "username":
                                              _usernameController.text.trim(),
                                          "password":
                                              _passwordController.text.trim()
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                            "Please enter both Username and Password",
                                            style: GoogleFonts.onest(
                                                fontSize: 14.sp),
                                          )),
                                        );
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                    height: 50.h,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: state is AuthLoading
                                          ? SizedBox(
                                              width: 24.w,
                                              height: 24.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                color: Colors
                                                    .white, // ← high contrast
                                              ),
                                            )
                                          : Text(
                                              "Login",
                                              style: GoogleFonts.onest(
                                                fontSize: 20.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if(state is AuthLoaded){
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                  SlideInPageRoute(page: BottomNavBarScreen()));
            });

            return Container();
          }else{
            return Skeletonizer(
                enabled: true,
                child: ProductsScrollView(
                  isLoading: true,
                  isGridLoading: true,
                ),
              );
          }
        },
      ),
    );
  }
}

class PasswordTextWidget extends StatefulWidget {
  const PasswordTextWidget({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  State<PasswordTextWidget> createState() => _PasswordTextWidgetState();
}

class _PasswordTextWidgetState extends State<PasswordTextWidget> {
  bool _isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.onest(fontSize: 16.sp),
      obscureText: _isObsecure,
      controller: widget._passwordController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObsecure = !_isObsecure;
              });
            },
            icon: _isObsecure
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility)),
        hintText: "Password",
        hintStyle: GoogleFonts.onest(fontSize: 16.sp, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 8.0, color: Colors.black),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: Colors.black),
          borderRadius: BorderRadius.circular(8.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: Colors.black),
          borderRadius: BorderRadius.circular(8.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
