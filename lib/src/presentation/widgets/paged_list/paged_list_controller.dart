import 'package:flutter/foundation.dart';

class _PagedListConfig<T> {
  /// [nextPageKey] is the key to verify if is necessary
  /// make another [fetchNewItems] call.
  /// Is the key page, offset or similar
  _PagedListConfig({
    required this.pageKey,
    required this.pageSize,
    required this.nextPageKey,
    required this.pageIncrement,
    required this.forceNewFetch,
  }) {
    _pageKey = pageKey;
    _pageSize = pageSize;
    _nextPageKey = nextPageKey;
    _pageIncrement = pageIncrement;
    _forceNewFetch = forceNewFetch;
  }

  int pageKey;
  int pageSize;
  int nextPageKey;
  int pageIncrement;
  bool forceNewFetch;
  List<T> lastItems = List.empty(growable: true);

  late final int _pageKey;
  late final int _pageSize;
  late final int _nextPageKey;
  late final int _pageIncrement;
  late final bool _forceNewFetch;

  bool get isLastFetch {
    return lastItems.isNotEmpty && lastItems.length < pageSize;
  }

  void reset() {
    lastItems.clear();
    pageKey = _pageKey;
    pageSize = _pageSize;
    nextPageKey = _nextPageKey;
    forceNewFetch = _forceNewFetch;
    pageIncrement = _pageIncrement;
  }
}

class PagedListController<E, S> extends ValueNotifier<List<S>> {
  PagedListController({
    int pageSize = 10,
    this.firstPageKey = 0,
    this.reverse = false,
    int pageIncrement = 1,
    this.searchPercent = 100,
    bool forceNewFetch = false,
  })  : assert(searchPercent >= 0 && searchPercent <= 100),
        super(const []) {
    config = _PagedListConfig(
      nextPageKey: firstPageKey + pageIncrement,
      forceNewFetch: forceNewFetch,
      pageIncrement: pageIncrement,
      pageKey: firstPageKey,
      pageSize: pageSize,
    );
  }

  final ValueNotifier<E?> _error = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  E? get error => _error.value;
  bool get hasError => _error.value != null;
  void setError(E value) {
    _loading.value = false;
    _error.value = value;
    notifyListeners();
  }

  void clearError({bool update = false}) {
    _error.value = null;
    if (update) {
      notifyListeners();
    }
  }

  bool get isLoading => _loading.value;
  void setLoading(bool value) {
    _loading.value = value;
    notifyListeners();
  }

  List<S> get state => value;
  void update(List<S> state, {force = false}) {
    clearError();
    _loading.value = false;
    if (value != state || force) {
      value = state;
      notifyListeners();
    }
  }

  /// [fetchItems] is used to do a new search by new items.
  late final Future<List<S>> Function({required int pageKey}) _fetchItems;

  /// [searchPercent] is the key to be used in case of a [refresh].
  final int searchPercent;

  /// [firstPageKey] is the key page, offset or similar
  ///  to be used in case of a [refresh].
  final int firstPageKey;

  /// [config] is the [PagedListController] settings
  late final _PagedListConfig<S> config;

  /// [reverse] check if the list is inverted
  late final bool reverse;

  Future<void> refresh() async {
    if (!isLoading) {
      config.reset();
      update(List<S>.empty(growable: true));
      await fetchNewItems(pageKey: firstPageKey);
    }
  }

  void setListener(
    Future<List<S>> Function({required int pageKey}) fetchItems,
  ) =>
      _fetchItems = fetchItems;

  Future<void> fetchNewItems({required int pageKey}) async {
    if (config.nextPageKey == pageKey ||
        (config.isLastFetch && !config.forceNewFetch) ||
        isLoading) {
      return;
    }

    clearError();
    setLoading(true);
    await _fetchItems(pageKey: pageKey).then((value) async {
      config.lastItems = value;
      config.pageKey += config.pageIncrement;
      if (value.isNotEmpty) {
        config.nextPageKey += config.pageIncrement;
        await Future.delayed(const Duration(milliseconds: 250));
        if (reverse) {
          update([...value.where((v) => !state.contains(v)), ...state]);
        } else {
          update([...state, ...value.where((v) => !state.contains(v))]);
        }
      }
    }).catchError((error) {
      setError(error);
    }).whenComplete(() => setLoading(false));
  }
}
