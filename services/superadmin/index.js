// server.js
import "dotenv/config"; 
import db from "./src/model/index.js"; 
// import logger from "./src/utils/logger.js";

const PORT = Number(process.env.PORT) || 4006;

const startServer = async () => {
  try {
    console.log("🔄 Initializing database and loading models...");

    // 1. Load all models + setup associations FIRST
    // This MUST happen before app.js is imported
    await db.loadModels();

    // logger.log() //what next??
    // 2. Authenticate connection
    await db.sequelize.authenticate();
    console.log("✅ Database connected successfully");

    // 3. Sync schema (only in non-production)
    if (process.env.NODE_ENV === "production") {
      console.warn("⚠️  Production mode: Skipping database sync/alter");
    } else {
      console.log("🔄 Synchronizing database schema...");
      await db.sequelize.sync({ alter: true });
      console.log("✅ Database schema synchronized");
    }

    // 4. DYNAMIC IMPORT of APP
    // This ensures AuthSuperAdmin exists in the registry before app.js loads the services
    const { default: app } = await import("./app.js");

    // 5. Start HTTP server
    const server = app.listen(PORT, () => {
      console.log(`🚀 Server listening on http://localhost:${PORT}`);
      console.log(`📊 Environment: ${process.env.NODE_ENV || "development"}`);
      console.log(`❤️  Health check: http://localhost:${PORT}/health`);
    });

    // Graceful shutdown handling
    const gracefulShutdown = async (signal) => {
      console.log(`\n🛑 Received ${signal}. Closing server gracefully...`);
      server.close(async () => {
        console.log("🔌 HTTP server closed");
        try {
          await db.sequelize.close();
          console.log("🔌 Database connection closed");
        } catch (err) {
          console.error("Error closing database:", err);
        }
        process.exit(0);
      });

      setTimeout(() => {
        console.error("⏰ Force closing...");
        process.exit(1);
      }, 10000);
    };

    process.on("SIGTERM", () => gracefulShutdown("SIGTERM"));
    process.on("SIGINT", () => gracefulShutdown("SIGINT"));

  } catch (error) {
    console.error("❌ Failed to start server:", error.message || error);
    process.exit(1);
  }
};

// Run the server
startServer();