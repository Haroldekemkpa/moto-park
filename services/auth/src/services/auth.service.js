// src/services/authService.js
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import db from '../model/index.js';
import logger from '../utils/logger.js';
import { sendEmail } from '../services/email.services.js'; // ← Correct path
import { welcomeSuperAdminEmail } from '../utils/emailtemplates.js'; // ← Correct filename (camelCase)
import BruteForceService from './bruteforce.service.js'; // ← Consistent naming
import "dotenv/config";

// Use Sequelize's official model registry — guaranteed to work after loadModels()
const models = db.sequelize.models;

const AuthSuperAdmin = models.AuthSuperAdmin;
const AuthSuperAdminRefreshToken = models.AuthSuperAdminRefreshToken;

// Critical safety check — fails fast with clear message if models not loaded correctly
if (!AuthSuperAdmin) {
  throw new Error('AuthSuperAdmin model not found. Check: file name ends with .model.js and define("AuthSuperAdmin", ...)');
}
if (!AuthSuperAdminRefreshToken) {
  throw new Error('AuthSuperAdminRefreshToken model not found. Check file name and define name');
}

// Config from .env
const ACCESS_TOKEN_EXPIRY = process.env.ACCESS_TOKEN_EXPIRES || '15m';
const REFRESH_TOKEN_EXPIRY_DAYS = Number(process.env.REFRESH_TOKEN_EXPIRES || 30);
const JWT_SECRET = process.env.JWT_SECRETE_KEY || process.env.JWT_SECRET; // Support both names

if (!JWT_SECRET) {
  throw new Error('JWT_SECRET (or JWT_SECRETE_KEY) is missing in .env');
}

class AuthService {
  // Generate short-lived JWT access token
  static generateAccessToken(superadmin) {
    return jwt.sign(
      { id: superadmin.id, email: superadmin.email },
      JWT_SECRET,
      { expiresIn: ACCESS_TOKEN_EXPIRY }
    );
  }

  // Generate cryptographically secure refresh token
  static generateRefreshToken() {
    return crypto.randomBytes(64).toString('hex');
  }

  // Register new superadmin
  static async register({ email, password }) {
    const normalizedEmail = email.trim().toLowerCase();

    // Check for existing email
    const existing = await AuthSuperAdmin.findOne({ where: { email: normalizedEmail } });
    if (existing) {
      throw new Error('Email already registered');
    }

    // Create superadmin — password hashed automatically by model hook
    const superadmin = await AuthSuperAdmin.create({
      email: normalizedEmail,
      password_hash: password,
    });

    // Send welcome email (fire and forget)
    const emailData = welcomeSuperAdminEmail({
      email: superadmin.email,
      temporaryPassword: null, // User chose their own password
    });

    sendEmail({
      to: superadmin.email,
      subject: emailData.subject,
      html: emailData.html,
    }).catch((err) => {
      logger.warn('Failed to send welcome email', {
        category: 'auth',
        action: 'welcome_email_failed',
        email: normalizedEmail,
        userId: superadmin.id,
        error: err.message,
      });
    });

    logger.info('Superadmin registered successfully', {
      category: 'auth',
      action: 'register_success',
      email: normalizedEmail,
      userId: superadmin.id,
    });

    return superadmin;
  }

  // Login superadmin
  static async login({ email, password }) {
    const normalizedEmail = email.trim().toLowerCase();

    // Brute force protection
    const lockStatus = await BruteForceService.isLocked(normalizedEmail);
    if (lockStatus.locked) {
      throw new Error(`Account locked. Try again in ${lockStatus.remainingMinutes} minutes.`);
    }

    // Find user
    const superadmin = await AuthSuperAdmin.findOne({ where: { email: normalizedEmail } });
    if (!superadmin || !superadmin.is_active) {
      await BruteForceService.recordFailedAttempt(normalizedEmail);
      throw new Error('Invalid credentials');
    }

    // Verify password
    const isMatch = await superadmin.comparePassword(password);
    if (!isMatch) {
      await BruteForceService.recordFailedAttempt(normalizedEmail);
      throw new Error('Invalid credentials');
    }

    // Success: reset brute force counter
    await BruteForceService.resetFailedAttempts(normalizedEmail);

    // Update last login
    await superadmin.update({ last_login: new Date() });

    // Generate tokens
    const accessToken = this.generateAccessToken(superadmin);
    const refreshToken = this.generateRefreshToken();

    // Store refresh token
    const expiryDays = parseInt(process.env.REFRESH_TOKEN_EXPIRES, 10) || 30;
    
    // Use the .setDate() method which is more reliable than raw millisecond math
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + expiryDays);

    // Final safety check: if the date is invalid, use a hardcoded 30-day fallback
    const finalExpiresAt = isNaN(expiresAt.getTime()) 
        ? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) 
        : expiresAt;
   
        await AuthSuperAdminRefreshToken.create({
      superadmin_id: superadmin.id,
      token: refreshToken,
      expires_at: finalExpiresAt,
    });

    logger.info('Login successful', {
      category: 'auth',
      action: 'login_success',
      email: normalizedEmail,
      userId: superadmin.id,
    });

    return {
      superadmin: {
        id: superadmin.id,
        email: superadmin.email,
        is_active: superadmin.is_active,
        email_verified: superadmin.email_verified,
      },
      accessToken,
      refreshToken,
    };
  }

  // Refresh access token
  static async refreshAccessToken(refreshToken) {
    const tokenRecord = await AuthSuperAdminRefreshToken.findOne({
      where: { token: refreshToken, revoked: false },
      include: [{
        model: AuthSuperAdmin,
        where: { is_active: true },
        attributes: ['id', 'email'],
      }],
    });

    if (!tokenRecord || tokenRecord.expires_at < new Date()) {
      throw new Error('Invalid or expired refresh token');
    }

    const newAccessToken = this.generateAccessToken(tokenRecord.superadmin);

    logger.info('Token refreshed successfully', {
      category: 'auth',
      action: 'token_refresh_success',
      userId: tokenRecord.superadmin.id,
      email: tokenRecord.superadmin.email,
    });

    return { accessToken: newAccessToken };
  }

  // Logout current session
  static async logout(refreshToken) {
    await AuthSuperAdminRefreshToken.update(
      { revoked: true },
      { where: { token: refreshToken } }
    );

    logger.info('Logout successful (single session)', {
      category: 'auth',
      action: 'logout',
    });
  }

  // Logout all sessions
  static async logoutAll(superadminId) {
    await AuthSuperAdminRefreshToken.update(
      { revoked: true },
      { where: { superadmin_id: superadminId } }
    );

    logger.info('All sessions revoked', {
      category: 'auth',
      action: 'logout_all',
      userId: superadminId,
    });
  }
}

export default AuthService;