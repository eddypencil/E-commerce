import 'package:e_commerce/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'features/auth/presentation/pages/loginPage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // Set your base design size
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
              
            ),
            BlocProvider(
              create: (context) => CartCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
                home: LoginPage(),
              ),
        );
      },
    );
  }
}
