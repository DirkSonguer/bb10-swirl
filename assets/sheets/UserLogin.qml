// *************************************************** //
// User Login Sheet
//
// The user login sheet uses a webview to show the login
// process of Foursquare.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../global/foursquarekeys.js" as FoursquareKeys
import "../classes/authenticationhandler.js" as Authentication
import "../classes/loginuihandler.js" as LoginUIHandler

Page {
    id: userLoginSheet

    // property flag to check if authentication process has been done
    property bool authenticationDone: false

    Container {
        // layout orientation
        layout: DockLayout {
        }

        // scroll view as the Foursquare login pages
        // do not fit on the Q10 / Q5 screen
        ScrollView {
            // only vertical scrolling is needed
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // web view
            // browser window showing the Foursquare authentication process
            WebView {
                id: loginFoursquareWebView

                // url is the entry point for the Foursquare login process
                // has to be called with the public Foursquare app key and a valid callback URL
                // requested rights are likes, comments, relationships
                url: FoursquareKeys.foursquarekeys.foursquareAuthorizeUrl + "/?client_id=" + FoursquareKeys.foursquarekeys.foursquareClientId + "&redirect_uri=" + FoursquareKeys.foursquarekeys.foursquareRedirectUrl + "&response_type=token"

                // layout definition
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                // set initial visibility to false
                visible: false

                onLoadProgressChanged: {
                    if ((loadProgress < 100) && (! loadingIndicator.loaderActive)) {
                        // console.log("# Loading process started");
                        loginFoursquareWebView.visible = false
                        loadingIndicator.showLoader("Loading login process");
                    }
                }

                // if loading state has changed, check for current state
                // if web view is loading, show activity indicator
                onLoadingChanged: {
                    if (loadRequest.status == WebLoadStatus.Succeeded) {
                        // console.log("# Loading process done");
                        loadingIndicator.hideLoader();
                        if (! authenticationDone) {
                            loginFoursquareWebView.visible = true
                        }
                    }
                }

                // check on every page load if the oauth token is in it
                onUrlChanged: {
                    console.log("# Authentication URL changed: " + url);
                    var foursquareResponse = new Array();
                    foursquareResponse = Authentication.auth.checkFoursquareAuthenticationUrl(url);

                    // show the error message if the Foursquare authentication was not successfull
                    if (foursquareResponse["status"] === "AUTH_ERROR") {
                        console.log("# Authentication failed: " + foursquareResponse["status"]);

                        loginFoursquareWebView.visible = false
                        var errorMessage = loginErrorText.text += "Foursquare says: " + foursquareResponse["error_description"] + "(" + foursquareResponse["status"] + ")";
                        infoMessage.showMessage(errorMessage, Copytext.insagoLoginErrorTitle);
                        authenticationDone = false;
                    }

                    // show the success message if the Foursquare authentication was ok
                    if (foursquareResponse["status"] === "AUTH_SUCCESS") {
                        console.log("# Authentication successful: " + foursquareResponse["status"]);

                        // show confirmation
                        loginFoursquareWebView.visible = false
                        loadingIndicator.hideLoader();
                        infoMessage.showMessage(Copytext.instagoLoginSuccessMessage, Copytext.instagoLoginSuccessTitle);
                        authenticationDone = true;

                        // activate tabs that are authenticated only
                        LoginUIHandler.loginUIHandler.setLoggedInState();
                    }
                }
            }
        }

        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        InfoMessage {
            id: infoMessage
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }

    onCreationCompleted: {
        loadingIndicator.showLoader("Loading login process");
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_close.png"

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                loginSheet.close();

                if (authenticationDone) {
                    /*
                    // reload profile page to login notification
                    profileComponent.source = "../pages/UserProfile.qml"
                    var profilePage = profileComponent.createObject();
                    profileTab.setContent(profilePage);
                    */
                }
            }
        }
    ]
}