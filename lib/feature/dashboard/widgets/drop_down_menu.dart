import 'package:flutter/material.dart';
import 'package:keygourd/core/models/user_key_model.dart';

class UsersDropDownButton extends StatefulWidget {
  const UsersDropDownButton(
      {super.key,
      required this.items,
      required this.hintText,
      required this.onChanged,
      this.selectedItem});

  final List<UserKeyModel> items;
  final ValueChanged<UserKeyModel> onChanged;
  final String hintText;
  final UserKeyModel? selectedItem;

  @override
  State<UsersDropDownButton> createState() => _UsersDropDownButtonState();
}

class _UsersDropDownButtonState extends State<UsersDropDownButton> {
  late UserKeyModel? selectedItem;

  @override
  void initState() {
    selectedItem = widget.selectedItem;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UsersDropDownButton oldWidget) {
    selectedItem = widget.selectedItem;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // margin: const EdgeInsets.only(top: IntroductionBody.tileTopPadding),
      // height: IntroductionBody.tileHeight,
      decoration: BoxDecoration(
        // borderRadius: IntroductionBody.borderRadius,
        color: theme.colorScheme.onSecondary,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<UserKeyModel>(
            value: selectedItem,
            hint: Text(
              widget.hintText,
              style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.normal),
            ),
            focusColor: theme.colorScheme.onSecondary,
            // borderRadius: IntroductionBody.borderRadius,
            isExpanded: true,
            elevation: 16,
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
            onChanged: (UserKeyModel? value) {
              setState(() {
                widget.onChanged(value!);
                selectedItem = value;
              });
            },
            items: widget.items
                .map<DropdownMenuItem<UserKeyModel>>((UserKeyModel value) {
              return DropdownMenuItem<UserKeyModel>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
