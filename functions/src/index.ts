import * as admin from "firebase-admin";
import axios from "axios";
import * as functions from "firebase-functions";
// import {serviceAccount} from "./confic/firebase";

admin.initializeApp({
  credential: admin.credential.cert({
    privateKey: functions.config().private.key.replace(/\\n/g, "\n"),
    projectId: functions.config().project.id,
    clientEmail: functions.config().client.email,
  }),
  databaseURL: "https://watalygold-default-rtdb.firebaseio.com/",
});
const apiUrl = "https://dataapi.moc.go.th/gis-product-prices?product_id=W14024&from_date=2018-01-01&to_date=2025-02-28";
axios.get(apiUrl)
  .then((response) => {
    const data = response.data;
    const db = admin.firestore();
    const docRef = db.collection("ExportPrice").doc("new_ExportPrice");
    docRef.set(data)
      .then(() => {
        console.log("Successfully saved data to Firebase.");
      })
      .catch((error) => {
        console.error("An error occurred while saving data.:", error);
      });
  })
  .catch((error) => {
    console.error("Err API:", error);
  });