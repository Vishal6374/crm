BEGIN;

-- Global sequence for employee numbers (ensures uniqueness)
CREATE SEQUENCE IF NOT EXISTS public.employee_number_seq;

-- Generates IDs like EMP00001, EMP00002, ...
CREATE OR REPLACE FUNCTION public.generate_employee_id()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  _n BIGINT;
BEGIN
  _n := nextval('public.employee_number_seq');
  RETURN 'EMP' || lpad(_n::text, 5, '0');
END;
$$;

-- Trigger: set employee_id if missing
CREATE OR REPLACE FUNCTION public.set_employee_id_on_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.employee_id IS NULL OR btrim(COALESCE(NEW.employee_id, '')) = '' THEN
    NEW.employee_id := public.generate_employee_id();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_set_employee_id ON public.employees;
CREATE TRIGGER trg_set_employee_id
BEFORE INSERT ON public.employees
FOR EACH ROW
EXECUTE FUNCTION public.set_employee_id_on_insert();

COMMIT;

