// controllers/authController.js
import AuthService from '../services/auth.service.js';
import BruteForceService from '../services/bruteforce.service.js';
import logger from "../utils/logger.js"


export const register = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    const superadmin = await AuthService.register({ email, password });

    res.status(201).json({
      message: 'Superadmin registered successfully',
      superadmin: {
        id: superadmin.id,
        email: superadmin.email,
        email_verified: superadmin.email_verified,
        is_active: superadmin.is_active,
      },
    });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};


export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password required' });
    }

    const normalizedEmail = email.trim().toLowerCase();

    // 1. Check if account is locked
    const lockStatus = await BruteForceService.isLocked(normalizedEmail);
    if (lockStatus.locked) {
      logger.warn('Login attempt on locked account', {
        category: 'auth',
        action: 'login_attempt_locked',
        email: normalizedEmail,
        ip: req.ip,
        remainingMinutes: lockStatus.remainingMinutes,
      });

      return res.status(423).json({
        message: `Account locked due to too many failed attempts. Try again in ${lockStatus.remainingMinutes} minutes.`,
      });
    }

    // 2. Attempt login
    const { superadmin, accessToken, refreshToken } = await AuthService.login({
      email: normalizedEmail,
      password,
    });

    // 3. Success → reset failed attempts
    await BruteForceService.resetFailedAttempts(normalizedEmail);

    logger.info('Login successful', {
      category: 'auth',
      action: 'login_success',
      email: normalizedEmail,
      userId: superadmin.id,
      ip: req.ip,
    });

    // Set cookie and respond
    res.cookie('refreshToken', refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 30 * 24 * 60 * 60 * 1000,
    });

    res.json({
      message: 'Login successful',
      superadmin: {
        id: superadmin.id,
        email: superadmin.email,
        is_active: superadmin.is_active,
        email_verified: superadmin.email_verified,
      },
      accessToken,
    });
  } catch (err) {
    const normalizedEmail = (req.body.email || '').trim().toLowerCase();

    // 4. Record failed attempt
    await BruteForceService.recordFailedAttempt(normalizedEmail);

    logger.warn('Login failed', {
      category: 'auth',
      action: 'login_failed',
      email: normalizedEmail,
      ip: req.ip,
      reason: err.message,
    });

    res.status(401).json({ message: 'Invalid credentials' });
  }
};

export const refresh = async (req, res) => {
  try {
    const refreshToken = req.cookies.refreshToken || req.body.refreshToken;

    if (!refreshToken) {
      return res.status(401).json({ message: 'Refresh token required' });
    }

    const { accessToken } = await AuthService.refreshAccessToken(refreshToken);

    res.json({ accessToken });
  } catch (err) {
    res.status(401).json({ message: 'Invalid or expired refresh token' });
  }
};

export const logout = async (req, res) => {
  try {
    const refreshToken = req.cookies.refreshToken || req.body.refreshToken;
    if (refreshToken) {
      await AuthService.logout(refreshToken);
    }

    res.clearCookie('refreshToken', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
    });

    res.json({ message: 'Logged out successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Logout failed' });
  }
};

export const logoutAll = async (req, res) => {
  try {
    await AuthService.logoutAll(req.superadmin.id);
    res.clearCookie('refreshToken', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
    });
    res.json({ message: 'All sessions revoked' });
  } catch (err) {
    res.status(500).json({ message: 'Failed to revoke all sessions' });
  }
};

export const me = async (req, res) => {
  try {
    const superadmin = req.superadmin;

    logger.info('Superadmin profile accessed', {
      category: 'auth',
      action: 'profile_view',
      userId: superadmin.id,
      email: superadmin.email,
      ip: req.ip,
    });

    res.json({
      message: 'Profile retrieved successfully',
      superadmin: {
        id: superadmin.id,
        email: superadmin.email,
        is_active: superadmin.is_active,
        email_verified: superadmin.email_verified,
        last_login: superadmin.last_login,
        created_at: superadmin.created_at,
      },
    });
  } catch (err) {
    logger.error('Error fetching profile', {
      error: err.message,
      userId: req.superadmin?.id,
    });
    res.status(500).json({ message: 'Failed to retrieve profile' });
  }
};