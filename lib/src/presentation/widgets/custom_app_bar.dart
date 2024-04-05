import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../core/themes/app_theme_base.dart';
import '../../core/themes/app_theme_factory.dart';
import '../../core/themes/spacing/spacing.dart';
import '../extensions/build_context_extensions.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  factory CustomAppBar.zero() {
    return const CustomAppBar(
      toolbarHeight: 0,
      automaticallyImplyLeading: false,
    );
  }
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.progress,
    this.onBackTap,
    this.titleColor,
    this.titleWidget,
    this.leadingIcon,
    this.leadingWidth,
    this.toolbarHeight,
    this.backgroundColor,
    this.centerTitle = true,
    this.enableShadow = true,
    this.scrolledUnderElevation,
    this.automaticallyImplyLeading = true,
  });

  final String? title;
  final double? progress;
  final bool centerTitle;
  final Color? titleColor;
  final bool enableShadow;
  final Widget? titleWidget;
  final Widget? leadingIcon;
  final double? leadingWidth;
  final List<Widget>? actions;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final VoidCallback? onBackTap;
  final double? scrolledUnderElevation;
  final bool automaticallyImplyLeading;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(
        double.infinity,
        toolbarHeight ?? AppThemeBase.appBarHeight,
      );
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: widget.enableShadow
                  ? [context.theme.shadowLightmodeLevel1]
                  : null,
            ),
            child: AppBar(
              elevation: 0,
              actions: widget.actions,
              centerTitle: widget.centerTitle,
              shadowColor: Colors.transparent,
              toolbarHeight: widget.toolbarHeight,
              foregroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shape: widget.enableShadow
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: .1,
                      ),
                    )
                  : null,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              backgroundColor: widget.backgroundColor ??
                  context.theme.scaffoldBackgroundColor,
              title: Padding(
                padding: EdgeInsets.only(
                  left: widget.leadingWidth == 0 ? Spacing.xs.value : 0,
                ),
                child: widget.titleWidget ??
                    AutoSizeText(
                      widget.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontFamily: context.textTheme.secodaryFontFamily,
                        fontWeight: context.textTheme.fontWeightMedium,
                        color: widget.titleColor,
                      ),
                    ),
              ),
              leadingWidth: widget.leadingWidth,
              leading: widget.automaticallyImplyLeading &&
                          Navigator.of(context).canPop() ||
                      widget.leadingIcon != null ||
                      widget.onBackTap != null
                  ? Semantics(
                      button: true,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: widget.onBackTap ??
                            () => Navigator.of(context).pop(context),
                        borderRadius: AppThemeBase.borderRadiusSM,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: Spacing.md.value),
                            child: widget.leadingIcon ??
                                Icon(
                                  Icons.chevron_left_rounded,
                                  color: context.textTheme.bodyMedium?.color,
                                ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              scrolledUnderElevation: widget.scrolledUnderElevation ?? 0,
            ),
          ),
        ),
        if (widget.progress != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: const Spacing(3).value),
            child: ClipRRect(
              borderRadius: context.theme.borderRadiusXLG,
              child: LinearProgressIndicator(
                value: widget.progress,
                minHeight: 2,
                backgroundColor: Colors.grey.shade300,
                color: context.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
