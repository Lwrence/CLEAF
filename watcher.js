const fs = require("fs");
const chokidar = require("chokidar");
const { MongoClient } = require("mongodb");

const uri = "mongodb+srv://qlmalaga:malaga10@cluster0.xj4okof.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
const client = new MongoClient(uri);

const dbName = "cleaf";
const collectionName = "indoorplants";
const jsonFile = "./indoorplants.json"; // same folder

async function updateMongoFromJSON() {
  try {
    console.log("🔄 Detected change in JSON file...");

    // read JSON
    const data = JSON.parse(fs.readFileSync(jsonFile, "utf8"));

    // ensure client connected only once
    if (!client.topology?.isConnected()) {
      await client.connect();
      console.log("🌿 Connected to MongoDB...");
    }

    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    // clear & insert
    await collection.deleteMany({});
    const result = await collection.insertMany(data);

    console.log(`✅ MongoDB updated! Inserted ${result.insertedCount} documents.`);
  } catch (err) {
    console.error("❌ Error updating MongoDB:", err);
  }
}

// Watch file continuously
chokidar.watch(jsonFile).on("change", async () => {
  console.log("📁 File changed:", jsonFile);
  await updateMongoFromJSON();
});

console.log("👀 Watching for JSON changes...");
