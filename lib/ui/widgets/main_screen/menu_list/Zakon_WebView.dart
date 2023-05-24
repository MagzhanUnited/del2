import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZakonWebView extends StatefulWidget {
  const ZakonWebView({Key? key}) : super(key: key);

  @override
  State<ZakonWebView> createState() => _ZakonWebViewState();
}

class _ZakonWebViewState extends State<ZakonWebView> {
  late WebViewController controller;
  double progres = 0;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.zakon),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () async => await controller.goBack(),
              icon: Icon(Icons.arrow_back_ios)),
          IconButton(
              onPressed: () async => await controller.goForward(),
              icon: Icon(Icons.arrow_forward_ios)),
          IconButton(
              onPressed: () async => await controller.reload(),
              icon: Icon(Icons.replay)),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progres,
            color: Colors.red,
            backgroundColor: Colors.black,
          ),
          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: 'https://adilet.zan.kz/rus/index/docs',
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onProgress: (progres) {
                this.progres = progres / 100;
                setState(() {});
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await controller.currentUrl().then((value) {
      //       if (value!.contains('/docs/')) {
      //         print(value);
      //         controller.loadUrl('${value}/download');
      //         print(value);
      //       }
      //     });
      //   },
      //   child: Icon(Icons.download),
      // ),
    );
  }
}
