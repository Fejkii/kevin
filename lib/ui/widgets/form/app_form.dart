import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> content;

  const AppForm({
    super.key,
    required this.formKey,
    required this.content,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  late List<Widget> newContent = [];

  @override
  void initState() {
    _parseContent();
    super.initState();
  }

  void _parseContent() {
    for (var element in widget.content) {
      newContent.add(element);
      newContent.add(const SizedBox(height: 20));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: newContent,
      ),
    );
  }

  bool validate() {
    //Validate Form Fields
    bool validate = widget.formKey.currentState!.validate();
    if (validate) widget.formKey.currentState!.save();
    return validate;
  }
}
