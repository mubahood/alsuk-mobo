import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../theme/custom_theme.dart';

class UnverifiedAccountPopup extends StatefulWidget {
  String email;
  Function() onVerify;

  UnverifiedAccountPopup(this.email, this.onVerify, {super.key});

  @override
  State<UnverifiedAccountPopup> createState() => _UnverifiedAccountPopupState();
}

class _UnverifiedAccountPopupState extends State<UnverifiedAccountPopup> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 45,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FxText.titleLarge(
                  "Unverified Account",
                  color: Colors.black,
                  fontWeight: 900,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FxText.bodyLarge(
                  "You have not verified your account (${widget.email}). Please verify your account to continue using our services."),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(),
              const SizedBox(
                height: 25,
              ),
              FxButton.block(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onVerify();
                },
                backgroundColor: CustomTheme.primary,
                borderRadiusAll: 10,
                padding: EdgeInsets.all(20),
                child: FxText.titleLarge(
                  "Verify Account",
                  color: Colors.white,
                  fontWeight: 900,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: FxButton.text(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.transparent,
                  borderRadiusAll: 10,
                  padding: EdgeInsets.all(10),
                  child: FxText.titleLarge(
                    "Verify Later",
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
