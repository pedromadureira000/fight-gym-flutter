import 'package:firebase_auth/firebase_auth.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginWithGoogle {
    LoginWithGoogle() : 
        googleSignIn =  kIsWeb ? GoogleSignIn(clientId: AppConfig.googleWebOAuthclientIdWeb, scopes: scopes) : GoogleSignIn() 
        {
            googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
                // if (account != null && avoidAuthenticateManyTimesOnListener == false) {
                if (account != null) {
                    GoogleSignInAuthentication authentication = await account.authentication;
                    final encodedIdToken = authentication.idToken ?? "";
                    final accessToken = authentication.accessToken ?? "";
                    AuthCredential credential = GoogleAuthProvider.credential(accessToken: accessToken, idToken: encodedIdToken);
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                    IdTokenResult tokenResult = await FirebaseAuth.instance.currentUser!.getIdTokenResult(); 
                    // var response = await httpClient.get(url,headers: {'Authorization':"Bearer ${tokenResult.token}"});
                    Map userData = {
                        "user": account,
                        // "idToken": encodedIdToken, //NOTE DON'T WORK
                        "idToken": tokenResult.token,
                        "accessToken": accessToken
                    };
                    getOrCreateAccountWithGoogle(userData);
                }
                // NOTE: I dont need authorization
                // In mobile, being authenticated means being authorized...
                // bool isAuthorized = account != null;
                // However, in the web...
                // if (kIsWeb && account != null) {
                    // isAuthorized = await googleSignIn.canAccessScopes(scopes);
                // }
                // Now that we know that the user can access the required scopes, the app
                // can call the REST API.
            });
        }

    dynamic signUpOrSignFunction;

    static List<String> scopes = <String>[
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn googleSignIn;

    handleSignIn() async {
        try {
            kIsWeb ? await _handleSignInWeb() : await _handleSignInAndroid();
        } catch (error) {
            AppConfig.logger.d('error: --> : $error');
        }
    }

    _handleSignInAndroid() async {
        // NOTE: if call googleSignIn.signIn after being logged. It don't open the popup and just brings the user
        await googleSignIn.signIn(); //Returns a Future<GoogleSignInAccount>
    }

    _handleSignInWeb() async {
        await googleSignIn.signInSilently();
    }

    callOneTapUXAndRediredAfterLogin() async {
        // 'if googleUser is not logged in, it will open OneTap UX in web if there are sessions available.'
        await _handleSignInWeb();
    }

    /// Marks current user as being in the signed out state.
    signOut() async {
        await googleSignIn.signOut();
    }

    /// Disconnects the current user from the app and revokes previous authentication
    disconnect() async {
        await googleSignIn.disconnect();
    }

    getOrCreateAccountWithGoogle(userData) async {
        signUpOrSignFunction(userData);
    }
}
