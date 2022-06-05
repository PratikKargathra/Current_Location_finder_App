import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String map = "https://www.google.com/maps/@";
  String late = "";
  String long = "";

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  @override
  initState(){
    super.initState();
    getPermission();
  }
  getPermission() async {
    await Permission.location.request();
    if(await Permission.location.status.isDenied || await Permission.location.status.isPermanentlyDenied){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("We Need Location Permission for Show your Current Location"), action: SnackBarAction(label: "Open Setting", onPressed: (){
        openAppSettings();
      }),));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        key:  webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(map+late+long)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: ()async{
          await getPermission();
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          setState((){
            late = position.latitude.toString();
            long = position.longitude.toString();
          });
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: Uri.parse(map+late+long)));
        },
        style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width*0.8,60),
            primary: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )
        ),
        child: const Text("Find Location"),
      ),
    );
  }
}


