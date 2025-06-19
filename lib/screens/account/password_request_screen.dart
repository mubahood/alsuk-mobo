import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../../models/RespondModel.dart';
import '../../theme/custom_theme.dart';

class PasswordRequestScreen extends StatefulWidget {
  const PasswordRequestScreen({Key? key}) : super(key: key);

  @override
  PasswordRequestScreenState createState() => PasswordRequestScreenState();
}

class PasswordRequestScreenState extends State<PasswordRequestScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  String? email_address = "";

  Future<void> submit_form() async {
    //LoggedInUserModel.fromJson("{id: 2206, username: muhsin, name: Muhsin  Mutagubya, avatar: images/a027e8675a269daa7eb85dee0cabd9f5.png, created_at: 2022-09-16T17:17:27.000000Z, updated_at: 2023-01-12T06:55:05.000000Z, enterprise_id: 7, first_name: Muhsin, last_name: Mutagubya, date_of_birth: 1992-02-12, place_of_birth: Old Kampala, sex: Male, home_address: Masaka, current_address: Kira, phone_number_1: +256700869880, phone_number_2: , email: muhsinmutagubya@gmail.com, nationality: Ugandan, religion: Islam, spouse_name: Shariffa Muhsin, spouse_phone: 0770479228, father_name: Sheikh Muhammad Mutagubya, father_phone: 0702811466, mother_name: Fatumah Nalubanga, mother_phone: 0702684117, languages: Arabic, English, Luganda, emergency_person_name: Dr. Ashraf Mutagubya, emergency_person_phone: +256705719772, national_id_number: CM9202410117LA, passport_number: A00348931, tin: null, nssf_number: null, bank_name: Equity Bank, bank_account_number: 1027101079959, primary_school_name: Kabowa Hidayat, primary_school_year_graduated: 2009, degree_university_year_graduated: 2020, masters_university_name: null, masters_university_year_graduated: null, phd_university_name: null, phd_university_year_graduated: null, user_type: employee, demo_id: 0, user_id: null, user_batch_importer_id: 0, school_pay_account_id: null, school_pay_payment_code: null, given_name: null, residential_type: Day, transportation: 25, swimming: No, outstanding: null, guardian_relation: null, referral: null, previous_school: null, deleted_at: null, marital_status: null, verification: 0, current_class_id: 0, current_theology_class_id: 0, status: 2, token: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3NjaG9vbGR5bmFtaWNzLnVnL2FwaS91c2Vycy9sb2dpbiIsImlhdCI6MTY3NTUwNDg3OCwiZXhwIjoxNjc1NTA4NDc4LCJuYmYiOjE2NzU1MDQ4NzgsImp0aSI6InRLOVRKaUkwM2lkbHdqTmYiLCJzdWIiOiIyMjA2IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.LH5safY3WweC-tdhvA4zbqTWi-UfrvdsVOMKkfBKWPo}");

    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please fix errors in the form.", color: Colors.red);
      return;
    }

    Map<String, dynamic> formDataMap = {};
    email_address = _formKey.currentState?.fields['username']?.value;
    formDataMap = {
      'username': _formKey.currentState?.fields['username']?.value,
      'email': _formKey.currentState?.fields['username']?.value,
      'task': 'request_password_reset',
    };

    is_loading = true;
    error_message = "";
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('users/login', formDataMap));
    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      return;
    }
    setState(() {
      is_loading = false;
    });
    code_is_sent = true;
    Utils.toast("Code sent to your email successfully!");
    setState(() {});
    return;
  }

  Future<void> reset_password() async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please fix errors in the form.", color: Colors.red);
      return;
    }

    if (passsword_1 != passsword_2) {
      Utils.toast("Passwords do not match.", color: Colors.red);
      return;
    }

    if (code.isEmpty) {
      Utils.toast("Please enter the code sent to your email.",
          color: Colors.red);
      return;
    }

    Map<String, dynamic> formDataMap = {};
    formDataMap = {
      'email': email_address,
      'username': email_address,
      'code': code,
      'password': passsword_1,
      'task': 'reset_password',
    };

    is_loading = true;
    error_message = "";
    password_reset_success = false;
    setState(() {});
    RespondModel resp =
        RespondModel(await Utils.http_post('users/login', formDataMap));
    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      return;
    }
    password_reset_success = true;
    setState(() {
      is_loading = false;
    });
    Utils.toast("Password reset successfully!");
    setState(() {});
    return;
  }

  bool password_reset_success = false;
  String error_message = "";
  String code = "";
  String passsword_1 = "";
  String passsword_2 = "";
  bool is_loading = false;
  bool code_is_sent = false;

  @override
  void initState() {
    Utils.init_theme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: ListView(
        children: [
          FxContainer(
              borderRadiusAll: 0,
              marginAll: 0,
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 50, bottom: 10),
              color: Colors.white,
              child: FormBuilder(
                  key: _formKey,
                  child: password_reset_success
                      ? Column(
                          children: [
                            Container(
                              height: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image(
                              width: MediaQuery.of(context).size.width / 3,
                              fit: BoxFit.cover,
                              image: AssetImage(AppConfig.logo1),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FxText.headlineMedium(
                              "Password Reset Successful!",
                              fontWeight: 900,
                              textAlign: TextAlign.center,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: CustomTheme.primary,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FxText.bodyLarge(
                              "Your password has been reset successfully. You can now login with your new password.",
                              fontWeight: 400,
                              textAlign: TextAlign.start,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: CustomTheme.primary,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CupertinoButton(
                              color: CustomTheme.primary,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              padding: FxSpacing.xy(32, 15),
                              pressedOpacity: 0.5,
                              child: FxText.titleLarge(
                                "LOGIN",
                                color: Colors.white,
                                fontWeight: 900,
                              ),
                            ),
                          ],
                        )
                      : code_is_sent
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                  image: AssetImage(AppConfig.logo1),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FxText.headlineMedium(
                                  "Password reset",
                                  fontWeight: 900,
                                  color: Colors.black,
                                ),
                                /* SizedBox(
                        height: 20,
                      ),
                      FxText.titleLarge("Sign in"),*/
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(height: 25),
                                FormBuilderTextField(
                                  name: 'email_address',
                                  autofocus: false,
                                  textInputAction: TextInputAction.next,
                                  initialValue: email_address,
                                  onChanged: (value) {
                                    setState(() {
                                      email_address = value.toString();
                                    });
                                  },
                                  readOnly: email_address!.isNotEmpty,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Email address is required.",
                                    ),
                                  ]),
                                  decoration: const InputDecoration(
                                    enabledBorder:
                                        CustomTheme.input_outline_border,
                                    border: CustomTheme
                                        .input_outline_focused_border,
                                    labelText: "Enter your email address",
                                  ),
                                ),
                                Container(height: 25),
                                FormBuilderTextField(
                                  name: 'code',
                                  autofocus: false,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    setState(() {
                                      code = value.toString();
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText:
                                          "Enter the code sent to your email.",
                                    ),
                                  ]),
                                  decoration: const InputDecoration(
                                    enabledBorder:
                                        CustomTheme.input_outline_border,
                                    border: CustomTheme
                                        .input_outline_focused_border,
                                    labelText: "Enter CODE sent to your email",
                                  ),
                                ),
                                Container(height: 15),
                                FormBuilderTextField(
                                  name: 'password_1',
                                  autofocus: false,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    setState(() {
                                      passsword_1 = value.toString();
                                    });
                                  },
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Password is required.",
                                    ),
                                  ]),
                                  decoration: const InputDecoration(
                                    enabledBorder:
                                        CustomTheme.input_outline_border,
                                    border: CustomTheme
                                        .input_outline_focused_border,
                                    labelText: "Enter your new password",
                                  ),
                                ),
                                Container(height: 15),
                                FormBuilderTextField(
                                  name: 'password_2',
                                  autofocus: false,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (value) {
                                    setState(() {
                                      passsword_2 = value.toString();
                                    });
                                  },
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Password 2 is required.",
                                    ),
                                  ]),
                                  decoration: const InputDecoration(
                                    enabledBorder:
                                        CustomTheme.input_outline_border,
                                    border: CustomTheme
                                        .input_outline_focused_border,
                                    labelText: "Re-enter your new password",
                                  ),
                                ),
                                error_message.isEmpty
                                    ? const SizedBox()
                                    : FxContainer(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        color: Colors.red.shade800,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(error_message,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                  ),
                                  child: is_loading
                                      ? Center(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            padding: const EdgeInsets.all(15),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                          ),
                                        )
                                      : CupertinoButton(
                                          color: CustomTheme.primary,
                                          onPressed: () {
                                            reset_password();
                                          },
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          padding: FxSpacing.xy(32, 15),
                                          pressedOpacity: 0.5,
                                          child: FxText.titleLarge(
                                            "RESET PASSWORD",
                                            color: Colors.white,
                                            fontWeight: 900,
                                          )),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Don't have code?",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 14),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor:
                                                Colors.transparent),
                                        child: const Text(
                                          "Request Code",
                                          style: TextStyle(
                                              color: CustomTheme.primary,
                                              fontSize: 14),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            error_message = "";
                                            code_is_sent = false;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(height: 5),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Image(
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                  image: AssetImage(AppConfig.logo1),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FxText.headlineMedium(
                                  "Password reset",
                                  fontWeight: 900,
                                  color: Colors.black,
                                ),
                                /* SizedBox(
                        height: 20,
                      ),
                      FxText.titleLarge("Sign in"),*/
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(height: 25),
                                FormBuilderTextField(
                                  name: 'username',
                                  autofocus: false,
/*                        initialValue: 'mubs0x@gmail.com',*/
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "This field is required.",
                                    ),
                                  ]),
                                  decoration: const InputDecoration(
                                    enabledBorder:
                                        CustomTheme.input_outline_border,
                                    border: CustomTheme
                                        .input_outline_focused_border,
                                    labelText: "Enter your email address",
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Already have code?",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 14),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor:
                                                Colors.transparent),
                                        child: const Text(
                                          "Enter Code",
                                          style: TextStyle(
                                              color: CustomTheme.primary,
                                              fontSize: 14),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            code_is_sent = true;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                error_message.isEmpty
                                    ? const SizedBox()
                                    : FxContainer(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        color: Colors.red.shade50,
                                        child: Text(
                                          error_message,
                                        ),
                                      ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                  ),
                                  child: is_loading
                                      ? Center(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            padding: const EdgeInsets.all(15),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                          ),
                                        )
                                      : CupertinoButton(
                                          color: CustomTheme.primary,
                                          onPressed: () {
                                            submit_form();
                                          },
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          padding: FxSpacing.xy(32, 15),
                                          pressedOpacity: 0.5,
                                          child: FxText.titleLarge(
                                            "REQUEST CODE",
                                            color: Colors.white,
                                            fontWeight: 900,
                                          )),
                                ),
                                Container(height: 5),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ))),
          const SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }
}
