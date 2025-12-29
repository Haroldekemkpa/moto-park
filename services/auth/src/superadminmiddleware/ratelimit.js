// middlewares/rateLimiter.js
import rateLimit from 'express-rate-limit';

export const rateLimiter = {
  auth: rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 10, // Limit each IP to 10 login/register attempts
    message: { message: 'Too many attempts, try again later' },
    standardHeaders: true,
    legacyHeaders: false,
  }),
};