const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("ipc", {
  send: (channel, data) => {
    return ipcRenderer.invoke(channel, data);
  },
});
