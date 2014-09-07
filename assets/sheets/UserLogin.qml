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
import bb.cascades 1.3

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../global/foursquarekeys.js" as FoursquareKeys
import "../classes/authenticationhandler.js" as Authentication

Page {
    id: userLoginSheet

    // property flag to check if authentication process has been done
    property bool authenticationDone: false

    // property that holds the ID of the tab to reload once the
    // login process is done
    property variant tabToReload

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

                // the initial url is the entry point for the Foursquare login process
                // has to be called with the public Foursquare app key and a valid callback URL
                // requested rights are likes, comments, relationships
                url: FoursquareKeys.foursquarekeys.foursquareAuthorizeUrl + "/?client_id=" + FoursquareKeys.foursquarekeys.foursquareClientId + "&redirect_uri=" + FoursquareKeys.foursquarekeys.foursquareRedirectUrl + "&response_type=token"

                // layout definition
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                // set initial visibility to false
                visible: false

                // if loading progress has changed, check to show loading indicator
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
                        infoMessage.showMessage(Copytext.swirlLoginErrorMessage, Copytext.swirlLoginErrorTitle);
                        authenticationDone = false;
                    }

                    // show the success message if the Foursquare authentication was ok
                    if (foursquareResponse["status"] === "AUTH_SUCCESS") {
                        console.log("# Authentication successful: " + foursquareResponse["status"]);

                        // show confirmation
                        loginFoursquareWebView.visible = false
                        loadingIndicator.hideLoader();
                        authenticationDone = true;

                        // close sheet and reload calling tab with new user credentialsÏ
                        userLoginSheet.tabToReload.triggered();
                        loginSheet.close();
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
}
