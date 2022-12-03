import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO try this instead of Alert
class DialogService {
  const DialogService._();

  static IDialog? _current;

  static Future<void> load(
    BuildContext context, {
    String? title,
  }) async {
    _current = LoadDialog(title: title);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _current ?? LoadDialog(title: title),
    );
  }

  static void dispose() {
    if (_current != null) {
      _current!.dismiss();
      _current = null;
    }
  }
}

mixin IDialogService {
  void dismiss();
}

abstract class IDialog extends StatelessWidget with IDialogService {
  const IDialog({Key? key}) : super(key: key);
}

// ignore: must_be_immutable
class LoadDialog extends IDialog {
  final String? title;
  LoadDialog({
    Key? key,
    this.title,
  }) : super(key: key);

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlertDialog(
      title: Text(title ?? "Loading..."),
      content: const CupertinoActivityIndicator(),
    );
  }

  @override
  void dismiss() {
    Navigator.pop(_context!);
  }
}
