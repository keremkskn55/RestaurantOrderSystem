import 'package:flutter/material.dart';
import 'package:restaurant_order_system/widgets/common_components/text_field_component.dart';
import 'package:restaurant_order_system/widgets/create_account_view_components/create_account_view_continue_button.dart';
import 'package:restaurant_order_system/widgets/create_account_view_components/create_account_view_top_texts.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  _CreateAccountViewState createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  /// Controller
  GlobalKey<FormState> _createAccountKey = GlobalKey<FormState>();

  /// Icons
  Icon emailPrefixIcon = const Icon(
    Icons.email,
    color: Colors.black,
  );
  Icon passwordPrefixIcon = const Icon(
    Icons.lock,
    color: Colors.black,
  );

  /// Text Editing Controller
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController passwordAgainCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black.withOpacity(0.25),
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _createAccountKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Spacer
              Spacer(flex: 1),

              /// Create Account Top Components
              CreateAccountViewTopTexts(),

              /// Spacer
              Spacer(flex: 1),

              /// Email Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFieldComponent(
                  sentPrefixIcon: emailPrefixIcon,
                  sentHintText: 'E-mail',
                  ctr: emailCtr,
                ),
              ),

              /// SizedBox
              SizedBox(height: 10),

              /// Password Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFieldComponent(
                  sentPrefixIcon: passwordPrefixIcon,
                  sentHintText: 'Password',
                  ctr: passwordCtr,
                ),
              ),

              /// SizedBox
              SizedBox(height: 10),

              /// Password Again Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFieldComponent(
                  sentPrefixIcon: passwordPrefixIcon,
                  sentHintText: 'Password Again',
                  ctr: passwordAgainCtr,
                ),
              ),

              /// Continue Create Account Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                    right: 16,
                  ),
                  child: CreateAccountViewContinueButton(
                    emailStr: emailCtr.text,
                    passwordStr: passwordCtr.text,
                    passwordAgainStr: passwordAgainCtr.text,
                    createAccountKey: _createAccountKey,
                    callbackCheckPassword: showErrorDialog,
                  ),
                ),
              ),

              /// Spacer
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showErrorDialog(String title, String detail) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(detail),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
