// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

export const environment = {
  production: false,
  api: 'http://localhost:5000/moodapp/api',
  firebaseConfig: {
    apiKey: "AIzaSyC1Y5nji7Btnhsx2l-4YoBB0JxeCum-nYQ",
    authDomain: "moodevaluationapp.firebaseapp.com",
    projectId: "moodevaluationapp",
    storageBucket: "moodevaluationapp.appspot.com",
    messagingSenderId: "514512654865",
    appId: "1:514512654865:web:adb00360a38a24fdd257b0",
    measurementId: "G-HDG9955NB6"
  }
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
