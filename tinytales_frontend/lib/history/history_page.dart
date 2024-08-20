import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/history/history_avatar.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/story/data/story.dart';
import 'package:tale_ai_frontend/story/data/story_service.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class HistoryPage extends HookConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController =
        usePagingController<String?, Story>(firstPageKey: null);
    useEffect(
      () {
        void pageRequestListener(String? pageKey) {
          const pageSize = 20;
          ref
              .read(storyServiceProvider)
              .getStories(pageSize: pageSize, lastStoryId: pageKey)
              .then(
            (items) {
              if (!context.mounted) return;
              final isLastPage = items.length < pageSize;
              if (isLastPage) {
                pagingController.appendLastPage(items);
              } else {
                final nextPageKey = items.last.id;
                pagingController.appendPage(items, nextPageKey);
              }
            },
            onError: (Object error, StackTrace st) {
              ref.read(talkerProvider).handle(error, st);
              if (!context.mounted) return;
              pagingController.error = error;
            },
          );
        }

        pagingController.addPageRequestListener(pageRequestListener);
        return () =>
            pagingController.removePageRequestListener(pageRequestListener);
      },
      [pagingController],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.historyPageTitle),
      ),
      body: AppMaxContentWidth(
        child: PagedListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.pageHorizontalPadding,
            vertical: context.dimensions.pageVerticalPadding,
          ),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Story>(
            firstPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            firstPageErrorIndicatorBuilder: (context) {
              return AppErrorWidget(
                onTryAgain: pagingController.refresh,
                shouldScroll: false,
              );
            },
            newPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            newPageErrorIndicatorBuilder: (context) {
              return LoadMoreError(
                onRetry: pagingController.retryLastFailedRequest,
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return EmptyList(
                title: context.l10n.historyPageEmptyTitle,
                message: context.l10n.historyPageEmptyMessage,
                image: Assets.images.historyEmpty.image(),
                action: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => StoryCreatorRoute().go(context),
                    child: Text(context.l10n.historyPageEmptyAction),
                  ),
                ),
              );
            },
            itemBuilder: (context, item, index) {
              return _HistoryTile(
                item: item,
                isFirst: index == 0,
                isLast: index == (pagingController.itemList?.length ?? -1) - 1,
                onTap: () {
                  HistoryToStoryPageRoute(storyId: item.id)
                      .push<StoryPageCloseReason>(context)
                      .then(
                    (closeReason) {
                      if (!context.mounted) return;
                      switch (closeReason) {
                        case StoryPageCloseReason.delete:
                          // remove deleted story from the list
                          // locally without refresh
                          final oldState = pagingController.value;
                          pagingController.value = PagingState(
                            itemList: oldState.itemList
                                ?.where((story) => story.id != item.id)
                                .toList(),
                            nextPageKey: oldState.nextPageKey,
                            error: oldState.error,
                          );
                        case null:
                          // no-op
                          break;
                      }
                    },
                  );
                },
              );
            },
          ),
          separatorBuilder: (context, index) => const FlatDivider(),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.item,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final Story item;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final itemOverview = item.overview;
    return Semantics(
      button: true,
      hint: context.l10n.a11yStoryDetails,
      child: AppListTile(
        leading: HistoryAvatar(storyId: item.id),
        // tileColor - exception to the standard theme
        // don't want to change it in Theme
        // due to problems it can cause in other places
        tileColor: context.colors.surface,
        title: Text(item.title),
        titleAlignment: ListTileTitleAlignment.titleHeight,
        subtitle: itemOverview != null ? Text(itemOverview) : null,
        onTap: onTap,
        isFirst: isFirst,
        isLast: isLast,
      ),
    );
  }
}
