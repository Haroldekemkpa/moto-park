// config/env.js
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.string(),
  DB_NAME: z.string(),
  JWT_SECRET: z.string().min(32),
  // ...
});

envSchema.parse(process.env);