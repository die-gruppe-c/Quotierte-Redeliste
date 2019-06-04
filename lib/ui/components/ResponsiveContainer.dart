import 'package:flutter/material.dart';
import 'package:quotierte_redeliste/ui/create_room/edit_room_widget.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget widget;
  final ScrollListener scrollListener;
  final ScrollController _scrollController = ScrollController();

  ResponsiveContainer(this.widget, {this.scrollListener}) {
    if (this.scrollListener != null)
      _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (scrollListener != null) {
      scrollListener(
          _scrollController.offset,
          _scrollController.position.minScrollExtent,
          _scrollController.position.outOfRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isTablet(context)) {
      return Center(
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: Card(
                    elevation: 2,
                    child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 500,
                            minHeight:
                                (MediaQuery.of(context).size.height - 48) *
                                    0.8),
                        child: widget),
                  ))));
    } else {
      return SingleChildScrollView(
          controller: _scrollController, child: widget);
    }
  }

  static bool isTablet(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.width;

    // Determine if we should use mobile layout or not. The
    // number 600 here is a common breakpoint for a typical
    // 7-inch tablet.
    return shortestSide > 500;
  }
}
