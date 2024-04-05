import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/sticker_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'chat.dart';

class ChatEmojiPicker extends StatelessWidget {
  final ChatController controller;
  const ChatEmojiPicker(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      height: controller.showEmojiPicker
          ? MediaQuery.of(context).size.height / 2
          : 0,
      child: controller.showEmojiPicker
          ? DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: L10n.of(context)!.emojis),
                      Tab(text: L10n.of(context)!.stickers),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        EmojiPicker(
                          onEmojiSelected: controller.onEmojiSelected,
                          onBackspacePressed: controller.emojiPickerBackspace,
                          config: Config(
                            checkPlatformCompatibility: true,
                            emojiViewConfig: EmojiViewConfig(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              gridPadding: EdgeInsets.zero,
                              emojiSizeMax: 32 * (Platform.isIOS ? 1.20 : 1),
                              recentsLimit: 28,
                              buttonMode: (Platform.isMacOS || Platform.isIOS)
                                  ? ButtonMode.CUPERTINO
                                  : ButtonMode.MATERIAL,
                              noRecents: const NoRecent(),
                            ),
                            swapCategoryAndBottomBar: true,
                            skinToneConfig: SkinToneConfig(
                              enabled: true,
                              dialogBackgroundColor: Color.lerp(
                                theme.colorScheme.background,
                                theme.colorScheme.primaryContainer,
                                0.75,
                              )!,
                              indicatorColor: theme.colorScheme.onBackground,
                            ),
                            categoryViewConfig: CategoryViewConfig(
                              iconColor:
                                  theme.colorScheme.primary.withOpacity(0.5),
                              iconColorSelected: theme.colorScheme.primary,
                              backspaceColor: theme.colorScheme.primary,
                              indicatorColor: theme.colorScheme.primary,
                              showBackspaceButton: true,
                            ),
                            bottomActionBarConfig: BottomActionBarConfig(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              buttonIconColor:
                                  theme.colorScheme.primary.withOpacity(0.5),
                              buttonColor: Colors.transparent,
                              showBackspaceButton: false,
                            ),
                            searchViewConfig: SearchViewConfig(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              hintText: "Search",
                            ),
                          ),
                        ),
                        StickerPickerDialog(
                          room: controller.room,
                          onSelected: (sticker) {
                            controller.room.sendEvent(
                              {
                                'body': sticker.body,
                                'info': sticker.info ?? {},
                                'url': sticker.url.toString(),
                              },
                              type: EventTypes.Sticker,
                            );
                            controller.hideEmojiPicker();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class NoRecent extends StatelessWidget {
  const NoRecent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      L10n.of(context)!.emoteKeyboardNoRecents,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
