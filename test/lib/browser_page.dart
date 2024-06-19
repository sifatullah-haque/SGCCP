import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lottie/lottie.dart';

class BrowserPage extends StatefulWidget {
  final String url;

  const BrowserPage({super.key, required this.url});

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _isError = false;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _isError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  Future<void> _goForward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff034d77),
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.home, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset("assets/logo.png", height: 30, width: 50),
          ),
        ],
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !_isError,
            child: WebViewWidget(controller: _controller),
          ),
          if (_isLoading)
            Center(
              child: Lottie.asset(
                'assets/loader.json', // path to your Lottie file
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
          if (_isError)
            Center(
              child: Text(
                'Connect to internet to access the app',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: const Color(0xff034d77),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _goBack,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: _goForward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
