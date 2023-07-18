import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class FormzTextListInput<T extends FormzBaseCubit> extends StatefulWidget {
  const FormzTextListInput({
    Key? key,
    this.height = 65,
    required this.title,
    required this.propKey,
    this.isLast = false,
    this.isChecklist = false,
  }) : super(key: key);
  final double height;
  final String title;
  final String propKey;
  final bool isLast;
  final bool isChecklist;

  @override
  State<FormzTextListInput> createState() => _FormzTextListInputState<T>();
}

class _FormzTextListInputState<T extends FormzBaseCubit> extends State<FormzTextListInput<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
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
          ps.readFormzProperty<dynamic>(widget.propKey).value != s.readFormzProperty<dynamic>(widget.propKey).value,
      builder: (BuildContext context, state) {
        final prop = state.readFormzProperty<List<String>?>(widget.propKey) as FormzTextList<String>;
        final textTheme = Theme.of(context).textTheme;
        return Column(
          children: [
            Column(
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
                          onSubmitted: (val) {
                            if (_controller.text.isEmpty) {
                              return;
                            }
                            final newList = List<String>.from(prop.value!)..add(val);
                            _controller.clear();
                            BlocProvider.of<T>(context).propertyChanged(widget.propKey, newList);
                          },
                          suffix: Row(
                            children: [
                              IconButton(
                                onPressed: prop.value!.isEmpty
                                    ? null
                                    : () {
                                        final newList = List<String>.from(prop.value!);
                                        _controller.text = newList.removeLast();
                                        BlocProvider.of<T>(context).propertyChanged(widget.propKey, newList);
                                      },
                                color: CupertinoColors.destructiveRed,
                                icon: const Icon(Icons.arrow_upward_rounded),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          controller: _controller,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: prop.invalid ? CupertinoColors.destructiveRed : CupertinoColors.systemGrey4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (prop.error != null && !prop.pure)
                  Text(prop.error.toString(), style: textTheme.labelSmall!.copyWith(color: CupertinoColors.destructiveRed)),
                if (prop.value!.isNotEmpty) const SizedBox(height: 8),
              ],
            ),
            if (prop.value!.isNotEmpty)
              Column(
                children: prop.value!
                    .map((n) => [ListItemRow(note: n, isChecklist: widget.isChecklist), const SizedBox(height: 4)])
                    .reduce((value, element) => value.followedBy(element).toList())
                    .sublist(0, prop.value!.length * 2 - 1),
              )
          ],
        );
      },
    );
  }

  bool isOptional(FormzTextList prop) => prop.empty && prop.value!.isEmpty;
}

class ListItemRow extends StatelessWidget {
  const ListItemRow({Key? key, required this.note, required this.isChecklist}) : super(key: key);

  final String note;
  final bool isChecklist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          if (isChecklist) const Icon(Icons.check_box_outline_blank_rounded, color: CupertinoColors.activeBlue, size: 16),
          if (!isChecklist) const Icon(Icons.circle, size: 6, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(child: Text(note)),
        ],
      ),
    );
  }
}
