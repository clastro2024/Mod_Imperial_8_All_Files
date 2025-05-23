// const electron = require("electron");
// // const path = require("path");
// const BrowserWindow = electron.remote.BrowserWindow;

// Initialize Lucide icons
lucide.createIcons();

// Navigation
const pages = {
  home: {
    link: document.getElementById("home-link"),
    page: document.getElementById("dashboard-page"),
  },
  settings: {
    link: document.getElementById("settings-link"),
    page: document.getElementById("settings-page"),
  },
  multiplayer: {
    link: document.getElementById("multiplayer-link"),
    page: document.getElementById("multiplayer-page"),
  },
  install: {
    link: document.getElementById("install-link"),
    page: document.getElementById("install-page"),
  },
  profile: {
    link: document.getElementById("profile-link"),
    page: document.getElementById("profile-page"),
  },
};

// Function to switch pages
function switchPage(pageId) {
  // Hide all pages
  Object.values(pages).forEach(({ link, page }) => {
    page.classList.add("hidden");
    link.classList.remove("bg-blue-600");
    link.classList.add("hover:bg-gray-700");
  });

  // Show selected page
  pages[pageId].page.classList.remove("hidden");
  pages[pageId].link.classList.add("bg-blue-600");
  pages[pageId].link.classList.remove("hover:bg-gray-700");
}

// Add click event listeners
Object.entries(pages).forEach(([pageId, { link }]) => {
  link.addEventListener("click", (e) => {
    e.preventDefault();
    switchPage(pageId);
  });
});
