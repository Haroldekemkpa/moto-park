// services/bruteForceService.js
import db from '../model/index.js';
import logger from '../utils/logger.js';
import "dotenv/config"

const { AuthSuperAdmin } = db;

// Config
const MAX_FAILED_ATTEMPTS = process.env.MAX_FAILED_ATTEMPTS;           // Lock after 5 failed logins
const LOCKOUT_DURATION_MINUTES = process.env.LOCKOUT_DURATION_MINUTES;     // Lock for 30 minutes
const TRACKING_WINDOW_MINUTES = process.env.TRACKING_WINDOW_MINUTES;      // Track attempts within 15 mins


class BruteForceService {
  // Record a failed login attempt
  static async recordFailedAttempt(email) {
    const lowerEmail = email.toLowerCase().trim();

    const superadmin = await AuthSuperAdmin.findOne({
      where: { email: lowerEmail },
    });

    if (!superadmin) {
      // Don't reveal if email exists — just log quietly
      logger.warn('Failed login attempt for non-existent email', {
        category: 'auth',
        action: 'login_failed_nonexistent',
        email: lowerEmail,
      });
      return;
    }

    // Increment failed attempts (we'll use a virtual field or update a column)
    // Option: Add a column `failed_login_attempts` and `locked_until` to your model
    const now = new Date();
    const updatedAttempts = (superadmin.failed_login_attempts || 0) + 1;

    let lockedUntil = superadmin.locked_until;

    if (updatedAttempts >= MAX_FAILED_ATTEMPTS) {
      lockedUntil = new Date(now.getTime() + LOCKOUT_DURATION_MINUTES * 60 * 1000);

      logger.warn('Account temporarily locked due to brute force', {
        category: 'auth',
        action: 'account_locked',
        email: lowerEmail,
        userId: superadmin.id,
        failedAttempts: updatedAttempts,
        lockoutUntil: lockedUntil,
      });
    }

    await superadmin.update({
      failed_login_attempts: updatedAttempts,
      locked_until: lockedUntil,
    });
  }

  // Check if account is locked
  static async isLocked(email) {
    const lowerEmail = email.toLowerCase().trim();

    const superadmin = await AuthSuperAdmin.findOne({
      where: { email: lowerEmail },
    });

    if (!superadmin) return false; // Non-existent → not locked

    if (superadmin.locked_until && superadmin.locked_until > new Date()) {
      return {
        locked: true,
        until: superadmin.locked_until,
        remainingMinutes: Math.ceil(
          (superadmin.locked_until - new Date()) / (60 * 1000)
        ),
      };
    }

    return { locked: false };
  }

  // Reset failed attempts on successful login
  static async resetFailedAttempts(email) {
    const lowerEmail = email.toLowerCase().trim();

    const superadmin = await AuthSuperAdmin.findOne({
      where: { email: lowerEmail },
    });

    if (superadmin && superadmin.failed_login_attempts > 0) {
      await superadmin.update({
        failed_login_attempts: 0,
        locked_until: null,
      });

      logger.info('Failed login attempts reset after successful login', {
        category: 'auth',
        action: 'failed_attempts_reset',
        email: lowerEmail,
        userId: superadmin.id,
      });
    }
  }
}

export default BruteForceService;