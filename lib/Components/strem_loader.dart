import 'package:flutter/material.dart';

class StreamLoader<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(BuildContext context, T data) builder;

  StreamLoader({required this.snapshot, required this.builder});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data == null) {
      return Center(child: Text("No data available"));
    }
    return builder(context, snapshot.data!);
  }
}
