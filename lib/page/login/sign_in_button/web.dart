import 'package:flutter/material.dart';
// import 'package:fight_gym/components/googlepluginiguess.dart';
// import 'package:google_sign_in_web/web_only.dart' as web;
// import 'stub.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/web_only.dart';


/// Renders a web-only SIGN IN button.
Widget buildSignInButton({loginWithGoogle, brightness}) {
    GSIButtonConfiguration gsiBtnConfig;
    if (brightness == Brightness.light){
        gsiBtnConfig = GSIButtonConfiguration(shape: web.GSIButtonShape.pill, minimumWidth: 400, text: GSIButtonText.continueWith);
    }
    else {
        gsiBtnConfig = GSIButtonConfiguration(theme: web.GSIButtonTheme.filledBlack, shape: web.GSIButtonShape.pill, minimumWidth: 400, text: GSIButtonText.continueWith);
    }
    return (GoogleSignInPlatform.instance as web.GoogleSignInPlugin).renderButton(configuration: gsiBtnConfig);
    // return Text('adsfsafd');

    // return FutureBuilder(
        // future: plugin.initWithParams(SignInInitParameters(
            // clientId: AppConfig.googleWebOAuthclientIdWeb,
        // )),
        // builder: (context, snapshot) {
            // if (snapshot.connectionState ==
                  // ConnectionState.waiting) {
                // return const SizedBox(
                    // height: 20,
                    // width: 20,
                    // child:
                        // CircularProgressIndicator());
            // }
            // return plugin.renderButton(configuration: gsiBtnConfig);
        // }
    // );
}
