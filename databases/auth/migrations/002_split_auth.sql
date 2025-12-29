-- ================================
-- Enable pgcrypto
-- ================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

BEGIN;

-- ================================
-- PASSENGERS
-- ================================
CREATE TABLE IF NOT EXISTS auth_passengers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  password_hash TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  last_login TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS auth_passenger_profiles (
  passenger_id UUID PRIMARY KEY REFERENCES auth_passengers(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  address TEXT,
  emergency_contact JSONB,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS auth_passenger_refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  passenger_id UUID REFERENCES auth_passengers(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================
-- DRIVERS
-- ================================
CREATE TABLE IF NOT EXISTS auth_drivers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  password_hash TEXT NOT NULL,
  license_number TEXT UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  last_login TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS auth_driver_refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id UUID REFERENCES auth_drivers(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================
-- COMPANIES
-- ================================
CREATE TABLE IF NOT EXISTS auth_companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  company_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  is_active BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  last_login TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS auth_company_refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES auth_companies(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================
-- SUPER ADMINS
-- ================================
CREATE TABLE IF NOT EXISTS auth_superadmins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  last_login TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS auth_superadmin_refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  superadmin_id UUID REFERENCES auth_superadmins(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ================================
-- DATA MIGRATION
-- ================================

-- PASSENGERS
INSERT INTO auth_passengers (id, email, phone, password_hash, is_active, email_verified, created_at, updated_at)
SELECT id, email, phone, password_hash, is_active, email_verified, created_at, updated_at
FROM auth_users
WHERE role = 'PASSENGER';

INSERT INTO auth_passenger_profiles (passenger_id, full_name, avatar_url, address, emergency_contact, created_at, updated_at)
SELECT user_id, full_name, avatar_url, address, emergency_contact, created_at, updated_at
FROM auth_user_profiles
WHERE user_id IN (SELECT id FROM auth_users WHERE role = 'PASSENGER');

INSERT INTO auth_passenger_refresh_tokens (id, passenger_id, token, expires_at, revoked, created_at)
SELECT id, user_id, token, expires_at, revoked, created_at
FROM auth_refresh_tokens
WHERE user_id IN (SELECT id FROM auth_users WHERE role = 'PASSENGER');

-- SUPER ADMINS
INSERT INTO auth_superadmins (id, email, password_hash, is_active, email_verified, created_at, updated_at)
SELECT id, email, password_hash, is_active, email_verified, created_at, updated_at
FROM auth_users
WHERE role = 'SUPERADMIN';

INSERT INTO auth_superadmin_refresh_tokens (id, superadmin_id, token, expires_at, revoked, created_at)
SELECT id, user_id, token, expires_at, revoked, created_at
FROM auth_refresh_tokens
WHERE user_id IN (SELECT id FROM auth_users WHERE role = 'SUPERADMIN');

COMMIT;
