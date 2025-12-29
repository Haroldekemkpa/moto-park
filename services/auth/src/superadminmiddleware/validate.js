// middlewares/validate.js
import { z } from 'zod';

export const validateLogin = (req, res, next) => {
  const schema = z.object({
    email: z.string().email(),
    password: z.string().min(8),
  });

  const result = schema.safeParse(req.body);
  if (!result.success) {
    return res.status(400).json({ message: result.error.errors[0].message });
  }
  next();
};