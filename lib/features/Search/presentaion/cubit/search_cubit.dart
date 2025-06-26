import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/Search/domain/usecase/search_usecases.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/domain/usecases.dart';
import 'package:e_commerce/core/injection/get_It.dart';

part 'search_states.dart';

class SearchCubit extends Cubit<SearchState> {
final GetSearchResultUseCase _getSearchResultUseCase;

  SearchCubit() :_getSearchResultUseCase = getIt<GetSearchResultUseCase>(), super(SearchInitial());

  void search(String query) async {
    if (query.isEmpty) return;

    emit(SearchLoading());
    try {
      final results = await _getSearchResultUseCase(query);
      results.fold((failuer) => emit(SearchError(failuer.toString())) ,(success) =>emit(SearchLoaded(success)) ,);
      
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
