-- SQL script to insert test pregnancy and baby data for testing Tips feature
-- Replace USER_ID_HERE with your actual user ID before running

-- IMPORTANT: Replace 'USER_ID_HERE' with your actual user ID from the users table
-- You can get your user ID by running: SELECT id FROM users LIMIT 1;

-- ============================================
-- TEST PREGNANCY DATA
-- ============================================

-- Insert a test pregnancy (Week 12 example - adjust LMP date as needed)
-- This creates a pregnancy starting 84 days ago (12 weeks * 7 days)
-- Adjust the date calculation based on what week you want to test
INSERT INTO pregnancies (
  id, 
  user_id, 
  lmp_date, 
  due_date, 
  is_active, 
  is_first_pregnancy, 
  is_high_risk, 
  medical_conditions,
  created_at, 
  updated_at
) VALUES (
  'test-pregnancy-001',
  'USER_ID_HERE',  -- ⚠️ REPLACE WITH YOUR USER ID
  date('now', '-84 days'),  -- 12 weeks ago (84 days = 12 weeks * 7 days)
  date('now', '-84 days', '+280 days'),  -- Due date (LMP + 280 days = 40 weeks)
  1,  -- is_active
  1,  -- is_first_pregnancy
  0,  -- is_high_risk
  NULL,  -- medical_conditions
  datetime('now'),
  datetime('now')
);

-- Alternative: Pregnancy at Week 28 (third trimester)
-- Uncomment and adjust USER_ID_HERE if you want to test third trimester tips
/*
INSERT INTO pregnancies (
  id, 
  user_id, 
  lmp_date, 
  due_date, 
  is_active, 
  is_first_pregnancy, 
  is_high_risk, 
  medical_conditions,
  created_at, 
  updated_at
) VALUES (
  'test-pregnancy-002',
  'USER_ID_HERE',  -- ⚠️ REPLACE WITH YOUR USER ID
  date('now', '-196 days'),  -- 28 weeks ago (196 days = 28 weeks * 7 days)
  date('now', '-196 days', '+280 days'),  -- Due date
  1,
  0,
  0,
  NULL,
  datetime('now'),
  datetime('now')
);
*/

-- ============================================
-- TEST BABY DATA (for Postpartum Tips)
-- ============================================

-- Insert a test baby (4 weeks old - adjust date_of_birth as needed)
-- This creates a baby born 28 days ago (4 weeks * 7 days)
-- Adjust the date calculation based on what postpartum week you want to test
INSERT INTO babies (
  id,
  user_id,
  name,
  gender,
  date_of_birth,
  birth_weight,
  birth_height,
  theme_color,
  is_active,
  created_at,
  updated_at
) VALUES (
  'test-baby-001',
  'USER_ID_HERE',  -- ⚠️ REPLACE WITH YOUR USER ID
  'Test Baby',
  'girl',  -- or 'boy'
  date('now', '-28 days'),  -- 4 weeks ago (28 days = 4 weeks * 7 days)
  3.5,  -- birth_weight in kg
  50.0,  -- birth_height in cm
  '#FFB6D9',  -- pink for girl, '#87CEEB' for boy
  1,  -- is_active
  datetime('now'),
  datetime('now')
);

-- Alternative: Baby at 8 weeks old
-- Uncomment and adjust USER_ID_HERE if you want to test 8-week postpartum tips
/*
INSERT INTO babies (
  id,
  user_id,
  name,
  gender,
  date_of_birth,
  birth_weight,
  birth_height,
  theme_color,
  is_active,
  created_at,
  updated_at
) VALUES (
  'test-baby-002',
  'USER_ID_HERE',  -- ⚠️ REPLACE WITH YOUR USER ID
  'Test Baby Boy',
  'boy',
  date('now', '-56 days'),  -- 8 weeks ago (56 days = 8 weeks * 7 days)
  3.8,
  52.0,
  '#87CEEB',
  1,
  datetime('now'),
  datetime('now')
);
*/

-- ============================================
-- QUICK REFERENCE: Calculate dates
-- ============================================
-- Week 1: date('now', '-7 days')
-- Week 4: date('now', '-28 days')
-- Week 8: date('now', '-56 days')
-- Week 12: date('now', '-84 days')
-- Week 20: date('now', '-140 days')
-- Week 28: date('now', '-196 days')
-- Week 36: date('now', '-252 days')
