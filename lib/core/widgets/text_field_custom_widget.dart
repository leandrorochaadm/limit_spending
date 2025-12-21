import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustomWidget extends StatelessWidget {
  TextFieldCustomWidget({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.hintText,
    this.onTap,
    this.readOnly = false,
    this.showSuffixIcon = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
    this.validator,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final String hintText;
  final void Function()? onTap;
  final bool readOnly;
  final bool showSuffixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  String? Function(String?)? validator;



  @override
  Widget build(BuildContext context) {
    final InkWell buttonClear = InkWell(
      onTap: () {
        onChanged?.call('');
        controller.clear();
        focusNode.requestFocus();
      },
      child: const Icon(
        Icons.close,
        size: 24,
        // color: ,
      ),
    );

    const Icon iconChevronRight = Icon(
      CupertinoIcons.chevron_right,
      size: 24,
      // color: AppColors.blueyGray,
    );

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, __, ___) {
        final Widget iconReturn =
            showSuffixIcon ? iconChevronRight : const SizedBox.shrink();
        final Widget suffixIcon =
            controller.text.isNotEmpty ? buttonClear : iconReturn;

        return TextFormField(
          validator: validator,
          controller: controller,
          readOnly: readOnly,
          focusNode: focusNode,
          autocorrect: false,
          enableSuggestions: true,
          textInputAction: TextInputAction.done,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: maxLines,
          inputFormatters: inputFormatters,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            hintText: hintText,
            labelText: hintText,
            suffixIcon: suffixIcon,
          ),
          onTap: onTap,
          onChanged: onChanged,
          onSaved: onChanged,
          onFieldSubmitted: onChanged,
        );
      },
    );
  }
}
