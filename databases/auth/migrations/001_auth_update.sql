-- Enable pgcrypto for UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ================================
-- Table: auth_users
-- ================================
CREATE TABLE IF NOT EXISTS auth_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  password_hash TEXT,
  role TEXT NOT NULL CHECK (role IN ('PASSENGER','COMPANY_ADMIN','DRIVER','SUPERADMIN')),
  is_active BOOLEAN DEFAULT TRUE,
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_auth_users_email ON auth_users(email);
CREATE INDEX IF NOT EXISTS idx_auth_users_role ON auth_users(role);

-- ================================
-- Table: auth_user_profiles
-- ================================
CREATE TABLE IF NOT EXISTS auth_user_profiles (
  user_id UUID PRIMARY KEY REFERENCES auth_users(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  address TEXT,
  emergency_contact JSONB,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ================================
-- Table: auth_refresh_tokens
-- ================================
CREATE TABLE IF NOT EXISTS auth_refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth_users(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Optional: one active refresh token per user
CREATE UNIQUE INDEX IF NOT EXISTS unique_active_refresh_token
ON auth_refresh_tokens(user_id)
WHERE revoked = FALSE;

-- ================================
-- Trigger function to auto-update 'updated_at'
-- ================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach triggers to update 'updated_at' automatically
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_auth_users_updated'
  ) THEN
    CREATE TRIGGER trg_auth_users_updated
    BEFORE UPDATE ON auth_users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_auth_profiles_updated'
  ) THEN
    CREATE TRIGGER trg_auth_profiles_updated
    BEFORE UPDATE ON auth_user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
  END IF;
END $$;
