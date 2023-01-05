import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:groupify/common/common.dart';

class FormzTextInput<T extends FormzBaseCubit> extends StatefulWidget {
  const FormzTextInput(
      {Key? key, this.height = 65, required this.title, required this.propKey, this.maxLines = 1, this.isLast = false})
      : super(key: key);
  final double height;
  final String title;
  final String propKey;
  final int maxLines;
  final bool isLast;

  @override
  State<FormzTextInput> createState() => _FormzTextInputState<T>();
}

class _FormzTextInputState<T extends FormzBaseCubit> extends State<FormzTextInput<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    final cubit = BlocProvider.of<T>(context);

    _controller = TextEditingController()
      ..text = cubit.state.readFormzProperty<String>(widget.propKey).value ?? ''
      ..addListener(() => cubit.propertyChanged(widget.propKey, _controller.text));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormzBaseCubitState>(
      buildWhen: (ps, s) =>
          ps.readFormzProperty<String>(widget.propKey).value != s.readFormzProperty<String>(widget.propKey).value,
      builder: (BuildContext context, state) {
        if (state.status == FormzStatus.pure) _controller.text = '';
        final prop = state.readFormzProperty<String>(widget.propKey) as FormzText;
        final textTheme = Theme.of(context).textTheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.height - 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: textTheme.headlineMedium!
                        .copyWith(color: isOptional(prop) ? CupertinoColors.systemGrey : CupertinoColors.black),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: CupertinoTextField(
                      textInputAction: TextInputAction.done,
                      controller: _controller,
                      maxLines: widget.maxLines,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border:
                            Border.all(color: prop.invalid ? CupertinoColors.destructiveRed : CupertinoColors.systemGrey4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (prop.error != null && !prop.pure)
              Text(prop.error.toString(), style: textTheme.labelSmall!.copyWith(color: CupertinoColors.destructiveRed)),
            if (!widget.isLast) const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  bool isOptional(FormzText prop) => prop.empty && prop.value.isEmpty;
}
