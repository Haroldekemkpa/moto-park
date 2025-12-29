CREATE TABLE companies (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  cac_number VARCHAR(100) UNIQUE NOT NULL,
  contact_email VARCHAR(255),
  contact_phone VARCHAR(50),
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING', 
  subscription_tier VARCHAR(50),
  approved_at TIMESTAMP,
  suspended_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE platform_transactions (
  id UUID PRIMARY KEY,
  booking_id UUID,
  company_id UUID,
  gross_amount NUMERIC(12,2),
  commission_amount NUMERIC(12,2),
  net_amount NUMERIC(12,2),
  status VARCHAR(30), -- PAID | FAILED
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE company_payouts (
  id UUID PRIMARY KEY,
  company_id UUID,
  amount NUMERIC(12,2),
  payout_reference VARCHAR(255),
  payout_status VARCHAR(30), -- PENDING | COMPLETED | FAILED
  processed_by UUID,
  processed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE refund_cases (
  id UUID PRIMARY KEY,
  booking_id UUID,
  company_id UUID,
  requested_amount NUMERIC(12,2),
  decision VARCHAR(30), -- APPROVED | DENIED
  decided_by UUID,
  decided_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE global_states (
  id UUID PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE global_cities (
  id UUID PRIMARY KEY,
  state_id UUID REFERENCES global_states(id),
  name VARCHAR(100)
);

CREATE TABLE terminals (
  id UUID PRIMARY KEY,
  city_id UUID REFERENCES global_cities(id),
  state_id UUID REFERENCES global_states(id),
  name VARCHAR(150)
);

CREATE TABLE system_announcements (
  id UUID PRIMARY KEY,
  title VARCHAR(255),
  message TEXT,
  target_audience VARCHAR(50), -- COMPANY_ADMINS | DRIVERS | ALL
  created_by UUID,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE admin_audit_logs (
  id UUID PRIMARY KEY,
  admin_id UUID,
  action VARCHAR(100),
  entity_type VARCHAR(50),
  entity_id UUID,
  metadata JSONB,
  ip_address VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);




