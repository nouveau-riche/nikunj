import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:adventurous_learner_app/utils/extensions.dart';
import 'package:adventurous_learner_app/generated/assets.dart';
import 'package:adventurous_learner_app/utils/const_color.dart';
import 'package:adventurous_learner_app/utils/constants.dart';
import 'package:adventurous_learner_app/data/controllers/auth/reset_password_controller.dart';

class ConfirmPasswordPasswordFieldWidget extends StatelessWidget {
  const ConfirmPasswordPasswordFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(ResetPasswordController());

    return GetBuilder<ResetPasswordController>(
      builder: (_) {
        return TextFormField(
          cursorColor: greenColor2,
          obscureText: ctr.isPasswordVisible,
          decoration: InputDecoration(
            hintText: constCtr.strings.confirmNewPassword,
            hintStyle: const TextStyle(
              color: kHintTextColor,
              fontWeight: FontWeight.w500,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greenColor2),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                ctr.changePasswordVisibility.call();
              },
              splashColor: Colors.transparent,
              icon: Icon(
                ctr.isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: kTextFieldIconColor,
                size: 20,
              ),
            ),
            icon: Image.asset(
              Assets.iconsPassword,
              color: kTextFieldIconColor,
              height: 20,
              width: 20,
            ),
          ),
          validator: (value) {
            if ((value).isNullOrEmpty) {
              return 'Enter password';
            }
            if ((value ?? '').length < 6) {
              return 'Password should be of atleast 6 characters';
            }
          },
          onSaved: (value) {
            ctr.confirmNewPassword = value ?? '';
          },
        );
      },
    );
  }
}
