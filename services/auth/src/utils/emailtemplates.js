// src/services/emailtemplates.js
export const welcomeEmailTemplate = (full_name, verifyUrl) => {
  return `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #eee; border-radius: 8px;">
      <h2 style="color: #333;">Welcome to Moto-Park, ${full_name}!</h2>
      <p style="color: #555; font-size: 16px;">
        Thank you for registering with Moto-Park. Please verify your email to activate your account.
      </p>
      <div style="text-align: center; margin: 30px 0;">
        <a href="${verifyUrl}" 
           style="background-color: #4CAF50; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold;">
          Verify Email
        </a>
      </div>
      <p style="color: #999; font-size: 14px;">
        If the button above doesn't work, copy and paste the following link into your browser:
        <br />
        <a href="${verifyUrl}" style="color: #4CAF50;">${verifyUrl}</a>
      </p>
      <p style="color: #999; font-size: 14px; margin-top: 40px;">
        &copy; ${new Date().getFullYear()} Moto-Park. All rights reserved.
      </p>
    </div>
  `;
};


export const welcomeSuperAdminEmail = ({ email, temporaryPassword }) => {
  return {
    subject: 'Welcome to Moto Park — Superadmin Access Granted',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
        <h2 style="color: #1a5fb4;">Welcome to Moto Park Admin Panel</h2>
        <p>Hello <strong>${email}</strong>,</p>
        <p>A superadmin account has been created for you. You now have full access to manage the Moto Park platform.</p>

        <div style="background: #f0f8ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
          <p><strong>Your Login Details:</strong></p>
          <p>Email: <code>${email}</code></p>
          <p>Temporary Password: <strong>${temporaryPassword || 'Set during registration'}</strong></p>
        </div>

        <p style="background: #fff3cd; padding: 10px; border-radius: 5px;">
          <strong>Security Notice:</strong> For maximum security, please log in immediately and change your password.
        </p>

        <p>
          <a href="https://admin.moto-park.com/login" 
             style="background: #1a5fb4; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block; margin: 10px 0;">
            Login to Admin Panel
          </a>
        </p>

        <hr style="margin: 30px 0;">
        <small style="color: #666;">
          This is an automated message. If you did not expect this email, please contact support immediately.
        </small>
      </div>
    `,
  };
};