import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/Interceptors/intreceptors.dart';
import 'package:e_commerce/features/Search/data/data_sources/data_Souces.dart';
import 'package:e_commerce/features/Search/data/repo/Search_repo_imp.dart';
import 'package:e_commerce/features/Search/domain/repo/Search_repo.dart';
import 'package:e_commerce/features/Search/domain/usecase/search_usecases.dart';
import 'package:e_commerce/features/Search/presentaion/cubit/search_cubit.dart';
import 'package:e_commerce/features/auth/data/DataSources.dart';
import 'package:e_commerce/features/auth/data/repos.dart';
import 'package:e_commerce/features/auth/domain/Repos.dart';
import 'package:e_commerce/features/auth/domain/useCases.dart';
import 'package:e_commerce/features/products/data/data_sources.dart';
import 'package:e_commerce/features/products/data/product_repo.dart';
import 'package:e_commerce/features/products/domain/repostries.dart';
import 'package:e_commerce/features/products/domain/usecases.dart';
import 'package:e_commerce/features/users/data/user_data_source.dart';
import 'package:e_commerce/features/users/presentation/cubit/user_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initGetIt() {
  // Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  //  Dio with Interceptors
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );
    dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(dio: dio),
    ]);
    return dio;
  });




  //  Products
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImp(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ProductsRepo>(
    () => ProductsRepoimpl(
      productRemoteDataSource: getIt<ProductRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductsRepo>()),
  );




  //  Categories
  getIt.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImp(getIt<Dio>()),
  );

  getIt.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepoImp(
      categoriesRemoteDataSource: getIt<CategoriesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CategoriesRepo>()),
  );

  //  Category Items
  getIt.registerLazySingleton<CategoriesItemsRemoteDataSource>(
    () => CategoriesItemsRemoteDataSourceImp(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<CategoriesItemRepo>(
    () => CategoriesItemRepoImp(
      categoriesItemsRemoteDataSource: getIt<CategoriesItemsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetCategoryItemUseCase>(
    () => GetCategoryItemUseCase(getIt<CategoriesItemRepo>()),
  );

  //  Authentication
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      authenticationRemoteDataSource: getIt<AuthenticationRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepo: getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<CheckifLoginUseCase>(
    () => CheckifLoginUseCase(authRepo: getIt<AuthRepo>()),
  );




  //  User
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImp(getIt<Dio>()),
  );

  getIt.registerFactory<UserCubit>(
    () => UserCubit(getIt<UserRemoteDataSource>()),
  );







  //  Search
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<SearchRepo>(
    () => SearchRepoImpl(
      searchRemoteDataSource: getIt<SearchRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetSearchResultUseCase>(
    () => GetSearchResultUseCase(searchRepo: getIt<SearchRepo>()),
  );

  
}
