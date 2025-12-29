// middlewares/authMiddleware.js
import jwt from 'jsonwebtoken';
import db from '../model/index.js';
import "dotenv/config"
const { AuthSuperAdmin } = db;

export const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization?.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    return res.status(401).json({ message: 'Not authorized' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const superadmin = await AuthSuperAdmin.findByPk(decoded.id, {
      attributes: ['id', 'email', 'is_active', 'email_verified'],
    });

    if (!superadmin || !superadmin.is_active) {
      return res.status(401).json({ message: 'Account disabled or not found' });
    }

    req.superadmin = superadmin;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};