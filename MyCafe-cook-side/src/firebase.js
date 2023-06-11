// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import firebase from 'firebase/compat/app';
import 'firebase/compat/database';
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: process.env.APIKEY,
  authDomain: "mycafe-57792.firebaseapp.com",
  databaseURL: "https://mycafe-57792-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "mycafe-57792",
  storageBucket: "mycafe-57792.appspot.com",
  messagingSenderId: "1027884904387",
  appId: "1:1027884904387:web:abe46b6dac5d5253ead776"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
export default firebase;