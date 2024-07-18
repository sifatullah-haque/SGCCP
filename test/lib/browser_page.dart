import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lottie/lottie.dart';

class BrowserPage extends StatefulWidget {
  final String url;

  const BrowserPage({super.key, required this.url});

  static Future<void> clearCookies() async {
    final cookieManager = WebviewCookieManager();
    await cookieManager.clearCookies();
  }

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isError = false;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _isError = false;
            });
            _injectJavaScript(); // Inject JavaScript to catch errors
          },
          onPageFinished: (_) async {
            setState(() {
              _isLoading = false;
            });
            await _updateNavigationState();
            _logCookies();
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _isError = true;
            });
          },
        ),
      )
      ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36")
      ..loadRequest(Uri.parse(widget.url));
  }

  void _injectJavaScript() {
    final js = '''
      window.onerror = function(message, source, lineno, colno, error) {
        // Handle the error here
        console.log("JavaScript Error: ", message);
        return true; // Prevents the default browser error handling
      };
      try {
        // Add your own error-prone script here
      } catch (e) {
        console.log("Caught Error: ", e);
      }
    ''';
    _controller.runJavaScript(js);
  }

  Future<void> _logCookies() async {
    final cookieManager = WebviewCookieManager();
    final cookies = await cookieManager.getCookies(widget.url);
    print(cookies);
  }

  Future<void> _updateNavigationState() async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      await _updateNavigationState();
    }
  }

  Future<void> _goForward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
      await _updateNavigationState();
    }
  }

  Future<void> _goHome() async {
    await _controller
        .loadRequest(Uri.parse('https://app.sgccp-bd.com/1/portal'));
    await _updateNavigationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff034d77),
        title: GestureDetector(
          onTap: _goHome,
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
            const Center(
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
                icon: Icon(Icons.arrow_back,
                    color: _canGoBack ? Colors.white : Colors.grey),
                onPressed: _canGoBack ? _goBack : null,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward,
                    color: _canGoForward ? Colors.white : Colors.grey),
                onPressed: _canGoForward ? _goForward : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
