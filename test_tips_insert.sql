-- SQL script to insert diverse test tips for the Tips feature
-- Run this in your database to populate test data

-- GLOBAL TIPS (Always visible)
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, is_active, created_at) VALUES
('tip-global-001', 'Stay Hydrated', 'Drink at least 8-10 glasses of water daily. Proper hydration helps maintain amniotic fluid levels and supports your baby''s development.', 'General', 'pregnant', 1, 9, 1, datetime('now')),
('tip-global-002', 'Get Adequate Rest', 'Aim for 7-9 hours of sleep per night. Use pillows to support your body and find a comfortable sleeping position.', 'Sleep', 'pregnant', 1, 8, 1, datetime('now')),
('tip-global-003', 'Practice Deep Breathing', 'Take 5-10 minutes daily for deep breathing exercises. This helps reduce stress and improves oxygen flow to your baby.', 'Mental', 'pregnant', 1, 7, 1, datetime('now')),
('tip-global-004', 'Postpartum Self-Care', 'Remember to take care of yourself too. Rest when the baby sleeps and don''t hesitate to ask for help from family and friends.', 'General', 'postpartum', 1, 9, 1, datetime('now')),
('tip-global-005', 'Monitor Your Mood', 'Pay attention to your emotional wellbeing. Mood swings are normal, but persistent sadness or anxiety should be discussed with your healthcare provider.', 'Mental', 'pregnant', 1, 8, 1, datetime('now'));

-- PREGNANCY TIPS BY WEEK (First Trimester: Weeks 1-12)
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, pregnancy_week_from, pregnancy_week_to, is_active, created_at) VALUES
('tip-preg-001', 'Start Taking Folic Acid', 'Begin taking 400-800 mcg of folic acid daily to prevent neural tube defects. Consult your doctor for the right dosage.', 'Medical', 'pregnant', 0, 9, 1, 4, 1, datetime('now')),
('tip-preg-002', 'Avoid Harmful Substances', 'Eliminate alcohol, smoking, and limit caffeine to 200mg per day. These substances can harm your developing baby.', 'General', 'pregnant', 0, 10, 1, 12, 1, datetime('now')),
('tip-preg-003', 'Morning Sickness Management', 'Eat small, frequent meals throughout the day. Ginger tea or ginger candies can help alleviate nausea.', 'Food', 'pregnant', 0, 8, 5, 12, 1, datetime('now')),
('tip-preg-004', 'Prenatal Vitamin Essentials', 'Ensure your prenatal vitamins include iron, calcium, and DHA. Take them with food to reduce stomach upset.', 'Medical', 'pregnant', 0, 8, 1, 12, 1, datetime('now')),
('tip-preg-005', 'Gentle Exercise Routine', 'Start with light walking, swimming, or prenatal yoga. Avoid high-intensity workouts and always consult your doctor first.', 'Sport', 'pregnant', 0, 7, 6, 12, 1, datetime('now'));

-- PREGNANCY TIPS BY WEEK (Second Trimester: Weeks 13-27)
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, pregnancy_week_from, pregnancy_week_to, is_active, created_at) VALUES
('tip-preg-006', 'Increase Protein Intake', 'Aim for 75-100g of protein daily. Include lean meats, eggs, legumes, and dairy products in your meals.', 'Food', 'pregnant', 0, 8, 13, 27, 1, datetime('now')),
('tip-preg-007', 'Feel Your Baby Move', 'You should start feeling baby movements around week 18-25. Keep track of movement patterns and contact your doctor if you notice changes.', 'General', 'pregnant', 0, 9, 18, 27, 1, datetime('now')),
('tip-preg-008', 'Supportive Sleep Positions', 'Sleep on your left side to improve blood flow. Use pregnancy pillows between your knees and under your belly for comfort.', 'Sleep', 'pregnant', 0, 8, 13, 27, 1, datetime('now')),
('tip-preg-009', 'Strengthen Your Core', 'Practice pelvic floor exercises (Kegels) daily. This helps prepare for delivery and recovery.', 'Sport', 'pregnant', 0, 7, 14, 27, 1, datetime('now')),
('tip-preg-010', 'Manage Back Pain', 'Wear supportive shoes, practice good posture, and consider prenatal massage. Gentle stretches can also help relieve tension.', 'Medical', 'pregnant', 0, 7, 20, 27, 1, datetime('now')),
('tip-preg-011', 'Calcium for Baby''s Bones', 'Increase calcium intake to 1000mg daily. Dairy products, leafy greens, and fortified foods are excellent sources.', 'Food', 'pregnant', 0, 8, 13, 27, 1, datetime('now'));

