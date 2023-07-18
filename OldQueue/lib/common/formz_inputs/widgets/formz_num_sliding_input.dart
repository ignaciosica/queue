import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class FormzNumSlidingInput<T extends FormzBaseCubit, N extends num> extends StatelessWidget {
  const FormzNumSlidingInput({
    Key? key,
    this.height = 65,
    required this.title,
    required this.propKey,
    required this.min,
    required this.max,
    this.isLast = false,
  }) : super(key: key);

  final double height;
  final String title;
  final double min;
  final double max;
  final String propKey;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      buildWhen: (ps, s) => ps.readFormzProperty<N?>(propKey).value != s.readFormzProperty<N?>(propKey).value,
      builder: (BuildContext context, state) {
        final prop = state.readFormzProperty<N?>(propKey) as FormzNumber<N>;
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: prop.value?.toDouble() ?? 5,
                            min: prop.min?.toDouble() ?? 0,
                            max: prop.max?.toDouble() ?? 20,
                            activeColor: CupertinoColors.activeBlue,
                            onChanged: (val) => BlocProvider.of<T>(context).propertyChanged(propKey, val.round()),
                            divisions: 17,
                          ),
                        ),
                        Column(
                          children: [
                            Text(prop.value.toString()),
                            Text('max', style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (prop.error != null && !prop.pure)
              Text(prop.error.toString(), style: textTheme.labelSmall!.copyWith(color: CupertinoColors.destructiveRed)),
            if (!isLast) const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  bool isOptional(FormzBase prop) => prop.empty && prop.isEmpty;
}
