// src/routes/authRoutes.js
import express from 'express';
import {
  register,
  login,
  refresh,
  logout,
  logoutAll,
  me, // Optional: get current admin profile
} from '../superadmincontroller/auth.controller.js';
import { protect } from '../superadminmiddleware/auithmiddleware.js';
import { rateLimiter } from '../superadminmiddleware/ratelimit.js';

const router = express.Router();

// =============================================
// Public Routes
// =============================================

// Register new superadmin
// Only allow in development or if explicitly enabled
if (process.env.ALLOW_REGISTRATION || process.env.NODE_ENV !== 'production') {
  router.post('/register', rateLimiter.auth, register);
} else {
  // Optional: log attempt to register in production
  router.post('/register', (req, res) => {
    logger.warn('Attempted registration in production (disabled)', {
      category: 'auth',
      action: 'register_attempt_disabled',
      ip: req.ip,
    });
    res.status(403).json({ message: 'Registration is disabled in production' });
  });
}

// Login
router.post('/login', rateLimiter.auth, login);

// Refresh access token
router.post('/refresh', refresh);

// Logout current session
router.post('/logout', logout);

// =============================================
// Protected Routes (require valid access token)
// =============================================

// Get current superadmin profile
router.get('/me', protect, me);

// Logout all sessions (revoke all refresh tokens)
router.post('/logout-all', protect, logoutAll);

export default router;