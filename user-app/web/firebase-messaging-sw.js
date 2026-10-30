importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
apiKey: "AIzaSyAwXOAJHiHBy6tJxMwnbXN_8Z8Mhedf2tg",
  authDomain: "nylopay-fb5d8.firebaseapp.com",
  projectId: "nylopay-fb5d8",
  storageBucket: "nylopay-fb5d8.firebasestorage.app",
  messagingSenderId: "844198651339",
  appId: "1:844198651339:web:ba4d8e8737d4d73a95c24e"
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});