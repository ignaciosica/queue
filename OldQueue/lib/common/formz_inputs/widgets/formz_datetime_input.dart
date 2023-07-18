import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';
import 'package:intl/intl.dart';

class FormzDateTimeInput<T extends FormzBaseCubit> extends StatelessWidget {
  const FormzDateTimeInput({
    Key? key,
    this.height = 65,
    required this.title,
    required this.propKey,
    this.isLast = false,
    this.cupertinoDatePickerMode = CupertinoDatePickerMode.dateAndTime,
    this.hint,
  }) : super(key: key);

  final double height;
  final String title;
  final String? hint;
  final String propKey;
  final bool isLast;
  final CupertinoDatePickerMode cupertinoDatePickerMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      buildWhen: (ps, s) => ps.readFormzProperty<DateTime?>(propKey).value != s.readFormzProperty<DateTime?>(propKey).value,
      builder: (BuildContext context, state) {
        final prop = state.readFormzProperty<DateTime?>(propKey);
        final textTheme = Theme.of(context).textTheme;
        return InkWell(
          onTap: () => showDateTimePicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height - 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: textTheme.headlineMedium!
                              .copyWith(color: isOptional(prop) ? CupertinoColors.systemGrey : CupertinoColors.black),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time_rounded,
                          size: Theme.of(context).textTheme.headlineMedium!.fontSize,
                          color: prop.value == null ? CupertinoColors.inactiveGray : CupertinoColors.activeBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          prop.value != null
                              ? cupertinoDatePickerMode == CupertinoDatePickerMode.dateAndTime
                                  ? DateFormat('EEEE d LLL, ').format(prop.value!) + DateFormat.jm().format(prop.value!)
                                  : DateFormat('EEEE d LLL').format(prop.value!)
                              : hint ?? 'Pick a datetime',
                          style: Theme.of(context).textTheme!.bodySmall,
                        ),
                      ),
                    ),
                    if (!isLast) const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isOptional(FormzBase prop) => prop.empty && prop.isEmpty;

  void showDateTimePicker(BuildContext context) {
    showCupertinoModalPopup<Container>(
      context: context,
      builder: (BuildContext builder) {
        final prop = BlocProvider.of<T>(context).state.readFormzProperty<DateTime?>(propKey) as FormzDateTime;
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
            color: Colors.white,
          ),
          child: CupertinoDatePicker(
            mode: cupertinoDatePickerMode,
            onDateTimeChanged: (value) {
              if (prop.value == null) {
                BlocProvider.of<T>(context).propertyChanged(propKey, value);
              } else if (value != prop.value) {
                BlocProvider.of<T>(context).propertyChanged(propKey, value);
              }
            },
            initialDateTime: prop.value ?? prop.initial ?? prop.min?.add(const Duration(hours: 2)),
            maximumDate: prop.max,
            minimumDate: prop.min,
          ),
        );
      },
    );
  }
}
