part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
