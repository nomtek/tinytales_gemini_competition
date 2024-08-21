import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_service.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 43,
            bottom: 48,
            left: context.dimensions.pageHorizontalPadding,
            right: context.dimensions.pageHorizontalPadding,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _TitleHeader(),
                Flexible(
                  child: _LoginAnimation(),
                ),
                GoogleLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleLoginButton extends ConsumerWidget {
  const GoogleLoginButton({super.key});

  void _showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(context.l10n.loginError),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final loginResult =
              await ref.read(authServiceProvider).signInWithGoogle();
          if (loginResult == LoginResult.failure) {
            ref.read(talkerProvider).info('Failed to log in with Google');
            if (context.mounted) _showErrorSnackBar(context);
          }
        } catch (e) {
          ref.read(talkerProvider).error(e.toString());
          if (context.mounted) _showErrorSnackBar(context);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          context.colors.surface,
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: 11.5,
            vertical: 9.5,
          ),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: context.colors.onSurface,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.google.svg(
            width: 20,
            height: 20,
          ),
          const Gap(10),
          Flexible(
            child: Text(
              context.l10n.continueWithGoogle,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleHeader extends StatelessWidget {
  const _TitleHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.appName,
          style: context.textTheme.displayLarge!.copyWith(
            color: context.colors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          context.l10n.appSlogan,
          style: context.textTheme.headlineSmall!.copyWith(
            color: context.colors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoginAnimation extends HookWidget {
  const _LoginAnimation();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    final animation = useAnimation(
      Tween<double>(begin: 1, end: 1.3).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(
      () {
        controller.repeat(reverse: true);
        return null;
      },
      const [],
    );

    return Transform.scale(
      scale: animation,
      child: Assets.images.loginPageImage.svg(),
    );
  }
}
