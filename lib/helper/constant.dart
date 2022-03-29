
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class Constants{
//#FF507D  tshirt color main
//D5DCED secons

  Color mainColor =  Color(0xff684e88);
  Color inactiveColor =  Color(0xff1E2E46);

  Color appBarColor= const Color(0xff523374);

  Color appBackGroundColor= const Color(0xff12202C);
  Color borderColor=   Colors.grey;
  String userDetailsCollectionName = "user_details";

  Color textColor =  const Color(0xffFFFFFF);

}

const Color mainColor = Color(0xff684e88);
const Color inactiveColor =  Color(0xff1E2E46);
const Color appBarColor= const Color(0xff523374);
const Color appBackGroundColor= const Color(0xff12202C);
const Color borderColor=   Colors.grey;
const Color textColor =  const Color(0xffFFFFFF);

Widget CommonText(
    {String text,
      double fontSize = 14.00,
      Color textColor = Colors.white,

      FontWeight fontStyle = FontWeight.normal,
      bool isCenter=false, TextAlign textAlign, inputController, TextInputAction textInputAction, String labeltext}) {
  return Text(
      text,
      style: GoogleFonts.lato(
        textStyle: Theme.of(Get.context).textTheme.headline4,
        fontSize: fontSize,
        fontWeight: fontStyle,
        // fontStyle: FontStyle.italic,
        color: textColor,
      ));

  // TextStyle(fontSize: fontSize, color: textColor, fontWeight: fontStyle,fontFamily: 'Cambria'),
  /*TextStyle(fontSize: fontSize, color: textColor, fontWeight: fontStyle),*/
  // textAlign: TextAlign.center,

  // );
}


Widget CommonTextInput1(
    {String lable = "",
      bool isValidationRequired = true,
      int maxLength,
      int minLength,
      int length,
      hint = "",
      labeltext = "Enter Value",
      FontWeight lableFontStyle,
      double lableFontSize,
      lableTextColor,
      width=0.0,
      TextEditingController inputController,
      TextInputType textInputType = TextInputType.text,
      String regexp,
      errortext,
      bool isRequired = false,
      bool isReadOnly = false,
      int  minLines =1,
      int maxLines =50,
      crossAxisAlignment = CrossAxisAlignment.start,
      Function onChanged ,
      TextInputAction textInputAction = TextInputAction.done}) {


  return Container(
    width: width,
    decoration: const BoxDecoration(

      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    ),
    child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLines),// for mobile
        ],
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: textInputAction,
        readOnly: isReadOnly,
        keyboardType: textInputType,
        controller: inputController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                  width: 1, color: Colors.white),
            ),
            fillColor: Colors.white,
            focusColor: Colors.white,
            border: OutlineInputBorder(),
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.white
            )

          /* prefixIcon: Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.otp)),*/
        ),
        validator: (value) {
          if (value.toString().isEmpty) {
            if (isValidationRequired) {
              return 'Field required';
            } else if (value.toString().isNotEmpty && isRequired) {
              if (RegExp(regexp).hasMatch(value.toString())) {
                return null;
              } else {
                return errortext;
              }
            } else {
              return null;
            }
          }
          return null;
        },
        onChanged: onChanged

    ),
  );
}

Widget CommonButton({
  Function onPressed,
  BuildContext context,
  String buttonText="My Button",
  Color buttonTextColor,
  Color buttonColor,
  Color shdowColor,
  FontWeight buttonTextStyle,
  double buttonTextSize = 14.00,
  double vPadding=25,
  double hPadding=130,
  Icon buttonIcon,
}) {
  return InkWell(
    onTap: (){
      onPressed();
    },
    child: Container(
      height: 60,
      width: 300,
      decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              child: Text(
                buttonText,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );;

}

commonSnackBar(String title,message){

  Get.snackbar(title, message,backgroundColor: inactiveColor,colorText: Colors.white);

}