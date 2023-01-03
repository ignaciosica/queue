import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class FormzEnumInput<T extends FormzBaseCubit, E extends IconEnum> extends StatelessWidget {
  const FormzEnumInput({
    Key? key,
    this.height = 65,
    required this.title,
    required this.propKey,
    required this.enumKey,
    this.isLast = false,
  }) : super(key: key);

  final double height;
  final String title;
  final String propKey;
  final String enumKey;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      buildWhen: (ps, s) => ps.readFormzProperty<E?>(propKey).value != s.readFormzProperty<E?>(propKey).value,
      builder: (BuildContext context, state) {
        final prop = state.readFormzProperty<E?>(propKey);
        final textTheme = Theme.of(context).textTheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height - 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineMedium!
                        .copyWith(color: isOptional(prop) ? CupertinoColors.systemGrey : CupertinoColors.black),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: Colors.grey.shade200,
                      groupValue: BlocProvider.of<T>(context).state.readFormzProperty<E?>(propKey).value,
                      children: {for (var v in Enums.map[enumKey]!) v: SegmentOption<T, E>(option: v, propKey: propKey)},
                      onValueChanged: (dynamic value) =>
                          BlocProvider.of<T>(context).propertyChanged(propKey, value as Object),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast) const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  bool isOptional(FormzBase prop) => prop.empty && prop.isEmpty;
}

class SegmentOption<T extends FormzBaseCubit, E extends IconEnum> extends StatelessWidget {
  const SegmentOption({Key? key, required this.option, required this.propKey}) : super(key: key);
  final IconEnum option;
  final String propKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 28,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    option.icon,
                    size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                    color: BlocProvider.of<T>(context).state.readFormzProperty<E?>(propKey).value == option
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey,
                  ),
                ),
                TextSpan(text: ' ${option.text}'),
              ],
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: CupertinoColors.systemGrey),
            ),
          ),
        ),
      ),
    );
  }
}