-- PREGNANCY TIPS BY WEEK (Third Trimester: Weeks 28-40)
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, pregnancy_week_from, pregnancy_week_to, is_active, created_at) VALUES
('tip-preg-012', 'Monitor Baby''s Movements', 'Count kicks daily. You should feel at least 10 movements in 2 hours. Report any significant decrease to your doctor immediately.', 'Medical', 'pregnant', 0, 10, 28, 40, 1, datetime('now')),
('tip-preg-013', 'Prepare for Labor', 'Practice breathing techniques and consider a birth plan. Attend childbirth classes and tour your delivery facility.', 'General', 'pregnant', 0, 8, 28, 40, 1, datetime('now')),
('tip-preg-014', 'Comfortable Sleeping', 'As your belly grows, sleep on your side with a pillow between your legs. Avoid lying flat on your back.', 'Sleep', 'pregnant', 0, 9, 28, 40, 1, datetime('now')),
('tip-preg-015', 'Light Exercise Helps', 'Continue gentle exercises like walking or swimming, but listen to your body and rest when needed.', 'Sport', 'pregnant', 0, 6, 28, 40, 1, datetime('now')),
('tip-preg-016', 'Small, Frequent Meals', 'Eat 5-6 small meals instead of 3 large ones. This helps manage heartburn and keeps energy levels stable.', 'Food', 'pregnant', 0, 7, 28, 40, 1, datetime('now')),
('tip-preg-017', 'Manage Swelling', 'Elevate your feet when sitting, stay hydrated, and avoid standing for long periods. Compression stockings can help.', 'Medical', 'pregnant', 0, 7, 32, 40, 1, datetime('now')),
('tip-preg-018', 'Omega-3 for Brain Development', 'Consume foods rich in DHA like fatty fish (2-3 times per week), walnuts, and chia seeds for your baby''s brain development.', 'Food', 'pregnant', 0, 8, 28, 40, 1, datetime('now'));

-- PREGNANCY TIPS BY MONTH
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, pregnancy_month_from, pregnancy_month_to, is_active, created_at) VALUES
('tip-preg-month-001', 'Monthly Checkups', 'Attend all scheduled prenatal appointments. These visits are crucial for monitoring your and your baby''s health.', 'Medical', 'pregnant', 0, 9, 1, 9, 1, datetime('now')),
('tip-preg-month-002', 'Iron-Rich Foods', 'Prevent anemia by including iron-rich foods: lean red meat, spinach, lentils, and iron-fortified cereals. Pair with vitamin C for better absorption.', 'Food', 'pregnant', 0, 8, 2, 9, 1, datetime('now')),
('tip-preg-month-003', 'Stay Active Safely', 'Moderate exercise throughout pregnancy is beneficial. Avoid contact sports, hot yoga, and activities with risk of falling.', 'Sport', 'pregnant', 0, 7, 1, 9, 1, datetime('now'));

