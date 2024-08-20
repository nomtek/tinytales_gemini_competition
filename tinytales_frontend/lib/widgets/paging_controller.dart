import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

PagingController<K, M> usePagingController<K, M>({required K firstPageKey}) {
  return use(_PagingControllerHook<K, M>(firstPageKey: firstPageKey));
}

class _PagingControllerHook<K, M> extends Hook<PagingController<K, M>> {
  const _PagingControllerHook({required this.firstPageKey});

  final K firstPageKey;

  @override
  _PagingControllerHookState<K, M> createState() =>
      _PagingControllerHookState<K, M>();
}

class _PagingControllerHookState<K, M>
    extends HookState<PagingController<K, M>, _PagingControllerHook<K, M>> {
  late final _pagingController = PagingController<K, M>(
    firstPageKey: hook.firstPageKey,
  );

  @override
  void dispose() {
    _pagingController.dispose();
  }

  @override
  PagingController<K, M> build(BuildContext context) => _pagingController;

  @override
  Object? get debugValue => _pagingController;

  @override
  String get debugLabel => 'usePagingController<$K, $M>';
}
