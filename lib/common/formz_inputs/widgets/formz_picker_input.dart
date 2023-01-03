/*
  @override
  Widget buildInputWidget(BuildContext context, RegisterState state) {
    return CupertinoPicker(
      useMagnifier: true,
      itemExtent: 24,
      onSelectedItemChanged: (val) {
        context.read<RegisterCubit>().genderChanged(GenderEnum.values.elementAt(val));
      },
      children: GenderEnum.values.map((GenderEnum genderOption) {
        return Text(genderOption.name);
      }).toList(),
    );
  }

 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class FormzPickerInput<T extends FormzBaseCubit, O extends ToTileMixin> extends StatelessWidget {
  const FormzPickerInput({
    Key? key,
    this.height = 65 * 1.5,
    required this.propKey,
    required this.title,
    required this.options,
    this.isLast = false,
  }) : super(key: key);
  final double height;
  final String title;
  final String propKey;
  final List<O> options;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      buildWhen: (ps, s) => ps.readFormzProperty<O?>(propKey).value != s.readFormzProperty<O?>(propKey).value,
      builder: (context, state) {
        final theme = Theme.of(context).textTheme;
        final prop = state.readFormzProperty<O?>(propKey) as FormzObject<O?>;
        return SizedBox(
          height: height - 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.headlineMedium!.copyWith(color: Colors.black)),
              const SizedBox(height: 4),
              Expanded(
                child: CupertinoPicker(
                  useMagnifier: true,
                  itemExtent: 24,
                  onSelectedItemChanged: (val) {
                    BlocProvider.of<T>(context).propertyChanged(propKey, val);
                  },
                  children: options.map((dynamic option) => Text(option.toString())).toList(),
                ),
              ),
              if (!isLast) const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