-- POSTPARTUM TIPS BY WEEK
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, postpartum_week_from, postpartum_week_to, is_active, created_at) VALUES
('tip-post-001', 'First Week Recovery', 'Focus on rest and healing. Take pain medication as prescribed, use ice packs for perineal discomfort, and stay hydrated.', 'Medical', 'postpartum', 0, 9, 1, 1, 1, datetime('now')),
('tip-post-002', 'Establishing Breastfeeding', 'Feed your baby on demand, usually 8-12 times per day. Ensure proper latch and seek help from lactation consultants if needed.', 'General', 'postpartum', 0, 10, 1, 4, 1, datetime('now')),
('tip-post-003', 'Postpartum Bleeding', 'Normal bleeding (lochia) can last 4-6 weeks. Use pads, not tampons. Contact your doctor if bleeding is excessive or has a foul odor.', 'Medical', 'postpartum', 0, 8, 1, 6, 1, datetime('now')),
('tip-post-004', 'Nutrition for Recovery', 'Eat nutrient-dense foods: lean proteins, whole grains, fruits, and vegetables. You need extra calories if breastfeeding.', 'Food', 'postpartum', 0, 8, 1, 8, 1, datetime('now')),
('tip-post-005', 'Baby''s Sleep Patterns', 'Newborns sleep 16-17 hours per day in short stretches. Sleep when your baby sleeps to manage fatigue.', 'Sleep', 'postpartum', 0, 9, 1, 8, 1, datetime('now')),
('tip-post-006', 'Tummy Time Begins', 'Start supervised tummy time for a few minutes daily around 2-3 weeks. This strengthens baby''s neck and back muscles.', 'General', 'postpartum', 0, 7, 2, 12, 1, datetime('now')),
('tip-post-007', 'Gentle Exercise Return', 'Begin with light walking after your doctor''s approval, usually around 6 weeks. Start slowly and listen to your body.', 'Sport', 'postpartum', 0, 7, 6, 12, 1, datetime('now')),
('tip-post-008', 'Postpartum Emotions', 'Baby blues are common in the first 2 weeks. If sadness persists or intensifies, discuss postpartum depression screening with your provider.', 'Mental', 'postpartum', 0, 9, 1, 12, 1, datetime('now')),
('tip-post-009', 'Pelvic Floor Recovery', 'Continue Kegel exercises to strengthen pelvic floor muscles. This aids in recovery from delivery.', 'Sport', 'postpartum', 0, 7, 2, 12, 1, datetime('now')),
('tip-post-010', 'Baby Feeding Schedule', 'Track feeding times and diaper changes. Newborns typically need 8-12 feedings per day in the first month.', 'General', 'postpartum', 0, 8, 1, 4, 1, datetime('now')),
('tip-post-011', 'Hydration for Breastfeeding', 'Drink water whenever you feel thirsty. Aim for 13 cups (3 liters) daily if breastfeeding. Keep a water bottle nearby.', 'Food', 'postpartum', 0, 8, 1, 12, 1, datetime('now')),
('tip-post-012', 'Skin-to-Skin Contact', 'Practice skin-to-skin contact daily. It promotes bonding, regulates baby''s temperature, and supports breastfeeding.', 'General', 'postpartum', 0, 9, 1, 12, 1, datetime('now'));

