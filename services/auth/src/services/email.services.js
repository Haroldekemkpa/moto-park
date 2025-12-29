// src/utils/emailService.js
import nodemailer from 'nodemailer';
import dotenv from 'dotenv/config';

// dotenv.config();

// Validate required env vars
if (!process.env.EMAIL_USER || !process.env.EMAIL_PASSWORD) {
  console.warn('⚠️  EMAIL_USER or EMAIL_PASSWORD not set — emails will not send');
}

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD, // Consider using App Password if 2FA enabled
  },
  tls: {
    rejectUnauthorized: false,
  },
});

// Verify connection on startup (optional but helpful)
transporter.verify((error) => {
  if (error) {
    console.error('❌ Email transporter error:', error);
  } else {
    console.log('✅ Email transporter ready');
  }
});

export const sendEmail = async ({ to, subject, text = '', html = '' }) => {
  if (!process.env.EMAIL_USER) {
    console.log(`📧 [DRY RUN] Would send email to: ${to} | Subject: ${subject}`);
    return; // Skip in dev if no email configured
  }

  try {
    await transporter.sendMail({
      from: `"Moto Park Admin" <${process.env.EMAIL_USER}>`,
      to,
      subject,
      text,
      html,
    });
    console.log(`✅ Email sent to ${to}`);
  } catch (error) {
    console.error(`❌ Failed to send email to ${to}:`, error.message);
    // Don't throw in production — email failure shouldn't block registration
    // throw error; ← remove this
  }
};