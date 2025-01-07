import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/wallet/transactions/routes/transaction_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WayaWebview extends StatefulWidget {
  const WayaWebview({
    super.key,
  });

  @override
  State<WayaWebview> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<WayaWebview> {
  String? url;
  String? title;
  bool showAppBar = false;
  String? paymentMethod;
  late final WebViewController _controller;
  bool _isLoading = true;
  String? transactionId;
  String? fundingOption;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onUrlChange: (change) {
            if (fundingOption != null && fundingOption == "PAYSTACK") {
              if (change.url!.contains("wayagram")) {
                WayaNav.offNamed(TransactionRoutes.verifyTransaction,
                    arguments: {
                      "transactionId": transactionId,
                      "fundingOption": fundingOption
                    });
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // You can handle navigation requests here
            // Return NavigationDecision.prevent to block navigation
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url ?? "https://www.google.com"));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _controller.loadRequest(Uri.parse(args['url']));
        url = args['url'];
        title = args['title'];
        showAppBar = args['showAppBar'] ?? false;
        transactionId = args["transactionId"];
        fundingOption = args["fundingOption"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    log("$url");
    return WayaScaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? "Waya Webview",
                  style: wayaTheme.textTheme.titleLarge),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _controller.reload();
                  },
                ),
              ],
            )
          : null,
      padding: EdgeInsets.all(0),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
