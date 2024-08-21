import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class CharactersPage extends HookConsumerWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController =
        usePagingController<String?, Character>(firstPageKey: null);

    useEffect(
      () {
        void pageRequestListener(String? pageKey) {
          const pageSize = 20;
          ref
              .read(charactersServiceProvider)
              .getCharactersLimited(
                pageSize: pageSize,
                lastCharacterId: pageKey,
              )
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
        title: Text(context.l10n.charactersPageTitle),
      ),
      body: AppMaxContentWidth(
        child: PagedListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.pageHorizontalPadding,
            vertical: context.dimensions.pageVerticalPadding,
          ),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Character>(
            firstPageProgressIndicatorBuilder: (context) =>
                const Center(child: AppLoader()),
            firstPageErrorIndicatorBuilder: (context) {
              return AppErrorWidget(
                errorDescription: context.l10n.historyPageLoadingError,
                onTryAgain: pagingController.retryLastFailedRequest,
                shouldScroll: false,
              );
            },
            newPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            newPageErrorIndicatorBuilder: (context) => LoadMoreError(
              onRetry: pagingController.retryLastFailedRequest,
            ),
            noItemsFoundIndicatorBuilder: (context) {
              return EmptyList(
                title: context.l10n.charactersPageEmptyTitle,
                message: context.l10n.charactersPageEmptyMessage,
                image: Assets.images.charactersEmpty.image(),
                action: FilledButton(
                  onPressed: () {
                    CreateCharacterPageRoute().push<void>(context).then((_) {
                      if (!context.mounted) return;
                      pagingController.refresh();
                    });
                  },
                  child: Text(context.l10n.createYourCharacter),
                ),
              );
            },
            itemBuilder: (context, item, index) {
              return _CharacterTile(
                character: item,
                onEditFinished: pagingController.refresh,
                isFirst: index == 0,
                isLast: index == (pagingController.itemList?.length ?? -1) - 1,
              );
            },
          ),
          separatorBuilder: (context, index) => const FlatDivider(),
        ),
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({
    required this.character,
    required this.onEditFinished,
    this.isFirst = false,
    this.isLast = false,
  });

  final Character character;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onEditFinished;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      hint: context.l10n.a11yCharacterEditHint,
      child: AppListTile(
        isFirst: isFirst,
        isLast: isLast,
        minTileHeight: 72,
        leading: ListCharacterAvatar(
          characterId: character.id,
        ),
        title: Text(
          character.name,
          style: context.textTheme.bodyLarge,
        ),
        tileColor: context.colors.surface,
        trailing: const Icon(Icons.arrow_right),
        onTap: () {
          EditCharacterPageRoute(
            characterId: character.id,
            name: character.name,
            description: character.userDescription,
          ).push<void>(context).then((_) {
            if (!context.mounted) return;
            onEditFinished();
          });
        },
      ),
    );
  }
}
