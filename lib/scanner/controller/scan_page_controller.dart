import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scanner_with_input/helpers/focus_node.dart';

class ScanPageController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  RxList<String> listData = <String>[].obs;

  void requestFocusScanner() {
    textFieldFocus.requestFocus();

    Future.delayed(Duration(microseconds: 100), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  void handleScannerInput(String scannedData) {
    if (scannedData.isNotEmpty) {
      listData.add(scannedData);
      textEditingController.clear();
    }
    requestFocusScanner(); // Ensure the focus is reset for continuous scanning
  }

  void _handleScannerInput(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final String? scannedKey = event.logicalKey.keyLabel;
      if (scannedKey == 'Game Button Right 1') {
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
      if (textEditingController.text.isNotEmpty) {
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
