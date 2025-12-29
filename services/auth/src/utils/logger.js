// src/utils/logger.js
import winston from 'winston';

// Custom format for security events
const securityFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.metadata({ fillExcept: ['message', 'level', 'timestamp', 'label'] }),
  winston.format.json()
);

// Align console logs in development for readability
const consoleFormat = winston.format.combine(
  winston.format.colorize(),
  winston.format.timestamp({ format: 'HH:mm:ss' }),
  winston.format.label({ label: '[AUTH]' }),
  winston.format.printf(
    ({ level, message, timestamp, label, ip, userId, email, action, ...meta }) =>
      `${timestamp} ${label} ${level}: ${message} ${
        ip ? `(IP: ${ip})` : ''
      } ${email ? `(Email: ${email})` : ''} ${
        userId ? `(ID: ${userId})` : ''
      } ${action ? `- Action: ${action}` : ''} ${
        Object.keys(meta).length ? JSON.stringify(meta) : ''
      }`
  )
);

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info', // Can be: debug, info, warn, error
  format: securityFormat,
  defaultMeta: { service: 'auth-service' },
  transports: [
    // Console output (pretty in dev)
    new winston.transports.Console({
      format: process.env.NODE_ENV === 'production' ? securityFormat : consoleFormat,
    }),

    // File: all logs
    new winston.transports.File({
      filename: 'logs/combined.log',
      maxsize: 10 * 1024 * 1024, // 10MB
      maxFiles: 5,
      tailable: true,
    }),

    // File: security/auth events only
    new winston.transports.File({
      filename: 'logs/auth-security.log',
      level: 'info',
      format: winston.format.combine(
        winston.format((info) => {
          // Only log auth-related events here
          if (info.category === 'auth') return info;
          return false;
        })(),
        securityFormat
      ),
    }),

    // File: errors only
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error',
    }),
  ],
});

// Create directories if they don't exist (in production)
if (process.env.NODE_ENV === 'production') {
  const fs = await import('fs');
  const path = await import('path');
  const logDir = path.join(process.cwd(), 'logs');
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir);
  }
}

export default logger;