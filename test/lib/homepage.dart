import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'browser_page.dart';
import 'authentication/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewAuthentication()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to SGCCP",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff034d77),
        actions: [
          GestureDetector(
              onTap: () => _logout(context),
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.logout_outlined,
                    color: Colors.white, size: 30.0),
              )),
        ],
      ),
      body: const Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerWithInfo(
                    text: "Regular\nGolfing",
                    url: "https://app.sgccp-bd.com/1/portal/golfing-bookings"),
                ContainerWithInfo(
                    text: "Tournament \nRegistration",
                    url:
                        "https://app.sgccp-bd.com/1/portal/golfing-tournament-bookings"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerWithInfo(
                    text: "Room Booking",
                    url: "https://app.sgccp-bd.com/1/portal/room-bookings"),
                ContainerWithInfo(
                    text: "Notices",
                    url: "https://app.sgccp-bd.com/1/portal/notices"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerWithInfo(
                    text: "Bills", url: "https://app.sgccp-bd.com/1/portal"),
                ContainerWithInfo(
                    text: "Pay\nAdvance",
                    url:
                        "https://app.sgccp-bd.com/1/portal/advance-payments/create"),
              ],
            ),
            SizedBox(height: 50),
            // Center(
            //   child: GestureDetector(
            //     onTap: () => _logout(context),
            //     child: Container(
            //       height: 50.0,
            //       width: 120.0,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.orange,
            //       ),
            //       child: const Center(
            //           child: Text("Logout",
            //               style: TextStyle(color: Colors.white, fontSize: 18))),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class ContainerWithInfo extends StatefulWidget {
  final String text;
  final String url;

  const ContainerWithInfo({
    super.key,
    required this.text,
    required this.url,
  });

  @override
  _ContainerWithInfoState createState() => _ContainerWithInfoState();
}

class _ContainerWithInfoState extends State<ContainerWithInfo> {
  bool _isLoading = false;

  void _openBrowserPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BrowserPage(url: widget.url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBrowserPage(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff034d77),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (_isLoading)
            const Positioned(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