-- CATEGORY-SPECIFIC TIPS (High Priority)
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, is_active, created_at) VALUES
('tip-food-001', 'Essential Nutrients', 'Include iron, calcium, folic acid, protein, and omega-3s in your daily diet. A varied, colorful plate helps ensure you get all nutrients.', 'Food', 'pregnant', 0, 9, 1, datetime('now')),
('tip-food-002', 'Foods to Avoid', 'Avoid raw fish, unpasteurized dairy, deli meats, and high-mercury fish. Cook all meats thoroughly to safe temperatures.', 'Food', 'pregnant', 0, 10, 1, datetime('now')),
('tip-food-003', 'Balanced Meals', 'Each meal should include protein, complex carbohydrates, healthy fats, and vegetables. This keeps you energized and supports baby''s growth.', 'Food', 'pregnant', 0, 8, 1, datetime('now')),
('tip-sport-001', 'Safe Pregnancy Exercises', 'Walking, swimming, prenatal yoga, and stationary cycling are excellent choices. Stop if you experience pain, dizziness, or bleeding.', 'Sport', 'pregnant', 0, 8, 1, datetime('now')),
('tip-sport-002', 'Exercise Benefits', 'Regular exercise helps manage weight, improves sleep, boosts mood, and can reduce pregnancy discomforts like back pain.', 'Sport', 'pregnant', 0, 7, 1, datetime('now')),
('tip-sleep-001', 'Sleep Hygiene', 'Maintain a regular sleep schedule, create a comfortable environment, limit screens before bed, and practice relaxation techniques.', 'Sleep', 'pregnant', 0, 8, 1, datetime('now')),
('tip-sleep-002', 'Dealing with Insomnia', 'If you can''t sleep, get up and do something calming like reading or gentle stretching. Avoid caffeine and heavy meals before bedtime.', 'Sleep', 'pregnant', 0, 7, 1, datetime('now')),
('tip-mental-001', 'Stress Management', 'Practice mindfulness, meditation, or gentle yoga. Connect with support groups and don''t hesitate to seek professional help when needed.', 'Mental', 'pregnant', 0, 9, 1, datetime('now')),
('tip-mental-002', 'Emotional Support', 'Build a support network of family, friends, and healthcare providers. Open communication about your feelings is important.', 'Mental', 'pregnant', 0, 8, 1, datetime('now')),
('tip-medical-001', 'When to Call Your Doctor', 'Contact your healthcare provider immediately if you experience severe abdominal pain, heavy bleeding, severe headaches, or decreased fetal movement.', 'Medical', 'pregnant', 0, 10, 1, datetime('now')),
('tip-medical-002', 'Regular Monitoring', 'Keep track of your blood pressure, weight gain, and any symptoms. Bring a list of questions to each prenatal visit.', 'Medical', 'pregnant', 0, 8, 1, datetime('now'));

-- ADDITIONAL DIVERSE TIPS
INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, pregnancy_week_from, pregnancy_week_to, is_active, created_at) VALUES
('tip-misc-001', 'Prepare Your Home', 'Set up the nursery, install car seat, and prepare a hospital bag by week 36. Having everything ready reduces last-minute stress.', 'General', 'pregnant', 0, 7, 30, 40, 1, datetime('now')),
('tip-misc-002', 'Birth Plan Basics', 'Write a flexible birth plan discussing pain management, delivery positions, and postpartum preferences with your partner and healthcare team.', 'General', 'pregnant', 0, 6, 24, 36, 1, datetime('now')),
('tip-misc-003', 'Dental Care', 'Maintain good oral hygiene and schedule a dental checkup. Hormonal changes can increase risk of gum disease during pregnancy.', 'Medical', 'pregnant', 0, 6, 1, 40, 1, datetime('now')),
('tip-misc-004', 'Travel During Pregnancy', 'Travel is generally safe until week 36. Stay hydrated, move around regularly, and wear compression stockings on long flights.', 'General', 'pregnant', 0, 5, 14, 36, 1, datetime('now')),
('tip-misc-005', 'Preparing Siblings', 'Involve older children in the pregnancy journey. Read age-appropriate books about new babies and involve them in preparations.', 'General', 'pregnant', 0, 6, 20, 40, 1, datetime('now'));

INSERT INTO tips (id, title, content, category, target_audience, is_global, priority, postpartum_week_from, postpartum_week_to, is_active, created_at) VALUES
('tip-post-misc-001', 'Newborn Care Basics', 'Learn diaper changing, bathing, and swaddling techniques before delivery. Practice makes these tasks easier after baby arrives.', 'General', 'postpartum', 0, 7, 1, 4, 1, datetime('now')),
('tip-post-misc-002', 'Partner Involvement', 'Encourage your partner to bond with the baby through feeding (if bottle-feeding), diapering, and cuddling. Shared care strengthens family bonds.', 'General', 'postpartum', 0, 7, 1, 12, 1, datetime('now')),
('tip-post-misc-003', 'Baby Development Milestones', 'Your baby will reach milestones at their own pace. Track development but remember that variations are normal and expected.', 'General', 'postpartum', 0, 6, 4, 12, 1, datetime('now'));
