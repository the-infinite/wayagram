import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class DisputeChatInput extends ConsumerStatefulWidget {
  const DisputeChatInput({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisputeChatInput();
}

class _DisputeChatInput extends ConsumerState<DisputeChatInput> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding:  const EdgeInsets.fromLTRB(0,12, 0, 0),
      decoration: BoxDecoration(
        border: Border(
          top:
              BorderSide(color: wayaTheme.colorScheme.greyColor300, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.primar50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor200)),
              width: 50,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    size: 30,
                  ),
                  onPressed: () {},
                  color: wayaTheme.colorScheme.greyColor600,
                ),
              )),
          const Gap(4),
          Expanded(
            child: WayaTextFormField(
              fillColor: wayaTheme.colorScheme.scaffoldColor,
              controller: TextEditingController(),
              hintText: 'Write a message here ..',
              suffixIcon: Container(
                padding: EdgeInsets.all(5),
                width: 50,
                child: WayaButton(
                callback: () {},
                height: 40,
                centerWidget: Transform.rotate(
                  angle:  30 * 3.1415927 / -180,
                  child: Icon(
                    Icons.send_rounded,
                    size: 30,
                    color: wayaTheme.colorScheme.white,
                  ),
                ),
              ),
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
