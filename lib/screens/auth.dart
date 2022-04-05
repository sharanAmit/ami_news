import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late WebViewController controller;
  bool loginDisplay = true;
  final magicBox = Hive.box('MagicBox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: 1.sw > 1.sh ? 900.h : 900.w,
            child: ListView(
              children: [
                SizedBox(
                  height: 0.05.sh,
                ),
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Text("Sign up",
                      style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade400)),
                ),
                SizedBox(height: 0.05.sh),
                SizedBox(
                  height: 0.7.sh,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: "https://newsapi.org/register",
                    onWebViewCreated: (controller) {
                      this.controller = controller;
                    },
                    onPageStarted: (string) {
                      if (string == "https://newsapi.org/account") {
                        controller
                            .runJavascript("document.body.display = 'none'");
                      }
                      if (string == "https://newsapi.org/register") {
                        controller
                            .runJavascript("document.body.display = 'none'");
                      }
                    },
                    onPageFinished: (string) async {
                      if (string == "https://newsapi.org/register") {
                        controller
                            .runJavascript("document.body.display = 'run-in'");
                        controller.runJavascript(
                            "document.getElementsByClassName('flex justify-between')[0].style.display = 'none'");
                        controller.runJavascript(
                            "document.getElementsByClassName('f2 fw3 black-90')[0].style.display = 'none'");
                        setState(() {
                          loginDisplay = true;
                        });
                      }
                      if (string == "https://newsapi.org/login") {
                        controller.runJavascript(
                            "document.getElementsByClassName('flex justify-between')[0].style.display = 'none'");
                      }
                      if (string == "https://newsapi.org/account") {
                        String apiKey =
                            await controller.runJavascriptReturningResult(
                                "document.getElementById('ApiKey').value");
                        apiKey = apiKey.replaceAll('"', '');
                        magicBox.put("apiKey", apiKey);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      apiKey: apiKey,
                                    )));
                      }
                    },
                  ),
                ),
                loginDisplay
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          TextButton(
                              onPressed: () {
                                controller.loadUrl("https://newsapi.org/login");
                                setState(() {
                                  loginDisplay = false;
                                });
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 12.sp),
                              ))
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ));
  }
}
