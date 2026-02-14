
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


class CustomTextFormField extends FormField<String> {
  CustomTextFormField(
      {Key? key,
        String? initialValue,
        required context,
        FormFieldSetter<String>? onSaved,
        String? Function(String? val)? validator,
        bool autoValidate=true,
        Color textColor = CustomColors.textBlack54,
        TextEditingController? controller,
        TextInputType? keyboardType,
        TextInputAction? textInputAction,
        FocusNode? focusNode,
        bool? autofocus,
        bool obscureText=false,
        bool? enabled,
        bool isPassword = false,
        bool isRequired = true,
        IconData? suffixIcon,
        IconData? prefixIcon,
        int? maxLength,
        Color color = CustomColors.borderColor,
        Color labelColor = CustomColors.textBlack54,
        required String label,
         String? hint,
        String? helperText,
        MaxLengthEnforcement? maxLengthEnforcement,
        ValueChanged<String>? onChanged,
        VoidCallback? onEditingComplete,
        ValueChanged<String>? onFieldSubmitted,
        int maxLines = 1})
      : super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (FormFieldState<String> state) {
      return Sizer(builder: (context, orientation, deviceType) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         if(label.isNotEmpty)   Text(label.capitalizeFirst!,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: CustomColors.textBlack87),),
            Padding(
              padding:  EdgeInsets.symmetric(vertical:label.isNotEmpty? 5.0:0),
              child: TextFormField(
                maxLines: maxLines,
                autovalidateMode:autoValidate!? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                textInputAction: textInputAction,
                focusNode: focusNode,
                autofocus: autofocus ?? false,
                enabled: enabled ?? true,obscureText: obscureText,
                maxLength: maxLength,
                maxLengthEnforcement:
                maxLengthEnforcement ?? MaxLengthEnforcement.enforced,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: textColor),
                decoration: InputDecoration(
                  errorStyle: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color:Colors.red),


                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: color)),helperText:helperText,contentPadding: EdgeInsets.all(5),
                   filled: true,fillColor: Colors.white,
                  // fillColor: color.withOpacity(0.3),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText:(hint??label).capitalizeFirst! ,helperStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: color)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: color)),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey[400]),
                //   label:
                //   RichText(text: TextSpan(children:
                //
                // [TextSpan(text: label.capitalizeFirst,style:Theme.of(context)
                //     .textTheme
                //     .displayMedium!
                //     .copyWith(color: labelColor) ),
                //   // if(isRequired)     TextSpan(text: " *",style:Theme.of(context)
                //   //     .textTheme
                //   //     .displayMedium!
                //   //     .copyWith(color: Colors.red) ),
                // ]
                // )),
                  suffixIcon:suffixIcon==null?null: Icon(suffixIcon,color: CustomColors.textBlack54,),
                  prefixIcon:prefixIcon==null?null:  Icon(prefixIcon,color: CustomColors.textBlack54,),
                ),
                onChanged: onChanged,
                onEditingComplete: onEditingComplete,
                onFieldSubmitted: onFieldSubmitted,
              ),
            ),
          ],
        );
      });
    },
  );
}
