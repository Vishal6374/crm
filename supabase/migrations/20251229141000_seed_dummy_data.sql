-- Seed dummy data across core tables
BEGIN;

WITH p AS (
  INSERT INTO public.profiles (id, full_name, email)
  VALUES
    (gen_random_uuid(), 'Alice Johnson', 'alice@example.com'),
    (gen_random_uuid(), 'Bob Smith', 'bob@example.com'),
    (gen_random_uuid(), 'Charlie Lee', 'charlie@example.com')
  RETURNING id, full_name, email
),
dept AS (
  INSERT INTO public.departments (id, name)
  VALUES
    (gen_random_uuid(), 'Engineering'),
    (gen_random_uuid(), 'Sales')
  RETURNING id, name
),
des AS (
  INSERT INTO public.designations (id, title)
  VALUES
    (gen_random_uuid(), 'Software Engineer'),
    (gen_random_uuid(), 'Account Executive')
  RETURNING id, title
),
comp AS (
  INSERT INTO public.companies (id, name)
  VALUES
    (gen_random_uuid(), 'Acme Corp'),
    (gen_random_uuid(), 'Globex Inc')
  RETURNING id, name
),
cont AS (
  INSERT INTO public.contacts (id, first_name, last_name, email, phone)
  VALUES
    (gen_random_uuid(), 'John', 'Doe', 'john.doe@acme.com', '+1 555 0100'),
    (gen_random_uuid(), 'Jane', 'Roe', 'jane.roe@globex.com', '+1 555 0101')
  RETURNING id, first_name, last_name
),
emp AS (
  INSERT INTO public.employees (id, employee_id, user_id, department_id, designation_id, phone, address, salary, hire_date, status)
  SELECT gen_random_uuid(),
         'EMP001',
         (SELECT id FROM p LIMIT 1),
         (SELECT id FROM dept WHERE name = 'Engineering'),
         (SELECT id FROM des WHERE title = 'Software Engineer'),
         '+1 555 1001',
         '123 Main St',
         90000,
         CURRENT_DATE,
         'active'
  RETURNING id
),
lead AS (
  INSERT INTO public.leads (id, title, company_name, status, value)
  VALUES
    (gen_random_uuid(), 'Website Redesign', 'Acme Corp', 'proposal', 25000),
    (gen_random_uuid(), 'CRM Implementation', 'Globex Inc', 'qualified', 40000)
  RETURNING id, title, company_name
),
t_dummy AS (
  SELECT 1
),
t AS (
  INSERT INTO public.tasks (id, title, description, priority, status, assigned_to, lead_id, deal_id)
  SELECT gen_random_uuid(), 'Design Kickoff', 'Prepare kickoff materials', 'medium', 'todo',
         (SELECT id FROM p WHERE full_name = 'Alice Johnson'),
         (SELECT id FROM lead WHERE company_name = 'Acme Corp'),
         NULL
  UNION ALL
  SELECT gen_random_uuid(), 'CRM Data Audit', 'Audit current data quality', 'high', 'in_progress',
         (SELECT id FROM p WHERE full_name = 'Bob Smith'),
         (SELECT id FROM lead WHERE company_name = 'Globex Inc'),
         NULL
  RETURNING id, title, assigned_to
),
tc AS (
  INSERT INTO public.task_collaborators (task_id, user_id)
  SELECT (SELECT id FROM t LIMIT 1), (SELECT id FROM p WHERE full_name = 'Charlie Lee')
  UNION ALL
  SELECT (SELECT id FROM t OFFSET 1 LIMIT 1), (SELECT id FROM p WHERE full_name = 'Alice Johnson')
  RETURNING task_id
),
tt AS (
  INSERT INTO public.task_timings (task_id, assigned_at, started_at)
  SELECT (SELECT id FROM t LIMIT 1), now(), NULL
  UNION ALL
  SELECT (SELECT id FROM t OFFSET 1 LIMIT 1), now() - INTERVAL '1 day', now() - INTERVAL '12 hours'
  RETURNING task_id
),
msg AS (
  INSERT INTO public.messages (entity_type, entity_id, author_id, content, mentions)
  SELECT 'task', (SELECT id FROM t LIMIT 1), (SELECT id FROM p WHERE full_name = 'Alice Johnson'),
         'Kickoff scheduled for next week', ARRAY[(SELECT id FROM p WHERE full_name = 'Bob Smith')]
  UNION ALL
  SELECT 'lead', (SELECT id FROM lead WHERE company_name = 'Acme Corp'), (SELECT id FROM p WHERE full_name = 'Charlie Lee'),
         'Sent initial proposal draft', '{}'
  RETURNING id
),
notif AS (
  INSERT INTO public.notifications (user_id, type, entity_type, entity_id, title, body)
  SELECT (SELECT id FROM p WHERE full_name = 'Alice Johnson'), 'comment', 'task', (SELECT id FROM t LIMIT 1), 'New comment', 'Kickoff scheduled for next week'
  UNION ALL
  SELECT (SELECT id FROM p WHERE full_name = 'Bob Smith'), 'update', 'lead', (SELECT id FROM lead WHERE company_name = 'Globex Inc'), 'Lead updated', 'Moved to qualified'
  RETURNING id
),
pay AS (
  INSERT INTO public.payroll (id, employee_id, month, year, basic_salary, allowances, deductions, net_salary, status)
  SELECT gen_random_uuid(), (SELECT id FROM emp), EXTRACT(MONTH FROM CURRENT_DATE)::int, EXTRACT(YEAR FROM CURRENT_DATE)::int, 90000, 5000, 1000, 94000, 'pending'
  RETURNING id
),
att AS (
  INSERT INTO public.attendance (id, employee_id, date, status, punch_in, punch_out)
  SELECT gen_random_uuid(), (SELECT id FROM emp), CURRENT_DATE - INTERVAL '1 day', 'present', now() - INTERVAL '1 day' + INTERVAL '9 hours', now() - INTERVAL '1 day' + INTERVAL '17 hours'
  UNION ALL
  SELECT gen_random_uuid(), (SELECT id FROM emp), CURRENT_DATE, 'present', now() + INTERVAL '9 hours', NULL
  RETURNING id
)
SELECT 1;

COMMIT;
