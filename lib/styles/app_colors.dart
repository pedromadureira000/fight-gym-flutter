import 'package:flutter/material.dart';

class AppColors {
  static const darktextColor = Color(0xffabb2bf); //kind of light gray-blue
  static const lightBackground = Color(0xffEEEEEE);
  static const darkBackground = Color(0xff141418);
  static const primaryColor = Color(0xff004D40);
  static const darkPrimaryColor = Color(0xff353540);
  static const darkSecondaryColor = Color(0xffd9d9d9); //almost white
  static const darkThirdColor = Color(0xff8b8b8c); // gray blue
  static const darkcontainerColor = Color(0xff2a2a30);
  static const contrastColorForDarkMode = Color(0xffb0b1b8); // light gray
  static const dialogDarkBackgroundColor = Color(0xff131318);
}


ThemeData lightTheme = ThemeData(
    fontFamily: 'Urbanist',
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryColor, // Where this shows up?
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.white)),
    useMaterial3: true,
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all<bool>(true),
    ),
    // drawerTheme: const DrawerThemeData(
        // backgroundColor: AppColors.primaryColor,
    // ),
);

ThemeData darkTheme_ = ThemeData(
    fontFamily: 'Urbanist',
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimaryColor, // Where this shows up?
    appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkPrimaryColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.darkSecondaryColor),
        titleTextStyle:  TextStyle(color: AppColors.darkSecondaryColor, fontSize: 20),
    ),
    brightness: Brightness.dark,
    textTheme: const TextTheme().copyWith(
        // headlineSmall
        titleMedium: const TextStyle(
            color: AppColors.darkSecondaryColor
        ),
        bodySmall: const TextStyle(color: AppColors.darktextColor),
        bodyMedium: const TextStyle(color: AppColors.darktextColor),
        bodyLarge: const TextStyle(color: AppColors.darktextColor),
        labelSmall: const TextStyle(color: AppColors.darktextColor),
        labelMedium: const TextStyle(color: AppColors.darktextColor),
        labelLarge: const TextStyle(color: AppColors.darktextColor),
        displaySmall: const TextStyle(color: AppColors.darktextColor),
        displayMedium: const TextStyle(color: AppColors.darktextColor),
        displayLarge: const TextStyle(color: AppColors.darktextColor),
    ),
    useMaterial3: true,
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all<bool>(true),
    ),
    // drawerTheme: const DrawerThemeData(
        // backgroundColor: AppColors.darkPrimaryColor,
    // ),
);
// NOTE: THis crazy workaround is because colorScheme change text colors previously set. And this was the way I found to set color for textField border to AppColors.darktextColor
ThemeData darkTheme = darkTheme_.copyWith(colorScheme: darkTheme_.colorScheme.copyWith(primary: AppColors.darktextColor, brightness: Brightness.dark));

// use it with "Theme.of(context).myCustomColor"
class CustomDarkThemeStyles {
    CustomDarkThemeStyles(this.brightness);
    Brightness brightness;

    Color get getPrimaryColor {
        if(brightness == Brightness.light){
            return AppColors.primaryColor;
        } else {
            return AppColors.darkPrimaryColor;
        }
    }
    Color get getSecundaryColor {
        if(brightness == Brightness.light){
            return AppColors.lightBackground;
        } else {
            return AppColors.lightBackground;
        }
    }

    Color get getContrastColor { // this should go in some places with hardcoded colors
        if(brightness == Brightness.light){
            return AppColors.primaryColor;
        } else {
            return AppColors.contrastColorForDarkMode;
        }
    }

    Color get inputDecorationFillcolor {
        if(brightness == Brightness.light){
            return Colors.white;
        } else {
            return AppColors.darkBackground;
        }
    }

  ButtonStyle get elevatedBtnStyle {
    if(brightness == Brightness.light){
        return ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.lightBackground,
        );
    } else {
        return ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkThirdColor,
            foregroundColor: AppColors.darkBackground,
        );
    }
  }

  ButtonStyle get elevatedBtnStyleCancelDeletion {
    if(brightness == Brightness.light){
        return ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            foregroundColor: Colors.white,
        );
    } else {
        return ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimaryColor,
            foregroundColor: AppColors.darkSecondaryColor,
        );
    }
  }

  ButtonStyle get googleBtnOnMobileStyle {
    if(brightness == Brightness.light){
        return ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(50),
                ),
            ),
        );
    } else {
        return ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimaryColor,
            foregroundColor: AppColors.darkSecondaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(50),
                ),
            ),
        );
    }
  }

  ButtonStyle get linkStyle  {
    if(brightness == Brightness.light){
        return TextButton.styleFrom();
    } else {
        return TextButton.styleFrom(
            foregroundColor: AppColors.contrastColorForDarkMode,
        );
    }
  }

  Color get arrowBackColor  {
    if(brightness == Brightness.light){
        return Colors.white;
    } else {
        return AppColors.darkSecondaryColor;
    }
  }

  Color get containerColor  {
    if(brightness == Brightness.light){
        return Colors.white;
    } else {
        return AppColors.darkcontainerColor;
    }
  }

  ButtonStyle get elevatedBtnStyleInsideContainer {
    if(brightness == Brightness.light){
        return ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.lightBackground,
        );
    } else {
        return ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkThirdColor,
            foregroundColor: AppColors.darkBackground,
        );
    }
  }

  Color get dialogBackgroundColor {
        if(brightness == Brightness.light){
            return Colors.white;
        } else {
            return AppColors.dialogDarkBackgroundColor; 
        }
   }
  }
