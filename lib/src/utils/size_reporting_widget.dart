import 'package:flutter/widgets.dart';

// Copied and modified from: https://github.com/Limbou/expandable_page_view/blob/d692cff38f9e098ad5c020d80123a13ab2a53083/lib/expandable_page_view.dart
class SizeReportingOverflowPage extends StatelessWidget {
  const SizeReportingOverflowPage({
    required this.onSizeChanged,
    required this.child,
  });

  final ValueChanged<Size> onSizeChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: 0,
      maxHeight: double.infinity,
      alignment: Alignment.topCenter,
      child: SizeReportingWidget(onSizeChanged: onSizeChanged, child: child),
    );
  }
}

// Copied and modified from https://github.com/Limbou/expandable_page_view/blob/d692cff38f9e098ad5c020d80123a13ab2a53083/lib/size_reporting_widget.dart
class SizeReportingWidget extends StatefulWidget {
  const SizeReportingWidget({
    Key? key,
    required this.onSizeChanged,
    required this.child,
  }) : super(key: key);

  final ValueChanged<Size> onSizeChanged;
  final Widget child;

  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  final _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _notifySize());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance!.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(key: _widgetKey, child: widget.child),
      ),
    );
  }

  void _notifySize() {
    final context = _widgetKey.currentContext;
    if (context == null) return;

    final size = context.size!;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChanged(size);
    }
  }
}
