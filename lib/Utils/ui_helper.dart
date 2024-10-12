//size
import 'package:flutter/material.dart';

//Colors

const Color redColor = Colors.red;
const Color greenColor = Colors.green;
const Color blueColor = Colors.blue;
const Color yellowColor = Colors.yellow;
const Color blackColor = Colors.black;
const Color blacklight = Colors.black12;
const Color whiteColor = Colors.white;
const Color greyColor = Colors.grey;

const Color softBlue = Color.fromARGB(255, 96, 165, 245); // Soft blue
const Color lightGreen = Color.fromRGBO(144, 238, 144, 1); // Light green
const Color pastelPink = Color.fromARGB(255, 255, 182, 193); // Pastel pink
const Color lavender = Color.fromARGB(255, 230, 230, 250); // Light lavender
const Color coral = Color.fromARGB(255, 255, 127, 80); // Coral
const Color mint = Color.fromARGB(255, 189, 252, 201); // Mint green

const Color softGrey = Color.fromARGB(255, 211, 211, 211); // Light grey
const Color ashGrey = Color.fromARGB(255, 178, 190, 181); // Ash grey

//Size
const double ksize1 = 1;
const double ksize2 = 2;
const double ksize4 = 4;
const double ksize6 = 6;
const double ksize8 = 8;
const double ksize10 = 10;
const double ksize12 = 12;
const double ksize14 = 14;
const double ksize16 = 16;
const double ksize18 = 18;
const double ksize20 = 20;
const double ksize22 = 22;
const double ksize24 = 24;
const double ksize26 = 26;
const double ksize28 = 28;
const double ksize30 = 30;
const double ksize32 = 32;
const double ksize34 = 34;
const double ksize36 = 36;
const double ksize38 = 38;
const double ksize40 = 40;
const double ksize42 = 42;
const double ksize44 = 44;
const double ksize46 = 46;
const double ksize48 = 48;
const double ksize50 = 50;
const double ksize52 = 52;
const double ksize54 = 54;
const double ksize56 = 56;
const double ksize58 = 58;
const double ksize60 = 60;

//Border Radius

const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(8.0));
const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(16.0));
const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(24.0));

//heightBox
heightBox(double size) {
  return SizedBox(
    height: size,
  );
}

final height10 = heightBox(ksize10);

widthBox(double size) {
  return SizedBox(
    width: size,
  );
}

// custom appBar

// PreferredSize generateAppBar(BuildContext context, Size size, String heading,
//     {Function()? onTapIcon,
//     IconData icon = Icons.arrow_back,
//     bool showLeadingIcon = false}) {
//   return PreferredSize(
//     preferredSize: size,
//     child: Container(
//       padding:
//           const EdgeInsets.symmetric(horizontal: ksize20, vertical: ksize10),
//       child: Row(
//         children: [
//           if (showLeadingIcon) // Conditional check for leading icon
//             GestureDetector(
//               onTap: onTapIcon ??
//                   () => Navigator.pop(
//                       context), // If no onTap provided, go back by default
//               child: Icon(
//                 icon,
//                 size: ksize24, // Increased the size to match appBar standards
//                 color: blackColor, // Set default color
//               ),
//             ),
//           if (showLeadingIcon)
//             widthBox(ksize20), // Adds spacing only if leading icon is shown
//           Expanded(
//             // Ensures heading takes up available space properly
//             child: Text(
//               heading,
//               style: kTextStyle(ksize24, blackColor,
//                   true), // Updated style to bold by default
//               textAlign: showLeadingIcon
//                   ? TextAlign.left
//                   : TextAlign
//                       .center, // Aligns text based on the presence of icon
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

final width10 = widthBox(ksize10);
//TextStyle

TextStyle kTextStyle(double size, Color color, bool isBold,
    {bool underline = false,
    double letterSpacing = 1.5,
    double wordSpacing = 2.0,
    bool isUnderline = false,
    Color underLineColor = Colors.red,
    bool changeFont = false}) {
  return TextStyle(
    fontSize: size,
    fontWeight: isBold ? FontWeight.bold : null,
    color: color,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    // fontFamily: changeFont ? 'PatrickHand' : 'Coming-Soon',
    decoration: isUnderline
        ? TextDecoration.combine([
            TextDecoration.underline,
          ])
        : null,
    decorationColor: isUnderline ? underLineColor : null,
  );
}

kCustomBoxDecoration(Color backgroundColor, Color shadowColor) {
  return BoxDecoration(color: backgroundColor, boxShadow: [
    BoxShadow(
      color: shadowColor,
    )
  ]);
}

buttonDecoration() {
  return Container(
      // decoration: ,
      );
}
