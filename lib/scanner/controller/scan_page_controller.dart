import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScanPageController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  RxList<String> listData = <String>[].obs;

  void requestFocusScanner() {
    textFieldFocus.requestFocus();

    Future.delayed(Duration(), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  void handleScannerInput(String scannedData) {
    print("DDDDDDDD 11111111");
    if (scannedData.isNotEmpty) {
      print("DDDDDDDD 222222222");
      listData.add(scannedData);
      textEditingController.clear();
    }
    requestFocusScanner(); // Ensure the focus is reset for continuous scanning
  }

  void _handleScannerInput(RawKeyEvent event) {
    print("CCCCCCCC  1111111");
    if (event is RawKeyDownEvent) {
      final String? scannedKey = event.logicalKey.keyLabel;
      if (scannedKey == 'Game Button Right 1') {
        print("CCCCCCCC  22222222222");
        handleScannerInput(textEditingController.text);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestFocusScanner();
    });

    RawKeyboard.instance.addListener(_handleScannerInput);

    textEditingController.addListener(() {
      print("BBBBBBBB 11111111");
      if (textEditingController.text.isNotEmpty) {
        print("BBBBBBBB 22222222");
        handleScannerInput(textEditingController.text);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    textFieldFocus.dispose();
    RawKeyboard.instance.removeListener(_handleScannerInput);
  }
}
