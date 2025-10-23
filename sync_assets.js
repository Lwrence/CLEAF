const fs = require("fs");
const path = require("path");
const chokidar = require("chokidar");

const source = path.join(__dirname, "indoorplants.json");
// assets folder outside cleaf_backend
const dest = path.join(__dirname, "assets", "indoorplants.json");

// Function to copy JSON file to Flutter's assets folder
function copyToAssets() {
  fs.copyFile(source, dest, (err) => {
    if (err) {
      console.error("❌ Error syncing JSON to assets:", err);
    } else {
      console.log("✅ JSON synced to Flutter assets!");
    }
  });
}

// Watch for changes in the main JSON file
chokidar.watch(source).on("change", () => {
  console.log("📁 Detected JSON change, syncing to assets...");
  copyToAssets();
});

console.log("👀 Watching for JSON changes to sync with Flutter assets...");
