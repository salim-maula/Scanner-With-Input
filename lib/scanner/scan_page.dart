import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_with_input/scanner/controller/scan_page_controller.dart';

class ScanPage extends StatelessWidget {
  final ScanPageController controller = Get.put(ScanPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Scan")),
      body: Column(
        children: [
          // Hidden TextFormField to handle the input
          Offstage(
            offstage: false,
            child: TextFormField(
              focusNode: controller.textFieldFocus,
              controller: controller.textEditingController,
              autofocus: true,
              onChanged: (content) {
                if (content.isNotEmpty) {
                  print("AAAAAAA");
                  controller.handleScannerInput(content);
                  controller.requestFocusScanner();
                }
              },
            ),
          ),
          Obx(() {
            return controller.listData.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: controller.listData.length,
                      itemBuilder: (context, index) {
                        return Text(controller.listData[index]);
                      },
                    ),
                  )
                : Center(child: Text("Don't have data"));
          }),
        ],
      ),
    );
  }
}
