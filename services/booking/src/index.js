require('dotenv').config();
const express = require('express');
const redis = require('redis');

const app = express();
app.use(express.json());

const redisClient = redis.createClient({ 
  url: process.env.REDIS_URL || 'redis://redis:6379'
});
redisClient.connect().catch(console.error);

app.get('/', (req, res) => {
  res.json({
    service: "MotoPark Booking Service",
    status: "running",
    redis_connected: true,
    database: process.env.DB_NAME,
    time: new Date().toISOString()
  });
});

app.get('/health', (req, res) => res.sendStatus(200));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Booking service LIVE on http://localhost:3005`);
  console.log(`Redis: ${process.env.REDIS_URL}`);
  console.log(`DB: ${process.env.DB_NAME}`);
});
