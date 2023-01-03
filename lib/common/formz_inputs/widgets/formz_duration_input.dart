import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class FormzDurationInput<T extends FormzBaseCubit> extends StatelessWidget {
  const FormzDurationInput({
    Key? key,
    this.height = 65,
    required this.title,
    required this.propKey,
    this.isLast = false,
  }) : super(key: key);

  final double height;
  final String title;
  final String propKey;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      buildWhen: (ps, s) => ps.readFormzProperty<Duration?>(propKey).value != s.readFormzProperty<Duration?>(propKey).value,
      builder: (BuildContext context, state) {
        final prop = state.readFormzProperty<Duration?>(propKey);
        final textTheme = Theme.of(context).textTheme;
        return InkWell(
          onTap: () => showDurationPicker(context),
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
                          Icons.timelapse_rounded,
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
                              ? prop.value.toString().split('.').first.padLeft(8, '0').substring(0, 5)
                              : 'Pick a duration',
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

  void showDurationPicker(BuildContext context) {
    showCupertinoModalPopup<Container>(
      context: context,
      builder: (BuildContext builder) {
        final prop = BlocProvider.of<T>(context).state.readFormzProperty<Duration?>(propKey) as FormzDuration;
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
            color: Colors.white,
          ),
          child: CupertinoTimerPicker(
            onTimerDurationChanged: (value) {
              if (prop.value == null) {
                BlocProvider.of<T>(context).propertyChanged(propKey, value);
              } else if (value != prop.value) {
                BlocProvider.of<T>(context).propertyChanged(propKey, value);
              }
            },
            initialTimerDuration: prop.value ?? const Duration(hours: 1),
            mode: CupertinoTimerPickerMode.hm,
            minuteInterval: 5,
          ),
        );
      },
    );
  }
}
