// src/model/index.js
import "dotenv/config";
import { fileURLToPath, pathToFileURL } from "url";
import { dirname, join } from "path"; 
import { readdirSync } from "fs";
import { Sequelize } from "sequelize";

// ESM __dirname equivalent
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 5432,
    dialect: "postgres",
    logging: false,
  }
);

// Main db object
const db = {
  sequelize,
  Sequelize,
};

/**
 * Recursively load all files ending with .model.js
 */
const loadModelsRecursively = async (dir) => {
  const entries = readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = join(dir, entry.name);

    if (entry.isDirectory()) {
      // Recurse into subdirectories
      await loadModelsRecursively(fullPath);
      continue;
    }

    // Only load files ending with .model.js
    if (!entry.name.endsWith(".model.js")) continue;

    try {
      // Convert absolute path to a file:// URL for ESM import compatibility
      const fileUrl = pathToFileURL(fullPath).href;
      const module = await import(fileUrl);

      if (!module.default || typeof module.default !== "function") {
        console.warn(`⚠️  Skipping ${entry.name}: default export is not a function`);
        continue;
      }

      const modelFactory = module.default;
      const model = modelFactory(sequelize, Sequelize.DataTypes);

      // Register the model on the db object using the name defined in sequelize.define
      db[model.name] = model;

    } catch (err) {
      console.error(`❌ Failed to load model ${entry.name}:`, err.message);
    }
  }
};

/**
 * Load all models and setup associations
 */
db.loadModels = async () => {
  // Start recursion from the current directory (src/model)
  await loadModelsRecursively(__dirname);

  // Setup associations after all models are loaded into the registry
  Object.values(sequelize.models).forEach((model) => {
    if (model.associate) {
      model.associate(sequelize.models);
    }
  });

  console.log("📦 Models loaded into registry:", Object.keys(sequelize.models));
};

export default db;