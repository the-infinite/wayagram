import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WayaBrowserView extends StatefulWidget {
  final String name;
  final String url;

  // Construct.
  const WayaBrowserView({
    super.key,
    required this.name,
    required this.url,
  });

  @override
  State<WayaBrowserView> createState() => _WayaBrowserViewState();
}

class _WayaBrowserViewState extends State<WayaBrowserView> {
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) => WayaPreloaderController.instance.show(),
        onPageFinished: (String url) => WayaPreloaderController.instance.hide(),
        onUrlChange: (change) {},
        onNavigationRequest: (NavigationRequest request) => NavigationDecision.navigate,
      ),
    )
    ..loadRequest(Uri.parse(widget.url));

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return the component after building it.
    return WayaScaffold(
      appBar: AppBar(
        title: Text(widget.name, style: wayaTheme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      padding: EdgeInsets.all(0),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
