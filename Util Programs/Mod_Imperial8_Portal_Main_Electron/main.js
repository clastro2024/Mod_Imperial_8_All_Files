const { app, BrowserWindow, ipcMain } = require("electron/main");
const path = require("path");

const createWindow = () => {
  ipcMain.handle("openGBS", (event) => {
    const winGBS = new BrowserWindow({
      width: 1500,
      height: 1000,
      webPreferences: {
        nodeIntegration: true,
        enableRemoteModule: false,
        preload: path.join(__dirname, "./preload.js"),
      },
    });

    winGBS.loadFile("./GUI/Settings/SetGameBackground.html");
  });

  const winMain = new BrowserWindow({
    width: 1500,
    height: 1000,
    webPreferences: {
      nodeIntegration: true,
      enableRemoteModule: false,
      preload: path.join(__dirname, "./preload.js"),
    },
  });

  winMain.loadFile("./GUI/main.html");
};

app.whenReady().then(() => {
  createWindow();

  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") app.quit();
});
