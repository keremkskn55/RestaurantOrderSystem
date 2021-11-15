import 'package:flutter/material.dart';
import 'package:restaurant_order_system/widgets/common_components/text_field_component.dart';
import 'package:restaurant_order_system/widgets/sign_in_view_components/sign_in_view_create_account_button.dart';
import 'package:restaurant_order_system/widgets/sign_in_view_components/sign_in_view_sign_in_button.dart';
import 'package:restaurant_order_system/widgets/sign_in_view_components/sign_in_view_top_texts.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  GlobalKey emailPasswordKey = GlobalKey<FormState>();

  Icon emailPrefixIcon = const Icon(
    Icons.email,
    color: Colors.black,
  );
  Icon passwordPrefixIcon = const Icon(
    Icons.lock,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          key: emailPasswordKey,
          child: Column(
            children: [
              /// Spacer
              const Spacer(flex: 1),

              /// Texts on the top
              const SignInViewTopComponents(),

              /// Spacer
              const Spacer(flex: 1),

              ///Username Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFieldComponent(
                  sentPrefixIcon: emailPrefixIcon,
                  sentHintText: 'E-mail',
                ),
              ),

              /// SizedBox for space
              SizedBox(height: 10),

              /// Password Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFieldComponent(
                  sentPrefixIcon: passwordPrefixIcon,
                  sentHintText: 'Password',
                ),
              ),

              ///Sign In Button
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 16),
                  child: SignInViewSignInButton(),
                ),
              ),

              /// SizedBox
              const SizedBox(
                height: 40,
              ),

              ///Create Button
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SignInViewCreateAccountButton(),
                ),
              ),

              /// Spacer
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
