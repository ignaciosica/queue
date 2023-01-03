import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class FormzChipInput<T extends FormzBaseCubit> extends StatelessWidget {
  const FormzChipInput({Key? key, this.height = 65, required this.title, required this.propKey, this.isLast = false})
      : super(key: key);

  final double height;
  final String title;
  final String propKey;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      builder: (BuildContext context, state) {
        final prop = state.readFormzProperty<List<String>?>(propKey) as FormzObjectList<String>;
        final textTheme = Theme.of(context).textTheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineMedium!
                        .copyWith(color: isOptional(prop) ? CupertinoColors.systemGrey : CupertinoColors.black),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: prop.options!.map((g) => AuxChipInput<T>(propKey: propKey, label: g)).toList(),
                  ),
                ],
              ),
            ),
            if (prop.error != null && !prop.pure) const SizedBox(height: 8),
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

class AuxChipInput<T extends FormzBaseCubit> extends StatelessWidget {
  const AuxChipInput({Key? key, required this.label, required this.propKey}) : super(key: key);
  final String propKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    final prop = BlocProvider.of<T>(context).state.readFormzProperty<List<String>?>(propKey) as FormzObjectList<String>;

    return InkWell(
      onTap: () {
        final newList = List<String>.from(prop.value!);

        if (!prop.value!.contains(label)) {
          newList.add(label);
        } else {
          newList.remove(label);
        }

        BlocProvider.of<T>(context).propertyChanged(propKey, newList);
      },
      child: AnimatedContainer(
        duration: Cte.defaultAnimationDuration,
        decoration: BoxDecoration(
          color: prop.value!.contains(label) ? CupertinoColors.systemBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: prop.value!.contains(label) ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
