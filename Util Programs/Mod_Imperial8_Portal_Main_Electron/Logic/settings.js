//const electron = require("electron");
// const path = require("path");
//const BrowserWindow = electron.remote.BrowserWindow;

const sgbButt = document.getElementById("sgbButt"); // Open Set Game Background Button
const sguibButt = document.getElementById("sguibButt"); // Open Set GUI Theme Button
const sglButt = document.getElementById("sglButt"); // Open Set Game Language Button
const sguilButt = document.getElementById("sguilButt"); // Open Set GUI Language Button
const sgvsmButt = document.getElementById("sgvsmButt"); // Open Set Game Visible Skirmish Maps Button
const sgvcomButt = document.getElementById("sgvcomButt"); // Open Set Game Visible Co-Op Maps Button
const sgvcButt = document.getElementById("sgvcButt"); // Open Set Game Visible Campaigns Button
const cameraSlider = document.getElementById("camera-distance"); // Camera distance slider
const cameraValue = document.getElementById("camera-value"); // Camera distance value

sgbButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

sguibButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

sglButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

sguilButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

sgvsmButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

sgvcomButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

sgvcButt.addEventListener("click", (e) => {
  window.ipc
    .send("openGBS", [])
    .then(function (res) {
      console.log(res);
    })
    .catch(function (err) {
      console.error(err);
    });
});

// Camera distance slider value change
cameraSlider.addEventListener("input", (e) => {
  cameraValue.textContent = "+" + e.target.value + "%";
});
