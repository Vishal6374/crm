--
-- PostgreSQL database dump
--

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: app_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.app_role AS ENUM (
    'admin',
    'manager',
    'employee',
    'tenant_admin',
    'hr',
    'finance',
    'viewer',
    'super_admin'
);


ALTER TYPE public.app_role OWNER TO postgres;

--
-- Name: attendance_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendance_status AS ENUM (
    'present',
    'absent',
    'late',
    'half_day'
);


ALTER TYPE public.attendance_status OWNER TO postgres;

--
-- Name: chat_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.chat_type AS ENUM (
    'direct',
    'group',
    'project',
    'department'
);


ALTER TYPE public.chat_type OWNER TO postgres;

--
-- Name: deal_stage; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.deal_stage AS ENUM (
    'prospecting',
    'qualification',
    'proposal',
    'negotiation',
    'closed_won',
    'closed_lost'
);


ALTER TYPE public.deal_stage OWNER TO postgres;

--
-- Name: employee_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.employee_status AS ENUM (
    'active',
    'inactive',
    'terminated'
);


ALTER TYPE public.employee_status OWNER TO postgres;

--
-- Name: entity_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.entity_type AS ENUM (
    'task',
    'deal',
    'lead',
    'chat_channel',
    'chat_message'
);


ALTER TYPE public.entity_type OWNER TO postgres;

--
-- Name: event_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.event_type AS ENUM (
    'task',
    'meeting',
    'leave'
);


ALTER TYPE public.event_type OWNER TO postgres;

--
-- Name: lead_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.lead_status AS ENUM (
    'new',
    'contacted',
    'qualified',
    'proposal',
    'negotiation',
    'won',
    'lost'
);


ALTER TYPE public.lead_status OWNER TO postgres;

--
-- Name: leave_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.leave_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.leave_status OWNER TO postgres;

--
-- Name: leave_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.leave_type AS ENUM (
    'annual',
    'sick',
    'maternity',
    'paternity',
    'emergency'
);


ALTER TYPE public.leave_type OWNER TO postgres;

--
-- Name: org_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.org_role AS ENUM (
    'owner',
    'admin',
    'member'
);


ALTER TYPE public.org_role OWNER TO postgres;

--
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'pending',
    'paid',
    'failed'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- Name: payroll_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payroll_status AS ENUM (
    'pending',
    'approved',
    'processed',
    'paid'
);


ALTER TYPE public.payroll_status OWNER TO postgres;

--
-- Name: task_priority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_priority AS ENUM (
    'low',
    'medium',
    'high',
    'urgent'
);


ALTER TYPE public.task_priority OWNER TO postgres;

--
-- Name: task_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_status AS ENUM (
    'todo',
    'in_progress',
    'completed',
    'cancelled'
);


ALTER TYPE public.task_status OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: add_creator_to_participants(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_creator_to_participants() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.chat_participants (channel_id, user_id)
  VALUES (NEW.id, NEW.created_by);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_creator_to_participants() OWNER TO postgres;

--
-- Name: can_capability(uuid, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.can_capability(_user_id uuid, _module text, _cap text) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  _org UUID;
  _role public.app_role;
  _cap_row RECORD;
BEGIN
  SELECT organization_id INTO _org FROM public.profiles WHERE id = _user_id;
  IF _org IS NULL THEN
    RETURN false;
  END IF;
  SELECT role INTO _role FROM public.user_roles WHERE user_id = _user_id AND organization_id = _org LIMIT 1;
  IF _role IS NULL THEN
    RETURN false;
  END IF;
  SELECT * INTO _cap_row FROM public.role_capabilities 
    WHERE organization_id = _org AND role = _role AND module = _module LIMIT 1;
  IF NOT FOUND THEN
    RETURN false;
  END IF;
  IF _cap = 'can_view' THEN
    RETURN COALESCE(_cap_row.can_view, false);
  ELSIF _cap = 'can_create' THEN
    RETURN COALESCE(_cap_row.can_create, false);
  ELSIF _cap = 'can_edit' THEN
    RETURN COALESCE(_cap_row.can_edit, false);
  ELSIF _cap = 'can_approve' THEN
    RETURN COALESCE(_cap_row.can_approve, false);
  ELSE
    RETURN false;
  END IF;
END;
$$;


ALTER FUNCTION public.can_capability(_user_id uuid, _module text, _cap text) OWNER TO postgres;

--
-- Name: cleanup_activity_logs(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_activity_logs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.organization_id IS NOT NULL THEN
    DELETE FROM public.activity_logs
    WHERE id IN (
      SELECT id FROM public.activity_logs
      WHERE organization_id = NEW.organization_id
      ORDER BY created_at DESC
      OFFSET 500
    );
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.cleanup_activity_logs() OWNER TO postgres;

--
-- Name: clone_payroll_month(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.clone_payroll_month(source_month integer, source_year integer, target_month integer, target_year integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  _count INTEGER;
  _org UUID;
BEGIN
  _org := public.current_org_id();

  INSERT INTO public.payroll (
    organization_id,
    employee_id,
    month,
    year,
    basic_salary,
    allowances,
    deductions,
    net_salary,
    status
  )
  SELECT 
    organization_id,
    employee_id,
    target_month,
    target_year,
    basic_salary,
    allowances,
    deductions,
    net_salary,
    'pending' -- Draft status
  FROM public.payroll
  WHERE month = source_month 
    AND year = source_year
    AND organization_id = _org
    AND NOT EXISTS (
      SELECT 1 FROM public.payroll p2 
      WHERE p2.employee_id = payroll.employee_id 
        AND p2.month = target_month 
        AND p2.year = target_year
    );
    
  GET DIAGNOSTICS _count = ROW_COUNT;
  RETURN _count;
END;
$$;


ALTER FUNCTION public.clone_payroll_month(source_month integer, source_year integer, target_month integer, target_year integer) OWNER TO postgres;

--
-- Name: create_department_chat_channel(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_department_chat_channel() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _channel_id UUID;
BEGIN
  -- Check if channel already exists
  IF EXISTS (SELECT 1 FROM public.chat_channels WHERE department_id = NEW.id) THEN
    RETURN NEW;
  END IF;

  INSERT INTO public.chat_channels (organization_id, name, type, department_id, created_by)
  VALUES (NEW.organization_id, NEW.name, 'department', NEW.id, NEW.manager_id)
  RETURNING id INTO _channel_id;

  -- Add manager as participant if exists
  IF NEW.manager_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_channel_id, NEW.manager_id)
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.create_department_chat_channel() OWNER TO postgres;

--
-- Name: current_org_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.current_org_id() RETURNS uuid
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT organization_id FROM public.profiles WHERE id = auth.uid()
$$;


ALTER FUNCTION public.current_org_id() OWNER TO postgres;

--
-- Name: enforce_single_tenant_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.enforce_single_tenant_admin() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.role = 'tenant_admin' THEN
    IF EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE organization_id = NEW.organization_id
        AND role = 'tenant_admin'
        AND (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND id <> NEW.id))
    ) THEN
      RAISE EXCEPTION 'Only one tenant_admin allowed per organization';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.enforce_single_tenant_admin() OWNER TO postgres;

--
-- Name: get_project_owner(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_project_owner(p_id uuid) RETURNS uuid
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
  SELECT owner_id FROM public.projects WHERE id = p_id
$$;


ALTER FUNCTION public.get_project_owner(p_id uuid) OWNER TO postgres;

--
-- Name: handle_lead_qualification(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_lead_qualification() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _company_id UUID;
  _contact_id UUID;
BEGIN
  IF NEW.status = 'qualified' AND OLD.status <> 'qualified' THEN
    -- 1. Create Company if missing
    IF NEW.company_id IS NULL AND NEW.company_name IS NOT NULL THEN
       -- Check if exists by name to avoid duplicates?
       SELECT id INTO _company_id FROM public.companies WHERE name = NEW.company_name LIMIT 1;
       
       IF _company_id IS NULL THEN
         INSERT INTO public.companies (name, created_by, organization_id)
         VALUES (NEW.company_name, NEW.created_by, NEW.organization_id)
         RETURNING id INTO _company_id;
       END IF;
       
       NEW.company_id := _company_id;
    END IF;

    -- 2. Create Contact if missing
    IF NEW.contact_id IS NULL AND NEW.contact_name IS NOT NULL THEN
       -- Split name?
       INSERT INTO public.contacts (first_name, last_name, company_id, created_by, organization_id)
       VALUES (
         split_part(NEW.contact_name, ' ', 1), 
         CASE WHEN strpos(NEW.contact_name, ' ') > 0 THEN substr(NEW.contact_name, strpos(NEW.contact_name, ' ') + 1) ELSE '' END,
         NEW.company_id,
         NEW.created_by,
         NEW.organization_id
       )
       RETURNING id INTO _contact_id;
       
       NEW.contact_id := _contact_id;
    END IF;
    
    -- 3. Auto-convert to Deal? (Optional per spec, but useful)
    -- Spec 4.3 "Convert Lead -> Deal".
    -- Let's just link Company/Contact for now.
    
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_lead_qualification() OWNER TO postgres;

--
-- Name: handle_new_project_chat(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_project_chat() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _channel_id UUID;
  _owner_id UUID;
BEGIN
  _owner_id := COALESCE(NEW.owner_id, auth.uid());
  
  -- Check if channel already exists (should not happen on insert, but safe check)
  SELECT id INTO _channel_id FROM public.chat_channels WHERE project_id = NEW.id LIMIT 1;
  
  IF _channel_id IS NULL THEN
    INSERT INTO public.chat_channels (organization_id, project_id, name, type, created_by)
    VALUES (NEW.organization_id, NEW.id, COALESCE('Project: ' || NEW.name, 'Project Chat'), 'group', _owner_id)
    RETURNING id INTO _channel_id;
  END IF;

  -- Add owner as participant
  IF _owner_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)
    VALUES (_channel_id, _owner_id, NEW.organization_id)
    ON CONFLICT (channel_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_project_chat() OWNER TO postgres;

--
-- Name: handle_new_project_member(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_project_member() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _channel_id UUID;
  _user_id UUID;
  _org_id UUID;
BEGIN
  -- Get project channel and org_id
  SELECT id, organization_id INTO _channel_id, _org_id
  FROM public.chat_channels
  WHERE project_id = NEW.project_id
  LIMIT 1;

  -- If no channel linked to project, try to find one or bail out (usually created by project trigger)
  IF _channel_id IS NULL THEN
    -- Fallback: Check if we can create one? No, better to wait or log.
    -- But for now, let's just return.
    RETURN NEW;
  END IF;

  -- Get user_id from employee
  SELECT user_id INTO _user_id
  FROM public.employees
  WHERE id = NEW.employee_id;

  IF _user_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)
    VALUES (_channel_id, _user_id, _org_id)
    ON CONFLICT (channel_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_project_member() OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  _org_id UUID;
  _role TEXT;
  _invite_id UUID;
  _default_org UUID;
BEGIN
  BEGIN
    SELECT organization_id, role, id
    INTO _org_id, _role, _invite_id
    FROM public.invitations
    WHERE email = NEW.email AND status = 'pending'
    ORDER BY created_at DESC
    LIMIT 1;
  EXCEPTION WHEN others THEN
    _org_id := NULL;
    _role := NULL;
    _invite_id := NULL;
  END;

  IF _org_id IS NULL THEN
    SELECT id INTO _default_org FROM public.organizations WHERE name = 'Default Organization' LIMIT 1;
    IF _default_org IS NULL THEN
      BEGIN
        INSERT INTO public.organizations (name) VALUES ('Default Organization')
        RETURNING id INTO _default_org;
      EXCEPTION WHEN others THEN
        SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;
      END;
    END IF;
    _org_id := _default_org;
    IF _role IS NULL THEN
      _role := 'employee';
    END IF;
  END IF;

  BEGIN
    INSERT INTO public.profiles (id, email, full_name, organization_id)
    VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.email), _org_id)
    ON CONFLICT (id) DO NOTHING;
  EXCEPTION WHEN others THEN
    NULL;
  END;

  BEGIN
    INSERT INTO public.user_roles (user_id, role, organization_id)
    VALUES (NEW.id, _role, _org_id)
    ON CONFLICT DO NOTHING;
  EXCEPTION WHEN others THEN
    NULL;
  END;

  IF _invite_id IS NOT NULL THEN
    BEGIN
      UPDATE public.invitations SET status = 'accepted' WHERE id = _invite_id;
    EXCEPTION WHEN others THEN
      NULL;
    END;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: has_role(uuid, public.app_role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_role(_user_id uuid, _role public.app_role) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;


ALTER FUNCTION public.has_role(_user_id uuid, _role public.app_role) OWNER TO postgres;

--
-- Name: is_admin_or_manager(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin_or_manager(_user_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role IN ('admin', 'manager')
  )
$$;


ALTER FUNCTION public.is_admin_or_manager(_user_id uuid) OWNER TO postgres;

--
-- Name: is_channel_creator(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_channel_creator(_channel_id uuid) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM chat_channels
    WHERE id = _channel_id AND created_by = auth.uid()
  );
$$;


ALTER FUNCTION public.is_channel_creator(_channel_id uuid) OWNER TO postgres;

--
-- Name: is_chat_participant(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_chat_participant(_channel_id uuid) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM chat_participants
    WHERE channel_id = _channel_id AND user_id = auth.uid()
  );
$$;


ALTER FUNCTION public.is_chat_participant(_channel_id uuid) OWNER TO postgres;

--
-- Name: is_event_creator(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_event_creator(_event_id uuid, _user_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.events e
    WHERE e.id = _event_id AND e.created_by = _user_id
  )
$$;


ALTER FUNCTION public.is_event_creator(_event_id uuid, _user_id uuid) OWNER TO postgres;

--
-- Name: is_hr(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_hr(_user_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = 'hr'
  )
$$;


ALTER FUNCTION public.is_hr(_user_id uuid) OWNER TO postgres;

--
-- Name: is_manager(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_manager(_user_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = 'manager'
  )
$$;


ALTER FUNCTION public.is_manager(_user_id uuid) OWNER TO postgres;

--
-- Name: is_project_manager(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_project_manager(_project_id uuid, _user_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id
      AND e.user_id = _user_id
      AND lower(pm.role) = 'manager'
  );
END;
$$;


ALTER FUNCTION public.is_project_manager(_project_id uuid, _user_id uuid) OWNER TO postgres;

--
-- Name: is_project_member_or_owner(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_project_member_or_owner(_project_id uuid, _user_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  -- Direct check on project_members (bypassing RLS due to SD)
  IF EXISTS (
    SELECT 1 FROM public.project_members pm
    JOIN public.employees e ON e.id = pm.employee_id
    WHERE pm.project_id = _project_id AND e.user_id = _user_id
  ) THEN
    RETURN TRUE;
  END IF;

  -- Direct check on projects (bypassing RLS due to SD)
  IF EXISTS (SELECT 1 FROM public.projects WHERE id = _project_id AND owner_id = _user_id) THEN
    RETURN TRUE;
  END IF;
  
  RETURN FALSE;
END;
$$;


ALTER FUNCTION public.is_project_member_or_owner(_project_id uuid, _user_id uuid) OWNER TO postgres;

--
-- Name: is_super_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_super_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT COALESCE(super_admin, false) FROM public.profiles WHERE id = auth.uid()
$$;


ALTER FUNCTION public.is_super_admin() OWNER TO postgres;

--
-- Name: is_tenant_admin(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_tenant_admin(_user_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = 'tenant_admin'
  )
$$;


ALTER FUNCTION public.is_tenant_admin(_user_id uuid) OWNER TO postgres;

--
-- Name: join_department_chat_channel(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.join_department_chat_channel() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _channel_id UUID;
  _dept_id UUID;
BEGIN
  _dept_id := NEW.department_id;

  IF _dept_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Find the chat channel for this department
  SELECT id INTO _channel_id FROM public.chat_channels 
  WHERE department_id = _dept_id
  LIMIT 1;

  IF _channel_id IS NOT NULL AND NEW.user_id IS NOT NULL THEN
    INSERT INTO public.chat_participants (channel_id, user_id)
    VALUES (_channel_id, NEW.user_id)
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.join_department_chat_channel() OWNER TO postgres;

--
-- Name: log_activity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_activity() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _action TEXT;
  _desc TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    _action := 'created';
    _desc := 'Created ' || TG_TABLE_NAME;
  ELSIF TG_OP = 'UPDATE' THEN
    _action := 'updated';
    _desc := 'Updated ' || TG_TABLE_NAME;
  ELSIF TG_OP = 'DELETE' THEN
    _action := 'deleted';
    _desc := 'Deleted ' || TG_TABLE_NAME;
  END IF;

  INSERT INTO public.activity_logs (user_id, action, entity_type, entity_id, description, organization_id)
  VALUES (auth.uid(), _action, TG_TABLE_NAME, COALESCE(NEW.id, OLD.id), _desc, COALESCE(NEW.organization_id, OLD.organization_id));
  
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.log_activity() OWNER TO postgres;

--
-- Name: log_activity_fn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_activity_fn() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.activity_logs (action, entity_type, entity_id, description, user_id)
  VALUES (
    TG_OP,
    TG_TABLE_NAME,
    NEW.id,
    TG_OP || ' on ' || TG_TABLE_NAME,
    auth.uid()
  );
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_activity_fn() OWNER TO postgres;

--
-- Name: notify_chat_participants(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_chat_participants() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _participant_id UUID;
BEGIN
  FOR _participant_id IN
    SELECT user_id FROM public.chat_participants
    WHERE channel_id = NEW.channel_id AND user_id != NEW.sender_id
  LOOP
    INSERT INTO public.notifications (user_id, type, entity_type, entity_id, title, body)
    VALUES (
      _participant_id,
      'message',
      'chat_channel',
      NEW.channel_id,
      'New Message',
      substring(NEW.content from 1 for 50)
    );
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_chat_participants() OWNER TO postgres;

--
-- Name: notify_leave_decision(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_leave_decision() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _employee_user UUID;
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status AND NEW.status IN ('approved','rejected') THEN
    SELECT user_id INTO _employee_user FROM public.employees WHERE id = NEW.employee_id;
    IF _employee_user IS NOT NULL THEN
      INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)
      VALUES (
        _employee_user,
        'leave_decision',
        CASE NEW.status WHEN 'approved' THEN 'Leave Approved' ELSE 'Leave Rejected' END,
        COALESCE(NEW.reason, ''),
        'leave_request',
        NEW.id,
        public.current_org_id()
      );
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_leave_decision() OWNER TO postgres;

--
-- Name: notify_leave_status_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_leave_status_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO public.notifications (user_id, title, message, type, organization_id)
    SELECT 
      e.user_id,
      'Leave Request ' || NEW.status,
      'Your leave request from ' || NEW.start_date || ' to ' || NEW.end_date || ' has been ' || NEW.status,
      'leave_update',
      NEW.organization_id
    FROM public.employees e
    WHERE e.id = NEW.employee_id;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_leave_status_change() OWNER TO postgres;

--
-- Name: notify_payroll_approval(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_payroll_approval() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  _employee_user UUID;
BEGIN
  IF NEW.approval_status IS DISTINCT FROM OLD.approval_status THEN
    SELECT user_id INTO _employee_user FROM public.employees WHERE id = NEW.employee_id;
    IF _employee_user IS NOT NULL THEN
      INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)
      VALUES (
        _employee_user,
        'payroll_approval',
        CASE NEW.approval_status WHEN 'approved' THEN 'Payroll Approved' ELSE 'Payroll Rejected' END,
        COALESCE(NEW.decision_note, ''),
        'payroll',
        NEW.id,
        public.current_org_id()
      );
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_payroll_approval() OWNER TO postgres;

--
-- Name: retain_activity_logs_limit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.retain_activity_logs_limit() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  WITH ranked AS (
    SELECT id,
           organization_id,
           created_at,
           row_number() OVER (PARTITION BY organization_id ORDER BY created_at DESC) AS rn
    FROM public.activity_logs
  )
  DELETE FROM public.activity_logs al
  USING ranked r
  WHERE al.id = r.id
    AND r.rn > 500;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.retain_activity_logs_limit() OWNER TO postgres;

--
-- Name: set_org_id_on_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_org_id_on_insert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_org_id_on_insert() OWNER TO postgres;

--
-- Name: set_org_id_on_insert_email_templates(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_org_id_on_insert_email_templates() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_org_id_on_insert_email_templates() OWNER TO postgres;

--
-- Name: set_org_id_on_insert_emails_outbox(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_org_id_on_insert_emails_outbox() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_org_id_on_insert_emails_outbox() OWNER TO postgres;

--
-- Name: set_org_id_on_insert_event_attendees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_org_id_on_insert_event_attendees() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_org_id_on_insert_event_attendees() OWNER TO postgres;

--
-- Name: set_org_id_on_insert_messages(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_org_id_on_insert_messages() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF NEW.organization_id IS NULL THEN
    NEW.organization_id = public.current_org_id();
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_org_id_on_insert_messages() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


ALTER FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_update_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_level_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.prefixes_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    action text NOT NULL,
    entity_type text,
    entity_id uuid,
    description text,
    ip_address text,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    module text,
    record_id uuid,
    organization_id uuid NOT NULL
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id uuid NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    check_in time without time zone,
    check_out time without time zone,
    status public.attendance_status DEFAULT 'present'::public.attendance_status NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    punch_in timestamp with time zone,
    punch_out timestamp with time zone,
    organization_id uuid NOT NULL
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: chat_channels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_channels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type public.chat_type NOT NULL,
    name text,
    department_id uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL,
    project_id uuid
);


ALTER TABLE public.chat_channels OWNER TO postgres;

--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    channel_id uuid,
    sender_id uuid,
    content text NOT NULL,
    attachments jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.chat_messages OWNER TO postgres;

--
-- Name: chat_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_participants (
    channel_id uuid NOT NULL,
    user_id uuid NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    last_read_at timestamp with time zone,
    organization_id uuid NOT NULL
);


ALTER TABLE public.chat_participants OWNER TO postgres;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    industry text,
    website text,
    phone text,
    email text,
    address text,
    city text,
    country text,
    logo_url text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name text NOT NULL,
    last_name text,
    email text,
    phone text,
    company_id uuid,
    "position" text,
    notes text,
    avatar_url text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text GENERATED ALWAYS AS ((first_name ||
CASE
    WHEN ((last_name IS NOT NULL) AND (length(last_name) > 0)) THEN (' '::text || last_name)
    ELSE ''::text
END)) STORED,
    organization_id uuid NOT NULL
);


ALTER TABLE public.contacts OWNER TO postgres;

--
-- Name: deals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    value numeric(15,2) DEFAULT 0,
    stage public.deal_stage DEFAULT 'prospecting'::public.deal_stage NOT NULL,
    probability integer DEFAULT 0,
    expected_close_date date,
    assigned_to uuid,
    company_id uuid,
    contact_id uuid,
    lead_id uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    amount numeric(12,2),
    organization_id uuid NOT NULL,
    CONSTRAINT deals_probability_check CHECK (((probability >= 0) AND (probability <= 100)))
);


ALTER TABLE public.deals OWNER TO postgres;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    manager_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: designations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.designations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    department_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.designations OWNER TO postgres;

--
-- Name: email_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    name text NOT NULL,
    subject text NOT NULL,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


ALTER TABLE public.email_templates OWNER TO postgres;

--
-- Name: emails_outbox; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emails_outbox (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id uuid,
    recipient_user_id uuid,
    recipient_email text,
    status text DEFAULT 'queued'::text NOT NULL,
    sent_at timestamp with time zone,
    organization_id uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.emails_outbox OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    employee_id text NOT NULL,
    department_id uuid,
    designation_id uuid,
    hire_date date DEFAULT CURRENT_DATE NOT NULL,
    salary numeric(15,2) DEFAULT 0,
    status public.employee_status DEFAULT 'active'::public.employee_status NOT NULL,
    phone text,
    address text,
    emergency_contact text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: event_attendees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_attendees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid
);


ALTER TABLE public.event_attendees OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    type public.event_type NOT NULL,
    related_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    meeting_link text,
    created_by uuid
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: invitations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    organization_id uuid NOT NULL,
    role text DEFAULT 'employee'::text NOT NULL,
    token text DEFAULT (gen_random_uuid())::text,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


ALTER TABLE public.invitations OWNER TO postgres;

--
-- Name: leads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    value numeric(15,2) DEFAULT 0,
    status public.lead_status DEFAULT 'new'::public.lead_status NOT NULL,
    source text,
    assigned_to uuid,
    company_id uuid,
    contact_id uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    company_name text NOT NULL,
    contact_name text NOT NULL,
    email text,
    phone text,
    notes text,
    name text,
    organization_id uuid NOT NULL
);


ALTER TABLE public.leads OWNER TO postgres;

--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id uuid NOT NULL,
    leave_type public.leave_type DEFAULT 'annual'::public.leave_type NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    reason text,
    status public.leave_status DEFAULT 'pending'::public.leave_status NOT NULL,
    approved_by uuid,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.leave_requests OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_type public.entity_type NOT NULL,
    entity_id uuid NOT NULL,
    author_id uuid NOT NULL,
    content text NOT NULL,
    mentions uuid[] DEFAULT '{}'::uuid[],
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    type text NOT NULL,
    entity_type public.entity_type,
    entity_id uuid,
    title text,
    body text,
    read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL,
    project_id uuid,
    meeting_id uuid
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    status text DEFAULT 'active'::text,
    CONSTRAINT organizations_status_check CHECK ((status = ANY (ARRAY['active'::text, 'suspended'::text])))
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deal_id uuid,
    amount numeric(12,2) NOT NULL,
    status public.payment_status DEFAULT 'pending'::public.payment_status NOT NULL,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payroll; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id uuid NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    basic_salary numeric(15,2) DEFAULT 0,
    allowances numeric(15,2) DEFAULT 0,
    deductions numeric(15,2) DEFAULT 0,
    net_salary numeric(15,2) DEFAULT 0,
    status public.payroll_status DEFAULT 'pending'::public.payroll_status NOT NULL,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    basic numeric(12,2),
    net_pay numeric(12,2),
    organization_id uuid NOT NULL,
    approval_status text,
    approved_by uuid,
    approved_at timestamp with time zone,
    decision_note text,
    rejection_note text,
    CONSTRAINT payroll_approval_status_check CHECK ((approval_status = ANY (ARRAY['approved'::text, 'rejected'::text]))),
    CONSTRAINT payroll_month_check CHECK (((month >= 1) AND (month <= 12)))
);


ALTER TABLE public.payroll OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    email text NOT NULL,
    full_name text,
    avatar_url text,
    is_active boolean DEFAULT true,
    last_login timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL,
    super_admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: project_meetings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_meetings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    title text NOT NULL,
    meeting_link text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.project_meetings OWNER TO postgres;

--
-- Name: project_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    role text,
    added_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.project_members OWNER TO postgres;

--
-- Name: project_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    title text NOT NULL,
    description text,
    status text DEFAULT 'todo'::text,
    priority text DEFAULT 'medium'::text,
    assigned_to uuid,
    created_by uuid,
    due_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    organization_id uuid NOT NULL
);


ALTER TABLE public.project_tasks OWNER TO postgres;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    owner_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: role_capabilities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_capabilities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    role public.app_role NOT NULL,
    module text NOT NULL,
    can_view boolean DEFAULT true NOT NULL,
    can_create boolean DEFAULT false NOT NULL,
    can_edit boolean DEFAULT false NOT NULL,
    can_approve boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.role_capabilities OWNER TO postgres;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key text NOT NULL,
    value jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: task_collaborators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_collaborators (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.task_collaborators OWNER TO postgres;

--
-- Name: task_timings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_timings (
    task_id uuid NOT NULL,
    assigned_at timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    total_seconds integer
);


ALTER TABLE public.task_timings OWNER TO postgres;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    status public.task_status DEFAULT 'todo'::public.task_status NOT NULL,
    priority public.task_priority DEFAULT 'medium'::public.task_priority NOT NULL,
    assigned_to uuid,
    created_by uuid NOT NULL,
    due_date timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    related_type text,
    related_id uuid,
    lead_id uuid,
    deal_id uuid,
    owner_id uuid,
    organization_id uuid NOT NULL,
    project_id uuid,
    CONSTRAINT tasks_related_type_check CHECK ((related_type = ANY (ARRAY['lead'::text, 'deal'::text, 'contact'::text])))
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tenant_modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenant_modules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    module text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tenant_modules OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role public.app_role DEFAULT 'employee'::public.app_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_12_29; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_12_29 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_12_29 OWNER TO supabase_admin;

--
-- Name: messages_2025_12_30; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_12_30 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_12_30 OWNER TO supabase_admin;

--
-- Name: messages_2025_12_31; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_12_31 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_12_31 OWNER TO supabase_admin;

--
-- Name: messages_2026_01_01; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_01_01 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_01_01 OWNER TO supabase_admin;

--
-- Name: messages_2026_01_02; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_01_02 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_01_02 OWNER TO supabase_admin;

--
-- Name: messages_2026_01_03; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_01_03 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_01_03 OWNER TO supabase_admin;

--
-- Name: messages_2026_01_04; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_01_04 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_01_04 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: messages_2025_12_29; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_12_29 FOR VALUES FROM ('2025-12-29 00:00:00') TO ('2025-12-30 00:00:00');


--
-- Name: messages_2025_12_30; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_12_30 FOR VALUES FROM ('2025-12-30 00:00:00') TO ('2025-12-31 00:00:00');


--
-- Name: messages_2025_12_31; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_12_31 FOR VALUES FROM ('2025-12-31 00:00:00') TO ('2026-01-01 00:00:00');


--
-- Name: messages_2026_01_01; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_01_01 FOR VALUES FROM ('2026-01-01 00:00:00') TO ('2026-01-02 00:00:00');


--
-- Name: messages_2026_01_02; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_01_02 FOR VALUES FROM ('2026-01-02 00:00:00') TO ('2026-01-03 00:00:00');


--
-- Name: messages_2026_01_03; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_01_03 FOR VALUES FROM ('2026-01-03 00:00:00') TO ('2026-01-04 00:00:00');


--
-- Name: messages_2026_01_04; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_01_04 FOR VALUES FROM ('2026-01-04 00:00:00') TO ('2026-01-05 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
b31edec7-f7a1-4c28-837f-9b9848caf405	b31edec7-f7a1-4c28-837f-9b9848caf405	{"sub": "b31edec7-f7a1-4c28-837f-9b9848caf405", "email": "vishalmurugavel105@gmail.com", "full_name": "admin", "email_verified": true, "phone_verified": false}	email	2025-12-29 05:33:52.886477+00	2025-12-29 05:33:52.886566+00	2025-12-29 05:33:52.886566+00	8fbbbe06-db4d-4d1f-a8ba-40bb45e45f3d
35ad9461-0240-487c-9dfb-9883cca83fef	35ad9461-0240-487c-9dfb-9883cca83fef	{"sub": "35ad9461-0240-487c-9dfb-9883cca83fef", "email": "admin@crm.test", "email_verified": false, "phone_verified": false}	email	2025-12-29 15:15:04.742956+00	2025-12-29 15:15:04.743024+00	2025-12-29 15:15:04.743024+00	69b4ca23-e658-453d-8f7f-587876ceb97e
b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	{"sub": "b0a4215b-381d-4e6e-b1e2-97e94d2a4a66", "email": "manager@crm.test", "email_verified": false, "phone_verified": false}	email	2025-12-29 15:15:32.005808+00	2025-12-29 15:15:32.005867+00	2025-12-29 15:15:32.005867+00	f7486bb9-9d96-4112-aded-4390a0ec0838
984d4095-ec12-4d0a-9ec9-5ffb28ed133d	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	{"sub": "984d4095-ec12-4d0a-9ec9-5ffb28ed133d", "email": "employee@crm.test", "email_verified": false, "phone_verified": false}	email	2025-12-29 15:15:45.340635+00	2025-12-29 15:15:45.340686+00	2025-12-29 15:15:45.340686+00	e226a9cc-af3a-4cec-954d-5be9d25906af
1808cd63-8cef-4e66-8cb0-67e68251f22c	1808cd63-8cef-4e66-8cb0-67e68251f22c	{"sub": "1808cd63-8cef-4e66-8cb0-67e68251f22c", "email": "gowthamp990@gmail.com", "full_name": "Gowtham", "email_verified": false, "phone_verified": false}	email	2025-12-30 06:29:10.303488+00	2025-12-30 06:29:10.30355+00	2025-12-30 06:29:10.30355+00	7b95051a-e560-45f6-b976-8bfc5ee60c8c
1c786a19-b2ca-41fd-8750-f427fb4c6b76	1c786a19-b2ca-41fd-8750-f427fb4c6b76	{"sub": "1c786a19-b2ca-41fd-8750-f427fb4c6b76", "email": "gowthamp1614@gmail.com", "full_name": "Gowtham", "email_verified": true, "phone_verified": false}	email	2025-12-30 06:42:17.559258+00	2025-12-30 06:42:17.559315+00	2025-12-30 06:42:17.559315+00	a8f4bb7b-e089-475c-b419-a817c2703f3a
f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8	f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8	{"sub": "f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8", "email": "dev.user.ccbfc6c7-b407-4519-ad7d-db6896970a86@example.com", "full_name": "Dev User", "email_verified": false, "phone_verified": false}	email	2026-01-01 03:25:35.233378+00	2026-01-01 03:25:35.233431+00	2026-01-01 03:25:35.233431+00	de84f9bf-ab01-46bc-ac56-7736bccb0b93
8a86a547-c01e-4e66-826b-ed1e2fab2d86	8a86a547-c01e-4e66-826b-ed1e2fab2d86	{"sub": "8a86a547-c01e-4e66-826b-ed1e2fab2d86", "email": "tenant1@gmail.com", "full_name": "tenant1", "email_verified": false, "phone_verified": false}	email	2026-01-01 03:26:59.336614+00	2026-01-01 03:26:59.336667+00	2026-01-01 03:26:59.336667+00	571ffdc2-3633-42cb-9e38-89388bb8c706
f1d803e3-7e13-4232-a1c1-6f1ef1e65355	f1d803e3-7e13-4232-a1c1-6f1ef1e65355	{"sub": "f1d803e3-7e13-4232-a1c1-6f1ef1e65355", "email": "tenant2@gmail.com", "full_name": "tenant2", "email_verified": false, "phone_verified": false}	email	2026-01-01 03:38:32.434214+00	2026-01-01 03:38:32.434264+00	2026-01-01 03:38:32.434264+00	183f2f85-d534-4e51-a627-c3b512574069
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9	2025-12-30 06:48:17.367246+00	2025-12-30 06:48:17.367246+00	otp	d574e22a-69d7-4fef-88ea-91a2dfb85161
fa0f4b79-fe50-4198-af07-02cc00ed262a	2025-12-31 10:43:25.912476+00	2025-12-31 10:43:25.912476+00	password	e65a9396-b8bd-46c9-bb80-8c7a7fb58269
6026b9da-a784-4340-acf7-c85c46bc90a5	2026-01-01 03:25:35.289728+00	2026-01-01 03:25:35.289728+00	password	c4907bf1-5be6-4616-a643-69a3914946d7
7f8a6d4c-356a-4fd9-a444-8dc4834d0ed2	2026-01-01 03:39:20.203491+00	2026-01-01 03:39:20.203491+00	password	770ea019-54b0-4ce6-8e62-856ca9d5f0d5
30c6ed49-0048-4182-9a43-8f172afe6fe7	2026-01-01 03:45:46.591977+00	2026-01-01 03:45:46.591977+00	password	77a6e89a-6338-429e-af1e-cfa4b9bbf19d
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
6bc77ddd-6a78-4818-943b-8b7adca18d65	1808cd63-8cef-4e66-8cb0-67e68251f22c	confirmation_token	ed51206872583be1b27babb24ae060a51490e2d5ad193534ea3f761e	gowthamp990@gmail.com	2025-12-30 06:47:04.428864	2025-12-30 06:47:04.428864
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	49	ybds67gsfaiy	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	f	2025-12-31 10:43:25.893131+00	2025-12-31 10:43:25.893131+00	\N	fa0f4b79-fe50-4198-af07-02cc00ed262a
00000000-0000-0000-0000-000000000000	21	ngljcbroku53	1c786a19-b2ca-41fd-8750-f427fb4c6b76	t	2025-12-30 06:48:17.355024+00	2025-12-30 07:46:19.886499+00	\N	f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9
00000000-0000-0000-0000-000000000000	23	5mmeqeclgiyv	1c786a19-b2ca-41fd-8750-f427fb4c6b76	t	2025-12-30 07:46:19.906584+00	2025-12-30 08:46:36.251577+00	ngljcbroku53	f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9
00000000-0000-0000-0000-000000000000	25	d4px5i5dsrgu	1c786a19-b2ca-41fd-8750-f427fb4c6b76	t	2025-12-30 08:46:36.271893+00	2025-12-30 09:45:04.61977+00	5mmeqeclgiyv	f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9
00000000-0000-0000-0000-000000000000	67	sru56wftqny4	f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8	f	2026-01-01 03:25:35.275693+00	2026-01-01 03:25:35.275693+00	\N	6026b9da-a784-4340-acf7-c85c46bc90a5
00000000-0000-0000-0000-000000000000	26	st4s6ojuberc	1c786a19-b2ca-41fd-8750-f427fb4c6b76	t	2025-12-30 09:45:04.642817+00	2025-12-30 10:43:34.312437+00	d4px5i5dsrgu	f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9
00000000-0000-0000-0000-000000000000	28	wla6zg2muu2k	1c786a19-b2ca-41fd-8750-f427fb4c6b76	f	2025-12-30 10:43:34.313893+00	2025-12-30 10:43:34.313893+00	st4s6ojuberc	f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9
00000000-0000-0000-0000-000000000000	72	mbr6h3wroocs	35ad9461-0240-487c-9dfb-9883cca83fef	f	2026-01-01 03:39:20.200839+00	2026-01-01 03:39:20.200839+00	\N	7f8a6d4c-356a-4fd9-a444-8dc4834d0ed2
00000000-0000-0000-0000-000000000000	74	yrsv2ga3o6rg	f1d803e3-7e13-4232-a1c1-6f1ef1e65355	f	2026-01-01 03:45:46.590053+00	2026-01-01 03:45:46.590053+00	\N	30c6ed49-0048-4182-9a43-8f172afe6fe7
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
6026b9da-a784-4340-acf7-c85c46bc90a5	f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8	2026-01-01 03:25:35.267872+00	2026-01-01 03:25:35.267872+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.7462	157.48.122.103	\N	\N	\N	\N	\N
7f8a6d4c-356a-4fd9-a444-8dc4834d0ed2	35ad9461-0240-487c-9dfb-9883cca83fef	2026-01-01 03:39:20.198576+00	2026-01-01 03:39:20.198576+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	157.48.120.139	\N	\N	\N	\N	\N
fa0f4b79-fe50-4198-af07-02cc00ed262a	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	2025-12-31 10:43:25.863188+00	2025-12-31 10:43:25.863188+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	125.62.146.50	\N	\N	\N	\N	\N
30c6ed49-0048-4182-9a43-8f172afe6fe7	f1d803e3-7e13-4232-a1c1-6f1ef1e65355	2026-01-01 03:45:46.587451+00	2026-01-01 03:45:46.587451+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	157.48.120.139	\N	\N	\N	\N	\N
f12dd4be-1cad-47b4-a3f1-7e6d1b3e4ce9	1c786a19-b2ca-41fd-8750-f427fb4c6b76	2025-12-30 06:48:17.342953+00	2025-12-30 10:43:34.317511+00	\N	aal1	\N	2025-12-30 10:43:34.316753	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36	106.197.99.215	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	1808cd63-8cef-4e66-8cb0-67e68251f22c	authenticated	authenticated	gowthamp990@gmail.com	$2a$10$L.oYeSJsHgbHi.Wz8y5Qh.SIqSkfFznyga2w4fb0RtpX45G5TwaaK	\N	\N	ed51206872583be1b27babb24ae060a51490e2d5ad193534ea3f761e	2025-12-30 06:47:02.604595+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "1808cd63-8cef-4e66-8cb0-67e68251f22c", "email": "gowthamp990@gmail.com", "full_name": "Gowtham", "email_verified": false, "phone_verified": false}	\N	2025-12-30 06:29:10.254685+00	2025-12-30 06:47:04.413302+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	authenticated	authenticated	employee@crm.test	$2a$10$tE6wKcUt24mbkRgwAQoCqON5qggjwGAPpmJeqG0m3D7R5iEkpGSd6	2025-12-29 15:15:45.342598+00	\N		\N		\N			\N	2025-12-31 10:43:25.863067+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-12-29 15:15:45.337274+00	2025-12-31 10:43:25.910974+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1c786a19-b2ca-41fd-8750-f427fb4c6b76	authenticated	authenticated	gowthamp1614@gmail.com	$2a$10$/bDwtdcCHQfyj430Z58ZMOaoWLxx2sVHdZ9xfURnm8DMlmmFoD/P6	2025-12-30 06:48:17.334953+00	\N		2025-12-30 06:42:17.566435+00		\N			\N	2025-12-30 06:48:17.342844+00	{"provider": "email", "providers": ["email"]}	{"sub": "1c786a19-b2ca-41fd-8750-f427fb4c6b76", "email": "gowthamp1614@gmail.com", "full_name": "Gowtham", "email_verified": true, "phone_verified": false}	\N	2025-12-30 06:42:17.521222+00	2025-12-30 10:43:34.315204+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b31edec7-f7a1-4c28-837f-9b9848caf405	authenticated	authenticated	vishalmurugavel105@gmail.com	$2a$10$q23Z1idALU7QAcYI93/4PuijfhuiA3WkMbtP8a8KHbKSAIy4cHw8u	2025-12-29 05:34:33.008967+00	\N		2025-12-29 05:33:52.894815+00		\N			\N	2026-01-01 00:17:21.218702+00	{"provider": "email", "providers": ["email"]}	{"sub": "b31edec7-f7a1-4c28-837f-9b9848caf405", "email": "vishalmurugavel105@gmail.com", "full_name": "admin", "email_verified": true, "phone_verified": false}	\N	2025-12-29 05:33:52.864458+00	2026-01-01 01:28:08.295278+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	35ad9461-0240-487c-9dfb-9883cca83fef	authenticated	authenticated	admin@crm.test	$2a$10$cTNNph2hGhAoJ2nMYF7BGuJNoWW2cipTFsmGvpZ5r8MoncCptf3oK	2025-12-29 15:15:04.749025+00	\N		\N		\N			\N	2026-01-01 03:39:20.198473+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-12-29 15:15:04.725813+00	2026-01-01 03:39:20.203126+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8a86a547-c01e-4e66-826b-ed1e2fab2d86	authenticated	authenticated	tenant1@gmail.com	$2a$10$zTighYRgpE5Rt4QNmvGC.ORNWVS9M71RdavCww5RhAu7/YOnsVHXG	2026-01-01 03:26:59.340571+00	\N		\N		\N			\N	2026-01-01 03:28:01.023217+00	{"provider": "email", "providers": ["email"]}	{"sub": "8a86a547-c01e-4e66-826b-ed1e2fab2d86", "email": "tenant1@gmail.com", "full_name": "tenant1", "email_verified": true, "phone_verified": false}	\N	2026-01-01 03:26:59.329101+00	2026-01-01 03:28:01.025442+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8	authenticated	authenticated	dev.user.ccbfc6c7-b407-4519-ad7d-db6896970a86@example.com	$2a$10$joTmQ5EJKKeQQA.Lw6qDH.4CayNAxgzIpgCtCFbYpynNcCo/QcsKi	2026-01-01 03:25:35.250564+00	\N		\N		\N			\N	2026-01-01 03:25:35.26776+00	{"provider": "email", "providers": ["email"]}	{"sub": "f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8", "email": "dev.user.ccbfc6c7-b407-4519-ad7d-db6896970a86@example.com", "full_name": "Dev User", "email_verified": true, "phone_verified": false}	\N	2026-01-01 03:25:35.204536+00	2026-01-01 03:25:35.289227+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	authenticated	authenticated	manager@crm.test	$2a$10$yoodk5ULqAif1Xvzj0IV4OyHvASD4WlVfjmmvHj9zcfe.BOF6aagu	2025-12-29 15:15:32.009648+00	\N		\N		\N			\N	2026-01-01 00:45:13.4438+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-12-29 15:15:32.002467+00	2026-01-01 03:44:36.796262+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f1d803e3-7e13-4232-a1c1-6f1ef1e65355	authenticated	authenticated	tenant2@gmail.com	$2a$10$KUcQVbpD4s6BnymH.khXDOMJV1x.QfcI8Stnsqt/nNDYDvQbP3Wj.	2026-01-01 03:38:32.441225+00	\N		\N		\N			\N	2026-01-01 03:45:46.587349+00	{"provider": "email", "providers": ["email"]}	{"sub": "f1d803e3-7e13-4232-a1c1-6f1ef1e65355", "email": "tenant2@gmail.com", "full_name": "tenant2", "email_verified": true, "phone_verified": false}	\N	2026-01-01 03:38:32.416877+00	2026-01-01 03:45:46.59165+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (id, user_id, action, entity_type, entity_id, description, ip_address, user_agent, created_at, module, record_id, organization_id) FROM stdin;
9b12328f-9b35-4cad-8adb-ffd8aca31721	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7edc4564-f42a-40bc-b332-4a65133431e2	UPDATE on leads	\N	\N	2025-12-30 15:15:11.441009+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1d2ee856-d16e-4377-837d-17d17c8c43b0	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead moved to qualified	\N	\N	2025-12-30 15:15:23.51334+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b5566fec-07d7-4120-83ae-3f181f9d9023	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-30 15:15:46.258644+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
df81fc27-4860-4914-8c88-0fe184c0adf1	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	tasks	3338ff8a-cb8e-4c1a-898a-264f01410534	INSERT on tasks	\N	\N	2025-12-31 03:32:23.384704+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d96f914f-b412-4c0b-9f12-f7f68b045b37	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	companies	6d464f4f-75f6-4e36-a2dd-66f7f7222a6c	INSERT on companies	\N	\N	2026-01-01 00:41:44.02491+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ae756955-9ec8-49ef-b916-ccb19179185e	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7ce98c4e-ca66-4dec-bf99-69dfebb88245	UPDATE on leads	\N	\N	2026-01-01 00:41:44.02491+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9f7d4663-e1e9-462d-ab4b-7c015e0a3da5	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7edc4564-f42a-40bc-b332-4a65133431e2	Lead moved to won	\N	\N	2025-12-30 15:15:11.830592+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ebe562fc-4f7f-4c46-8a9d-7284cdfe176b	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-30 15:15:25.703859+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
785e3f1e-1f27-44be-b734-41987bec627c	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead moved to won	\N	\N	2025-12-30 15:15:46.420342+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
be3608af-e47e-4faa-8b8c-d86131ff9843	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to proposal and follow-up task created	\N	\N	2025-12-31 03:32:23.521301+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0bf5316f-a80e-4488-aa8e-ad640a71984d	b31edec7-f7a1-4c28-837f-9b9848caf405	converted_to_contact	lead	7ce98c4e-ca66-4dec-bf99-69dfebb88245	Lead converted to contact #5f39ad63-2e59-420c-a3db-e96cee17ba6c	\N	\N	2026-01-01 00:41:44.225322+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8d6c49b5-159f-4e2c-84fc-be7ec6ba3522	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_removed	task	5d3853b6-e27e-499d-8632-b978fac17e53	Collaborator removed from task	\N	\N	2025-12-29 11:51:57.628339+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
03af2768-5e1d-43de-a8ac-f3da368c1dda	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	5d3853b6-e27e-499d-8632-b978fac17e53	Task owner reassigned	\N	\N	2025-12-29 11:52:10.857343+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5858c9dc-52ab-4438-848f-a1c8eba26fa9	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	582f6a7e-d21f-4693-a931-77d941dbde27	Task owner reassigned	\N	\N	2025-12-29 11:52:26.001175+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ba02f586-ac70-4da0-b48c-40689bbb6f49	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 11:53:00.859551+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ee35a52c-abd6-43c7-bc04-fa31ff8893a4	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to negotiation and follow-up task created	\N	\N	2025-12-29 11:53:04.923577+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e85c5dda-ce4e-4beb-8d0a-da311427c6b9	\N	UPDATE	companies	8406a40f-38fa-4dcf-9176-0727e1b04fb5	UPDATE on companies	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
34a56526-3636-4015-9090-f0d060b87dd5	\N	UPDATE	contacts	b300a3f2-7d17-469e-a6f6-991c2870e9e0	UPDATE on contacts	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9f602d5a-fe48-46ef-8bb6-6209c131efe3	\N	UPDATE	contacts	5c6bf342-3920-4a77-8529-6a394d11886a	UPDATE on contacts	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fe9fbec2-9f5b-42b8-b7a3-79ac7ec4fea5	\N	UPDATE	contacts	a3c75970-9473-40be-ae2e-e708c6179e16	UPDATE on contacts	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b372a1c8-f90f-4dad-9e07-9e648539c377	\N	UPDATE	contacts	829d1942-9c15-45f2-8e43-36719c7c79a1	UPDATE on contacts	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f3c263c5-5f6d-45a4-ac5d-0ac2f0c44c18	\N	UPDATE	contacts	fae5b99f-d063-4bcf-95ce-58b247c52167	UPDATE on contacts	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
de69f428-67c2-434d-8e34-fe0743593b8f	\N	UPDATE	leads	7edc4564-f42a-40bc-b332-4a65133431e2	UPDATE on leads	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7d8c6d08-9b8b-49ad-ad3b-73e256b3afa2	\N	UPDATE	leads	7ce98c4e-ca66-4dec-bf99-69dfebb88245	UPDATE on leads	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2f4a6823-104e-4f4c-8038-5c31cae5fbab	\N	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
52d4e72c-5b53-4836-a617-c3452234e2e0	\N	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
565fe251-80ab-420e-835d-e73d801fb24f	\N	UPDATE	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
91cf2436-19b7-448d-a696-3b35ec86cca4	\N	UPDATE	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bc7cd08d-6594-4c22-987d-89726c46ab89	\N	UPDATE	deals	cf56f4fe-97e3-4007-b227-f4799d58f4cd	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ba4bc0e6-0a27-41ad-8c11-2c57d0259d44	\N	UPDATE	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ab8f804d-622d-4b0d-a2ed-7812c77232da	\N	UPDATE	deals	cfeee563-250b-4890-a5d5-87b6c89adaa0	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
600e7236-7a99-450c-8596-b6f4d54f7746	\N	UPDATE	deals	1890fade-d586-416e-9628-9d69560be41b	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9e6c6911-da2f-48c3-92c3-fa1b8e25d186	\N	UPDATE	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	UPDATE on deals	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bba91bf6-d63f-4d59-85e6-d8d4caa9d42a	\N	UPDATE	employees	887ded8b-2573-47cb-9fcf-2641ace4ad44	UPDATE on employees	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fc4e1790-6c90-47ed-8e62-738261e02679	\N	UPDATE	employees	6f661578-7dfb-4543-83e3-1f66ccc05e9b	UPDATE on employees	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fe62aef9-8811-45c8-8fa8-2eb2d446fa5d	\N	UPDATE	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
66c131cd-d28b-4a30-aa7b-6dbd00d0c767	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7edc4564-f42a-40bc-b332-4a65133431e2	UPDATE on leads	\N	\N	2025-12-30 15:15:13.773052+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5327df06-04a6-464f-a750-617dbd025a9e	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead moved to proposal	\N	\N	2025-12-30 15:15:25.840526+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
85a07cc9-9b50-4654-bc1d-4536cfe48386	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	90e8f71e-b710-4444-b7ff-b5d34a647c76	UPDATE on tasks	\N	\N	2025-12-31 07:02:08.088536+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1b9cb7b4-b97c-4ac8-aba1-cb2b1bc56f46	b31edec7-f7a1-4c28-837f-9b9848caf405	updated	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	Updated tasks	\N	\N	2026-01-01 01:03:42.751409+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
100a937d-d4f9-43b4-b75d-269c61421a4d	b31edec7-f7a1-4c28-837f-9b9848caf405	created_lead	lead	7edc4564-f42a-40bc-b332-4a65133431e2	Created lead: ggg	\N	\N	2025-12-29 05:35:11.905427+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
261da003-829b-4c4e-a415-27ae1c083bed	b31edec7-f7a1-4c28-837f-9b9848caf405	create	contacts	\N	\N	\N	\N	2025-12-29 05:56:45.505856+00	contacts	b300a3f2-7d17-469e-a6f6-991c2870e9e0	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7d0827c5-6597-4c82-a6b4-403724c1250b	b31edec7-f7a1-4c28-837f-9b9848caf405	create	companies	\N	\N	\N	\N	2025-12-29 05:57:32.682092+00	companies	8406a40f-38fa-4dcf-9176-0727e1b04fb5	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3efcb1f3-b4c9-4252-b948-be8dd263d55f	b31edec7-f7a1-4c28-837f-9b9848caf405	create	deals	\N	\N	\N	\N	2025-12-29 05:57:52.764766+00	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
936cb968-821d-41f6-96bc-7aa8b0a071af	b31edec7-f7a1-4c28-837f-9b9848caf405	create	deals	\N	\N	\N	\N	2025-12-29 06:19:33.873194+00	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
450dbb7e-91aa-4bdb-bbed-7987922f9778	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 06:21:38.982141+00	leads	7edc4564-f42a-40bc-b332-4a65133431e2	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3daaec18-f087-4149-a44a-7adea563505a	b31edec7-f7a1-4c28-837f-9b9848caf405	updated_lead	lead	7edc4564-f42a-40bc-b332-4a65133431e2	Updated lead: ggg	\N	\N	2025-12-29 06:21:39.160427+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1c15992c-1fc6-4269-9c5b-81358da2be58	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 06:22:43.314709+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
26cc17ed-ea07-483d-9554-3a164c7e3a29	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 06:22:47.284284+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7abecd3d-e5e8-408b-af34-383f82401677	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 06:22:49.989907+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
24b8e7c3-dada-49c0-a3a4-81d1e94babbb	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 06:29:15.698135+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d72242e0-bb6d-4b39-bc74-89d686d8bf61	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 06:29:20.071712+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bdd71f21-df6f-44c2-8d7c-e205b25ad62d	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 06:29:36.487838+00	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9dbcb5e3-6150-402e-8611-5be2245a0262	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 06:29:43.166078+00	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d4df4683-1729-4bbf-bd9e-dfc6e6fc661d	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 06:30:02.236845+00	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9acb9cd7-00f3-4a9a-805b-814cac52903b	b31edec7-f7a1-4c28-837f-9b9848caf405	create	leads	\N	\N	\N	\N	2025-12-29 06:30:34.224304+00	leads	3bbc8354-f139-4a68-af79-357cd934047c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9c396df1-89c7-4832-938b-49a0c940a413	b31edec7-f7a1-4c28-837f-9b9848caf405	created_lead	lead	3bbc8354-f139-4a68-af79-357cd934047c	Created lead: gggd	\N	\N	2025-12-29 06:30:35.040429+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
50d040c9-4920-4895-a518-55a9f3665a38	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 06:30:46.985432+00	leads	3bbc8354-f139-4a68-af79-357cd934047c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ec64f9a1-7cd4-40aa-9dc7-d054e45bb742	b31edec7-f7a1-4c28-837f-9b9848caf405	updated_lead	lead	3bbc8354-f139-4a68-af79-357cd934047c	Updated lead: gggd	\N	\N	2025-12-29 06:30:47.08381+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
490c735f-e07c-4aa2-b6a6-a60124ed097a	b31edec7-f7a1-4c28-837f-9b9848caf405	create	contacts	\N	\N	\N	\N	2025-12-29 06:30:52.252929+00	contacts	5c6bf342-3920-4a77-8529-6a394d11886a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f55b5a1f-1867-4d09-b25b-7105590e241b	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 06:30:52.415773+00	leads	3bbc8354-f139-4a68-af79-357cd934047c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
32b14440-dc25-4d0a-ad04-2c6de4e4e1a1	b31edec7-f7a1-4c28-837f-9b9848caf405	converted_to_contact	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead converted to contact #5c6bf342-3920-4a77-8529-6a394d11886a	\N	\N	2025-12-29 06:30:52.522426+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c88f9892-7008-46f5-994d-565ba22b9b41	b31edec7-f7a1-4c28-837f-9b9848caf405	create	deals	\N	\N	\N	\N	2025-12-29 06:31:51.49401+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
80100940-4d70-4568-8c26-4b58d2d8c465	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 06:32:00.575604+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
698a73fb-2f5a-42a1-9027-f3562758e297	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 06:32:03.114347+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5162360e-31f9-4b22-aeb1-30c311fd0b4c	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 06:32:14.403053+00	leads	3bbc8354-f139-4a68-af79-357cd934047c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4c68b329-aec0-4669-9e7c-c1a6779842a7	b31edec7-f7a1-4c28-837f-9b9848caf405	updated_lead	lead	3bbc8354-f139-4a68-af79-357cd934047c	Updated lead: gggd	\N	\N	2025-12-29 06:32:14.55726+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0ae7b56c-3d6c-4993-89b5-1291f80c05ae	b31edec7-f7a1-4c28-837f-9b9848caf405	create	contacts	\N	\N	\N	\N	2025-12-29 07:06:01.012112+00	contacts	a3c75970-9473-40be-ae2e-e708c6179e16	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8980635e-44ba-4176-8ea4-b8c18896a9e3	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 07:06:01.207956+00	leads	3bbc8354-f139-4a68-af79-357cd934047c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
aaa57a17-31f1-4998-a6c0-825c6f830f75	b31edec7-f7a1-4c28-837f-9b9848caf405	converted_to_contact	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead converted to contact #a3c75970-9473-40be-ae2e-e708c6179e16	\N	\N	2025-12-29 07:06:01.358099+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
502a2b48-98e0-4b5d-87a2-838a237bae6d	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 07:23:32.741133+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
19a63198-0b01-438c-92bc-cb0c9c2301dd	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 07:30:38.263949+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3c856399-a67d-48c4-b93d-34b0a89b87a6	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 07:30:39.162955+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
58737b0f-0da1-4272-a345-482585215afe	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 07:30:40.680697+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c391153e-a621-47e0-bd21-542e45be2d20	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 07:30:43.084948+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
88d2e590-0e8b-4b5c-954f-ad912f4a8e6a	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 07:30:45.501378+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0368ce44-714c-4f92-94ad-dad87f1973cf	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 07:48:54.608116+00	tasks	582f6a7e-d21f-4693-a931-77d941dbde27	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
efe0965a-1132-4ba0-8487-8bcd99d90c57	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 07:49:08.483946+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b955a20b-f6a5-4276-8029-3170c914db67	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 07:49:23.442912+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
31a5483f-1788-4472-9696-7c1d5e3d4640	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 10:06:53.304042+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
07a5ab1f-7854-42da-9101-e0dfdf3b1178	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 10:06:55.18151+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6edc9583-3361-4215-8a53-80e5bbfe3ef8	b31edec7-f7a1-4c28-837f-9b9848caf405	create	leads	\N	\N	\N	\N	2025-12-29 10:44:53.272396+00	leads	40f564b4-c3d0-40be-9503-b0310824519a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5e5b4fa0-1df6-46fc-bbf7-f5eefcecb382	b31edec7-f7a1-4c28-837f-9b9848caf405	created_lead	lead	40f564b4-c3d0-40be-9503-b0310824519a	Created lead: ss	\N	\N	2025-12-29 10:44:53.435217+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c93655c4-0f97-4d5f-8b82-d48ce038bd54	b31edec7-f7a1-4c28-837f-9b9848caf405	create	contacts	\N	\N	\N	\N	2025-12-29 10:44:57.543708+00	contacts	08e3f0f5-dc92-4eb0-b523-d4baf3bac239	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b4a7905a-2920-4de8-9350-36c7db4a7429	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 10:44:57.67763+00	leads	40f564b4-c3d0-40be-9503-b0310824519a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
21806540-d5af-41a2-a790-60c8e3f9e48c	b31edec7-f7a1-4c28-837f-9b9848caf405	converted_to_contact	lead	40f564b4-c3d0-40be-9503-b0310824519a	Lead converted to contact #08e3f0f5-dc92-4eb0-b523-d4baf3bac239	\N	\N	2025-12-29 10:44:57.777825+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9827ce9a-b0e4-4038-9e5d-aab27f5c7928	b31edec7-f7a1-4c28-837f-9b9848caf405	create	contacts	\N	\N	\N	\N	2025-12-29 10:45:00.288496+00	contacts	829d1942-9c15-45f2-8e43-36719c7c79a1	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
521abe1c-9d0f-4135-b412-109b418b4063	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 10:45:00.41621+00	leads	3bbc8354-f139-4a68-af79-357cd934047c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
828f2c2c-6128-4136-90bd-6029b0e68cb8	b31edec7-f7a1-4c28-837f-9b9848caf405	converted_to_contact	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead converted to contact #829d1942-9c15-45f2-8e43-36719c7c79a1	\N	\N	2025-12-29 10:45:00.498063+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
da17a41a-3d9c-4ffc-bf87-5c3ecd62f0ed	b31edec7-f7a1-4c28-837f-9b9848caf405	create	deals	\N	\N	\N	\N	2025-12-29 10:45:06.188491+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c38b055a-bf29-4570-b28f-79edc7567f8c	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7edc4564-f42a-40bc-b332-4a65133431e2	Lead moved to lost	\N	\N	2025-12-30 15:15:13.943303+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
33259ea8-3bde-490d-a58e-3a726e15bf71	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-30 15:15:36.668578+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
26a6085e-4d86-4135-a80e-0a731f9a6a1d	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	90e8f71e-b710-4444-b7ff-b5d34a647c76	Task moved to in_progress	\N	\N	2025-12-31 07:02:08.340302+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3b5fc9ba-9eb6-4da1-80df-7c74cee15a8a	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	Task owner reassigned	\N	\N	2026-01-01 01:03:43.263788+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f2793c83-6188-4235-9a76-db0d361b5fe8	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 10:47:00.574997+00	tasks	582f6a7e-d21f-4693-a931-77d941dbde27	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f26d74da-f7dd-43e3-a33a-fb54bd63aad9	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 10:47:02.454703+00	tasks	582f6a7e-d21f-4693-a931-77d941dbde27	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5bb07a29-006b-4a1f-a599-778f4bc0d7d3	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 10:47:03.240429+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8b8d5439-75d0-4f61-a3ca-18c8c6c97e1d	b31edec7-f7a1-4c28-837f-9b9848caf405	create	deals	\N	\N	\N	\N	2025-12-29 10:50:27.872322+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5591146b-e54d-440c-9fa1-c91de506f558	b31edec7-f7a1-4c28-837f-9b9848caf405	create	contacts	\N	\N	\N	\N	2025-12-29 10:54:50.644258+00	contacts	fae5b99f-d063-4bcf-95ce-58b247c52167	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
612f4fd5-ee50-4cfb-825f-7ee35ee8cc0f	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 10:54:50.7771+00	leads	40f564b4-c3d0-40be-9503-b0310824519a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
291aa73b-5cf6-4704-b80d-4681011be8ee	b31edec7-f7a1-4c28-837f-9b9848caf405	converted_to_contact	lead	40f564b4-c3d0-40be-9503-b0310824519a	Lead converted to contact #fae5b99f-d063-4bcf-95ce-58b247c52167	\N	\N	2025-12-29 10:54:50.8954+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
52c1964d-87ea-482c-9ba8-a8820bf72b31	b31edec7-f7a1-4c28-837f-9b9848caf405	update	leads	\N	\N	\N	\N	2025-12-29 10:55:31.546087+00	leads	40f564b4-c3d0-40be-9503-b0310824519a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e3433002-c1bb-4fb5-bc15-28a16739c5b9	b31edec7-f7a1-4c28-837f-9b9848caf405	updated_lead	lead	40f564b4-c3d0-40be-9503-b0310824519a	Updated lead: ss	\N	\N	2025-12-29 10:55:31.746743+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d018c9e3-8897-4681-9cec-f87e410192be	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:01:24.543042+00	tasks	a7f37ba8-ed55-47f6-af18-344045421e7c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f8cba10b-bf3a-4743-a752-0151ca9d97c9	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:50:42.135226+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2c369006-8c6e-493d-b03b-ccf8972d3a35	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	07d2197a-a964-4842-9383-13353613aa12	Task marked in progress	\N	\N	2025-12-29 11:50:42.437304+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8bc50e31-104d-45a1-93b1-3db7b6258ecb	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:50:44.779851+00	tasks	07d2197a-a964-4842-9383-13353613aa12	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2da80851-d121-4df6-9d5b-16721283e6f2	b31edec7-f7a1-4c28-837f-9b9848caf405	task_completed	task	07d2197a-a964-4842-9383-13353613aa12	Task marked completed	\N	\N	2025-12-29 11:50:45.009258+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
699f5e70-56e2-4a53-bda9-0db2cfb39267	b31edec7-f7a1-4c28-837f-9b9848caf405	create	deals	\N	\N	\N	\N	2025-12-29 16:23:46.166503+00	deals	cfeee563-250b-4890-a5d5-87b6c89adaa0	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3e4e4a64-e1f5-4482-b309-4a167e195628	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7edc4564-f42a-40bc-b332-4a65133431e2	UPDATE on leads	\N	\N	2025-12-30 15:15:16.689761+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
da3d3f88-8353-4d61-a123-fc6362c6a53c	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	40f564b4-c3d0-40be-9503-b0310824519a	Lead moved to won	\N	\N	2025-12-30 15:15:36.800392+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b4f3f413-bb49-416d-8716-47afe92967d0	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	employees	baed20e6-f79c-439e-a2fa-01ff6dd930c4	INSERT on employees	\N	\N	2025-12-31 15:42:45.217416+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
19a7a149-c1ad-4691-a5a2-d4dea638f25d	b31edec7-f7a1-4c28-837f-9b9848caf405	updated	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	Updated tasks	\N	\N	2026-01-01 01:12:22.506919+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d732d89f-19c0-4013-b339-442f391542d1	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7edc4564-f42a-40bc-b332-4a65133431e2	Lead moved to negotiation	\N	\N	2025-12-30 15:15:16.84284+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2b7342d2-dc70-4456-ba23-cb79ce5e36fa	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7edc4564-f42a-40bc-b332-4a65133431e2	UPDATE on leads	\N	\N	2025-12-30 15:15:43.930749+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4dccfcdd-6031-4b27-9bc1-1ba4ced4c71b	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7ce98c4e-ca66-4dec-bf99-69dfebb88245	UPDATE on leads	\N	\N	2025-12-31 16:35:24.665829+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
eb25f627-9960-43c1-94c0-77a2efe94458	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_added	task	5d3853b6-e27e-499d-8632-b978fac17e53	Collaborator added to task	\N	\N	2025-12-29 11:51:50.494684+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ec823aa4-215b-4446-ac3a-7ee59b57fa5a	\N	UPDATE	tasks	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a353fa20-72ae-4735-bad3-f1af798fa63b	\N	UPDATE	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
15141283-6a98-40fd-8047-ceff8ecdab0b	\N	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
26d72917-09bf-4ad7-9221-00ff5a3f5ff4	\N	UPDATE	tasks	91c70b2e-7ec7-49ca-8d4b-4cc7e1e40598	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cf54fae0-c96d-41d4-9f24-bb87bee6c20c	\N	UPDATE	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8cb6359f-73cc-4b75-bcab-574b4bb136b6	\N	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9365d65c-938a-40f2-bf40-196104ba9019	\N	UPDATE	tasks	90e8f71e-b710-4444-b7ff-b5d34a647c76	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
36ddb718-020a-43a8-8a3c-1b8bc963420e	\N	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
50a0f3ac-81b8-408b-8d36-5f671a1d51c5	\N	UPDATE	tasks	8238ad02-586d-401e-b9cb-2e5d2494cdbe	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
97b63235-8616-4028-8241-1f75d1587bca	\N	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
52f6a160-57dc-47f7-9138-1690bc8d8c24	\N	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e0bc80ff-e0f1-426b-be5a-1781b1ee125c	\N	UPDATE	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
dc5e592d-b5fa-4925-b834-9c13308b3c57	\N	UPDATE	tasks	582f6a7e-d21f-4693-a931-77d941dbde27	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2b2d5c5b-62d7-4289-9d09-5b4581a761d4	\N	UPDATE	tasks	10eb9d57-ab2c-4d2d-97a3-7e104b8ec09a	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7a73b3bf-e55e-4b44-8297-4686c0a8da5b	\N	UPDATE	tasks	769a86ea-40dc-416c-8486-8964f7ac2623	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
77afa7d6-331d-467a-af55-8377a3acf537	\N	UPDATE	tasks	da852014-c162-4c01-b8e0-81f0d2bdb7d7	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ac72caff-25d4-49a9-9339-c451497477ba	\N	UPDATE	tasks	07d2197a-a964-4842-9383-13353613aa12	UPDATE on tasks	\N	\N	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
51565393-f4d4-4f49-8750-1d3fc3a77b92	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:52:02.15703+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
db78673a-6641-4a82-a52d-a12d2e358209	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	5d3853b6-e27e-499d-8632-b978fac17e53	Task owner reassigned	\N	\N	2025-12-29 11:52:02.854931+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
305ebbf9-24e7-41af-b046-f938cfc4b2cb	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:52:12.841957+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c72e4d7e-4d8d-48f9-a4df-fd9952413026	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	5d3853b6-e27e-499d-8632-b978fac17e53	Task owner reassigned	\N	\N	2025-12-29 11:52:13.066784+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b3658121-dbc9-4752-aeef-93376a49c4ba	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_added	task	582f6a7e-d21f-4693-a931-77d941dbde27	Collaborator added to task	\N	\N	2025-12-29 11:52:20.083249+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
aa77eab4-038e-4d2c-b94c-4093cc77bfdb	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 11:53:04.827838+00	tasks	769a86ea-40dc-416c-8486-8964f7ac2623	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4cb91dec-5672-469b-99d5-3d7bfcaeaa7f	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 11:53:41.353025+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8c7ebb52-389a-4694-82f8-723b7043d290	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 11:53:41.452592+00	tasks	10eb9d57-ab2c-4d2d-97a3-7e104b8ec09a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c12b086b-58f4-464e-b212-350d132ecab4	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:54:01.338266+00	tasks	769a86ea-40dc-416c-8486-8964f7ac2623	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
81656db5-40d5-4514-ae0f-64690fa7cfde	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:52:10.63565+00	tasks	5d3853b6-e27e-499d-8632-b978fac17e53	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c01c9634-b670-4cef-88db-e3847bcb1e5e	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 11:52:25.805928+00	tasks	582f6a7e-d21f-4693-a931-77d941dbde27	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c2ddb9a8-d341-4ed2-b3e1-10bbba8e98ea	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 11:53:04.68902+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
220cc266-f7a5-46bc-b684-e93bd41ba953	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 11:53:27.602061+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
845220fc-2116-4aed-9ee2-2babb36c43db	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	9b078e58-0ca6-452a-94dc-96ec6ece641c	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 11:53:41.551628+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8ac30a0f-2702-4475-899b-2349c4cf07b2	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_added	task	10eb9d57-ab2c-4d2d-97a3-7e104b8ec09a	Collaborator added to task	\N	\N	2025-12-29 11:53:48.353409+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
56c58378-8d5f-463a-919f-47fb610b09cc	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:22.099816+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
571ae98a-0188-4fdd-8271-0f02626121e4	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:23.623741+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4bf656cc-4dd4-4cac-ab25-d7fa982db117	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:31.684754+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f292d8ae-67cc-41b7-ac03-cc61ffaa5b38	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:33.354372+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8946608f-35cf-4c57-bf1d-c1f4caa70186	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:44.307782+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fa011619-e7cd-4207-9b5f-cabef5436eeb	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:46.293102+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
250decc3-e695-4e12-9770-e4f2b1674001	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:00:46.388875+00	tasks	da852014-c162-4c01-b8e0-81f0d2bdb7d7	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
47e12a0e-26c9-4096-80b4-c26ff2a0a831	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 12:00:46.486185+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c900cf8d-f944-4608-a7a9-71105bf1ed57	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:00:49.343643+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ac20d353-d726-4785-acf2-0540dbf2c00d	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:00:49.426747+00	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ca8e846e-a0e8-4c31-a1ac-c139f758278a	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to negotiation and follow-up task created	\N	\N	2025-12-29 12:00:49.508556+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
dee73bd8-f4fc-44cf-939a-c714d4199bb5	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:00.796817+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0e15f510-9c88-4528-9723-b3ffa1ae5d5c	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:01:00.895017+00	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a64ec86a-b479-4518-815a-e5f98de3c130	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 12:01:00.986053+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3cd09031-24a6-46aa-ad8e-4b1fec49db66	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:04.05421+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8245ac53-0650-46e3-b7a7-c18aa8dfa05f	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:01:04.153874+00	tasks	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e840aa06-1cb6-4469-aeaf-7023d737e724	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	9b078e58-0ca6-452a-94dc-96ec6ece641c	Stage set to negotiation and follow-up task created	\N	\N	2025-12-29 12:01:04.254193+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8e7631b8-0d7e-40f3-b4e7-544429f19b5f	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:13.336741+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ef8a4157-c854-4398-a7c7-ffe5a9a3bee3	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:19.851774+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ef49e14b-d987-42d7-b0ee-1183dce54c2d	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:01:19.946241+00	tasks	91c70b2e-7ec7-49ca-8d4b-4cc7e1e40598	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
49cb2ed4-f78e-4f07-b7d2-4a922813be9d	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	9b078e58-0ca6-452a-94dc-96ec6ece641c	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 12:01:20.041821+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
dc0e3316-2a6a-46b9-8c89-3c442c4ed349	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:21.928161+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6430e7ec-0c02-4771-9059-ff13a18abcfb	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-30 15:15:23.349147+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
eff40fcb-b38e-421a-b87c-f44e67719a09	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7edc4564-f42a-40bc-b332-4a65133431e2	Lead moved to won	\N	\N	2025-12-30 15:15:44.072418+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0c661fa3-0c97-4fe1-b4ba-b47c54fa3c1c	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7ce98c4e-ca66-4dec-bf99-69dfebb88245	Lead moved to negotiation	\N	\N	2025-12-31 16:35:24.867072+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a4f766b5-cd33-4164-8454-fb7dec69fbf2	8a86a547-c01e-4e66-826b-ed1e2fab2d86	INSERT	leads	7388973e-c669-47be-873c-813b726d1e58	INSERT on leads	\N	\N	2026-01-01 03:37:57.622861+00	\N	\N	98b41759-8acc-498a-8ee6-bed16d2704fb
88f1beb7-7c20-415d-a10b-86af64fecc97	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	1890fade-d586-416e-9628-9d69560be41b	UPDATE on deals	\N	\N	2025-12-31 03:32:23.233383+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8a0fb01b-39ea-4c99-ba57-ca0ee62011e2	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	contacts	5f39ad63-2e59-420c-a3db-e96cee17ba6c	INSERT on contacts	\N	\N	2026-01-01 00:41:43.824536+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b7c58725-9f27-4fe3-9265-fd079a97a22a	8a86a547-c01e-4e66-826b-ed1e2fab2d86	created_lead	lead	7388973e-c669-47be-873c-813b726d1e58	Created lead: tenant1 lead	\N	\N	2026-01-01 03:37:57.925385+00	\N	\N	98b41759-8acc-498a-8ee6-bed16d2704fb
a2edb3ae-660d-4bfa-976c-7923f7245229	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:27.525239+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ba4830ed-5ef3-4657-91f7-15d572eb74dc	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:01:27.615968+00	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b5c95e63-39bf-4e65-a25e-f85164bb09d3	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	9b078e58-0ca6-452a-94dc-96ec6ece641c	Stage set to negotiation and follow-up task created	\N	\N	2025-12-29 12:01:27.706285+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9f755be8-5372-417e-8db9-81ca4baa77dc	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:28.92929+00	deals	9b078e58-0ca6-452a-94dc-96ec6ece641c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
274106a3-5c51-43b4-83da-f9fe497bb086	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:01:29.018808+00	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e1f89276-03f4-476e-9d7a-2a5595b2cfdf	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	9b078e58-0ca6-452a-94dc-96ec6ece641c	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 12:01:29.106028+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
30eee417-42f8-4030-9690-247a6170f577	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:30.395034+00	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e8848fe4-b3d4-4b0a-a92f-417f011fbb4a	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 12:01:30.496766+00	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cc4a8fc5-8d21-498a-a46d-318b3fc601be	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	Stage set to negotiation and follow-up task created	\N	\N	2025-12-29 12:01:30.591508+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
100a1e27-0bf0-45a4-b83d-422b62197f0c	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:01:32.291638+00	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ee277f9a-65f4-4ff8-8fa6-19d9e942e7b9	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_won	deal	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	Deal marked closed_won	\N	\N	2025-12-29 12:01:32.388809+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
49f6e3a5-d4e7-4b87-82c8-eb1455e8c31a	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 12:09:03.530772+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
32569859-8e2d-4503-ab5e-1d283fc0264f	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 12:09:33.429598+00	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2a4d5485-6784-432d-86f9-db6ecc918ee7	b31edec7-f7a1-4c28-837f-9b9848caf405	task_completed	task	a1b35373-cad5-4e4c-b59a-d34b93bf844e	Task marked completed	\N	\N	2025-12-29 12:09:33.625468+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b5260e3c-e54f-4849-98c3-aed6e9c8ec42	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 12:09:39.662139+00	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d669a131-56e5-4e23-9b28-7fd05e31ec5a	b31edec7-f7a1-4c28-837f-9b9848caf405	task_completed	task	68caba55-d79d-4776-b8fe-d75de6d41aec	Task marked completed	\N	\N	2025-12-29 12:09:39.856473+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
980ac12e-4a37-4067-a37c-f6ad285cc499	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 12:09:42.812194+00	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5f830b45-7247-4484-beb3-b7cbe7d01288	b31edec7-f7a1-4c28-837f-9b9848caf405	task_completed	task	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Task marked completed	\N	\N	2025-12-29 12:09:43.010137+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a87d6cf8-f6bc-43f9-be5d-e63a20ac5f16	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 12:09:43.841931+00	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9451e81d-075e-44c8-ab8e-4e1789810794	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	534ad481-2dd8-4c07-9539-ba1b8ae03143	Task marked in progress	\N	\N	2025-12-29 12:09:44.029322+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b2db6acc-13e9-4707-86b0-146fb202a018	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 12:09:46.202221+00	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bf01ee8a-3647-44a3-b0b0-f47da95dc722	b31edec7-f7a1-4c28-837f-9b9848caf405	task_completed	task	534ad481-2dd8-4c07-9539-ba1b8ae03143	Task marked completed	\N	\N	2025-12-29 12:09:46.39847+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0057f92e-254c-4d9f-8351-f550a20a1098	b31edec7-f7a1-4c28-837f-9b9848caf405	update	tasks	\N	\N	\N	\N	2025-12-29 12:14:13.853316+00	tasks	da852014-c162-4c01-b8e0-81f0d2bdb7d7	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2813ba1e-b20a-433c-9e6c-b77d21838ecd	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 14:13:39.9472+00	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3d0ef250-7dcd-444a-a3c3-3392c99b291c	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 14:13:42.443658+00	deals	1890fade-d586-416e-9628-9d69560be41b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
232428b8-7d89-401d-b8f3-00e386e3ddc0	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 14:13:42.91296+00	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6977c98d-4344-4639-81b2-6fd1a48aa501	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 14:13:43.297704+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e1d759f3-24f4-4d01-8fbd-30373ab3f531	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 14:13:46.536009+00	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
771f1b70-7e59-4078-bca4-af3ea4b7bb84	b31edec7-f7a1-4c28-837f-9b9848caf405	create	tasks	\N	\N	\N	\N	2025-12-29 14:13:46.79218+00	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
22523051-9e83-4aa2-914c-750b0aa440b7	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	Stage set to proposal and follow-up task created	\N	\N	2025-12-29 14:13:46.990812+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fea2ccab-835d-4d18-a02d-a9038b01cec3	b31edec7-f7a1-4c28-837f-9b9848caf405	update	deals	\N	\N	\N	\N	2025-12-29 14:13:53.482861+00	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
21786fe3-ff4f-42c6-802a-a8d561142a6b	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_lost	deal	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	Deal marked closed_lost	\N	\N	2025-12-29 14:13:53.624154+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fff209b7-c880-4d97-949d-2a827f32646f	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	leads	7ce98c4e-ca66-4dec-bf99-69dfebb88245	INSERT on leads	\N	\N	2025-12-29 20:41:00.886518+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
91c6ef65-b185-481b-8eef-5936e6d9d230	b31edec7-f7a1-4c28-837f-9b9848caf405	created_lead	lead	7ce98c4e-ca66-4dec-bf99-69dfebb88245	Created lead: sdf	\N	\N	2025-12-29 20:41:01.072269+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
34be631d-4bc4-49e0-8200-961b50181ab0	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	44dd434b-4032-4f26-bd3a-d5afc8b43535	UPDATE on deals	\N	\N	2025-12-29 20:42:55.147115+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4941bcc8-3aea-456c-9ae0-0ad7f6e67134	b31edec7-f7a1-4c28-837f-9b9848caf405	DELETE	contacts	\N	DELETE on contacts	\N	\N	2025-12-29 20:49:10.608165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8f60fc52-45ff-4e34-b6a2-83a4224ea3b8	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	employees	6f661578-7dfb-4543-83e3-1f66ccc05e9b	INSERT on employees	\N	\N	2025-12-29 21:01:53.235977+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
990d502f-4db3-459a-a0ea-2ad1ea760c22	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:13:31.269331+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3b6b5654-f21c-4b33-afbf-6f94eb6f6ce6	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	2f8742e6-2df4-4b73-a1e1-eeedead083c9	Task owner reassigned	\N	\N	2025-12-29 21:13:31.746524+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ff9a5c6a-f934-475a-ab7e-09e373644cad	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	UPDATE on tasks	\N	\N	2025-12-29 21:13:43.561108+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
604cf3b7-6ca9-41cb-84fc-84278c649cf4	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	Task owner reassigned	\N	\N	2025-12-29 21:13:43.922117+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b3a0eb57-aacb-4cbb-a010-4f9d512f7e57	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_added	task	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	Collaborator added to task	\N	\N	2025-12-29 21:13:50.625332+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d17d84d8-3c21-4b96-986b-71f1a1703797	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	UPDATE on tasks	\N	\N	2025-12-29 21:14:12.108182+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ee892374-d83c-493f-a891-8b8b486de82a	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_added	task	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	Collaborator added to task	\N	\N	2025-12-29 21:14:22.325859+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e87f5b32-e9f7-4757-b931-0c44bedaa206	b31edec7-f7a1-4c28-837f-9b9848caf405	collaborator_added	task	2f8742e6-2df4-4b73-a1e1-eeedead083c9	Collaborator added to task	\N	\N	2025-12-29 21:14:35.468063+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b916b36d-8144-4f9b-be5d-9467a076b983	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:24:13.578004+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6fe84886-6670-417d-900c-540ad30635ee	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2f8742e6-2df4-4b73-a1e1-eeedead083c9	Task moved to in_progress	\N	\N	2025-12-29 21:24:13.831403+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bdafaa36-3948-4b30-b51d-6104a719272e	b31edec7-f7a1-4c28-837f-9b9848caf405	DELETE	tasks	\N	DELETE on tasks	\N	\N	2025-12-29 21:25:30.667693+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8cd3c6da-ddd7-4da2-8aa7-c53834ac741e	b31edec7-f7a1-4c28-837f-9b9848caf405	task_deleted	task	a7f37ba8-ed55-47f6-af18-344045421e7c	Task deleted	\N	\N	2025-12-29 21:25:30.907346+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cd01e4f5-f3e3-41af-87d5-df2f18fe6cd1	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	UPDATE on tasks	\N	\N	2025-12-29 21:25:40.242352+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7e3c687b-77fc-462b-9671-03dff82be191	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	Task moved to cancelled	\N	\N	2025-12-29 21:25:40.766857+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d1bbe32c-8d26-423c-a466-8089b9d466c4	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:26:27.058837+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
330fcaa8-c2ad-4cf1-bd1a-caf684d2eefa	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:26:27.435731+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
364ceb9d-8a91-4994-8be6-f12c7f6ea6aa	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	UPDATE on tasks	\N	\N	2025-12-29 21:26:32.430756+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ba70d87d-0140-4f37-af88-88dc6431a0df	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:26:41.552973+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cfbdc46a-69a1-4df2-a810-9a5112712660	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	UPDATE on tasks	\N	\N	2025-12-29 21:26:43.486031+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0f4fed27-ba8e-414c-a44b-d3d1245dc404	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-29 21:26:45.011624+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a4e4dfd1-d7c8-4c45-873e-60f7045afd56	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-29 21:26:45.107765+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7f1271f2-b54a-4cba-9c36-92aa399d86fb	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-29 21:26:45.292348+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
afe32d19-e92d-4b6e-9420-51cce90ac74a	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	UPDATE on tasks	\N	\N	2025-12-29 21:26:45.58737+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3548ddeb-bc61-4fd7-b288-b0557ba31525	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	UPDATE on tasks	\N	\N	2025-12-29 21:26:45.766324+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e1b02fb0-3517-4df4-9b89-7642dc18dc96	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	UPDATE on tasks	\N	\N	2025-12-29 21:26:46.008795+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
faa6688a-644c-4dea-9d14-ee83091c432e	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	UPDATE on tasks	\N	\N	2025-12-29 21:26:46.465122+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fff5a321-6ad2-4fa8-b63f-b590fa929779	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	UPDATE on tasks	\N	\N	2025-12-29 21:26:46.626113+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b8511f01-21c4-45b8-bf2f-b9684c7cbc28	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	UPDATE on tasks	\N	\N	2025-12-29 21:26:46.750703+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9ac3d967-c8e5-41e1-8372-dfe5e53a357b	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-29 21:26:51.914756+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9d39cecf-a8ec-4e19-85dc-8a2acf531175	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-29 21:26:52.019772+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f4fd0278-2d00-4fa7-8382-20015a70e8ae	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-29 21:26:52.319592+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
83021682-157a-4703-b092-28ee1a5a4583	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-29 21:26:52.429234+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
047490cb-7147-412e-9d84-1087d13ac50d	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	07d2197a-a964-4842-9383-13353613aa12	UPDATE on tasks	\N	\N	2025-12-29 21:26:52.8533+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2ce4e9c5-cf62-4df2-a753-b79c781ce5f1	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	07d2197a-a964-4842-9383-13353613aa12	UPDATE on tasks	\N	\N	2025-12-29 21:26:53.092362+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a9a67172-c32a-4320-8405-0ffd6bb8e3bf	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	07d2197a-a964-4842-9383-13353613aa12	UPDATE on tasks	\N	\N	2025-12-29 21:26:53.210924+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
69984681-1354-4eae-91e1-de2597bf32db	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:26:56.297063+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3a9c5382-8bb2-46fb-afc9-83656d4c426b	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:26:59.350333+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
26691e4d-19aa-49a2-b56f-27669287bb30	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:27:54.738785+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
98a6561a-6fde-4c38-952a-96e908a13312	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2f8742e6-2df4-4b73-a1e1-eeedead083c9	Task moved to in_progress	\N	\N	2025-12-29 21:27:55.01319+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
699bb1a9-a005-47cf-9ce3-6d9217315e80	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-29 21:27:56.962921+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
53c7e3fd-f880-4135-a14a-f39ce308daa6	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Task moved to completed	\N	\N	2025-12-29 21:27:57.142449+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9bebcb5e-567c-49a5-aba2-18117c6cc469	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	UPDATE on tasks	\N	\N	2025-12-29 21:27:59.360036+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3a141c36-1ab0-4e08-a86b-a0a0a74f817a	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	534ad481-2dd8-4c07-9539-ba1b8ae03143	Task moved to completed	\N	\N	2025-12-29 21:27:59.608728+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2543cee8-47c3-4705-b99e-dd1d75c07c42	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-29 21:28:10.379053+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
46322a1f-e2fc-48aa-be6b-8a376d544b9b	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	Task marked in progress	\N	\N	2025-12-29 21:28:10.999651+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
be44b504-5524-4e1f-a68b-298d67217c8c	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-29 21:28:36.007088+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ccd8c4f8-1479-4846-8e33-759e0faa40bb	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-29 21:28:51.604917+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ea2f9f64-27d7-462c-86ff-ec4164994f50	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-29 21:29:28.971348+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f5138617-b02d-460b-be25-b19298f148a8	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-29 21:29:26.363214+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8dd464e1-d525-43b2-b7d1-e1ef544d3216	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-29 21:29:31.060103+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
80c5e1af-118f-4b3b-8ab1-0011042419c2	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-29 21:29:33.448269+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ed4e4841-0fd5-4cd1-be49-a7a0d243a7c0	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-29 21:36:50.523411+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fb9d6853-dd91-4266-afaf-be97a0833989	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	40f564b4-c3d0-40be-9503-b0310824519a	Lead moved to proposal	\N	\N	2025-12-29 21:36:50.816226+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9d152d16-aed5-4752-9b10-302efa0fcc1e	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7ce98c4e-ca66-4dec-bf99-69dfebb88245	UPDATE on leads	\N	\N	2025-12-29 21:36:53.987012+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
955f24b1-05e3-4a34-9cc3-8cd826df31e6	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7ce98c4e-ca66-4dec-bf99-69dfebb88245	Lead moved to proposal	\N	\N	2025-12-29 21:36:54.191172+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
25b84375-4569-4a44-8f6a-dcbc99c83f2a	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	7ce98c4e-ca66-4dec-bf99-69dfebb88245	UPDATE on leads	\N	\N	2025-12-29 21:36:58.212972+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
413b7f90-8d24-46ac-a9b1-e35e693e8460	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	7ce98c4e-ca66-4dec-bf99-69dfebb88245	Lead moved to won	\N	\N	2025-12-29 21:36:58.428959+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4ba27655-703d-49f3-8b2e-3df2d1846ee1	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	40f564b4-c3d0-40be-9503-b0310824519a	UPDATE on leads	\N	\N	2025-12-29 21:36:59.827064+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
efa35383-3867-4cc8-bfca-702d1f4bc2b8	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	40f564b4-c3d0-40be-9503-b0310824519a	Lead moved to lost	\N	\N	2025-12-29 21:37:00.071359+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
79f31239-83e6-4687-8b61-8ae0103e265b	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	deals	cf56f4fe-97e3-4007-b227-f4799d58f4cd	INSERT on deals	\N	\N	2025-12-29 21:39:35.60484+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d2e69fae-73e7-4650-8db6-48364d5cb605	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	UPDATE on tasks	\N	\N	2025-12-29 21:40:28.272355+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c4457ee6-597d-411a-bd47-e68cd82abbde	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-29 21:53:59.413483+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f198ef5f-17b8-4b47-ae8f-0307b75be985	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Task marked in progress	\N	\N	2025-12-29 21:54:00.081531+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
196f9b0c-e390-4810-b8fe-dbf4b665458f	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-29 21:54:05.618463+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
72b5f9f5-7caf-4748-963b-8e2d6b16e595	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	Task marked in progress	\N	\N	2025-12-29 21:54:06.383075+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
613b605a-2d40-4716-989d-41eb8fa71544	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-29 21:54:09.06059+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
08ed0eb7-1b1d-4822-80e4-3219a2f4f1ef	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	Task marked in progress	\N	\N	2025-12-29 21:54:09.725149+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
278250a2-8f53-48c7-9059-b9d90da6d510	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-29 21:54:10.859911+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e1c79afa-67a2-4f82-b425-9946abe52638	b31edec7-f7a1-4c28-837f-9b9848caf405	task_started	task	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	Task marked in progress	\N	\N	2025-12-29 21:54:11.616814+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
94f2429b-bc4a-4537-a4d5-8b2de1f9acaf	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	UPDATE on tasks	\N	\N	2025-12-29 21:54:12.34147+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
862bee42-21c6-4378-9e63-06d1b0b5c407	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-30 05:42:43.912898+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b5513405-d3a3-4147-84f9-23262e5e9ee5	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	leads	3bbc8354-f139-4a68-af79-357cd934047c	UPDATE on leads	\N	\N	2025-12-30 05:42:44.30955+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
41afbbd2-15bf-40e7-8501-392ced5533f7	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead moved to qualified	\N	\N	2025-12-30 05:42:44.525173+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4ed390e9-ec7d-4ee2-b0e5-77e0cc19280b	b31edec7-f7a1-4c28-837f-9b9848caf405	lead_status_changed	lead	3bbc8354-f139-4a68-af79-357cd934047c	Lead moved to contacted	\N	\N	2025-12-30 05:42:44.576905+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7b63f279-96ab-49cd-9d79-a3b570aefc1b	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	1890fade-d586-416e-9628-9d69560be41b	UPDATE on deals	\N	\N	2025-12-30 05:56:47.876305+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9de471bc-b859-44dd-883f-a9b03144ad86	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	UPDATE on deals	\N	\N	2025-12-30 05:56:56.601938+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1ae9f29e-d686-44cc-8bab-86fabc762b98	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-30 05:57:09.237977+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
74361ba0-a5b5-44cc-b75b-a9e53e27368b	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	68caba55-d79d-4776-b8fe-d75de6d41aec	Task moved to in_progress	\N	\N	2025-12-30 05:57:09.329798+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6f635ea4-b724-4287-9408-c2993b78a9c3	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	UPDATE on tasks	\N	\N	2025-12-30 05:57:35.355228+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c766acbf-a0e1-4ac2-b8ca-6e81a46e393c	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-30 05:57:41.26283+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c15e5576-fc21-49cf-b2a2-0a48d5ec1a91	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	UPDATE on tasks	\N	\N	2025-12-30 05:57:48.288339+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
968b6ab1-65c0-442d-b2b6-6b0b0abba7f5	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	534ad481-2dd8-4c07-9539-ba1b8ae03143	UPDATE on tasks	\N	\N	2025-12-30 05:57:58.833772+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
dd016948-f229-4bfe-ac42-b16a081a22da	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	INSERT on tasks	\N	\N	2025-12-30 05:58:47.3947+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
47c4bb76-9983-4370-b6e7-322d3b941f0e	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 06:26:02.346192+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c25045c8-86f0-4a10-81c7-78aaf76793ca	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2b5fb755-ac13-43d8-867a-87a77870570f	Task moved to in_progress	\N	\N	2025-12-30 06:26:02.526156+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4da72933-815c-4fac-8b2d-6cd853427b6c	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-30 06:26:05.504561+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5683084c-9128-42a0-bd04-c22648954713	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Task moved to in_progress	\N	\N	2025-12-30 06:26:05.633432+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
744d2c4f-a091-4907-b69d-247a6b10743d	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-30 06:26:10.308022+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ca9a6f22-649f-4fc9-ae33-860a1f78f7ec	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Task moved to in_progress	\N	\N	2025-12-30 06:26:10.397807+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bb382474-ec27-4526-b5ec-9e610e42b85f	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2f8742e6-2df4-4b73-a1e1-eeedead083c9	UPDATE on tasks	\N	\N	2025-12-30 06:26:12.371137+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1067e742-ce3e-44ff-b9d6-d626ff5b282c	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2f8742e6-2df4-4b73-a1e1-eeedead083c9	Task moved to in_progress	\N	\N	2025-12-30 06:26:12.454191+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
dbaff4f2-0a4b-4988-8ff8-1ed2030bc688	1c786a19-b2ca-41fd-8750-f427fb4c6b76	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 06:57:42.338609+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e497bfa1-6324-46a2-9f88-2834ebf93562	1c786a19-b2ca-41fd-8750-f427fb4c6b76	task_status_changed	task	2b5fb755-ac13-43d8-867a-87a77870570f	Task moved to completed	\N	\N	2025-12-30 06:57:42.616116+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
aefe257a-f8dd-4c3e-9cfe-5ad5acaa4d72	1c786a19-b2ca-41fd-8750-f427fb4c6b76	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 06:57:43.925183+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e637e6b0-0dae-48ff-ae3a-e97c1be5b548	1c786a19-b2ca-41fd-8750-f427fb4c6b76	task_status_changed	task	2b5fb755-ac13-43d8-867a-87a77870570f	Task moved to in_progress	\N	\N	2025-12-30 06:57:44.074103+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
eaf9954a-20d4-450a-b70e-b7a6c9cf182e	1c786a19-b2ca-41fd-8750-f427fb4c6b76	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 06:57:46.88423+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
518296f3-fe1a-4efd-9d4a-222a379828d1	1c786a19-b2ca-41fd-8750-f427fb4c6b76	task_status_changed	task	2b5fb755-ac13-43d8-867a-87a77870570f	Task moved to todo	\N	\N	2025-12-30 06:57:47.104092+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
761080c1-39c9-48f8-9e8e-3d4c374635db	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	UPDATE on deals	\N	\N	2025-12-30 07:17:21.549074+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f439d266-6bd8-4e8b-bd04-d7692f0e09f2	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	tasks	8238ad02-586d-401e-b9cb-2e5d2494cdbe	INSERT on tasks	\N	\N	2025-12-30 07:17:21.690903+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
59fceb9f-07b7-46b0-80f5-020245d6d5d1	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	Stage set to negotiation and follow-up task created	\N	\N	2025-12-30 07:17:21.830176+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2a64bdcb-dd83-43b6-b15a-cb1c0ce04cf7	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	UPDATE on tasks	\N	\N	2025-12-30 07:18:02.187382+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a37c60f8-2091-4800-9ca7-f24558387c7d	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Task moved to completed	\N	\N	2025-12-30 07:18:02.288929+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7dd990e5-97ae-4958-b44e-6246ccb50661	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	68caba55-d79d-4776-b8fe-d75de6d41aec	UPDATE on tasks	\N	\N	2025-12-30 07:18:18.493465+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
133b5f5a-d9cf-42ae-907d-4392864ac171	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	68caba55-d79d-4776-b8fe-d75de6d41aec	Task owner reassigned	\N	\N	2025-12-30 07:18:18.74637+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7e0f1c36-c71f-4afc-bb97-71f9c4bc3f46	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	UPDATE on tasks	\N	\N	2025-12-30 07:19:03.567806+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8b023955-ec3f-4ae3-9182-451b860ea720	b31edec7-f7a1-4c28-837f-9b9848caf405	task_reassigned	task	d37b4c04-2866-4999-bfd6-25ecd32ce3f3	Task owner reassigned	\N	\N	2025-12-30 07:19:03.789169+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a31e3935-451e-4289-9450-52e91f24a3a8	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	a1b35373-cad5-4e4c-b59a-d34b93bf844e	UPDATE on tasks	\N	\N	2025-12-30 07:19:43.384222+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
082eb669-4b9d-44cd-a186-f5e15131928f	b31edec7-f7a1-4c28-837f-9b9848caf405	task_status_changed	task	a1b35373-cad5-4e4c-b59a-d34b93bf844e	Task moved to cancelled	\N	\N	2025-12-30 07:19:43.493239+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
88e0bb2e-4555-43ed-b1e7-9a9d438dae12	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 07:27:50.702037+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e7f09890-af2f-4ca9-a21f-7be72bf541d4	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	91c70b2e-7ec7-49ca-8d4b-4cc7e1e40598	UPDATE on tasks	\N	\N	2025-12-30 07:28:02.000364+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
89e0138d-1f25-4814-abde-40b524989f9f	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	tasks	2b5fb755-ac13-43d8-867a-87a77870570f	UPDATE on tasks	\N	\N	2025-12-30 07:28:18.759865+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ed41a271-1e1b-471c-b570-ad0c7c3a066b	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	cfeee563-250b-4890-a5d5-87b6c89adaa0	UPDATE on deals	\N	\N	2025-12-30 11:11:04.617319+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
69fa74d3-3faa-4d50-9f80-d3f6b9c65037	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	1890fade-d586-416e-9628-9d69560be41b	UPDATE on deals	\N	\N	2025-12-30 11:11:05.815074+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
238dd50d-f9de-423e-af43-8d5eb5f6dfdc	b31edec7-f7a1-4c28-837f-9b9848caf405	INSERT	tasks	90e8f71e-b710-4444-b7ff-b5d34a647c76	INSERT on tasks	\N	\N	2025-12-30 11:11:05.956561+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3fa7c2eb-cdd6-40ec-9c0c-74fc7b6efbf2	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_stage_changed	deal	1890fade-d586-416e-9628-9d69560be41b	Stage set to proposal and follow-up task created	\N	\N	2025-12-30 11:11:06.125917+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
83f9f5e3-17ea-4f8a-a11b-a4ab486ad189	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	1890fade-d586-416e-9628-9d69560be41b	UPDATE on deals	\N	\N	2025-12-30 11:11:07.900256+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7ce3bc4f-36d3-4943-94d6-12fd376b0aa2	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	UPDATE on deals	\N	\N	2025-12-30 11:11:13.14772+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
23b50bad-cbb8-467b-bf27-9415cb245bfc	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_lost	deal	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	Deal marked closed_lost	\N	\N	2025-12-30 11:11:13.246773+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a6113d1a-9f76-4e91-8395-2c82b19d381d	b31edec7-f7a1-4c28-837f-9b9848caf405	UPDATE	deals	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	UPDATE on deals	\N	\N	2025-12-30 11:11:14.852986+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c500530b-1013-47cb-af95-5ea5e2b2af86	b31edec7-f7a1-4c28-837f-9b9848caf405	deal_won	deal	46f0514e-3f43-408e-b5f5-aa3e49ffbef8	Deal marked closed_won	\N	\N	2025-12-30 11:11:14.952828+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, employee_id, date, check_in, check_out, status, notes, created_at, updated_at, punch_in, punch_out, organization_id) FROM stdin;
c6f7f6bd-8301-46d7-8d28-37b6a67fbf85	887ded8b-2573-47cb-9fcf-2641ace4ad44	2025-12-29	09:00:00	17:00:00	present	ff	2025-12-29 20:46:50.868615+00	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: chat_channels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_channels (id, type, name, department_id, created_by, created_at, updated_at, organization_id, project_id) FROM stdin;
471b3af2-c3bb-41d3-bc76-717895d4b514	group	eee	\N	35ad9461-0240-487c-9dfb-9883cca83fef	2025-12-29 16:11:38.729514+00	2025-12-29 16:11:38.729514+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
ea7a45a2-4daf-473d-9e3d-caaf2ed12429	group	RE	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 16:07:29.522519+00	2025-12-29 19:34:04.049+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
1e45b508-2a84-48bb-8a60-73caaae37c58	direct	\N	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 16:07:03.060867+00	2025-12-30 07:16:00.121+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
89941550-1674-4169-8da8-4b31d369dc2f	group	Project: ffds	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 16:22:48.635586+00	2025-12-30 16:30:46.061+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	695a27d4-181a-4ef6-a766-3ebc2f892d00
2d85dcfb-f23d-4899-9e46-69d87adc4a8c	group	sdfsdf	\N	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	2025-12-31 11:19:20.386248+00	2025-12-31 11:19:20.386248+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
045d09db-193f-4030-8bcd-af739297f6dc	project	dsfsdf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 12:33:09.508874+00	2025-12-31 12:33:09.508874+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	dc6773fa-7d35-465c-97e0-1fe5437b4206
2526a78c-96c4-4172-a1e7-11299df846c4	project	dd	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 12:05:18.6891+00	2025-12-31 15:44:45.626+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	1b8c0495-9fe3-4c50-8b89-6851f1a97603
8638487e-ddcf-4810-8207-0ff9c773d2f0	project	dfdsf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 11:55:10.714941+00	2026-01-01 00:43:59.835+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883
\.


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_messages (id, channel_id, sender_id, content, attachments, created_at, updated_at, organization_id) FROM stdin;
8fbe15b4-8b41-40f8-9f97-735d33ee826f	1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:07:12.09078+00	2025-12-29 16:07:12.09078+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
44addb69-4e0f-4e67-a98f-2cfaa3f42d0d	1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	how are you	[]	2025-12-29 16:07:21.00156+00	2025-12-29 16:07:21.00156+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
80c503de-abe6-4cb3-b00d-acc2b7d0ae61	1e45b508-2a84-48bb-8a60-73caaae37c58	35ad9461-0240-487c-9dfb-9883cca83fef	im fine 	[]	2025-12-29 16:10:08.490504+00	2025-12-29 16:10:08.490504+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
67fef634-e12b-4f3c-8bc9-c60c0ec7b94e	1e45b508-2a84-48bb-8a60-73caaae37c58	35ad9461-0240-487c-9dfb-9883cca83fef	what about u	[]	2025-12-29 16:10:26.232285+00	2025-12-29 16:10:26.232285+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c634ef68-b9b1-4a7b-b094-690deda0ee08	1e45b508-2a84-48bb-8a60-73caaae37c58	35ad9461-0240-487c-9dfb-9883cca83fef	df	[]	2025-12-29 16:10:33.552366+00	2025-12-29 16:10:33.552366+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3ed83eff-9efa-48be-857a-07b9c90a5691	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:17:18.593476+00	2025-12-29 16:17:18.593476+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a40270ff-f704-41aa-bc62-0552f9888d3c	1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:17:58.899684+00	2025-12-29 16:17:58.899684+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cb92c775-34a1-48b8-90ed-ad3991adce43	1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:18:11.120627+00	2025-12-29 16:18:11.120627+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f861430c-35c2-4e44-8067-a8778d5023db	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:18:31.596505+00	2025-12-29 16:18:31.596505+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c3b10edc-3a74-48b0-9b5a-7b1288de217b	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:19:13.863148+00	2025-12-29 16:19:13.863148+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
46bfbebb-78d3-41fe-b9fd-5d6a3a46a2c5	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:19:24.678223+00	2025-12-29 16:19:24.678223+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2eebddc3-5497-47ef-9248-71dade630cd1	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:19:43.188579+00	2025-12-29 16:19:43.188579+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
e9758061-e2d4-44c1-a263-c8def7723874	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 16:22:25.928119+00	2025-12-29 16:22:25.928119+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c63a8c84-da36-484b-9a11-e474cc54bc22	1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	ihh	[]	2025-12-29 16:22:31.837197+00	2025-12-29 16:22:31.837197+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
bafd03bb-1648-4df2-8ba6-939275919750	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-29 19:34:04.721366+00	2025-12-29 19:34:04.721366+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ca07c920-5ac9-44d8-ba90-39aa10ed0562	1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-30 07:15:59.970054+00	2025-12-30 07:15:59.970054+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6a71e4e9-3131-4f33-a6b8-2048ebd0ebcf	89941550-1674-4169-8da8-4b31d369dc2f	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-30 16:30:46.510831+00	2025-12-30 16:30:46.510831+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
0fead72f-93c1-4cc3-b65d-b3f72dfd352d	8638487e-ddcf-4810-8207-0ff9c773d2f0	b31edec7-f7a1-4c28-837f-9b9848caf405	ddd	[]	2025-12-31 11:55:51.618312+00	2025-12-31 11:55:51.618312+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
67046a19-db68-4177-a684-7f750193f0f5	2526a78c-96c4-4172-a1e7-11299df846c4	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-31 15:41:13.909187+00	2025-12-31 15:41:13.909187+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a9277faf-f8b8-4b3d-aafb-9ae7a6a6d199	2526a78c-96c4-4172-a1e7-11299df846c4	b31edec7-f7a1-4c28-837f-9b9848caf405	hi	[]	2025-12-31 15:44:46.480244+00	2025-12-31 15:44:46.480244+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4e2bd644-3566-492a-8823-5b6293eb7bf5	8638487e-ddcf-4810-8207-0ff9c773d2f0	b31edec7-f7a1-4c28-837f-9b9848caf405	before employeee	[]	2026-01-01 00:43:45.351255+00	2026-01-01 00:43:45.351255+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
f6069a72-f25a-4239-8c32-7a67cb76571f	8638487e-ddcf-4810-8207-0ff9c773d2f0	b31edec7-f7a1-4c28-837f-9b9848caf405	after employee	[]	2026-01-01 00:43:59.929028+00	2026-01-01 00:43:59.929028+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: chat_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_participants (channel_id, user_id, joined_at, last_read_at, organization_id) FROM stdin;
1e45b508-2a84-48bb-8a60-73caaae37c58	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 16:07:03.060867+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1e45b508-2a84-48bb-8a60-73caaae37c58	35ad9461-0240-487c-9dfb-9883cca83fef	2025-12-29 16:07:03.240837+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 16:07:29.522519+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
471b3af2-c3bb-41d3-bc76-717895d4b514	35ad9461-0240-487c-9dfb-9883cca83fef	2025-12-29 16:11:38.729514+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ea7a45a2-4daf-473d-9e3d-caaf2ed12429	35ad9461-0240-487c-9dfb-9883cca83fef	2025-12-29 16:16:55.078057+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
ea7a45a2-4daf-473d-9e3d-caaf2ed12429	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	2025-12-29 16:17:14.356085+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
89941550-1674-4169-8da8-4b31d369dc2f	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 16:22:48.635586+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
89941550-1674-4169-8da8-4b31d369dc2f	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	2025-12-30 16:31:05.556162+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2d85dcfb-f23d-4899-9e46-69d87adc4a8c	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	2025-12-31 11:19:20.386248+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8638487e-ddcf-4810-8207-0ff9c773d2f0	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 11:55:10.714941+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
2526a78c-96c4-4172-a1e7-11299df846c4	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 12:05:18.6891+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
045d09db-193f-4030-8bcd-af739297f6dc	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 12:33:09.508874+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8638487e-ddcf-4810-8207-0ff9c773d2f0	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	2026-01-01 00:43:22.712817+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8638487e-ddcf-4810-8207-0ff9c773d2f0	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	2026-01-01 00:43:52.779799+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (id, name, industry, website, phone, email, address, city, country, logo_url, created_by, created_at, updated_at, organization_id) FROM stdin;
8406a40f-38fa-4dcf-9176-0727e1b04fb5	sdfdsf	sdfsf	https://hacketon.com	06374193712	sdfs@gmail.com	4/167-2, Kamarajpettai	Dharmapuri	India	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 05:57:32.682092+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6d464f4f-75f6-4e36-a2dd-66f7f7222a6c	sdf	\N	\N	\N	\N	\N	\N	\N	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2026-01-01 00:41:44.02491+00	2026-01-01 00:41:44.02491+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contacts (id, first_name, last_name, email, phone, company_id, "position", notes, avatar_url, created_by, created_at, updated_at, organization_id) FROM stdin;
b300a3f2-7d17-469e-a6f6-991c2870e9e0	Sridhar	D	sdfs@gamil.com	06374193712	\N	sdfsd	sdfsf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 05:56:45.505856+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5c6bf342-3920-4a77-8529-6a394d11886a	Sridhar	J D	\N	+916374193712	\N	\N	Converted from Lead: gggd. \nsdfsf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 06:30:52.252929+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a3c75970-9473-40be-ae2e-e708c6179e16	Sridhar	J D	\N	+916374193712	\N	\N	Converted from Lead: gggd. \nsdfsf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 07:06:01.012112+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
829d1942-9c15-45f2-8e43-36719c7c79a1	Sridhar	J D	\N	+916374193712	\N	\N	Converted from Lead: gggd. \nsdfsf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 10:45:00.288496+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
fae5b99f-d063-4bcf-95ce-58b247c52167	vishal	B M	vishalmurugavel105@gmail.com	06374221609	\N	\N	Converted from Lead: ss. \nsdfsf	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 10:54:50.644258+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5f39ad63-2e59-420c-a3db-e96cee17ba6c	sdf		vishalmurugavel105@gmail.com	06374221609	\N	\N	Converted from Lead: sdf. \nsfd	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2026-01-01 00:41:43.824536+00	2026-01-01 00:41:43.824536+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: deals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deals (id, title, description, value, stage, probability, expected_close_date, assigned_to, company_id, contact_id, lead_id, created_by, created_at, updated_at, amount, organization_id) FROM stdin;
1890fade-d586-416e-9628-9d69560be41b	Sridhar J D	\N	0.00	proposal	0	\N	\N	\N	5c6bf342-3920-4a77-8529-6a394d11886a	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 06:31:51.49401+00	2025-12-31 03:32:23.233383+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
9b078e58-0ca6-452a-94dc-96ec6ece641c	Sridhar J D	\N	0.00	proposal	0	\N	\N	\N	829d1942-9c15-45f2-8e43-36719c7c79a1	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 10:50:27.872322+00	2025-12-30 11:31:09.901165+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
44dd434b-4032-4f26-bd3a-d5afc8b43535	Sridhar D	\N	0.00	qualification	0	\N	\N	\N	b300a3f2-7d17-469e-a6f6-991c2870e9e0	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 10:45:06.188491+00	2025-12-30 11:31:09.901165+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cf56f4fe-97e3-4007-b227-f4799d58f4cd	something	something	100000.00	closed_won	100	2026-01-07	b31edec7-f7a1-4c28-837f-9b9848caf405	8406a40f-38fa-4dcf-9176-0727e1b04fb5	\N	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 21:39:35.60484+00	2025-12-30 11:31:09.901165+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	Sridhar D	\N	0.00	negotiation	0	\N	\N	\N	b300a3f2-7d17-469e-a6f6-991c2870e9e0	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 06:19:33.873194+00	2025-12-30 11:31:09.901165+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
cfeee563-250b-4890-a5d5-87b6c89adaa0	vishal B M	\N	0.00	prospecting	0	\N	\N	\N	fae5b99f-d063-4bcf-95ce-58b247c52167	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 16:23:46.166503+00	2025-12-30 11:31:09.901165+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
46f0514e-3f43-408e-b5f5-aa3e49ffbef8	sdfsdf	sdfs	474.00	closed_won	50	2025-12-04	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	8406a40f-38fa-4dcf-9176-0727e1b04fb5	b300a3f2-7d17-469e-a6f6-991c2870e9e0	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 05:57:52.764766+00	2025-12-30 11:31:09.901165+00	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, name, description, manager_id, created_at, updated_at, organization_id) FROM stdin;
c65bd29a-5ff9-4cc4-81fc-7b79831e8df3	Marketing	Markets	\N	2025-12-29 11:39:00.518426+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: designations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.designations (id, title, description, department_id, created_at, updated_at, organization_id) FROM stdin;
3d67f204-f4cb-404c-9326-83fa4cf1644e	Marketing Manager	sdfs	c65bd29a-5ff9-4cc4-81fc-7b79831e8df3	2025-12-29 11:40:54.53942+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4eeaf617-36bc-45f4-9d0b-62cc369d0585	Sales clerk	nothing\n	c65bd29a-5ff9-4cc4-81fc-7b79831e8df3	2025-12-29 21:01:07.59271+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: email_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_templates (id, organization_id, name, subject, body, created_at, updated_at, created_by) FROM stdin;
32bf0f14-75d4-4077-88b3-922f79b0757b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	sfs	fdsfssf	sfsdfsfsfsfsfsf	2026-01-01 00:37:19.185596+00	2026-01-01 00:37:19.185596+00	b31edec7-f7a1-4c28-837f-9b9848caf405
\.


--
-- Data for Name: emails_outbox; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emails_outbox (id, template_id, recipient_user_id, recipient_email, status, sent_at, organization_id, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, user_id, employee_id, department_id, designation_id, hire_date, salary, status, phone, address, emergency_contact, created_at, updated_at, organization_id) FROM stdin;
887ded8b-2573-47cb-9fcf-2641ace4ad44	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	EMP001	c65bd29a-5ff9-4cc4-81fc-7b79831e8df3	3d67f204-f4cb-404c-9326-83fa4cf1644e	2025-12-29	50000.00	active	4444444444	dsfffdsf	\N	2025-12-29 16:26:01.312227+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
6f661578-7dfb-4543-83e3-1f66ccc05e9b	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	Emp0002	c65bd29a-5ff9-4cc4-81fc-7b79831e8df3	4eeaf617-36bc-45f4-9d0b-62cc369d0585	2025-12-29	10000.00	active	0987654321	sfsfs	\N	2025-12-29 21:01:53.235977+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
baed20e6-f79c-439e-a2fa-01ff6dd930c4	1c786a19-b2ca-41fd-8750-f427fb4c6b76	EMP003	c65bd29a-5ff9-4cc4-81fc-7b79831e8df3	3d67f204-f4cb-404c-9326-83fa4cf1644e	2025-12-31	20000.00	active	0123456789	14, periyar nagar, valaraigate	\N	2025-12-31 15:42:45.217416+00	2025-12-31 15:42:45.217416+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: event_attendees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_attendees (id, event_id, user_id, organization_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, title, start_time, end_time, type, related_id, created_at, updated_at, meeting_link, created_by) FROM stdin;
cf3d706b-1ab5-417d-96ab-e60acc862bd1	dfsdf	2025-12-30 17:44:00+00	2025-12-30 17:45:00+00	meeting	eaee7955-cebe-4515-956e-8f3a1420f3f3	2025-12-30 12:14:56.206788+00	2025-12-30 12:14:56.206788+00	\N	\N
db3af225-36d1-4977-9c70-34703f64572b	project discussion	2025-12-30 20:25:00+00	2025-12-30 20:26:00+00	meeting	eaee7955-cebe-4515-956e-8f3a1420f3f3	2025-12-30 14:51:57.787815+00	2025-12-30 14:51:57.787815+00	\N	\N
d1b2df46-ae22-4617-8362-281ff8cf0627	ddd	2025-12-30 21:47:00+00	2025-12-30 21:47:00+00	meeting	eaee7955-cebe-4515-956e-8f3a1420f3f3	2025-12-30 16:16:31.62786+00	2025-12-30 16:16:31.62786+00		\N
\.


--
-- Data for Name: invitations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invitations (id, email, organization_id, role, token, status, created_at, created_by) FROM stdin;
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leads (id, title, description, value, status, source, assigned_to, company_id, contact_id, created_by, created_at, updated_at, company_name, contact_name, email, phone, notes, name, organization_id) FROM stdin;
40f564b4-c3d0-40be-9503-b0310824519a	ss	sdfsf	435.00	won	Referral	\N	\N	fae5b99f-d063-4bcf-95ce-58b247c52167	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 10:44:53.272396+00	2025-12-30 15:15:36.668578+00	ss	vishal B M	vishalmurugavel105@gmail.com	06374221609	sdfsf	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7edc4564-f42a-40bc-b332-4a65133431e2	ggg	fsdsf	74.00	won	Website	\N	\N	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 05:35:11.786106+00	2025-12-30 15:15:43.930749+00	ggg	Sridhar J D	xyz@gmail.com	+916374193712	fsdsf	ggg	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
3bbc8354-f139-4a68-af79-357cd934047c	gggd	sdfsf	75527.00	won	Cold Call	\N	\N	829d1942-9c15-45f2-8e43-36719c7c79a1	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 06:30:34.224304+00	2025-12-30 15:15:46.258644+00	gggd	Sridhar J D	\N	+916374193712	sdfsf	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7ce98c4e-ca66-4dec-bf99-69dfebb88245	sdf	sfd	435.00	qualified	Referral	\N	6d464f4f-75f6-4e36-a2dd-66f7f7222a6c	5f39ad63-2e59-420c-a3db-e96cee17ba6c	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 20:41:00.886518+00	2026-01-01 00:41:44.02491+00	sdf	sdf	vishalmurugavel105@gmail.com	06374221609	sfd	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
7388973e-c669-47be-873c-813b726d1e58	tenant1 lead	sfsf	100.00	contacted	Website	\N	\N	\N	8a86a547-c01e-4e66-826b-ed1e2fab2d86	2026-01-01 03:37:57.622861+00	2026-01-01 03:37:57.622861+00	tenant1 lead	sss	john@gmail.com	123345897	sfsf	\N	98b41759-8acc-498a-8ee6-bed16d2704fb
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (id, employee_id, leave_type, start_date, end_date, reason, status, approved_by, approved_at, created_at, updated_at, organization_id) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, entity_type, entity_id, author_id, content, mentions, created_at, organization_id) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, type, entity_type, entity_id, title, body, read, created_at, organization_id, project_id, meeting_id) FROM stdin;
a924429e-e42c-4151-9b46-9cfad736d357	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	how are you	t	2025-12-29 16:07:21.00156+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
13254f6d-29b8-4b36-980a-e48abddac7bb	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	8638487e-ddcf-4810-8207-0ff9c773d2f0	New Message	after employee	t	2026-01-01 00:43:59.929028+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
76f8f658-fac2-41ba-85ec-80ae9cdde00b	b31edec7-f7a1-4c28-837f-9b9848caf405	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	df	t	2025-12-29 16:10:33.552366+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
8b27badf-fa2e-459b-b305-6bd1a1bafb8d	b31edec7-f7a1-4c28-837f-9b9848caf405	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	im fine 	t	2025-12-29 16:10:08.490504+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
4b882fe0-dd9b-45e8-9e56-fa34fa5e5cae	b31edec7-f7a1-4c28-837f-9b9848caf405	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	what about u	t	2025-12-29 16:10:26.232285+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
e60617ca-0505-439f-9d81-13243d4135b3	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	8638487e-ddcf-4810-8207-0ff9c773d2f0	New Message	before employeee	t	2026-01-01 00:43:45.351255+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
69ef7e35-ac69-428e-ac8a-8d39a105b247	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	hi	t	2025-12-29 16:07:12.09078+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
bb6b1277-250e-4804-b526-9d0014b2bb59	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:17:18.593476+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
bcb753ca-e966-481d-9271-6eb376f0ead9	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	hi	t	2025-12-29 16:17:58.899684+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
2d933f63-e9ad-4abe-a11d-db05b98bc70d	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	hi	t	2025-12-29 16:18:11.120627+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
d62a06ef-ad33-4f68-a26c-dcc65e3eb7ad	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:18:31.596505+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
36d7d982-d429-44c9-8dd8-847db964b88d	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:17:18.593476+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
567cc40e-d4a6-4745-b859-757d1b97424f	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:18:31.596505+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
124f3d09-c85f-4a61-921b-4e1420d3b8b1	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:19:13.863148+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
923049f4-9c77-4fe2-8607-08e0beb0644c	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:19:24.678223+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
4ae55f85-bcfe-4956-a993-c4fecafa7368	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:19:43.188579+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
f712363b-da70-4f7d-ba87-8f63a1d89cb1	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:22:25.928119+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
4505c995-73b0-4812-a3fc-2c0e9baf4d88	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 19:34:04.721366+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
6f311d00-c241-4156-a59c-4b380caa54f2	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	message	chat_channel	8638487e-ddcf-4810-8207-0ff9c773d2f0	New Message	after employee	f	2026-01-01 00:43:59.929028+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
3ad8fe2c-6c2a-4dcf-abdd-111bb43b99ec	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:19:13.863148+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
8d444044-a600-4b7b-be5f-f7fd4da0ef18	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:19:24.678223+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
cf004d6f-101c-47ab-8983-86ff8f821923	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:19:43.188579+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
2be6f17f-f62e-43bf-b1ff-a7ca61d1ea8b	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 16:22:25.928119+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
1c6d1cdb-cb6e-4527-a30e-fc601f4bf243	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	ihh	t	2025-12-29 16:22:31.837197+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
65de4070-d1e4-441a-8815-315b51728151	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	ea7a45a2-4daf-473d-9e3d-caaf2ed12429	New Message	hi	t	2025-12-29 19:34:04.721366+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
181c7ba6-d6a8-4f7f-983d-f900293d4274	35ad9461-0240-487c-9dfb-9883cca83fef	message	chat_channel	1e45b508-2a84-48bb-8a60-73caaae37c58	New Message	hi	t	2025-12-30 07:15:59.970054+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, created_at, updated_at, status) FROM stdin;
6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	Default Organization	2025-12-30 11:31:09.901165+00	2025-12-30 11:31:09.901165+00	active
98b41759-8acc-498a-8ee6-bed16d2704fb	Something	2026-01-01 02:11:23.92655+00	2026-01-01 02:11:23.92655+00	active
240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	tenant2	2026-01-01 03:39:31.63041+00	2026-01-01 03:39:31.63041+00	active
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, deal_id, amount, status, paid_at, created_at) FROM stdin;
\.


--
-- Data for Name: payroll; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll (id, employee_id, month, year, basic_salary, allowances, deductions, net_salary, status, paid_at, created_at, updated_at, basic, net_pay, organization_id, approval_status, approved_by, approved_at, decision_note, rejection_note) FROM stdin;
fdf3622a-a84d-442f-a7c1-0f59b1afda2b	6f661578-7dfb-4543-83e3-1f66ccc05e9b	12	2025	10000.00	0.00	0.00	10000.00	paid	2025-12-29 21:37:56.489+00	2025-12-29 21:37:43.118929+00	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N	\N	\N	\N
2b9550c8-fa9d-4c52-b520-bdf19b9ff0b1	887ded8b-2573-47cb-9fcf-2641ace4ad44	12	2025	50000.00	1000.00	500.00	50500.00	paid	2025-12-30 07:22:20.344+00	2025-12-29 20:43:28.974577+00	2025-12-30 11:31:09.901165+00	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N	\N	\N	\N	\N
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, email, full_name, avatar_url, is_active, last_login, created_at, updated_at, organization_id, super_admin) FROM stdin;
b31edec7-f7a1-4c28-837f-9b9848caf405	vishalmurugavel105@gmail.com	admin	\N	t	\N	2025-12-29 16:06:50.37366+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	f
b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	manager@crm.test	manager@crm.test	\N	t	\N	2025-12-29 16:06:50.37366+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	f
984d4095-ec12-4d0a-9ec9-5ffb28ed133d	employee@crm.test	employee@crm.test	\N	t	\N	2025-12-29 16:06:50.37366+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	f
1808cd63-8cef-4e66-8cb0-67e68251f22c	gowthamp990@gmail.com	Gowtham	\N	t	\N	2025-12-30 06:29:10.253697+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	f
1c786a19-b2ca-41fd-8750-f427fb4c6b76	gowthamp1614@gmail.com	Gowtham	\N	t	\N	2025-12-30 06:42:17.520859+00	2025-12-30 11:31:09.901165+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	f
35ad9461-0240-487c-9dfb-9883cca83fef	admin@crm.test	admin@crm.test	\N	t	\N	2025-12-29 16:06:50.37366+00	2026-01-01 02:04:25.275814+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	t
f77f95e8-5d65-4aa6-8fb8-18e0cfbe72a8	dev.user.ccbfc6c7-b407-4519-ad7d-db6896970a86@example.com	Dev User	\N	t	\N	2026-01-01 03:25:35.204209+00	2026-01-01 03:25:35.204209+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	f
8a86a547-c01e-4e66-826b-ed1e2fab2d86	tenant1@gmail.com	tenant1	\N	t	\N	2026-01-01 03:26:59.327459+00	2026-01-01 03:27:39.743846+00	98b41759-8acc-498a-8ee6-bed16d2704fb	f
f1d803e3-7e13-4232-a1c1-6f1ef1e65355	tenant2@gmail.com	tenant2	\N	t	\N	2026-01-01 03:38:32.415968+00	2026-01-01 03:45:09.226319+00	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	f
\.


--
-- Data for Name: project_meetings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_meetings (id, project_id, title, meeting_link, created_by, created_at, start_time, end_time, organization_id) FROM stdin;
28a93c88-aa3d-4f8a-ad8d-498f4be89ef7	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	tiile	http://localhost:8080/projects/b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	\N	2026-01-01 00:48:07.64713+00	2026-01-01 06:15:00+00	2026-01-01 06:17:00+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
8762aba1-fc06-4484-9bdf-80fb5a00a5f1	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	,,,,	http://localhost:8080/projects/b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	\N	2026-01-01 01:04:33.699179+00	2026-01-31 06:37:00+00	2026-01-01 06:34:00+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: project_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_members (id, project_id, employee_id, role, added_at, organization_id) FROM stdin;
0cb5c119-c51a-4d32-bfaa-1eb5211550a1	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	887ded8b-2573-47cb-9fcf-2641ace4ad44	\N	2026-01-01 00:43:22.712817+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
28b64229-2a90-4770-8fb8-e4881712e865	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	6f661578-7dfb-4543-83e3-1f66ccc05e9b	\N	2026-01-01 00:43:52.779799+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: project_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_tasks (id, project_id, title, description, status, priority, assigned_to, created_by, due_date, created_at, updated_at, organization_id) FROM stdin;
7b65b0d4-028d-4188-8f5f-5e6780fafe11	1b8c0495-9fe3-4c50-8b89-6851f1a97603	dd	ddd	todo	medium	\N	\N	\N	2025-12-31 14:30:10.752596+00	2025-12-31 14:30:10.752596+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
87a5e61b-5674-4d6e-8f53-91a3767967e2	dc6773fa-7d35-465c-97e0-1fe5437b4206	fff	ggg	todo	medium	\N	\N	2026-01-02 00:00:00+00	2025-12-31 15:34:46.460261+00	2025-12-31 15:34:46.460261+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
a2beffcb-0796-4c23-9dfd-7077f14c07d4	1b8c0495-9fe3-4c50-8b89-6851f1a97603	aaaaa	aaaaaaaa	in_progress	medium	\N	\N	\N	2025-12-31 15:18:43.452867+00	2025-12-31 15:18:43.452867+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
372f61a0-cc8c-4896-b39e-2d05bab657b8	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	,,,,	,,,,	todo	medium	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	\N	2026-01-08 00:00:00+00	2026-01-01 00:41:09.856763+00	2026-01-01 00:41:09.856763+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
42cb7e6d-f479-414e-8bea-afe1a9e1ff50	b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	werwr	rwerwr	todo	urgent	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	\N	2026-01-02 00:00:00+00	2026-01-01 00:52:23.945266+00	2026-01-01 00:52:23.945266+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, name, description, owner_id, created_at, updated_at, organization_id) FROM stdin;
695a27d4-181a-4ef6-a766-3ebc2f892d00	ffds	sfdf	\N	2025-12-30 16:22:48.173229+00	2025-12-30 16:22:48.173229+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
b6ad6e0f-17b6-4f0c-af3b-da5ee4747883	dfdsf	sdfsf	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 11:55:10.714941+00	2025-12-31 11:55:10.714941+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
1b8c0495-9fe3-4c50-8b89-6851f1a97603	dd	fdsdf	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 12:05:18.6891+00	2025-12-31 12:05:18.6891+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
dc6773fa-7d35-465c-97e0-1fe5437b4206	dsfsdf	dsfsdf	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 12:33:09.508874+00	2025-12-31 12:33:09.508874+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
\.


--
-- Data for Name: role_capabilities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_capabilities (id, organization_id, role, module, can_view, can_create, can_edit, can_approve, created_at) FROM stdin;
c1a5bdac-59b0-40e9-bcd8-afefb468e350	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	leads	t	t	t	t	2025-12-30 11:31:10.169557+00
d583656b-28a0-40e4-813b-96b8d5311688	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	deals	t	t	t	t	2025-12-30 11:31:10.169557+00
1b822ed0-7678-4d50-9039-a8c140aeef21	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	tasks	t	t	t	t	2025-12-30 11:31:10.169557+00
61d2f8d4-0b5b-4fce-a91e-70a43e59b00b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	calendar	t	t	t	t	2025-12-30 11:31:10.169557+00
9bcb600a-828b-46f4-a94f-7c2debdd18aa	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	payroll	t	t	t	t	2025-12-30 11:31:10.169557+00
45a00359-aa8c-40f7-93d5-ba25c566f51b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	attendance	t	t	t	t	2025-12-30 11:31:10.169557+00
5f7f8bee-3b77-4412-8701-36afd2c2df4c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	reports	t	t	t	t	2025-12-30 11:31:10.169557+00
d122d378-db5d-44ab-b5dd-6a3b3d917c05	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	chat	t	t	t	t	2025-12-30 11:31:10.169557+00
2df3d38a-3841-480d-b267-f43caca5da4a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	leave_requests	t	t	t	t	2025-12-30 11:31:10.169557+00
0f598765-187d-4ccd-96f7-043332c8cae4	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	leads	t	t	t	f	2025-12-30 11:31:10.169557+00
b7d8aa73-399a-42f1-a6da-4b9d6170bdd1	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	deals	t	t	t	f	2025-12-30 11:31:10.169557+00
acf9746a-2d07-4eda-bee0-05446a3f0d2b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	tasks	t	t	t	f	2025-12-30 11:31:10.169557+00
9c50c4d6-b15e-429b-87ed-478ca1146b5b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	attendance	t	t	t	f	2025-12-30 11:31:10.169557+00
35149829-a2f1-411e-99c0-eebc830d7a67	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	payroll	t	f	f	f	2025-12-30 11:31:10.169557+00
1d4cc5e0-6292-4780-b045-79633a8b6547	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	reports	t	f	f	f	2025-12-30 11:31:10.169557+00
669cac96-367c-45fc-b055-0489ab87a80f	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	chat	t	t	f	f	2025-12-30 11:31:10.169557+00
72ed539d-985e-4dde-8cfe-e6ac5e2bf1fa	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	leave_requests	t	f	t	t	2025-12-30 11:31:10.169557+00
e51871d4-4646-476c-8fd6-ea3541a5d830	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	leads	t	f	f	f	2025-12-30 11:31:10.169557+00
f1bd96cd-eab4-4134-9112-103688ab6a5f	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	deals	t	f	f	f	2025-12-30 11:31:10.169557+00
1e930f51-45a8-4e57-b989-ec8b28835142	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	tasks	t	t	t	f	2025-12-30 11:31:10.169557+00
f9932580-020a-4952-b9bf-e88ee6d37f94	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	calendar	t	f	f	f	2025-12-30 11:31:10.169557+00
a87a7a62-4686-491b-84a5-c90365c5edee	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	attendance	t	f	f	f	2025-12-30 11:31:10.169557+00
700c9562-99a4-4d9c-918d-b295ab23afe1	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	payroll	t	f	f	f	2025-12-30 11:31:10.169557+00
0a001c33-9877-455e-9d51-e0c33b0a01c6	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	reports	f	f	f	f	2025-12-30 11:31:10.169557+00
26fa3860-5f37-43ec-b160-e0e5c66fc3ec	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	chat	t	t	f	f	2025-12-30 11:31:10.169557+00
4cbab1ff-76ce-4a08-92dc-10edafceb5e0	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employee	leave_requests	t	t	f	f	2025-12-30 11:31:10.169557+00
5c820fe8-e795-45a1-a112-8c92c6afa847	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	calendar	t	t	f	f	2025-12-30 11:31:10.169557+00
0b7fb957-d2a2-4ef5-9028-fbfc11216960	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	dashboard	t	t	t	t	2025-12-31 07:38:48.584096+00
bf517e5d-8b57-4f84-abb2-80c858c28188	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	chat	t	t	t	t	2025-12-31 07:38:48.584096+00
5e0a0c94-c987-49ef-b7dd-59c1581cf26c	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	leads	t	t	t	t	2025-12-31 07:38:48.584096+00
87731a3c-9608-45dd-a8c8-b706693aea7b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	deals	t	t	t	t	2025-12-31 07:38:48.584096+00
6869b5c1-255d-4086-b827-8f0395a77671	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	tasks	t	t	t	t	2025-12-31 07:38:48.584096+00
4179516d-07cd-48d8-8e48-ad64cc90d60d	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	calendar	t	t	t	t	2025-12-31 07:38:48.584096+00
88c7595e-8404-4bee-bed2-8dbe018fd400	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	payroll	t	t	t	t	2025-12-31 07:38:48.584096+00
93883106-fc86-44a8-b64d-778f6956b3c9	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	attendance	t	t	t	t	2025-12-31 07:38:48.584096+00
0f099b5f-fde2-4e2d-85c0-f53b0d7806a2	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	reports	t	t	t	t	2025-12-31 07:38:48.584096+00
b2077ea6-048b-43d0-bc45-dfc390030d08	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	leave_requests	t	t	t	t	2025-12-31 07:38:48.584096+00
8f5221b5-680d-4a55-a1d8-1f614b5e8fd4	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	projects	t	t	t	t	2025-12-31 07:38:48.584096+00
1f79ae64-96fe-410f-b414-b5c789eb6d26	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	employees	t	t	t	t	2025-12-31 07:38:48.584096+00
8337aabd-347a-4cba-8179-7abff04adc5b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	departments	t	t	t	t	2025-12-31 07:38:48.584096+00
1b7bc156-d1c5-4149-8850-be5178b79bc6	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	designations	t	t	t	t	2025-12-31 07:38:48.584096+00
66cf0c28-5f61-4b27-bd30-779d58d38412	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	user_roles	t	t	t	t	2025-12-31 07:38:48.584096+00
bf9a448f-44a0-4ff8-a7b3-29a387482d9f	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	activity_logs	t	t	t	t	2025-12-31 07:38:48.584096+00
d83b3930-ae59-40b3-9399-2d949499dbac	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tenant_admin	settings	t	t	t	t	2025-12-31 07:38:48.584096+00
b1ec5b59-a1d9-4a75-90d5-d1129a2b9dbb	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	hr	employees	t	t	t	f	2025-12-31 07:38:48.584096+00
d8a036b7-be16-47a4-a711-3f6bda57b1a5	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	hr	attendance	t	t	t	f	2025-12-31 07:38:48.584096+00
90951659-c006-4fec-bcd5-f3046b38544f	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	hr	payroll	t	t	t	f	2025-12-31 07:38:48.584096+00
a8679619-f918-42af-a2f2-1d6e260fe6a9	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	hr	leave_requests	t	f	t	t	2025-12-31 07:38:48.584096+00
16a068b9-b85c-41f9-b114-c1e2567893b1	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	hr	reports	t	f	f	f	2025-12-31 07:38:48.584096+00
fc4fd39e-a964-4c73-a24a-114a4903b1aa	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	finance	payroll	t	f	f	f	2025-12-31 07:38:48.584096+00
d061d40e-1806-4ddb-95b2-7346d0ce98a1	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	viewer	dashboard	t	f	f	f	2025-12-31 07:38:48.584096+00
e61e4909-c54d-4805-87fe-10f048e3f6d4	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	viewer	reports	t	f	f	f	2025-12-31 07:38:48.584096+00
413c0e89-2fff-473a-bd4a-de94c0eeb2db	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	admin	projects	t	t	t	t	2025-12-31 07:38:48.584096+00
65b7bd86-2cf0-46a5-8c92-f249fe246fa1	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	manager	projects	t	t	t	f	2025-12-31 07:38:48.584096+00
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (id, key, value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: task_collaborators; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_collaborators (id, task_id, user_id, created_at) FROM stdin;
a0e89add-f405-4b92-af58-424e79f7497f	6b4f58f6-6616-4aab-ba3b-6a45cf99379e	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	2025-12-29 21:13:50.40825+00
94122acf-6c47-4a9a-a7d4-58123066ee5f	ad91c7d7-cf19-431e-b77f-a5b4089c0a72	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	2025-12-29 21:14:22.092512+00
b3a43de4-aa21-4a28-bff3-5dc8e7a1614a	2f8742e6-2df4-4b73-a1e1-eeedead083c9	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-29 21:14:35.283477+00
\.


--
-- Data for Name: task_timings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_timings (task_id, assigned_at, started_at, completed_at, total_seconds) FROM stdin;
07d2197a-a964-4842-9383-13353613aa12	\N	2025-12-29 11:50:42.28+00	2025-12-29 11:50:44.667+00	2
5d3853b6-e27e-499d-8632-b978fac17e53	2025-12-29 11:52:12.997+00	\N	\N	\N
582f6a7e-d21f-4693-a931-77d941dbde27	2025-12-29 11:52:25.926+00	\N	\N	\N
a1b35373-cad5-4e4c-b59a-d34b93bf844e	\N	\N	2025-12-29 12:09:33.206+00	\N
534ad481-2dd8-4c07-9539-ba1b8ae03143	\N	2025-12-29 12:09:43.879+00	2025-12-29 12:09:46.006+00	2
2f8742e6-2df4-4b73-a1e1-eeedead083c9	2025-12-29 21:13:30.734+00	\N	\N	\N
2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	\N	2025-12-29 21:53:58.869+00	2025-12-29 12:09:42.583+00	\N
ad91c7d7-cf19-431e-b77f-a5b4089c0a72	\N	2025-12-29 21:54:10.28+00	\N	\N
68caba55-d79d-4776-b8fe-d75de6d41aec	2025-12-30 07:18:18.643+00	\N	2025-12-29 12:09:39.414+00	\N
d37b4c04-2866-4999-bfd6-25ecd32ce3f3	2025-12-30 07:19:03.719+00	\N	\N	\N
6b4f58f6-6616-4aab-ba3b-6a45cf99379e	2026-01-01 01:03:42.642+00	\N	\N	\N
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, title, description, status, priority, assigned_to, created_by, due_date, completed_at, created_at, updated_at, related_type, related_id, lead_id, deal_id, owner_id, organization_id, project_id) FROM stdin;
d37b4c04-2866-4999-bfd6-25ecd32ce3f3	Follow-up: negotiation for Sridhar J D	Automated task created when deal moved to negotiation	cancelled	medium	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-19 00:00:00+00	\N	2025-12-29 12:01:04.153874+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	9b078e58-0ca6-452a-94dc-96ec6ece641c	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
6b4f58f6-6616-4aab-ba3b-6a45cf99379e	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	completed	medium	1808cd63-8cef-4e66-8cb0-67e68251f22c	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 00:00:00+00	2025-12-29 21:40:27.244+00	2025-12-29 14:13:42.91296+00	2026-01-01 01:03:42.751409+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
a1b35373-cad5-4e4c-b59a-d34b93bf844e	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	cancelled	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-03 00:00:00+00	\N	2025-12-29 12:01:00.895017+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
ad91c7d7-cf19-431e-b77f-a5b4089c0a72	Follow-up: negotiation for Sridhar J D	Automated task created when deal moved to negotiation	completed	high	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 00:00:00+00	2025-12-29 21:54:11.542+00	2025-12-29 12:01:27.615968+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	9b078e58-0ca6-452a-94dc-96ec6ece641c	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
91c70b2e-7ec7-49ca-8d4b-4cc7e1e40598	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	completed	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 00:00:00+00	2025-12-30 07:28:01.99+00	2025-12-29 12:01:19.946241+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	9b078e58-0ca6-452a-94dc-96ec6ece641c	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
2b5fb755-ac13-43d8-867a-87a77870570f	NEW APP	DDD	todo	high	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 00:00:00+00	\N	2025-12-30 05:58:47.3947+00	2025-12-30 11:31:09.901165+00	\N	\N	7ce98c4e-ca66-4dec-bf99-69dfebb88245	cfeee563-250b-4890-a5d5-87b6c89adaa0	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
2f8742e6-2df4-4b73-a1e1-eeedead083c9	Follow-up: proposal for Sridhar D	Automated task created when deal moved to proposal	in_progress	low	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 00:00:00+00	\N	2025-12-29 14:13:46.79218+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
8238ad02-586d-401e-b9cb-2e5d2494cdbe	Follow-up: negotiation for Sridhar D	Automated task created when deal moved to negotiation	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 00:00:00+00	\N	2025-12-30 07:17:21.690903+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
2920bf80-32fe-4e1d-b7f7-1bfc0fe5f9e0	Follow-up: negotiation for Sridhar D	Automated task created when deal moved to negotiation	completed	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 00:00:00+00	2025-12-30 07:18:02.228+00	2025-12-29 12:01:30.496766+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	6b6a4fa2-0ca0-48d0-8fdf-1ba0c3340abe	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
68caba55-d79d-4776-b8fe-d75de6d41aec	Follow-up: negotiation for Sridhar J D	Automated task created when deal moved to negotiation	in_progress	medium	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-10 00:00:00+00	\N	2025-12-29 12:00:49.426747+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
5d3853b6-e27e-499d-8632-b978fac17e53	fsdf	sdfs	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-12 00:00:00+00	\N	2025-12-29 07:23:32.741133+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
582f6a7e-d21f-4693-a931-77d941dbde27	ddd	dddd	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-12 00:00:00+00	\N	2025-12-29 07:48:54.608116+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
10eb9d57-ab2c-4d2d-97a3-7e104b8ec09a	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-30 00:00:00+00	\N	2025-12-29 11:53:41.452592+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	9b078e58-0ca6-452a-94dc-96ec6ece641c	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
769a86ea-40dc-416c-8486-8964f7ac2623	Follow-up: negotiation for Sridhar J D	Automated task created when deal moved to negotiation	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 00:00:00+00	\N	2025-12-29 11:53:04.827838+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
da852014-c162-4c01-b8e0-81f0d2bdb7d7	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2026-01-01 00:00:00+00	\N	2025-12-29 12:00:46.388875+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
07d2197a-a964-4842-9383-13353613aa12	sdfsf	sdfsf	todo	medium	b31edec7-f7a1-4c28-837f-9b9848caf405	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-13 00:00:00+00	\N	2025-12-29 07:49:08.483946+00	2025-12-30 11:31:09.901165+00	\N	\N	\N	\N	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
3338ff8a-cb8e-4c1a-898a-264f01410534	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	todo	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2026-01-01 00:00:00+00	\N	2025-12-31 03:32:23.384704+00	2025-12-31 03:32:23.384704+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
90e8f71e-b710-4444-b7ff-b5d34a647c76	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	in_progress	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2025-12-31 00:00:00+00	\N	2025-12-30 11:11:05.956561+00	2025-12-31 07:02:08.088536+00	\N	\N	\N	1890fade-d586-416e-9628-9d69560be41b	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
534ad481-2dd8-4c07-9539-ba1b8ae03143	Follow-up: proposal for Sridhar J D	Automated task created when deal moved to proposal	completed	medium	\N	b31edec7-f7a1-4c28-837f-9b9848caf405	2026-01-02 00:00:00+00	2025-12-29 21:27:58.57+00	2025-12-29 12:01:29.018808+00	2026-01-01 01:12:22.506919+00	\N	\N	\N	9b078e58-0ca6-452a-94dc-96ec6ece641c	\N	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	\N
\.


--
-- Data for Name: tenant_modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenant_modules (id, organization_id, module, enabled, created_at) FROM stdin;
133c6993-966e-4360-87bc-c88d66e54178	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	dashboard	t	2025-12-31 07:38:48.350173+00
8a06e0c7-8754-4fc1-8fba-da64103e4c1a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	chat	t	2025-12-31 07:38:48.350173+00
be95c68c-8ce2-41bf-b2f1-6680df36d719	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	leads	t	2025-12-31 07:38:48.350173+00
84cc501c-4d3f-49cd-8382-17a345d682a3	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	contacts	t	2025-12-31 07:38:48.350173+00
912c0011-7219-417c-9ab3-493b67456569	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	companies	t	2025-12-31 07:38:48.350173+00
acb3dc14-2193-41e3-a34e-8afe4a7bb332	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	deals	t	2025-12-31 07:38:48.350173+00
a04673a7-14e0-4405-9450-4fbe64686dbf	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	projects	t	2025-12-31 07:38:48.350173+00
09bcf9a3-7769-44d1-bd51-a9c5f0da734d	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	tasks	t	2025-12-31 07:38:48.350173+00
ddf89711-1dd8-4f28-9184-00b19463e68d	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	calendar	t	2025-12-31 07:38:48.350173+00
cee6157d-d6f6-4721-8cb1-ff3dd23bddf2	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	employees	t	2025-12-31 07:38:48.350173+00
6fc04256-f267-4eda-bb7f-af03efdc9555	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	attendance	t	2025-12-31 07:38:48.350173+00
f5465c61-a61c-4fe3-8807-aaf2584a9fc6	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	payroll	t	2025-12-31 07:38:48.350173+00
901b51ac-9763-418f-9e0c-d06d58b06e5a	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	leave_requests	t	2025-12-31 07:38:48.350173+00
87f65ed8-8aaf-4680-9ffc-c7db4dcbf3a0	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	reports	t	2025-12-31 07:38:48.350173+00
a17ea121-42d6-4029-b4d2-5c4d75b2e994	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	departments	t	2025-12-31 07:38:48.350173+00
5f2efe32-67b1-4933-a251-64d0f2f4d205	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	designations	t	2025-12-31 07:38:48.350173+00
3321f90a-c103-408b-affa-5215bb8f6e9b	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	user_roles	t	2025-12-31 07:38:48.350173+00
b0f0f3ff-fbad-4e0a-ba90-7959c3bbfcb6	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	activity_logs	t	2025-12-31 07:38:48.350173+00
881d5f62-2dbe-4554-a317-b6a41e968757	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c	settings	t	2025-12-31 07:38:48.350173+00
54c82ed2-a2bb-4351-a587-ef8644914a8d	98b41759-8acc-498a-8ee6-bed16d2704fb	dashboard	t	2026-01-01 02:11:24.278843+00
ce13fff3-e231-41bf-805c-4527fb4ddd19	98b41759-8acc-498a-8ee6-bed16d2704fb	chat	t	2026-01-01 02:11:24.278843+00
a170edb4-1b4e-4494-9cb8-dfe8498e9847	98b41759-8acc-498a-8ee6-bed16d2704fb	leads	t	2026-01-01 02:11:24.278843+00
3ad1365b-721a-4e44-b5f1-c1e3b15faa89	98b41759-8acc-498a-8ee6-bed16d2704fb	contacts	t	2026-01-01 02:11:24.278843+00
613ba320-49d2-4ef7-8bdc-b889d05a7ca6	98b41759-8acc-498a-8ee6-bed16d2704fb	companies	t	2026-01-01 02:11:24.278843+00
a8b06fa1-cc31-4fa9-ad16-a39fe66a5ec7	98b41759-8acc-498a-8ee6-bed16d2704fb	deals	t	2026-01-01 02:11:24.278843+00
a93a6b90-9632-43b6-8bfa-a197b31d9822	98b41759-8acc-498a-8ee6-bed16d2704fb	projects	t	2026-01-01 02:11:24.278843+00
00e8a9c0-2d84-49b6-a4da-6a4df2d0153e	98b41759-8acc-498a-8ee6-bed16d2704fb	tasks	t	2026-01-01 02:11:24.278843+00
951a3b25-8b1a-40ff-83c6-2da21b566a23	98b41759-8acc-498a-8ee6-bed16d2704fb	calendar	t	2026-01-01 02:11:24.278843+00
db72dd1b-fb4c-4bb0-b1af-5e033304649b	98b41759-8acc-498a-8ee6-bed16d2704fb	employees	t	2026-01-01 02:11:24.278843+00
048b2a35-54fd-4d25-838a-eb5946b715be	98b41759-8acc-498a-8ee6-bed16d2704fb	attendance	t	2026-01-01 02:11:24.278843+00
81a0d2db-f2f5-4dd2-919f-9708d2aa864c	98b41759-8acc-498a-8ee6-bed16d2704fb	payroll	t	2026-01-01 02:11:24.278843+00
c865181a-0bd8-4944-b819-219f78953a00	98b41759-8acc-498a-8ee6-bed16d2704fb	leave_requests	t	2026-01-01 02:11:24.278843+00
9c6d4dc2-c65e-4f18-a88a-eb91bbc6f5d5	98b41759-8acc-498a-8ee6-bed16d2704fb	reports	t	2026-01-01 02:11:24.278843+00
fe6d7fd0-6dd4-41c9-9f26-38154d145515	98b41759-8acc-498a-8ee6-bed16d2704fb	departments	t	2026-01-01 02:11:24.278843+00
bd9b66ba-7306-49dd-bb87-aebfaf51456c	98b41759-8acc-498a-8ee6-bed16d2704fb	designations	t	2026-01-01 02:11:24.278843+00
5ac7dc47-9233-44f0-8964-eb81197fea7e	98b41759-8acc-498a-8ee6-bed16d2704fb	user_roles	t	2026-01-01 02:11:24.278843+00
083f0ab6-e51f-4dcc-8284-bd66f27cd047	98b41759-8acc-498a-8ee6-bed16d2704fb	activity_logs	t	2026-01-01 02:11:24.278843+00
2cae2175-2d24-48fd-9013-06bd16166607	98b41759-8acc-498a-8ee6-bed16d2704fb	settings	t	2026-01-01 02:11:24.278843+00
c7a2ab9d-700b-4dca-a19c-139d5dc1c950	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	dashboard	t	2026-01-01 03:39:31.939101+00
1737325c-caa3-47a6-a874-40d1b713a04b	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	chat	t	2026-01-01 03:39:31.939101+00
84cafe63-7519-4fab-9be6-f4a1ff1dacbf	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	leads	t	2026-01-01 03:39:31.939101+00
42cf4501-edc7-4cdf-9d56-c8f7de715c18	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	contacts	t	2026-01-01 03:39:31.939101+00
97a0098a-d864-4deb-ac4c-7c09c45ab897	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	companies	t	2026-01-01 03:39:31.939101+00
d0d4e312-3b10-45f4-9a85-b4df0787395c	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	deals	t	2026-01-01 03:39:31.939101+00
875b200e-d7b1-4409-b02b-18f241641ff4	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	projects	t	2026-01-01 03:39:31.939101+00
0376e75b-3524-4eee-80d6-59142b2e3c5b	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	tasks	t	2026-01-01 03:39:31.939101+00
752bfed4-6a1f-4ab0-9764-4f97479136fa	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	calendar	t	2026-01-01 03:39:31.939101+00
a44596e1-7c54-4437-94e7-b5206650092a	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	employees	t	2026-01-01 03:39:31.939101+00
e0255aea-f5be-432e-aeb4-eb3ca9ab6d01	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	attendance	t	2026-01-01 03:39:31.939101+00
0673e72e-8bd9-4f1e-8cfc-0a96841c4bd0	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	payroll	t	2026-01-01 03:39:31.939101+00
0806fdd0-51a9-4ab8-aaf9-b2d85321ca69	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	leave_requests	t	2026-01-01 03:39:31.939101+00
ab4becdf-cb9e-4f17-aa78-1053de3cb281	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	reports	t	2026-01-01 03:39:31.939101+00
55a26fc2-5c06-4fbe-9e42-cd7d6b42b89b	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	departments	t	2026-01-01 03:39:31.939101+00
b59a1fe7-0197-4a5c-b1b4-cda5284fa812	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	designations	t	2026-01-01 03:39:31.939101+00
5fc68e2d-3770-4060-b10c-1de9510b4c56	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	user_roles	t	2026-01-01 03:39:31.939101+00
faf40717-6002-4eb6-a522-e87e9d791fe6	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	activity_logs	t	2026-01-01 03:39:31.939101+00
ff52de04-d213-48c6-94f4-8ab0c10bd782	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2	settings	t	2026-01-01 03:39:31.939101+00
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, user_id, role, created_at, organization_id) FROM stdin;
b90c6a18-3d04-459d-96c1-f4b0cabbd534	984d4095-ec12-4d0a-9ec9-5ffb28ed133d	employee	2025-12-29 15:15:45.336303+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
c0b48704-bf25-445c-9749-a8ed239fe9f9	b0a4215b-381d-4e6e-b1e2-97e94d2a4a66	manager	2025-12-29 20:45:07.862245+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
079cb610-f9e5-44fb-8707-33efeed0575b	1808cd63-8cef-4e66-8cb0-67e68251f22c	employee	2025-12-30 06:29:10.253697+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d5e190ab-a558-4813-9379-ce40e0b1345c	1c786a19-b2ca-41fd-8750-f427fb4c6b76	employee	2025-12-30 06:42:17.520859+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
4afd7bcc-1bcb-40d1-bcf6-ee1ec7e3cf96	b31edec7-f7a1-4c28-837f-9b9848caf405	tenant_admin	2025-12-29 20:45:44.429219+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
5eb1ba7f-2c44-451b-83ab-ca2664cc9f8f	1808cd63-8cef-4e66-8cb0-67e68251f22c	manager	2025-12-31 15:43:15.229575+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d8b49606-f805-4edf-8d02-2ffa11556eee	35ad9461-0240-487c-9dfb-9883cca83fef	super_admin	2025-12-29 15:15:04.725474+00	6e04df8c-0fa7-4dd3-b820-8f4a6aaf782c
d1b2258e-b86e-4a61-ab9c-6c596644d61a	8a86a547-c01e-4e66-826b-ed1e2fab2d86	tenant_admin	2026-01-01 03:27:39.540424+00	98b41759-8acc-498a-8ee6-bed16d2704fb
36f2fdba-5df3-43dc-ab81-94a3fdc647c9	f1d803e3-7e13-4232-a1c1-6f1ef1e65355	tenant_admin	2026-01-01 03:45:08.801137+00	240a9d6b-5b0f-46e5-b413-5a7fdbff54c2
\.


--
-- Data for Name: messages_2025_12_29; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_12_29 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_12_30; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_12_30 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_12_31; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_12_31 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_01_01; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_01_01 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_01_02; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_01_02 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_01_03; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_01_03 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_01_04; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_01_04 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-12-29 04:52:56
20211116045059	2025-12-29 04:52:56
20211116050929	2025-12-29 04:52:56
20211116051442	2025-12-29 04:52:56
20211116212300	2025-12-29 04:52:56
20211116213355	2025-12-29 04:52:57
20211116213934	2025-12-29 04:52:57
20211116214523	2025-12-29 04:52:57
20211122062447	2025-12-29 04:52:57
20211124070109	2025-12-29 04:52:57
20211202204204	2025-12-29 04:52:57
20211202204605	2025-12-29 04:52:57
20211210212804	2025-12-29 04:52:57
20211228014915	2025-12-29 04:52:57
20220107221237	2025-12-29 04:52:57
20220228202821	2025-12-29 04:52:57
20220312004840	2025-12-29 04:52:57
20220603231003	2025-12-29 04:52:57
20220603232444	2025-12-29 04:52:57
20220615214548	2025-12-29 04:52:57
20220712093339	2025-12-29 04:52:57
20220908172859	2025-12-29 04:52:57
20220916233421	2025-12-29 04:52:57
20230119133233	2025-12-29 04:52:57
20230128025114	2025-12-29 04:52:57
20230128025212	2025-12-29 04:52:57
20230227211149	2025-12-29 04:52:57
20230228184745	2025-12-29 04:52:57
20230308225145	2025-12-29 04:52:57
20230328144023	2025-12-29 04:52:57
20231018144023	2025-12-29 04:52:57
20231204144023	2025-12-29 04:52:57
20231204144024	2025-12-29 04:52:57
20231204144025	2025-12-29 04:52:57
20240108234812	2025-12-29 04:52:57
20240109165339	2025-12-29 04:52:57
20240227174441	2025-12-29 04:52:57
20240311171622	2025-12-29 04:52:57
20240321100241	2025-12-29 04:52:57
20240401105812	2025-12-29 04:52:57
20240418121054	2025-12-29 04:52:57
20240523004032	2025-12-29 04:52:57
20240618124746	2025-12-29 04:52:57
20240801235015	2025-12-29 04:52:57
20240805133720	2025-12-29 04:52:57
20240827160934	2025-12-29 04:52:57
20240919163303	2025-12-29 04:52:57
20240919163305	2025-12-29 04:52:57
20241019105805	2025-12-29 04:52:57
20241030150047	2025-12-29 04:52:57
20241108114728	2025-12-29 04:52:57
20241121104152	2025-12-29 04:52:57
20241130184212	2025-12-29 04:52:58
20241220035512	2025-12-29 04:52:58
20241220123912	2025-12-29 04:52:58
20241224161212	2025-12-29 04:52:58
20250107150512	2025-12-29 04:52:58
20250110162412	2025-12-29 04:52:58
20250123174212	2025-12-29 04:52:58
20250128220012	2025-12-29 04:52:58
20250506224012	2025-12-29 04:52:58
20250523164012	2025-12-29 04:52:58
20250714121412	2025-12-29 04:52:58
20250905041441	2025-12-29 04:52:58
20251103001201	2025-12-29 04:52:58
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-12-29 04:52:56.824906
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-12-29 04:52:56.86403
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-12-29 04:52:56.86948
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-12-29 04:52:56.902434
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-12-29 04:52:56.957874
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-12-29 04:52:56.962693
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-12-29 04:52:56.968151
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-12-29 04:52:56.97314
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-12-29 04:52:56.977532
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-12-29 04:52:56.983397
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-12-29 04:52:56.988429
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-12-29 04:52:56.993834
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-12-29 04:52:56.998777
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-12-29 04:52:57.003375
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-12-29 04:52:57.007939
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-12-29 04:52:57.031752
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-12-29 04:52:57.036635
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-12-29 04:52:57.041017
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-12-29 04:52:57.046095
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-12-29 04:52:57.053209
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-12-29 04:52:57.058032
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-12-29 04:52:57.06491
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-12-29 04:52:57.079385
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-12-29 04:52:57.091113
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-12-29 04:52:57.095777
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-12-29 04:52:57.100719
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-12-29 04:52:57.105478
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-12-29 04:52:57.116843
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-12-29 04:52:57.753624
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-12-29 04:52:57.802124
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-12-29 04:52:57.829823
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-12-29 04:52:57.966846
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-12-29 04:52:58.324713
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-12-29 04:52:58.335076
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-12-29 04:52:58.349964
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-12-29 04:52:58.361285
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-12-29 04:52:58.366792
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-12-29 04:52:58.373262
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2025-12-29 04:52:58.37862
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2025-12-29 04:52:58.415566
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2025-12-29 04:52:58.420617
41	add-object-level-update-trigger	44c22478bf01744b2129efc480cd2edc9a7d60e9	2025-12-29 04:52:58.429999
42	rollback-prefix-triggers	f2ab4f526ab7f979541082992593938c05ee4b47	2025-12-29 04:52:58.435729
43	fix-object-level	ab837ad8f1c7d00cc0b7310e989a23388ff29fc6	2025-12-29 04:52:58.445098
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-12-29 04:52:58.449993
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-12-29 04:52:58.455112
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-12-29 04:52:58.472354
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-12-29 04:52:58.476746
48	iceberg-catalog-ids	2666dff93346e5d04e0a878416be1d5fec345d6f	2025-12-29 04:52:58.480876
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2025-12-29 04:52:58.496609
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20251228155720	{"-- Create enum types for the application\nCREATE TYPE public.lead_status AS ENUM ('new', 'contacted', 'qualified', 'proposal', 'negotiation', 'won', 'lost')","CREATE TYPE public.deal_stage AS ENUM ('prospecting', 'qualification', 'proposal', 'negotiation', 'closed_won', 'closed_lost')","CREATE TYPE public.task_status AS ENUM ('todo', 'in_progress', 'completed', 'cancelled')","CREATE TYPE public.task_priority AS ENUM ('low', 'medium', 'high', 'urgent')","CREATE TYPE public.employee_status AS ENUM ('active', 'inactive', 'terminated')","CREATE TYPE public.attendance_status AS ENUM ('present', 'absent', 'late', 'half_day')","CREATE TYPE public.payroll_status AS ENUM ('pending', 'processed', 'paid')","CREATE TYPE public.leave_type AS ENUM ('annual', 'sick', 'maternity', 'paternity', 'emergency')","CREATE TYPE public.leave_status AS ENUM ('pending', 'approved', 'rejected')","CREATE TYPE public.app_role AS ENUM ('admin', 'manager', 'employee')","-- Profiles table for user information\nCREATE TABLE public.profiles (\n  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  email TEXT NOT NULL,\n  full_name TEXT,\n  avatar_url TEXT,\n  is_active BOOLEAN DEFAULT true,\n  last_login TIMESTAMPTZ,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- User roles table (separate from profiles for security)\nCREATE TABLE public.user_roles (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  role app_role NOT NULL DEFAULT 'employee',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  UNIQUE(user_id, role)\n)","-- Departments table\nCREATE TABLE public.departments (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  name TEXT NOT NULL,\n  description TEXT,\n  manager_id UUID REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Designations table\nCREATE TABLE public.designations (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  description TEXT,\n  department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Companies table\nCREATE TABLE public.companies (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  name TEXT NOT NULL,\n  industry TEXT,\n  website TEXT,\n  phone TEXT,\n  email TEXT,\n  address TEXT,\n  city TEXT,\n  country TEXT,\n  logo_url TEXT,\n  created_by UUID REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Contacts table\nCREATE TABLE public.contacts (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  first_name TEXT NOT NULL,\n  last_name TEXT,\n  email TEXT,\n  phone TEXT,\n  company_id UUID REFERENCES public.companies(id) ON DELETE SET NULL,\n  position TEXT,\n  notes TEXT,\n  avatar_url TEXT,\n  created_by UUID REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Leads table\nCREATE TABLE public.leads (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  description TEXT,\n  value DECIMAL(15,2) DEFAULT 0,\n  status lead_status NOT NULL DEFAULT 'new',\n  source TEXT,\n  assigned_to UUID REFERENCES auth.users(id),\n  company_id UUID REFERENCES public.companies(id) ON DELETE SET NULL,\n  contact_id UUID REFERENCES public.contacts(id) ON DELETE SET NULL,\n  created_by UUID REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Deals table\nCREATE TABLE public.deals (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  description TEXT,\n  value DECIMAL(15,2) DEFAULT 0,\n  stage deal_stage NOT NULL DEFAULT 'prospecting',\n  probability INTEGER DEFAULT 0 CHECK (probability >= 0 AND probability <= 100),\n  expected_close_date DATE,\n  assigned_to UUID REFERENCES auth.users(id),\n  company_id UUID REFERENCES public.companies(id) ON DELETE SET NULL,\n  contact_id UUID REFERENCES public.contacts(id) ON DELETE SET NULL,\n  lead_id UUID REFERENCES public.leads(id) ON DELETE SET NULL,\n  created_by UUID REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Employees table\nCREATE TABLE public.employees (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,\n  employee_id TEXT UNIQUE NOT NULL,\n  department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,\n  designation_id UUID REFERENCES public.designations(id) ON DELETE SET NULL,\n  hire_date DATE NOT NULL DEFAULT CURRENT_DATE,\n  salary DECIMAL(15,2) DEFAULT 0,\n  status employee_status NOT NULL DEFAULT 'active',\n  phone TEXT,\n  address TEXT,\n  emergency_contact TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Tasks table\nCREATE TABLE public.tasks (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  description TEXT,\n  status task_status NOT NULL DEFAULT 'todo',\n  priority task_priority NOT NULL DEFAULT 'medium',\n  assigned_to UUID REFERENCES auth.users(id),\n  created_by UUID NOT NULL REFERENCES auth.users(id),\n  due_date TIMESTAMPTZ,\n  completed_at TIMESTAMPTZ,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Attendance table\nCREATE TABLE public.attendance (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,\n  date DATE NOT NULL DEFAULT CURRENT_DATE,\n  check_in TIME,\n  check_out TIME,\n  status attendance_status NOT NULL DEFAULT 'present',\n  notes TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  UNIQUE(employee_id, date)\n)","-- Payroll table\nCREATE TABLE public.payroll (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,\n  month INTEGER NOT NULL CHECK (month >= 1 AND month <= 12),\n  year INTEGER NOT NULL,\n  basic_salary DECIMAL(15,2) DEFAULT 0,\n  allowances DECIMAL(15,2) DEFAULT 0,\n  deductions DECIMAL(15,2) DEFAULT 0,\n  net_salary DECIMAL(15,2) DEFAULT 0,\n  status payroll_status NOT NULL DEFAULT 'pending',\n  paid_at TIMESTAMPTZ,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  UNIQUE(employee_id, month, year)\n)","-- Leave requests table\nCREATE TABLE public.leave_requests (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,\n  leave_type leave_type NOT NULL DEFAULT 'annual',\n  start_date DATE NOT NULL,\n  end_date DATE NOT NULL,\n  reason TEXT,\n  status leave_status NOT NULL DEFAULT 'pending',\n  approved_by UUID REFERENCES auth.users(id),\n  approved_at TIMESTAMPTZ,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Activity logs table\nCREATE TABLE public.activity_logs (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID REFERENCES auth.users(id),\n  action TEXT NOT NULL,\n  entity_type TEXT,\n  entity_id UUID,\n  description TEXT,\n  ip_address TEXT,\n  user_agent TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Enable RLS on all tables\nALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY","ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY","ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY","ALTER TABLE public.designations ENABLE ROW LEVEL SECURITY","ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY","ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY","ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY","ALTER TABLE public.deals ENABLE ROW LEVEL SECURITY","ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY","ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY","ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY","ALTER TABLE public.payroll ENABLE ROW LEVEL SECURITY","ALTER TABLE public.leave_requests ENABLE ROW LEVEL SECURITY","ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY","-- Security definer function for role checking\nCREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.user_roles\n    WHERE user_id = _user_id AND role = _role\n  )\n$$","-- Function to check if user is admin or manager\nCREATE OR REPLACE FUNCTION public.is_admin_or_manager(_user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.user_roles\n    WHERE user_id = _user_id AND role IN ('admin', 'manager')\n  )\n$$","-- Handle new user signup - create profile and assign default role\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER SET search_path = public\nAS $$\nBEGIN\n  INSERT INTO public.profiles (id, email, full_name)\n  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.email));\n  \n  INSERT INTO public.user_roles (user_id, role)\n  VALUES (NEW.id, 'employee');\n  \n  RETURN NEW;\nEND;\n$$","-- Trigger for new user creation\nCREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user()","-- Update timestamp function\nCREATE OR REPLACE FUNCTION public.update_updated_at_column()\nRETURNS TRIGGER AS $$\nBEGIN\n  NEW.updated_at = now();\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SET search_path = public","-- Create triggers for updated_at\nCREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_designations_updated_at BEFORE UPDATE ON public.designations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON public.companies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_deals_updated_at BEFORE UPDATE ON public.deals FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_attendance_updated_at BEFORE UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_payroll_updated_at BEFORE UPDATE ON public.payroll FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_leave_requests_updated_at BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","-- RLS Policies for profiles\nCREATE POLICY \\"Users can view their own profile\\" ON public.profiles FOR SELECT USING (auth.uid() = id)","CREATE POLICY \\"Users can update their own profile\\" ON public.profiles FOR UPDATE USING (auth.uid() = id)","CREATE POLICY \\"Admins can view all profiles\\" ON public.profiles FOR SELECT USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for user_roles\nCREATE POLICY \\"Users can view their own roles\\" ON public.user_roles FOR SELECT USING (auth.uid() = user_id)","CREATE POLICY \\"Admins can manage all roles\\" ON public.user_roles FOR ALL USING (public.has_role(auth.uid(), 'admin'))","-- RLS Policies for departments\nCREATE POLICY \\"Authenticated users can view departments\\" ON public.departments FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Admins can manage departments\\" ON public.departments FOR ALL USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for designations\nCREATE POLICY \\"Authenticated users can view designations\\" ON public.designations FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Admins can manage designations\\" ON public.designations FOR ALL USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for companies\nCREATE POLICY \\"Authenticated users can view companies\\" ON public.companies FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Authenticated users can create companies\\" ON public.companies FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by)","CREATE POLICY \\"Users can update their own companies\\" ON public.companies FOR UPDATE USING (auth.uid() = created_by OR public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"Admins can delete companies\\" ON public.companies FOR DELETE USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for contacts\nCREATE POLICY \\"Authenticated users can view contacts\\" ON public.contacts FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Authenticated users can create contacts\\" ON public.contacts FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by)","CREATE POLICY \\"Users can update their own contacts\\" ON public.contacts FOR UPDATE USING (auth.uid() = created_by OR public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"Admins can delete contacts\\" ON public.contacts FOR DELETE USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for leads\nCREATE POLICY \\"Authenticated users can view leads\\" ON public.leads FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Authenticated users can create leads\\" ON public.leads FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by)","CREATE POLICY \\"Assigned users can update leads\\" ON public.leads FOR UPDATE USING (auth.uid() = assigned_to OR auth.uid() = created_by OR public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"Admins can delete leads\\" ON public.leads FOR DELETE USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for deals\nCREATE POLICY \\"Authenticated users can view deals\\" ON public.deals FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Authenticated users can create deals\\" ON public.deals FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by)","CREATE POLICY \\"Assigned users can update deals\\" ON public.deals FOR UPDATE USING (auth.uid() = assigned_to OR auth.uid() = created_by OR public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"Admins can delete deals\\" ON public.deals FOR DELETE USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for employees\nCREATE POLICY \\"Authenticated users can view employees\\" ON public.employees FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Admins can manage employees\\" ON public.employees FOR ALL USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for tasks\nCREATE POLICY \\"Authenticated users can view tasks\\" ON public.tasks FOR SELECT TO authenticated USING (true)","CREATE POLICY \\"Authenticated users can create tasks\\" ON public.tasks FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by)","CREATE POLICY \\"Assigned users can update tasks\\" ON public.tasks FOR UPDATE USING (auth.uid() = assigned_to OR auth.uid() = created_by OR public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"Creators can delete tasks\\" ON public.tasks FOR DELETE USING (auth.uid() = created_by OR public.is_admin_or_manager(auth.uid()))","-- RLS Policies for attendance\nCREATE POLICY \\"Employees can view their own attendance\\" ON public.attendance FOR SELECT USING (\n  EXISTS (SELECT 1 FROM public.employees WHERE employees.id = attendance.employee_id AND employees.user_id = auth.uid())\n  OR public.is_admin_or_manager(auth.uid())\n)","CREATE POLICY \\"Admins can manage attendance\\" ON public.attendance FOR ALL USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for payroll\nCREATE POLICY \\"Employees can view their own payroll\\" ON public.payroll FOR SELECT USING (\n  EXISTS (SELECT 1 FROM public.employees WHERE employees.id = payroll.employee_id AND employees.user_id = auth.uid())\n  OR public.is_admin_or_manager(auth.uid())\n)","CREATE POLICY \\"Admins can manage payroll\\" ON public.payroll FOR ALL USING (public.is_admin_or_manager(auth.uid()))","-- RLS Policies for leave_requests\nCREATE POLICY \\"Employees can view their own leave requests\\" ON public.leave_requests FOR SELECT USING (\n  EXISTS (SELECT 1 FROM public.employees WHERE employees.id = leave_requests.employee_id AND employees.user_id = auth.uid())\n  OR public.is_admin_or_manager(auth.uid())\n)","CREATE POLICY \\"Employees can create leave requests\\" ON public.leave_requests FOR INSERT TO authenticated WITH CHECK (\n  EXISTS (SELECT 1 FROM public.employees WHERE employees.id = leave_requests.employee_id AND employees.user_id = auth.uid())\n)","CREATE POLICY \\"Admins can manage leave requests\\" ON public.leave_requests FOR UPDATE USING (public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"Employees can delete their pending requests\\" ON public.leave_requests FOR DELETE USING (\n  EXISTS (SELECT 1 FROM public.employees WHERE employees.id = leave_requests.employee_id AND employees.user_id = auth.uid())\n  AND status = 'pending'\n)","-- RLS Policies for activity_logs\nCREATE POLICY \\"Users can view their own logs\\" ON public.activity_logs FOR SELECT USING (auth.uid() = user_id OR public.is_admin_or_manager(auth.uid()))","CREATE POLICY \\"System can create logs\\" ON public.activity_logs FOR INSERT TO authenticated WITH CHECK (true)","-- Create indexes for performance\nCREATE INDEX idx_leads_status ON public.leads(status)","CREATE INDEX idx_leads_assigned_to ON public.leads(assigned_to)","CREATE INDEX idx_deals_stage ON public.deals(stage)","CREATE INDEX idx_deals_assigned_to ON public.deals(assigned_to)","CREATE INDEX idx_tasks_status ON public.tasks(status)","CREATE INDEX idx_tasks_assigned_to ON public.tasks(assigned_to)","CREATE INDEX idx_employees_status ON public.employees(status)","CREATE INDEX idx_attendance_date ON public.attendance(date)","CREATE INDEX idx_payroll_month_year ON public.payroll(month, year)","CREATE INDEX idx_leave_requests_status ON public.leave_requests(status)"}	87339f32-428a-4852-bfdb-08508b060e36
20251230000000	{"-- Add new fields to leads table\r\nALTER TABLE public.leads ADD COLUMN IF NOT EXISTS company_name TEXT","ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS contact_name TEXT","ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS email TEXT","ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS phone TEXT","ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS notes TEXT","-- Update existing rows to populate new fields from old ones\r\nUPDATE public.leads \r\nSET \r\n  company_name = title,\r\n  contact_name = 'Unknown', \r\n  notes = description\r\nWHERE company_name IS NULL","-- Make required fields not null\r\nALTER TABLE public.leads ALTER COLUMN company_name SET NOT NULL","ALTER TABLE public.leads ALTER COLUMN contact_name SET NOT NULL","-- Add indexes for better search performance\r\nCREATE INDEX IF NOT EXISTS idx_leads_company_name ON public.leads(company_name)","CREATE INDEX IF NOT EXISTS idx_leads_contact_name ON public.leads(contact_name)","CREATE INDEX IF NOT EXISTS idx_leads_email ON public.leads(email)"}	add_lead_fields
20251229105000	{"-- Core modules schema alignment and activity logging triggers\n\n-- 1) Calendar Events\nDO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'event_type') THEN\n    CREATE TYPE public.event_type AS ENUM ('task','meeting','leave');\n  END IF;\nEND\n$$","CREATE TABLE IF NOT EXISTS public.events (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  title text NOT NULL,\n  start_time timestamptz NOT NULL,\n  end_time timestamptz NOT NULL,\n  type public.event_type NOT NULL,\n  related_id uuid NULL,\n  created_at timestamptz NOT NULL DEFAULT now(),\n  updated_at timestamptz NOT NULL DEFAULT now()\n)","CREATE INDEX IF NOT EXISTS idx_events_type ON public.events(type)","CREATE INDEX IF NOT EXISTS idx_events_time ON public.events(start_time, end_time)","-- 2) Settings\nCREATE TABLE IF NOT EXISTS public.settings (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  key text UNIQUE NOT NULL,\n  value jsonb,\n  created_at timestamptz NOT NULL DEFAULT now(),\n  updated_at timestamptz NOT NULL DEFAULT now()\n)","CREATE INDEX IF NOT EXISTS idx_settings_key ON public.settings(key)","-- 3) Payments (for revenue and dashboards)\nDO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_status') THEN\n    CREATE TYPE public.payment_status AS ENUM ('pending','paid','failed');\n  END IF;\nEND\n$$","CREATE TABLE IF NOT EXISTS public.payments (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  deal_id uuid REFERENCES public.deals(id) ON DELETE SET NULL,\n  amount numeric(12,2) NOT NULL,\n  status public.payment_status NOT NULL DEFAULT 'pending',\n  paid_at timestamptz,\n  created_at timestamptz NOT NULL DEFAULT now()\n)","CREATE INDEX IF NOT EXISTS idx_payments_status ON public.payments(status)","CREATE INDEX IF NOT EXISTS idx_payments_deal ON public.payments(deal_id)","-- 4) Leads convenience field\nALTER TABLE public.leads ADD COLUMN IF NOT EXISTS name text","UPDATE public.leads SET name = COALESCE(company_name, title) WHERE name IS NULL","CREATE INDEX IF NOT EXISTS idx_leads_name ON public.leads(name)","-- 5) Contacts convenience field\nALTER TABLE public.contacts ADD COLUMN IF NOT EXISTS name text GENERATED ALWAYS AS (\n  first_name || CASE WHEN last_name IS NOT NULL AND length(last_name) > 0 THEN ' ' || last_name ELSE '' END\n) STORED","CREATE INDEX IF NOT EXISTS idx_contacts_name ON public.contacts(name)","-- 6) Deals amount mirror for analytics compatibility\nALTER TABLE public.deals ADD COLUMN IF NOT EXISTS amount numeric(12,2)","UPDATE public.deals SET amount = value WHERE amount IS NULL AND value IS NOT NULL","CREATE INDEX IF NOT EXISTS idx_deals_amount ON public.deals(amount)","-- 7) Tasks linking to CRM entities\nALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS related_type text CHECK (related_type IN ('lead','deal','contact'))","ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS related_id uuid","CREATE INDEX IF NOT EXISTS idx_tasks_related ON public.tasks(related_type, related_id)","-- 8) Attendance naming alignment\nALTER TABLE public.attendance ADD COLUMN IF NOT EXISTS punch_in timestamptz","ALTER TABLE public.attendance ADD COLUMN IF NOT EXISTS punch_out timestamptz","-- 9) Payroll naming alignment\nALTER TABLE public.payroll ADD COLUMN IF NOT EXISTS basic numeric(12,2)","ALTER TABLE public.payroll ADD COLUMN IF NOT EXISTS net_pay numeric(12,2)","UPDATE public.payroll SET basic = basic_salary WHERE basic IS NULL AND basic_salary IS NOT NULL","UPDATE public.payroll SET net_pay = net_salary WHERE net_pay IS NULL AND net_salary IS NOT NULL","-- 10) Activity Logs: add required fields\nALTER TABLE public.activity_logs ADD COLUMN IF NOT EXISTS module text","ALTER TABLE public.activity_logs ADD COLUMN IF NOT EXISTS record_id uuid","ALTER TABLE public.activity_logs ALTER COLUMN created_at SET DEFAULT now()","CREATE INDEX IF NOT EXISTS idx_activity_logs_module ON public.activity_logs(module)","CREATE INDEX IF NOT EXISTS idx_activity_logs_record ON public.activity_logs(record_id)","-- 11) Activity logging function and triggers\nCREATE OR REPLACE FUNCTION public.log_activity_fn() RETURNS trigger AS $$\nDECLARE\n  _user_id uuid;\n  _action text;\n  _record_id uuid;\nBEGIN\n  _user_id := auth.uid();\n  IF TG_OP = 'INSERT' THEN\n    _action := 'create';\n    _record_id := NEW.id;\n  ELSIF TG_OP = 'UPDATE' THEN\n    _action := 'update';\n    _record_id := NEW.id;\n  ELSIF TG_OP = 'DELETE' THEN\n    _action := 'delete';\n    _record_id := OLD.id;\n  END IF;\n\n  INSERT INTO public.activity_logs (id, user_id, action, entity_type, entity_id, description, module, record_id, created_at)\n  VALUES (gen_random_uuid(), COALESCE(_user_id::text, NULL), _action, TG_TABLE_NAME, COALESCE((_record_id)::text, NULL), NULL, TG_TABLE_NAME, _record_id, now());\n\n  RETURN COALESCE(NEW, OLD);\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_log_leads') THEN\n    CREATE TRIGGER trg_log_leads\n    AFTER INSERT OR UPDATE OR DELETE ON public.leads\n    FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();\n  END IF;\n  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_log_contacts') THEN\n    CREATE TRIGGER trg_log_contacts\n    AFTER INSERT OR UPDATE OR DELETE ON public.contacts\n    FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();\n  END IF;\n  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_log_companies') THEN\n    CREATE TRIGGER trg_log_companies\n    AFTER INSERT OR UPDATE OR DELETE ON public.companies\n    FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();\n  END IF;\n  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_log_deals') THEN\n    CREATE TRIGGER trg_log_deals\n    AFTER INSERT OR UPDATE OR DELETE ON public.deals\n    FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();\n  END IF;\n  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_log_tasks') THEN\n    CREATE TRIGGER trg_log_tasks\n    AFTER INSERT OR UPDATE OR DELETE ON public.tasks\n    FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();\n  END IF;\nEND\n$$"}	add_core_modules
20251229112000	{"CREATE OR REPLACE FUNCTION public.log_activity_fn() RETURNS trigger AS $$\nDECLARE\n  _user_id uuid;\n  _action text;\n  _record_id uuid;\nBEGIN\n  _user_id := auth.uid();\n  IF TG_OP = 'INSERT' THEN\n    _action := 'create';\n    _record_id := NEW.id;\n  ELSIF TG_OP = 'UPDATE' THEN\n    _action := 'update';\n    _record_id := NEW.id;\n  ELSIF TG_OP = 'DELETE' THEN\n    _action := 'delete';\n    _record_id := OLD.id;\n  END IF;\n\n  INSERT INTO public.activity_logs (id, user_id, action, entity_type, entity_id, description, module, record_id, created_at)\n  VALUES (gen_random_uuid(), _user_id, _action, TG_TABLE_NAME, NULL, NULL, TG_TABLE_NAME, _record_id, now());\n\n  RETURN COALESCE(NEW, OLD);\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER"}	fix_activity_logs_user_id
20251229120000	{"-- Add optional links from tasks to leads and deals\nALTER TABLE public.tasks\nADD COLUMN IF NOT EXISTS lead_id uuid NULL,\nADD COLUMN IF NOT EXISTS deal_id uuid NULL","ALTER TABLE public.tasks\nADD CONSTRAINT tasks_lead_id_fkey\nFOREIGN KEY (lead_id) REFERENCES public.leads (id) ON UPDATE CASCADE ON DELETE SET NULL","ALTER TABLE public.tasks\nADD CONSTRAINT tasks_deal_id_fkey\nFOREIGN KEY (deal_id) REFERENCES public.deals (id) ON UPDATE CASCADE ON DELETE SET NULL"}	add_task_links
20251229130000	{"-- Add collaboration features: owners, collaborators, timings, messages, notifications\ndo $$\nbegin\n  if not exists (select 1 from pg_type where typname = 'entity_type') then\n    create type public.entity_type as enum ('task','deal','lead');\n  end if;\nend$$","alter table public.tasks\n  add column if not exists owner_id uuid","alter table public.tasks\n  add constraint tasks_owner_id_fk foreign key (owner_id) references public.profiles(id) on delete set null","create table if not exists public.task_collaborators (\n  id uuid primary key default gen_random_uuid(),\n  task_id uuid not null references public.tasks(id) on delete cascade,\n  user_id uuid not null references public.profiles(id) on delete cascade,\n  created_at timestamptz not null default now(),\n  unique (task_id, user_id)\n)","create table if not exists public.task_timings (\n  task_id uuid primary key references public.tasks(id) on delete cascade,\n  assigned_at timestamptz,\n  started_at timestamptz,\n  completed_at timestamptz,\n  total_seconds integer\n)","create table if not exists public.messages (\n  id uuid primary key default gen_random_uuid(),\n  entity_type public.entity_type not null,\n  entity_id uuid not null,\n  author_id uuid not null references public.profiles(id) on delete set null,\n  content text not null,\n  mentions uuid[] default '{}',\n  created_at timestamptz not null default now()\n)","create index if not exists idx_messages_entity on public.messages(entity_type, entity_id, created_at)","create table if not exists public.notifications (\n  id uuid primary key default gen_random_uuid(),\n  user_id uuid not null references public.profiles(id) on delete cascade,\n  type text not null,\n  entity_type public.entity_type,\n  entity_id uuid,\n  title text,\n  body text,\n  read boolean not null default false,\n  created_at timestamptz not null default now()\n)","create index if not exists idx_notifications_user on public.notifications(user_id, created_at, read)"}	add_collaboration
20251230000001	{"-- Create chat type enum\r\nDO $$\r\nBEGIN\r\n  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'chat_type') THEN\r\n    CREATE TYPE public.chat_type AS ENUM ('direct', 'group');\r\n  END IF;\r\nEND\r\n$$","-- Create chat channels table\r\nCREATE TABLE IF NOT EXISTS public.chat_channels (\r\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  type public.chat_type NOT NULL,\r\n  name TEXT,\r\n  department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,\r\n  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,\r\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\r\n)","-- Create chat participants table\r\nCREATE TABLE IF NOT EXISTS public.chat_participants (\r\n  channel_id UUID REFERENCES public.chat_channels(id) ON DELETE CASCADE,\r\n  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,\r\n  joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n  last_read_at TIMESTAMPTZ,\r\n  PRIMARY KEY (channel_id, user_id)\r\n)","-- Create chat messages table\r\nCREATE TABLE IF NOT EXISTS public.chat_messages (\r\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  channel_id UUID REFERENCES public.chat_channels(id) ON DELETE CASCADE,\r\n  sender_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,\r\n  content TEXT NOT NULL,\r\n  attachments JSONB DEFAULT '[]',\r\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\r\n)","-- Indexes\r\nCREATE INDEX IF NOT EXISTS idx_chat_participants_user ON public.chat_participants(user_id)","CREATE INDEX IF NOT EXISTS idx_chat_messages_channel ON public.chat_messages(channel_id, created_at)","-- Add chat_channel to entity_type enum for notifications\r\nALTER TYPE public.entity_type ADD VALUE IF NOT EXISTS 'chat_channel'","ALTER TYPE public.entity_type ADD VALUE IF NOT EXISTS 'chat_message'","-- Add RLS policies\r\nALTER TABLE public.chat_channels ENABLE ROW LEVEL SECURITY","ALTER TABLE public.chat_participants ENABLE ROW LEVEL SECURITY","ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY","-- Policies for chat_channels\r\n-- Users can view channels they are participants of\r\nCREATE POLICY \\"Users can view channels they are in\\" ON public.chat_channels\r\n  FOR SELECT USING (\r\n    EXISTS (\r\n      SELECT 1 FROM public.chat_participants\r\n      WHERE channel_id = chat_channels.id AND user_id = auth.uid()\r\n    )\r\n  )","-- Users can create channels (and will be added as participant automatically via trigger/logic)\r\nCREATE POLICY \\"Users can create channels\\" ON public.chat_channels\r\n  FOR INSERT WITH CHECK (auth.uid() = created_by)","-- Policies for chat_participants\r\n-- Users can view participants of channels they are in\r\nCREATE POLICY \\"Users can view participants of their channels\\" ON public.chat_participants\r\n  FOR SELECT USING (\r\n    EXISTS (\r\n      SELECT 1 FROM public.chat_participants cp\r\n      WHERE cp.channel_id = chat_participants.channel_id AND cp.user_id = auth.uid()\r\n    )\r\n  )","-- Users can add participants (if they are in the channel? or open?)\r\n-- For now, let's say anyone can add anyone to a channel if they are in it, or creators.\r\nCREATE POLICY \\"Participants can add others\\" ON public.chat_participants\r\n  FOR INSERT WITH CHECK (\r\n    EXISTS (\r\n      SELECT 1 FROM public.chat_participants cp\r\n      WHERE cp.channel_id = chat_participants.channel_id AND cp.user_id = auth.uid()\r\n    )\r\n    OR\r\n    EXISTS (\r\n       SELECT 1 FROM public.chat_channels cc\r\n       WHERE cc.id = chat_participants.channel_id AND cc.created_by = auth.uid()\r\n    )\r\n  )","-- Policies for chat_messages\r\n-- Users can view messages in their channels\r\nCREATE POLICY \\"Users can view messages in their channels\\" ON public.chat_messages\r\n  FOR SELECT USING (\r\n    EXISTS (\r\n      SELECT 1 FROM public.chat_participants\r\n      WHERE channel_id = chat_messages.channel_id AND user_id = auth.uid()\r\n    )\r\n  )","-- Users can insert messages in their channels\r\nCREATE POLICY \\"Users can send messages to their channels\\" ON public.chat_messages\r\n  FOR INSERT WITH CHECK (\r\n    EXISTS (\r\n      SELECT 1 FROM public.chat_participants\r\n      WHERE channel_id = chat_messages.channel_id AND user_id = auth.uid()\r\n    )\r\n    AND sender_id = auth.uid()\r\n  )","-- Function to automatically add creator to participants\r\nCREATE OR REPLACE FUNCTION public.add_creator_to_participants()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n  INSERT INTO public.chat_participants (channel_id, user_id)\r\n  VALUES (NEW.id, NEW.created_by);\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql SECURITY DEFINER","CREATE TRIGGER trg_add_creator_to_participants\r\n  AFTER INSERT ON public.chat_channels\r\n  FOR EACH ROW\r\n  EXECUTE FUNCTION public.add_creator_to_participants()","-- Function to notify participants on new message\r\nCREATE OR REPLACE FUNCTION public.notify_chat_participants()\r\nRETURNS TRIGGER AS $$\r\nDECLARE\r\n  _participant_id UUID;\r\nBEGIN\r\n  FOR _participant_id IN\r\n    SELECT user_id FROM public.chat_participants\r\n    WHERE channel_id = NEW.channel_id AND user_id != NEW.sender_id\r\n  LOOP\r\n    INSERT INTO public.notifications (user_id, type, entity_type, entity_id, title, body)\r\n    VALUES (\r\n      _participant_id,\r\n      'message',\r\n      'chat_channel',\r\n      NEW.channel_id,\r\n      'New Message',\r\n      substring(NEW.content from 1 for 50)\r\n    );\r\n  END LOOP;\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql SECURITY DEFINER","CREATE TRIGGER trg_notify_chat_participants\r\n  AFTER INSERT ON public.chat_messages\r\n  FOR EACH ROW\r\n  EXECUTE FUNCTION public.notify_chat_participants()"}	add_chat_module
20251230000002	{"-- Fix RLS recursion by using Security Definer functions\n-- This prevents the policies from triggering infinite loops when querying the same tables\n\n-- 1. Function to check if user is participant of a channel\nCREATE OR REPLACE FUNCTION public.is_chat_participant(_channel_id uuid)\nRETURNS boolean\nLANGUAGE sql\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM chat_participants\n    WHERE channel_id = _channel_id AND user_id = auth.uid()\n  );\n$$","-- 2. Function to check if user is creator of a channel\nCREATE OR REPLACE FUNCTION public.is_channel_creator(_channel_id uuid)\nRETURNS boolean\nLANGUAGE sql\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM chat_channels\n    WHERE id = _channel_id AND created_by = auth.uid()\n  );\n$$","-- 3. Drop existing policies to replace them\nDROP POLICY IF EXISTS \\"Users can view channels they are in\\" ON public.chat_channels","DROP POLICY IF EXISTS \\"Users can create channels\\" ON public.chat_channels","DROP POLICY IF EXISTS \\"Users can view participants of their channels\\" ON public.chat_participants","DROP POLICY IF EXISTS \\"Participants can add others\\" ON public.chat_participants","DROP POLICY IF EXISTS \\"Users can view messages in their channels\\" ON public.chat_messages","DROP POLICY IF EXISTS \\"Users can send messages to their channels\\" ON public.chat_messages","-- 4. Re-create policies using the safe functions\n\n-- Chat Channels\nCREATE POLICY \\"Users can view channels they are in\\" ON public.chat_channels\n  FOR SELECT USING (\n    public.is_chat_participant(id)\n  )","CREATE POLICY \\"Users can create channels\\" ON public.chat_channels\n  FOR INSERT WITH CHECK (auth.uid() = created_by)","-- Chat Participants\n-- Users can view participants if they are in the channel themselves\nCREATE POLICY \\"Users can view participants of their channels\\" ON public.chat_participants\n  FOR SELECT USING (\n    public.is_chat_participant(channel_id)\n  )","-- Users can add participants if they are already in the channel OR if they are the creator\n-- (Using is_channel_creator avoids querying chat_channels RLS, though chat_channels insert RLS is simple)\nCREATE POLICY \\"Participants can add others\\" ON public.chat_participants\n  FOR INSERT WITH CHECK (\n    public.is_chat_participant(channel_id)\n    OR\n    public.is_channel_creator(channel_id)\n  )","-- Chat Messages\nCREATE POLICY \\"Users can view messages in their channels\\" ON public.chat_messages\n  FOR SELECT USING (\n    public.is_chat_participant(channel_id)\n  )","CREATE POLICY \\"Users can send messages to their channels\\" ON public.chat_messages\n  FOR INSERT WITH CHECK (\n    public.is_chat_participant(channel_id)\n    AND sender_id = auth.uid()\n  )"}	fix_chat_rls
20251230000003	{"-- Fix profiles RLS to allow searching users (for DM and Group add)\nDROP POLICY IF EXISTS \\"Users can view their own profile\\" ON public.profiles","CREATE POLICY \\"Authenticated users can view all profiles\\" ON public.profiles\n  FOR SELECT TO authenticated USING (true)","-- Update chat_channels policy to ensure creators can always view their channels immediately\n-- This prevents issues where the SELECT after INSERT fails because the participant trigger hasn't completed/propagated yet\nDROP POLICY IF EXISTS \\"Users can view channels they are in\\" ON public.chat_channels","CREATE POLICY \\"Users can view channels they are in or created\\" ON public.chat_channels\n  FOR SELECT USING (\n    public.is_chat_participant(id) \n    OR \n    created_by = auth.uid()\n  )"}	fix_chat_permissions
20251230000004	{"-- Backfill missing profiles for existing users\n-- This ensures that users who signed up before the trigger was active (or if it failed) have a profile\nINSERT INTO public.profiles (id, email, full_name)\nSELECT \n  id, \n  email, \n  COALESCE(raw_user_meta_data->>'full_name', email)\nFROM auth.users\nWHERE id NOT IN (SELECT id FROM public.profiles)","-- Also ensure user_roles exist\nINSERT INTO public.user_roles (user_id, role)\nSELECT \n  id, \n  'employee'\nFROM auth.users\nWHERE id NOT IN (SELECT user_id FROM public.user_roles)"}	backfill_profiles
20251230000005	{"-- Add chat tables to supabase_realtime publication to ensure real-time events are sent\n-- We use a DO block to avoid errors if they are already added or if the publication is defined differently\nDO $$\nBEGIN\n  -- Try to add tables to the publication. \n  -- Note: If 'supabase_realtime' is defined as FOR ALL TABLES, this might not be needed, \n  -- but explicitly adding them ensures they are tracked if it's a specific list.\n  \n  -- We check if the publication exists first\n  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN\n    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_messages;\n    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_channels;\n    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_participants;\n  END IF;\nEXCEPTION\n  WHEN duplicate_object THEN\n    -- If tables are already in the publication, ignore the error\n    NULL;\n  WHEN OTHERS THEN\n    -- In case of other errors (like publication not existing which shouldn't happen in Supabase), log or ignore\n    NULL;\nEND\n$$"}	enable_realtime
20251230000006	{"-- Fix RLS for profiles to ensure employees can be seen\nDROP POLICY IF EXISTS \\"Public profiles are viewable by everyone\\" ON public.profiles","DROP POLICY IF EXISTS \\"Users can view their own profile\\" ON public.profiles","DROP POLICY IF EXISTS \\"Authenticated users can view all profiles\\" ON public.profiles","CREATE POLICY \\"Authenticated users can view all profiles\\" \nON public.profiles FOR SELECT \nTO authenticated \nUSING (true)","-- Fix RLS for employees\nDROP POLICY IF EXISTS \\"Authenticated users can view employees\\" ON public.employees","CREATE POLICY \\"Authenticated users can view employees\\" \nON public.employees FOR SELECT \nTO authenticated \nUSING (true)","-- Fix RLS for activity_logs\nDROP POLICY IF EXISTS \\"Users can view their own logs\\" ON public.activity_logs","DROP POLICY IF EXISTS \\"Authenticated users can view all logs\\" ON public.activity_logs","CREATE POLICY \\"Authenticated users can view all logs\\" \nON public.activity_logs FOR SELECT \nTO authenticated \nUSING (true)","-- Add assigned_to to leads if not exists\nDO $$ \nBEGIN \n    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'assigned_to') THEN\n        ALTER TABLE public.leads ADD COLUMN assigned_to uuid REFERENCES auth.users(id);\n    END IF;\n    \n    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'deals' AND column_name = 'assigned_to') THEN\n        ALTER TABLE public.deals ADD COLUMN assigned_to uuid REFERENCES auth.users(id);\n    END IF;\nEND $$","-- Ensure activity logging triggers exist and work\n-- (We assume the function log_activity_fn exists from previous migrations, if not we recreate it)\nCREATE OR REPLACE FUNCTION public.log_activity_fn()\nRETURNS TRIGGER AS $$\nBEGIN\n  INSERT INTO public.activity_logs (action, entity_type, entity_id, description, user_id)\n  VALUES (\n    TG_OP,\n    TG_TABLE_NAME,\n    NEW.id,\n    TG_OP || ' on ' || TG_TABLE_NAME,\n    auth.uid()\n  );\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Re-apply triggers for key tables if they are missing (idempotent drop/create)\nDROP TRIGGER IF EXISTS trg_log_leads ON public.leads","CREATE TRIGGER trg_log_leads AFTER INSERT OR UPDATE OR DELETE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn()","DROP TRIGGER IF EXISTS trg_log_deals ON public.deals","CREATE TRIGGER trg_log_deals AFTER INSERT OR UPDATE OR DELETE ON public.deals FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn()","DROP TRIGGER IF EXISTS trg_log_tasks ON public.tasks","CREATE TRIGGER trg_log_tasks AFTER INSERT OR UPDATE OR DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn()","DROP TRIGGER IF EXISTS trg_log_contacts ON public.contacts","CREATE TRIGGER trg_log_contacts AFTER INSERT OR UPDATE OR DELETE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn()","DROP TRIGGER IF EXISTS trg_log_employees ON public.employees","CREATE TRIGGER trg_log_employees AFTER INSERT OR UPDATE OR DELETE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn()"}	fix_issues_and_features
20251230010010	{"-- Organizations and Multi-tenancy\nDO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'org_role') THEN\n    CREATE TYPE public.org_role AS ENUM ('owner', 'admin', 'member');\n  END IF;\nEND\n$$","CREATE TABLE IF NOT EXISTS public.organizations (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  name TEXT NOT NULL,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Seed a default organization if none exists\nINSERT INTO public.organizations (name)\nSELECT 'Default Organization'\nWHERE NOT EXISTS (SELECT 1 FROM public.organizations)","-- moved below after adding organization_id to profiles\n\n-- Add organization_id to core tables (nullable first, backfill, then not null)\nDO $$\nDECLARE\n  _default_org UUID;\nBEGIN\n  SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;\n\n  -- profiles\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.profiles ADD COLUMN organization_id UUID;\n    UPDATE public.profiles SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.profiles ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.profiles ADD CONSTRAINT profiles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE RESTRICT;\n  END IF;\n\n  -- user_roles\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'user_roles' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.user_roles ADD COLUMN organization_id UUID;\n    UPDATE public.user_roles ur\n      SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.user_roles ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.user_roles ADD CONSTRAINT user_roles_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- departments\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'departments' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.departments ADD COLUMN organization_id UUID;\n    UPDATE public.departments SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.departments ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.departments ADD CONSTRAINT departments_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- designations\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'designations' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.designations ADD COLUMN organization_id UUID;\n    UPDATE public.designations SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.designations ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.designations ADD CONSTRAINT designations_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- companies\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'companies' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.companies ADD COLUMN organization_id UUID;\n    UPDATE public.companies SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.companies ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.companies ADD CONSTRAINT companies_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- contacts\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'contacts' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.contacts ADD COLUMN organization_id UUID;\n    UPDATE public.contacts SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.contacts ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.contacts ADD CONSTRAINT contacts_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- leads\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.leads ADD COLUMN organization_id UUID;\n    UPDATE public.leads SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.leads ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.leads ADD CONSTRAINT leads_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- deals\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'deals' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.deals ADD COLUMN organization_id UUID;\n    UPDATE public.deals SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.deals ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.deals ADD CONSTRAINT deals_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- employees\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'employees' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.employees ADD COLUMN organization_id UUID;\n    UPDATE public.employees SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.employees ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.employees ADD CONSTRAINT employees_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- tasks\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'tasks' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.tasks ADD COLUMN organization_id UUID;\n    UPDATE public.tasks SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.tasks ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.tasks ADD CONSTRAINT tasks_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- attendance\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'attendance' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.attendance ADD COLUMN organization_id UUID;\n    UPDATE public.attendance SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.attendance ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.attendance ADD CONSTRAINT attendance_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- payroll\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'payroll' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.payroll ADD COLUMN organization_id UUID;\n    UPDATE public.payroll SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.payroll ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.payroll ADD CONSTRAINT payroll_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- leave_requests\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leave_requests' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.leave_requests ADD COLUMN organization_id UUID;\n    UPDATE public.leave_requests SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.leave_requests ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.leave_requests ADD CONSTRAINT leave_requests_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- activity_logs\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'activity_logs' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.activity_logs ADD COLUMN organization_id UUID;\n    UPDATE public.activity_logs SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.activity_logs ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.activity_logs ADD CONSTRAINT activity_logs_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  -- chat tables\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'chat_channels' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.chat_channels ADD COLUMN organization_id UUID;\n    UPDATE public.chat_channels SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.chat_channels ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.chat_channels ADD CONSTRAINT chat_channels_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'chat_participants' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.chat_participants ADD COLUMN organization_id UUID;\n    UPDATE public.chat_participants cp\n      SET organization_id = COALESCE(organization_id, (SELECT organization_id FROM public.chat_channels cc WHERE cc.id = cp.channel_id));\n    ALTER TABLE public.chat_participants ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.chat_participants ADD CONSTRAINT chat_participants_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\n\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'chat_messages' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.chat_messages ADD COLUMN organization_id UUID;\n    UPDATE public.chat_messages cm\n      SET organization_id = COALESCE(organization_id, (SELECT organization_id FROM public.chat_channels cc WHERE cc.id = cm.channel_id));\n    ALTER TABLE public.chat_messages ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.chat_messages ADD CONSTRAINT chat_messages_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\nEND $$","-- Helper: get current user's organization_id (create after profiles.organization_id exists)\nCREATE OR REPLACE FUNCTION public.current_org_id()\nRETURNS UUID\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT organization_id FROM public.profiles WHERE id = auth.uid()\n$$","-- Triggers to set organization_id on insert if NULL\nCREATE OR REPLACE FUNCTION public.set_org_id_on_insert()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DO $$\nDECLARE \n  _tbl text;\nBEGIN\n  -- Attach trigger to key tables\n  FOREACH _tbl IN ARRAY ARRAY[\n    'profiles','user_roles','departments','designations','companies','contacts','leads',\n    'deals','employees','tasks','attendance','payroll','leave_requests','activity_logs',\n    'chat_channels','chat_participants','chat_messages'\n  ]\n  LOOP\n    EXECUTE format('DROP TRIGGER IF EXISTS trg_set_org_on_insert_%I ON public.%I', _tbl, _tbl);\n    EXECUTE format('CREATE TRIGGER trg_set_org_on_insert_%I BEFORE INSERT ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()', _tbl, _tbl);\n  END LOOP;\nEND $$","-- Basic org-aware policies: limit access to records in same organization\nDO $$\nDECLARE \n  _tbl text;\nBEGIN\n  -- SELECT/INSERT/UPDATE/DELETE org-aware policies\n  FOREACH _tbl IN ARRAY ARRAY[\n    'departments','designations','companies','contacts','leads',\n    'deals','employees','tasks','attendance','payroll','leave_requests','activity_logs',\n    'chat_channels','chat_participants','chat_messages'\n  ]\n  LOOP\n    EXECUTE format('DROP POLICY IF EXISTS \\"org_select_%I\\" ON public.%I', _tbl, _tbl);\n    EXECUTE format('CREATE POLICY \\"org_select_%I\\" ON public.%I FOR SELECT USING (organization_id = public.current_org_id())', _tbl, _tbl);\n    EXECUTE format('DROP POLICY IF EXISTS \\"org_insert_%I\\" ON public.%I', _tbl, _tbl);\n    EXECUTE format('CREATE POLICY \\"org_insert_%I\\" ON public.%I FOR INSERT WITH CHECK (organization_id = public.current_org_id())', _tbl, _tbl);\n    EXECUTE format('DROP POLICY IF EXISTS \\"org_update_%I\\" ON public.%I', _tbl, _tbl);\n    EXECUTE format('CREATE POLICY \\"org_update_%I\\" ON public.%I FOR UPDATE USING (organization_id = public.current_org_id()) WITH CHECK (organization_id = public.current_org_id())', _tbl, _tbl);\n    EXECUTE format('DROP POLICY IF EXISTS \\"org_delete_%I\\" ON public.%I', _tbl, _tbl);\n    EXECUTE format('CREATE POLICY \\"org_delete_%I\\" ON public.%I FOR DELETE USING (organization_id = public.current_org_id())', _tbl, _tbl);\n  END LOOP;\nEND $$"}	add_organizations_multi_tenancy
20251230011000	{"-- Role capabilities per organization\nCREATE TABLE IF NOT EXISTS public.role_capabilities (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\n  role public.app_role NOT NULL,\n  module TEXT NOT NULL,\n  can_view BOOLEAN NOT NULL DEFAULT true,\n  can_create BOOLEAN NOT NULL DEFAULT false,\n  can_edit BOOLEAN NOT NULL DEFAULT false,\n  can_approve BOOLEAN NOT NULL DEFAULT false,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  UNIQUE (organization_id, role, module)\n)","-- Seed defaults for existing org\nDO $$\nDECLARE\n  _org UUID;\nBEGIN\n  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;\n  -- Admin: full access to all modules\n  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)\n  SELECT _org, 'admin', m, true, true, true, true\n  FROM unnest(ARRAY['leads','deals','tasks','calendar','payroll','attendance','reports','chat','leave_requests']) AS m\n  ON CONFLICT DO NOTHING;\n\n  -- Manager: broad access except payroll approval\n  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)\n  VALUES \n    (_org, 'manager', 'leads', true, true, true, false),\n    (_org, 'manager', 'deals', true, true, true, false),\n    (_org, 'manager', 'tasks', true, true, true, false),\n    (_org, 'manager', 'calendar', true, false, false, false),\n    (_org, 'manager', 'attendance', true, true, true, false),\n    (_org, 'manager', 'payroll', true, false, false, false),\n    (_org, 'manager', 'reports', true, false, false, false),\n    (_org, 'manager', 'chat', true, true, false, false),\n    (_org, 'manager', 'leave_requests', true, false, true, true)\n  ON CONFLICT DO NOTHING;\n\n  -- Employee: limited access\n  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)\n  VALUES \n    (_org, 'employee', 'leads', true, false, false, false),\n    (_org, 'employee', 'deals', true, false, false, false),\n    (_org, 'employee', 'tasks', true, true, true, false),\n    (_org, 'employee', 'calendar', true, false, false, false),\n    (_org, 'employee', 'attendance', true, false, false, false),\n    (_org, 'employee', 'payroll', true, false, false, false),\n    (_org, 'employee', 'reports', false, false, false, false),\n    (_org, 'employee', 'chat', true, true, false, false),\n    (_org, 'employee', 'leave_requests', true, true, false, false)\n  ON CONFLICT DO NOTHING;\nEND $$","-- Capability function\nCREATE OR REPLACE FUNCTION public.can_capability(_user_id UUID, _module TEXT, _cap TEXT)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  _org UUID;\n  _role public.app_role;\n  _cap_row RECORD;\nBEGIN\n  SELECT organization_id INTO _org FROM public.profiles WHERE id = _user_id;\n  IF _org IS NULL THEN\n    RETURN false;\n  END IF;\n  SELECT role INTO _role FROM public.user_roles WHERE user_id = _user_id AND organization_id = _org LIMIT 1;\n  IF _role IS NULL THEN\n    RETURN false;\n  END IF;\n  SELECT * INTO _cap_row FROM public.role_capabilities \n    WHERE organization_id = _org AND role = _role AND module = _module LIMIT 1;\n  IF NOT FOUND THEN\n    RETURN false;\n  END IF;\n  IF _cap = 'can_view' THEN\n    RETURN COALESCE(_cap_row.can_view, false);\n  ELSIF _cap = 'can_create' THEN\n    RETURN COALESCE(_cap_row.can_create, false);\n  ELSIF _cap = 'can_edit' THEN\n    RETURN COALESCE(_cap_row.can_edit, false);\n  ELSIF _cap = 'can_approve' THEN\n    RETURN COALESCE(_cap_row.can_approve, false);\n  ELSE\n    RETURN false;\n  END IF;\nEND;\n$$","-- Strengthen RLS: require capability for write operations\n-- Leads\nDROP POLICY IF EXISTS \\"org_insert_leads\\" ON public.leads","DROP POLICY IF EXISTS \\"org_update_leads\\" ON public.leads","CREATE POLICY \\"org_insert_leads\\" ON public.leads\n  FOR INSERT WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'leads', 'can_create')\n  )","CREATE POLICY \\"org_update_leads\\" ON public.leads\n  FOR UPDATE USING (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'leads', 'can_edit')\n  )\n  WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'leads', 'can_edit')\n  )","-- Deals\nDROP POLICY IF EXISTS \\"org_insert_deals\\" ON public.deals","DROP POLICY IF EXISTS \\"org_update_deals\\" ON public.deals","CREATE POLICY \\"org_insert_deals\\" ON public.deals\n  FOR INSERT WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'deals', 'can_create')\n  )","CREATE POLICY \\"org_update_deals\\" ON public.deals\n  FOR UPDATE USING (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'deals', 'can_edit')\n  )\n  WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'deals', 'can_edit')\n  )","-- Tasks\nDROP POLICY IF EXISTS \\"org_insert_tasks\\" ON public.tasks","DROP POLICY IF EXISTS \\"org_update_tasks\\" ON public.tasks","CREATE POLICY \\"org_insert_tasks\\" ON public.tasks\n  FOR INSERT WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'tasks', 'can_create')\n  )","CREATE POLICY \\"org_update_tasks\\" ON public.tasks\n  FOR UPDATE USING (\n    organization_id = public.current_org_id()\n    AND (\n      public.can_capability(auth.uid(), 'tasks', 'can_edit')\n      OR assigned_to = auth.uid()\n      OR created_by = auth.uid()\n    )\n  )\n  WITH CHECK (\n    organization_id = public.current_org_id()\n    AND (\n      public.can_capability(auth.uid(), 'tasks', 'can_edit')\n      OR assigned_to = auth.uid()\n      OR created_by = auth.uid()\n    )\n  )","-- Payroll\nDROP POLICY IF EXISTS \\"org_insert_payroll\\" ON public.payroll","DROP POLICY IF EXISTS \\"org_update_payroll\\" ON public.payroll","CREATE POLICY \\"org_insert_payroll\\" ON public.payroll\n  FOR INSERT WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'payroll', 'can_create')\n  )","CREATE POLICY \\"org_update_payroll\\" ON public.payroll\n  FOR UPDATE USING (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'payroll', 'can_edit')\n  )\n  WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'payroll', 'can_edit')\n  )","-- Leave Requests\nDROP POLICY IF EXISTS \\"org_insert_leave_requests\\" ON public.leave_requests","DROP POLICY IF EXISTS \\"org_update_leave_requests\\" ON public.leave_requests","CREATE POLICY \\"org_insert_leave_requests\\" ON public.leave_requests\n  FOR INSERT WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'leave_requests', 'can_create')\n  )","CREATE POLICY \\"org_update_leave_requests\\" ON public.leave_requests\n  FOR UPDATE USING (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'leave_requests', 'can_approve')\n  )\n  WITH CHECK (\n    organization_id = public.current_org_id()\n    AND public.can_capability(auth.uid(), 'leave_requests', 'can_approve')\n  )"}	role_capabilities_permissions
20251230012000	{"-- Create projects table and extend notifications/tasks with project and meeting links\nDO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'org_role') THEN\n    PERFORM 1;\n  END IF;\nEND\n$$","CREATE TABLE IF NOT EXISTS public.projects (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  name TEXT NOT NULL,\n  description TEXT,\n  owner_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE\n)","CREATE INDEX IF NOT EXISTS idx_projects_name ON public.projects(name)","ALTER TABLE public.tasks\n  ADD COLUMN IF NOT EXISTS project_id UUID NULL","ALTER TABLE public.tasks\n  ADD CONSTRAINT tasks_project_id_fkey\n  FOREIGN KEY (project_id) REFERENCES public.projects (id) ON UPDATE CASCADE ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_tasks_project_id ON public.tasks(project_id)","DO $$\nDECLARE\n  _default_org UUID;\nBEGIN\n  SELECT id INTO _default_org FROM public.organizations ORDER BY created_at LIMIT 1;\n\n  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'notifications' AND column_name = 'organization_id') THEN\n    ALTER TABLE public.notifications ADD COLUMN organization_id UUID;\n    UPDATE public.notifications SET organization_id = COALESCE(organization_id, _default_org);\n    ALTER TABLE public.notifications ALTER COLUMN organization_id SET NOT NULL;\n    ALTER TABLE public.notifications ADD CONSTRAINT notifications_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\n  END IF;\nEND $$","ALTER TABLE public.notifications\n  ADD COLUMN IF NOT EXISTS project_id UUID NULL,\n  ADD COLUMN IF NOT EXISTS meeting_id UUID NULL","ALTER TABLE public.notifications\n  ADD CONSTRAINT notifications_project_id_fkey\n  FOREIGN KEY (project_id) REFERENCES public.projects (id) ON UPDATE CASCADE ON DELETE SET NULL","ALTER TABLE public.notifications\n  ADD CONSTRAINT notifications_meeting_id_fkey\n  FOREIGN KEY (meeting_id) REFERENCES public.events (id) ON UPDATE CASCADE ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_notifications_project ON public.notifications(project_id)","ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY","ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"org_select_projects\\" ON public.projects\n  FOR SELECT USING (organization_id = public.current_org_id())","CREATE POLICY \\"org_insert_projects\\" ON public.projects\n  FOR INSERT WITH CHECK (organization_id = public.current_org_id())","CREATE POLICY \\"org_update_projects\\" ON public.projects\n  FOR UPDATE USING (organization_id = public.current_org_id()) WITH CHECK (organization_id = public.current_org_id())","CREATE POLICY \\"org_delete_projects\\" ON public.projects\n  FOR DELETE USING (organization_id = public.current_org_id())","CREATE POLICY \\"own_select_notifications\\" ON public.notifications\n  FOR SELECT USING (user_id = auth.uid() AND organization_id = public.current_org_id())","CREATE POLICY \\"own_insert_notifications\\" ON public.notifications\n  FOR INSERT WITH CHECK (user_id = auth.uid() AND organization_id = public.current_org_id())","CREATE POLICY \\"own_update_notifications\\" ON public.notifications\n  FOR UPDATE USING (user_id = auth.uid() AND organization_id = public.current_org_id()) WITH CHECK (user_id = auth.uid() AND organization_id = public.current_org_id())","CREATE POLICY \\"own_delete_notifications\\" ON public.notifications\n  FOR DELETE USING (user_id = auth.uid() AND organization_id = public.current_org_id())","CREATE OR REPLACE FUNCTION public.set_org_id_on_insert()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_set_org_on_insert_projects ON public.projects","CREATE TRIGGER trg_set_org_on_insert_projects\n  BEFORE INSERT ON public.projects\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()","DROP TRIGGER IF EXISTS trg_set_org_on_insert_notifications ON public.notifications","CREATE TRIGGER trg_set_org_on_insert_notifications\n  BEFORE INSERT ON public.notifications\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()"}	add_projects_notifications_extension
20251230014000	{"-- Add project members and link chat channels to projects\r\nCREATE TABLE IF NOT EXISTS public.project_members (\r\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,\r\n  employee_id UUID NOT NULL REFERENCES public.employees(id) ON DELETE CASCADE,\r\n  role TEXT,\r\n  added_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n  UNIQUE (project_id, employee_id)\r\n)","ALTER TABLE public.chat_channels\r\n  ADD COLUMN IF NOT EXISTS project_id UUID NULL REFERENCES public.projects(id) ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_chat_channels_project ON public.chat_channels(project_id)","CREATE INDEX IF NOT EXISTS idx_project_members_project ON public.project_members(project_id)","CREATE INDEX IF NOT EXISTS idx_project_members_employee ON public.project_members(employee_id)","ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"org_select_project_members\\" ON public.project_members\r\n  FOR SELECT USING (\r\n    EXISTS (\r\n      SELECT 1 FROM public.projects p\r\n      WHERE p.id = project_members.project_id\r\n        AND p.organization_id = public.current_org_id()\r\n    )\r\n  )","CREATE POLICY \\"org_insert_project_members\\" ON public.project_members\r\n  FOR INSERT WITH CHECK (\r\n    EXISTS (\r\n      SELECT 1 FROM public.projects p\r\n      WHERE p.id = project_members.project_id\r\n        AND p.organization_id = public.current_org_id()\r\n    )\r\n  )","CREATE POLICY \\"org_update_project_members\\" ON public.project_members\r\n  FOR UPDATE USING (\r\n    EXISTS (\r\n      SELECT 1 FROM public.projects p\r\n      WHERE p.id = project_members.project_id\r\n        AND p.organization_id = public.current_org_id()\r\n    )\r\n  ) WITH CHECK (\r\n    EXISTS (\r\n      SELECT 1 FROM public.projects p\r\n      WHERE p.id = project_members.project_id\r\n        AND p.organization_id = public.current_org_id()\r\n    )\r\n  )","CREATE POLICY \\"org_delete_project_members\\" ON public.project_members\r\n  FOR DELETE USING (\r\n    EXISTS (\r\n      SELECT 1 FROM public.projects p\r\n      WHERE p.id = project_members.project_id\r\n        AND p.organization_id = public.current_org_id()\r\n    )\r\n  )"}	add_project_members_and_chat_project
20251231000000	{"-- Align schema with updates.md for Projects, Project Tasks, Project Meetings, and Chat auto-creation\n-- Idempotent changes where possible\n\n-- Extend app_role to include additional roles if missing\nDO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'app_role') THEN\n    CREATE TYPE public.app_role AS ENUM ('admin','manager','employee');\n  END IF;\n  -- Add new roles to existing enum\n  BEGIN\n    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'tenant_admin';\n  EXCEPTION WHEN duplicate_object THEN NULL; END;\n  BEGIN\n    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'hr';\n  EXCEPTION WHEN duplicate_object THEN NULL; END;\n  BEGIN\n    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'finance';\n  EXCEPTION WHEN duplicate_object THEN NULL; END;\n  BEGIN\n    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'viewer';\n  EXCEPTION WHEN duplicate_object THEN NULL; END;\n  BEGIN\n    ALTER TYPE public.app_role ADD VALUE IF NOT EXISTS 'super_admin';\n  EXCEPTION WHEN duplicate_object THEN NULL; END;\nEND $$","-- Enforce uniqueness for Tenant Admin per organization (treat legacy 'admin' as tenant admin equivalent)\nDO $$\nBEGIN\n  IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'one_tenant_admin_per_org') THEN\n    CREATE UNIQUE INDEX one_tenant_admin_per_org ON public.user_roles(organization_id)\n    WHERE role IN ('tenant_admin','admin');\n  END IF;\nEND $$","-- Tenant modules per organization\nCREATE TABLE IF NOT EXISTS public.tenant_modules (\n  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\n  module_name TEXT NOT NULL,\n  enabled BOOLEAN NOT NULL DEFAULT true,\n  PRIMARY KEY (organization_id, module_name)\n)","-- Project Tasks (isolated from global tasks)\nCREATE TABLE IF NOT EXISTS public.project_tasks (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,\n  title TEXT NOT NULL,\n  description TEXT,\n  status TEXT NOT NULL DEFAULT 'todo',\n  priority TEXT NOT NULL DEFAULT 'medium',\n  assigned_to UUID NULL REFERENCES auth.users(id),\n  created_by UUID NULL REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY","-- Basic org-scoped visibility via project linkage\nDROP POLICY IF EXISTS org_select_project_tasks ON public.project_tasks","CREATE POLICY org_select_project_tasks ON public.project_tasks\n  FOR SELECT USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","DROP POLICY IF EXISTS org_insert_project_tasks ON public.project_tasks","CREATE POLICY org_insert_project_tasks ON public.project_tasks\n  FOR INSERT WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","DROP POLICY IF EXISTS org_update_project_tasks ON public.project_tasks","CREATE POLICY org_update_project_tasks ON public.project_tasks\n  FOR UPDATE USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  ) WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","DROP POLICY IF EXISTS org_delete_project_tasks ON public.project_tasks","CREATE POLICY org_delete_project_tasks ON public.project_tasks\n  FOR DELETE USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","-- Project Meetings (separate from org-level meetings)\nCREATE TABLE IF NOT EXISTS public.project_meetings (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,\n  title TEXT NOT NULL,\n  start_time TIMESTAMPTZ NOT NULL,\n  end_time TIMESTAMPTZ NOT NULL,\n  meeting_link TEXT,\n  created_by UUID NULL REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","ALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS org_select_project_meetings ON public.project_meetings","CREATE POLICY org_select_project_meetings ON public.project_meetings\n  FOR SELECT USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_meetings.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","DROP POLICY IF EXISTS org_insert_project_meetings ON public.project_meetings","CREATE POLICY org_insert_project_meetings ON public.project_meetings\n  FOR INSERT WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_meetings.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","DROP POLICY IF EXISTS org_update_project_meetings ON public.project_meetings","CREATE POLICY org_update_project_meetings ON public.project_meetings\n  FOR UPDATE USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_meetings.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  ) WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_meetings.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","DROP POLICY IF EXISTS org_delete_project_meetings ON public.project_meetings","CREATE POLICY org_delete_project_meetings ON public.project_meetings\n  FOR DELETE USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_meetings.project_id\n        AND p.organization_id = public.current_org_id()\n    )\n  )","-- Auto-create project chat channel on project creation\nCREATE OR REPLACE FUNCTION public.create_project_chat()\nRETURNS TRIGGER AS $$\nDECLARE\n  _chan_id UUID;\nBEGIN\n  -- Create a group chat channel linked to project\n  INSERT INTO public.chat_channels (type, name, created_by, project_id)\n  VALUES ('group', COALESCE('Project: ' || NEW.name, 'Project Chat'), auth.uid(), NEW.id)\n  RETURNING id INTO _chan_id;\n\n  -- Add creator as participant\n  INSERT INTO public.chat_participants (channel_id, user_id)\n  VALUES (_chan_id, auth.uid());\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_create_project_chat ON public.projects","CREATE TRIGGER trg_create_project_chat\n  AFTER INSERT ON public.projects\n  FOR EACH ROW EXECUTE FUNCTION public.create_project_chat()","-- Auto-join project members to project chat\nCREATE OR REPLACE FUNCTION public.add_member_to_project_chat()\nRETURNS TRIGGER AS $$\nDECLARE\n  _chan_id UUID;\n  _user_id UUID;\nBEGIN\n  -- Find channel for project\n  SELECT id INTO _chan_id FROM public.chat_channels WHERE project_id = NEW.project_id LIMIT 1;\n  IF _chan_id IS NULL THEN\n    RETURN NEW;\n  END IF;\n  -- Resolve auth user_id from employees\n  SELECT user_id INTO _user_id FROM public.employees WHERE id = NEW.employee_id LIMIT 1;\n  IF _user_id IS NULL THEN\n    RETURN NEW;\n  END IF;\n\n  -- Insert participant if not already present\n  INSERT INTO public.chat_participants (channel_id, user_id)\n  SELECT _chan_id, _user_id\n  WHERE NOT EXISTS (\n    SELECT 1 FROM public.chat_participants WHERE channel_id = _chan_id AND user_id = _user_id\n  );\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_add_member_to_project_chat ON public.project_members","CREATE TRIGGER trg_add_member_to_project_chat\n  AFTER INSERT ON public.project_members\n  FOR EACH ROW EXECUTE FUNCTION public.add_member_to_project_chat()","-- Auto-create department chat channel on department creation\nCREATE OR REPLACE FUNCTION public.create_department_chat()\nRETURNS TRIGGER AS $$\nDECLARE\n  _chan_id UUID;\nBEGIN\n  INSERT INTO public.chat_channels (type, name, created_by)\n  VALUES ('group', COALESCE('Department: ' || NEW.name, 'Department Chat'), auth.uid())\n  RETURNING id INTO _chan_id;\n  -- Creator joins automatically via existing trigger\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_create_department_chat ON public.departments","CREATE TRIGGER trg_create_department_chat\n  AFTER INSERT ON public.departments\n  FOR EACH ROW EXECUTE FUNCTION public.create_department_chat()"}	update_to_spec
20251231002000	{"-- Fix project chat creation to avoid null user_id in chat_participants\n-- Uses NEW.owner_id as primary source, fallback to auth.uid(), and skips participant insert if user_id is null\n\nCREATE OR REPLACE FUNCTION public.create_project_chat()\nRETURNS TRIGGER AS $$\nDECLARE\n  _chan_id UUID;\n  _creator UUID;\nBEGIN\n  _creator := COALESCE(NEW.owner_id, auth.uid());\n\n  INSERT INTO public.chat_channels (type, name, created_by, project_id)\n  VALUES (\n    'group',\n    COALESCE('Project: ' || NEW.name, 'Project Chat'),\n    COALESCE(_creator, auth.uid()),\n    NEW.id\n  )\n  RETURNING id INTO _chan_id;\n\n  IF _creator IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id)\n    VALUES (_chan_id, _creator);\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER"}	fix_project_chat_function
20251231001000	{"-- Notifications triggers for assignments and creations (tasks, deals)\n-- Align with updates.md: notify on assignment, task creation, deal creation, chat messages (chat handled separately)\n\n-- Ensure notifications has 'type' column\nALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS type TEXT","-- Function: notify on assignment changes\nCREATE OR REPLACE FUNCTION public.notify_assignment_change()\nRETURNS TRIGGER AS $$\nDECLARE\n  _target_user UUID;\n  _entity TEXT;\n  _entity_id UUID;\n  _title TEXT;\n  _body TEXT;\nBEGIN\n  IF TG_TABLE_NAME = 'tasks' THEN\n    _entity := 'task';\n    _entity_id := COALESCE(NEW.id, OLD.id);\n    _target_user := NEW.assigned_to;\n    _title := 'Task Assignment';\n    _body := COALESCE(NEW.title, 'Task updated');\n  ELSIF TG_TABLE_NAME = 'deals' THEN\n    _entity := 'deal';\n    _entity_id := COALESCE(NEW.id, OLD.id);\n    _target_user := NEW.assigned_to;\n    _title := 'Deal Assignment';\n    _body := COALESCE(NEW.title, 'Deal updated');\n  ELSE\n    RETURN COALESCE(NEW, OLD);\n  END IF;\n\n  IF _target_user IS NOT NULL THEN\n    INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id)\n    VALUES (_target_user, 'assignment', _title, _body, _entity, _entity_id);\n  END IF;\n\n  RETURN COALESCE(NEW, OLD);\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Function: notify on creation\nCREATE OR REPLACE FUNCTION public.notify_creation()\nRETURNS TRIGGER AS $$\nDECLARE\n  _target_user UUID;\n  _entity TEXT;\n  _title TEXT;\n  _body TEXT;\nBEGIN\n  IF TG_TABLE_NAME = 'tasks' THEN\n    _entity := 'task';\n    _target_user := NEW.assigned_to;\n    _title := 'New Task';\n    _body := COALESCE(NEW.title, 'New task created');\n  ELSIF TG_TABLE_NAME = 'deals' THEN\n    _entity := 'deal';\n    _target_user := NEW.assigned_to;\n    _title := 'New Deal';\n    _body := COALESCE(NEW.title, 'New deal created');\n  ELSE\n    RETURN NEW;\n  END IF;\n\n  IF _target_user IS NOT NULL THEN\n    INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id)\n    VALUES (_target_user, 'create', _title, _body, _entity, NEW.id);\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Attach triggers (idempotent drop/create)\nDROP TRIGGER IF EXISTS trg_notify_task_creation ON public.tasks","CREATE TRIGGER trg_notify_task_creation\n  AFTER INSERT ON public.tasks\n  FOR EACH ROW EXECUTE FUNCTION public.notify_creation()","DROP TRIGGER IF EXISTS trg_notify_deal_creation ON public.deals","CREATE TRIGGER trg_notify_deal_creation\n  AFTER INSERT ON public.deals\n  FOR EACH ROW EXECUTE FUNCTION public.notify_creation()","DROP TRIGGER IF EXISTS trg_notify_task_assignment ON public.tasks","CREATE TRIGGER trg_notify_task_assignment\n  AFTER UPDATE OF assigned_to ON public.tasks\n  FOR EACH ROW EXECUTE FUNCTION public.notify_assignment_change()","DROP TRIGGER IF EXISTS trg_notify_deal_assignment ON public.deals","CREATE TRIGGER trg_notify_deal_assignment\n  AFTER UPDATE OF assigned_to ON public.deals\n  FOR EACH ROW EXECUTE FUNCTION public.notify_assignment_change()"}	notifications_triggers
20251231120000	{"-- Strengthen visibility and permissions per updates.md\n-- 1) Create missing tables: project_meetings, project_tasks\n-- 2) Projects visibility: only creator or assigned member can see\n-- 3) Project meetings creation: only project manager can create\n-- 4) Role capabilities: allow managers to create calendar meetings\n-- 5) Auto-create chat channels for projects and add members\n\n-- Ensure chat_type enum has 'project'\nALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'project'","-- Create project_meetings table if not exists\nCREATE TABLE IF NOT EXISTS public.project_meetings (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,\n  title TEXT NOT NULL,\n  scheduled_at TIMESTAMPTZ NOT NULL,\n  meeting_link TEXT,\n  created_by UUID REFERENCES auth.users(id),\n  created_at TIMESTAMPTZ DEFAULT now()\n)","-- Create project_tasks table if not exists\nCREATE TABLE IF NOT EXISTS public.project_tasks (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,\n  title TEXT NOT NULL,\n  description TEXT,\n  status TEXT DEFAULT 'todo',\n  priority TEXT DEFAULT 'medium',\n  assigned_to UUID REFERENCES auth.users(id),\n  created_by UUID REFERENCES auth.users(id),\n  due_date TIMESTAMPTZ,\n  created_at TIMESTAMPTZ DEFAULT now(),\n  updated_at TIMESTAMPTZ DEFAULT now()\n)","-- Enable RLS\nALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY","ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY","-- Projects SELECT policy: creator or assigned member, within org\nDO $$\nBEGIN\n  -- Drop existing simple org-select policy if present\n  IF EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'org_select_projects'\n  ) THEN\n    EXECUTE 'DROP POLICY \\"org_select_projects\\" ON public.projects';\n  END IF;\n\n  -- Create new visibility policy if not exists\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'creator_or_member_select_projects'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"creator_or_member_select_projects\\" ON public.projects\n        FOR SELECT USING (\n          organization_id = public.current_org_id()\n          AND (\n            owner_id = auth.uid()\n            OR EXISTS (\n              SELECT 1 \n              FROM public.project_members pm\n              JOIN public.employees e ON e.id = pm.employee_id\n              WHERE pm.project_id = projects.id\n                AND e.user_id = auth.uid()\n            )\n          )\n        )\n    $sql$;\n  END IF;\nEND $$","-- Project meetings policies\nDO $$\nBEGIN\n  -- Select policy\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_members_select_meetings'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"project_members_select_meetings\\" ON public.project_meetings\n        FOR SELECT USING (\n          EXISTS (\n            SELECT 1 FROM public.project_members pm\n            JOIN public.employees e ON e.id = pm.employee_id\n            WHERE pm.project_id = project_meetings.project_id\n            AND e.user_id = auth.uid()\n          )\n          OR \n          EXISTS (\n            SELECT 1 FROM public.projects p\n            WHERE p.id = project_meetings.project_id\n            AND p.owner_id = auth.uid()\n          )\n        )\n    $sql$;\n  END IF;\n\n  -- Insert policy: only project manager\n  IF EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'org_insert_project_meetings'\n  ) THEN\n    EXECUTE 'DROP POLICY \\"org_insert_project_meetings\\" ON public.project_meetings';\n  END IF;\n\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_meetings' AND policyname = 'project_manager_insert_meetings'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"project_manager_insert_meetings\\" ON public.project_meetings\n        FOR INSERT WITH CHECK (\n          EXISTS (\n            SELECT 1 \n            FROM public.project_members pm\n            JOIN public.employees e ON e.id = pm.employee_id\n            WHERE pm.project_id = project_meetings.project_id\n              AND e.user_id = auth.uid()\n              AND lower(pm.role) = 'manager'\n          )\n        )\n    $sql$;\n  END IF;\nEND $$","-- Project tasks policies\nDO $$\nBEGIN\n  -- Select policy\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_tasks' AND policyname = 'project_members_select_tasks'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"project_members_select_tasks\\" ON public.project_tasks\n        FOR SELECT USING (\n          EXISTS (\n            SELECT 1 FROM public.project_members pm\n            JOIN public.employees e ON e.id = pm.employee_id\n            WHERE pm.project_id = project_tasks.project_id\n            AND e.user_id = auth.uid()\n          )\n          OR \n          EXISTS (\n            SELECT 1 FROM public.projects p\n            WHERE p.id = project_tasks.project_id\n            AND p.owner_id = auth.uid()\n          )\n        )\n    $sql$;\n  END IF;\n\n  -- Insert/Update policy: Project members can create/update tasks\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_tasks' AND policyname = 'project_members_modify_tasks'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"project_members_modify_tasks\\" ON public.project_tasks\n        FOR ALL USING (\n          EXISTS (\n            SELECT 1 FROM public.project_members pm\n            JOIN public.employees e ON e.id = pm.employee_id\n            WHERE pm.project_id = project_tasks.project_id\n            AND e.user_id = auth.uid()\n          )\n          OR \n          EXISTS (\n            SELECT 1 FROM public.projects p\n            WHERE p.id = project_tasks.project_id\n            AND p.owner_id = auth.uid()\n          )\n        )\n    $sql$;\n  END IF;\nEND $$","-- PBAC update: managers can create calendar meetings\nUPDATE public.role_capabilities\nSET can_create = true\nWHERE role = 'manager' AND module = 'calendar'","-- Auto-create chat channel for project\nCREATE OR REPLACE FUNCTION public.create_project_chat_channel()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\nBEGIN\n  -- Check if channel already exists\n  IF EXISTS (SELECT 1 FROM public.chat_channels WHERE project_id = NEW.id) THEN\n    RETURN NEW;\n  END IF;\n\n  -- Assuming chat_type 'project' exists (added at top)\n  INSERT INTO public.chat_channels (organization_id, project_id, name, type, created_by)\n  VALUES (NEW.organization_id, NEW.id, NEW.name, 'project', NEW.owner_id)\n  RETURNING id INTO _channel_id;\n\n  -- Add owner as participant\n  -- Note: chat_participants table (channel_id, user_id)\n  INSERT INTO public.chat_participants (channel_id, user_id)\n  VALUES (_channel_id, NEW.owner_id)\n  ON CONFLICT DO NOTHING;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_create_project_chat ON public.projects","CREATE TRIGGER trg_create_project_chat\n  AFTER INSERT ON public.projects\n  FOR EACH ROW EXECUTE FUNCTION public.create_project_chat_channel()","-- Auto-join project chat when added as member\nCREATE OR REPLACE FUNCTION public.join_project_chat_channel()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\n  _user_id UUID;\nBEGIN\n  -- Get channel id\n  SELECT id INTO _channel_id FROM public.chat_channels WHERE project_id = NEW.project_id LIMIT 1;\n  \n  -- Get user id from employee\n  SELECT user_id INTO _user_id FROM public.employees WHERE id = NEW.employee_id;\n\n  IF _channel_id IS NOT NULL AND _user_id IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id)\n    VALUES (_channel_id, _user_id)\n    ON CONFLICT DO NOTHING;\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_join_project_chat ON public.project_members","CREATE TRIGGER trg_join_project_chat\n  AFTER INSERT ON public.project_members\n  FOR EACH ROW EXECUTE FUNCTION public.join_project_chat_channel()"}	permissions_visibility_updates
20251231130000	{"-- Auto-create chat channels for departments and add members\n-- Align with updates.md: \\"When department is created -> auto chat channel\\"\n\n-- Ensure chat_type enum has 'department'\nALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'department'","-- Auto-create chat channel for departments\nCREATE OR REPLACE FUNCTION public.create_department_chat_channel()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\nBEGIN\n  -- Check if channel already exists\n  IF EXISTS (SELECT 1 FROM public.chat_channels WHERE department_id = NEW.id) THEN\n    RETURN NEW;\n  END IF;\n\n  INSERT INTO public.chat_channels (organization_id, name, type, department_id, created_by)\n  VALUES (NEW.organization_id, NEW.name, 'department', NEW.id, NEW.manager_id)\n  RETURNING id INTO _channel_id;\n\n  -- Add manager as participant if exists\n  IF NEW.manager_id IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id)\n    VALUES (_channel_id, NEW.manager_id)\n    ON CONFLICT DO NOTHING;\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_create_department_chat ON public.departments","CREATE TRIGGER trg_create_department_chat\n  AFTER INSERT ON public.departments\n  FOR EACH ROW EXECUTE FUNCTION public.create_department_chat_channel()","-- Auto-join department chat when added as member (or department updated)\nCREATE OR REPLACE FUNCTION public.join_department_chat_channel()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\n  _dept_id UUID;\nBEGIN\n  _dept_id := NEW.department_id;\n\n  IF _dept_id IS NULL THEN\n    RETURN NEW;\n  END IF;\n\n  -- Find the chat channel for this department\n  SELECT id INTO _channel_id FROM public.chat_channels \n  WHERE department_id = _dept_id\n  LIMIT 1;\n\n  IF _channel_id IS NOT NULL AND NEW.user_id IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id)\n    VALUES (_channel_id, NEW.user_id)\n    ON CONFLICT DO NOTHING;\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_join_department_chat ON public.employees","CREATE TRIGGER trg_join_department_chat\n  AFTER INSERT OR UPDATE OF department_id ON public.employees\n  FOR EACH ROW EXECUTE FUNCTION public.join_department_chat_channel()"}	department_auto_chat
20251231131000	{"-- Fix project_meetings schema to match frontend and spec\n-- 1) Add start_time and end_time (mandatory), drop scheduled_at\n-- 2) Enforce meeting_link NOT NULL\n-- 3) Tighten projects INSERT policy to admin or manager only\n-- Idempotent: safe to re-run\n\nDO $$\nBEGIN\n  -- Add columns if missing\n  IF NOT EXISTS (\n    SELECT 1 FROM information_schema.columns \n    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'start_time'\n  ) THEN\n    ALTER TABLE public.project_meetings ADD COLUMN start_time TIMESTAMPTZ;\n  END IF;\n  IF NOT EXISTS (\n    SELECT 1 FROM information_schema.columns \n    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'end_time'\n  ) THEN\n    ALTER TABLE public.project_meetings ADD COLUMN end_time TIMESTAMPTZ;\n  END IF;\n  \n  -- Backfill from scheduled_at if present\n  IF EXISTS (\n    SELECT 1 FROM information_schema.columns \n    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'scheduled_at'\n  ) THEN\n    UPDATE public.project_meetings\n    SET start_time = COALESCE(start_time, scheduled_at),\n        end_time = COALESCE(end_time, scheduled_at + INTERVAL '1 hour')\n    WHERE start_time IS NULL OR end_time IS NULL;\n  END IF;\n  \n  -- Set NOT NULL constraints\n  ALTER TABLE public.project_meetings\n    ALTER COLUMN start_time SET NOT NULL,\n    ALTER COLUMN end_time SET NOT NULL;\n  \n  -- Ensure meeting_link exists and is NOT NULL\n  IF NOT EXISTS (\n    SELECT 1 FROM information_schema.columns \n    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'meeting_link'\n  ) THEN\n    ALTER TABLE public.project_meetings ADD COLUMN meeting_link TEXT;\n  END IF;\n  -- Backfill meeting_link with empty string if NULL to allow setting NOT NULL\n  UPDATE public.project_meetings SET meeting_link = COALESCE(meeting_link, '') WHERE meeting_link IS NULL;\n  ALTER TABLE public.project_meetings ALTER COLUMN meeting_link SET NOT NULL;\n  \n  -- Drop scheduled_at if it exists (now replaced by start_time/end_time)\n  IF EXISTS (\n    SELECT 1 FROM information_schema.columns \n    WHERE table_schema = 'public' AND table_name = 'project_meetings' AND column_name = 'scheduled_at'\n  ) THEN\n    ALTER TABLE public.project_meetings DROP COLUMN scheduled_at;\n  END IF;\nEND $$","-- Tighten projects INSERT policy: only admin or manager may create\nDO $$\nBEGIN\n  IF EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'org_insert_projects'\n  ) THEN\n    EXECUTE 'DROP POLICY \\"org_insert_projects\\" ON public.projects';\n  END IF;\n  \n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'projects' AND policyname = 'admin_or_manager_insert_projects'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"admin_or_manager_insert_projects\\" ON public.projects\n        FOR INSERT WITH CHECK (\n          organization_id = public.current_org_id()\n          AND EXISTS (\n            SELECT 1 FROM public.user_roles ur\n            WHERE ur.user_id = auth.uid()\n              AND ur.organization_id = public.current_org_id()\n              AND ur.role IN ('admin','manager')\n          )\n        )\n    $sql$;\n  END IF;\nEND $$"}	project_meetings_schema_fix
20251231132000	{"DO $$\r\nDECLARE\r\n  v TEXT;\r\nBEGIN\r\n  FOR v IN SELECT unnest(ARRAY['tenant_admin','hr','finance','viewer','super_admin'])\r\n  LOOP\r\n    IF NOT EXISTS (\r\n      SELECT 1 FROM pg_enum e\r\n      JOIN pg_type t ON t.oid = e.enumtypid\r\n      WHERE t.typname = 'app_role' AND e.enumlabel = v\r\n    ) THEN\r\n      EXECUTE format('ALTER TYPE public.app_role ADD VALUE %L', v);\r\n    END IF;\r\n  END LOOP;\r\nEND $$","ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS super_admin BOOLEAN NOT NULL DEFAULT false","CREATE TABLE IF NOT EXISTS public.tenant_modules (\r\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\r\n  module TEXT NOT NULL,\r\n  enabled BOOLEAN NOT NULL DEFAULT true,\r\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n  UNIQUE (organization_id, module)\r\n)","DO $$\r\nDECLARE\r\n  _org UUID;\r\n  m TEXT;\r\nBEGIN\r\n  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;\r\n  FOR m IN SELECT unnest(ARRAY[\r\n    'dashboard','chat','leads','contacts','companies','deals','projects','tasks','calendar',\r\n    'employees','attendance','payroll','leave_requests','reports','departments','designations',\r\n    'user_roles','activity_logs','settings'\r\n  ])\r\n  LOOP\r\n    INSERT INTO public.tenant_modules(organization_id, module, enabled)\r\n    VALUES (_org, m, true)\r\n    ON CONFLICT (organization_id, module) DO NOTHING;\r\n  END LOOP;\r\nEND $$","CREATE OR REPLACE FUNCTION public.enforce_single_tenant_admin()\r\nRETURNS TRIGGER\r\nLANGUAGE plpgsql\r\nAS $$\r\nBEGIN\r\n  IF NEW.role = 'tenant_admin' THEN\r\n    IF EXISTS (\r\n      SELECT 1 FROM public.user_roles\r\n      WHERE organization_id = NEW.organization_id\r\n        AND role = 'tenant_admin'\r\n        AND (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND id <> NEW.id))\r\n    ) THEN\r\n      RAISE EXCEPTION 'Only one tenant_admin allowed per organization';\r\n    END IF;\r\n  END IF;\r\n  RETURN NEW;\r\nEND;\r\n$$","DROP TRIGGER IF EXISTS trg_enforce_single_tenant_admin ON public.user_roles","CREATE TRIGGER trg_enforce_single_tenant_admin\r\nBEFORE INSERT OR UPDATE ON public.user_roles\r\nFOR EACH ROW EXECUTE FUNCTION public.enforce_single_tenant_admin()","-- seeding moved to separate migration to avoid enum unsafe usage in same transaction"}	roles_modules_constraints
20251231132100	{"DO $$\nDECLARE\n  _org UUID;\nBEGIN\n  SELECT id INTO _org FROM public.organizations ORDER BY created_at LIMIT 1;\n  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)\n  SELECT _org, 'tenant_admin', m, true, true, true, true\n  FROM unnest(ARRAY['dashboard','chat','leads','deals','tasks','calendar','payroll','attendance','reports','leave_requests','projects','employees','departments','designations','user_roles','activity_logs','settings']) AS m\n  ON CONFLICT DO NOTHING;\n\n  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)\n  VALUES \n    (_org, 'hr', 'employees', true, true, true, false),\n    (_org, 'hr', 'attendance', true, true, true, false),\n    (_org, 'hr', 'payroll', true, true, true, false),\n    (_org, 'hr', 'leave_requests', true, false, true, true),\n    (_org, 'hr', 'reports', true, false, false, false),\n    (_org, 'finance', 'payroll', true, false, false, false),\n    (_org, 'viewer', 'dashboard', true, false, false, false),\n    (_org, 'viewer', 'reports', true, false, false, false)\n  ON CONFLICT DO NOTHING;\n\n  INSERT INTO public.role_capabilities (organization_id, role, module, can_view, can_create, can_edit, can_approve)\n  VALUES \n    (_org, 'admin', 'projects', true, true, true, true),\n    (_org, 'manager', 'projects', true, true, true, false)\n  ON CONFLICT DO NOTHING;\nEND $$"}	seed_roles_capabilities
20251231133000	{"-- HR approvals and activity logs retention\n-- 1) Payroll approval fields and notification trigger\n-- 2) Leave request decision notification\n-- 3) Activity logs retention per organization (keep latest 500)\n\n-- Payroll approval fields\nALTER TABLE public.payroll\n  ADD COLUMN IF NOT EXISTS approval_status TEXT CHECK (approval_status IN ('approved','rejected')) NULL,\n  ADD COLUMN IF NOT EXISTS approved_by UUID NULL REFERENCES public.profiles(id) ON DELETE SET NULL,\n  ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ NULL,\n  ADD COLUMN IF NOT EXISTS decision_note TEXT NULL","-- Notify on payroll approval/rejection\nCREATE OR REPLACE FUNCTION public.notify_payroll_approval()\nRETURNS TRIGGER AS $$\nDECLARE\n  _employee_user UUID;\nBEGIN\n  IF NEW.approval_status IS DISTINCT FROM OLD.approval_status THEN\n    SELECT user_id INTO _employee_user FROM public.employees WHERE id = NEW.employee_id;\n    IF _employee_user IS NOT NULL THEN\n      INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)\n      VALUES (\n        _employee_user,\n        'payroll_approval',\n        CASE NEW.approval_status WHEN 'approved' THEN 'Payroll Approved' ELSE 'Payroll Rejected' END,\n        COALESCE(NEW.decision_note, ''),\n        'payroll',\n        NEW.id,\n        public.current_org_id()\n      );\n    END IF;\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_notify_payroll_approval ON public.payroll","CREATE TRIGGER trg_notify_payroll_approval\nAFTER UPDATE OF approval_status ON public.payroll\nFOR EACH ROW EXECUTE FUNCTION public.notify_payroll_approval()","-- Notify on leave decision\nCREATE OR REPLACE FUNCTION public.notify_leave_decision()\nRETURNS TRIGGER AS $$\nDECLARE\n  _employee_user UUID;\nBEGIN\n  IF NEW.status IS DISTINCT FROM OLD.status AND NEW.status IN ('approved','rejected') THEN\n    SELECT user_id INTO _employee_user FROM public.employees WHERE id = NEW.employee_id;\n    IF _employee_user IS NOT NULL THEN\n      INSERT INTO public.notifications (user_id, type, title, body, entity_type, entity_id, organization_id)\n      VALUES (\n        _employee_user,\n        'leave_decision',\n        CASE NEW.status WHEN 'approved' THEN 'Leave Approved' ELSE 'Leave Rejected' END,\n        COALESCE(NEW.reason, ''),\n        'leave_request',\n        NEW.id,\n        public.current_org_id()\n      );\n    END IF;\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_notify_leave_decision ON public.leave_requests","CREATE TRIGGER trg_notify_leave_decision\nAFTER UPDATE OF status ON public.leave_requests\nFOR EACH ROW EXECUTE FUNCTION public.notify_leave_decision()","-- Activity logs retention: keep latest 500 per org\nCREATE OR REPLACE FUNCTION public.retain_activity_logs_limit()\nRETURNS TRIGGER AS $$\nBEGIN\n  WITH ranked AS (\n    SELECT id,\n           organization_id,\n           created_at,\n           row_number() OVER (PARTITION BY organization_id ORDER BY created_at DESC) AS rn\n    FROM public.activity_logs\n  )\n  DELETE FROM public.activity_logs al\n  USING ranked r\n  WHERE al.id = r.id\n    AND r.rn > 500;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_retain_activity_logs_limit ON public.activity_logs","CREATE TRIGGER trg_retain_activity_logs_limit\nAFTER INSERT ON public.activity_logs\nFOR EACH STATEMENT EXECUTE FUNCTION public.retain_activity_logs_limit()"}	hr_approvals_and_logs
20251231140000	{"-- Break recursive RLS between projects and project_members by simplifying project_members SELECT policy\nDO $$\nBEGIN\n  -- Drop existing org-scoped SELECT policy if present\n  IF EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_members' AND policyname = 'org_select_project_members'\n  ) THEN\n    EXECUTE 'DROP POLICY \\"org_select_project_members\\" ON public.project_members';\n  END IF;\n\n  -- Recreate SELECT policy without referencing projects to avoid recursion\n  -- Visible to the authenticated employee themselves within their organization\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'project_members' AND policyname = 'employee_self_select_project_members'\n  ) THEN\n    EXECUTE $sql$\n      CREATE POLICY \\"employee_self_select_project_members\\" ON public.project_members\n        FOR SELECT USING (\n          EXISTS (\n            SELECT 1 \n            FROM public.employees e\n            WHERE e.id = project_members.employee_id\n              AND e.user_id = auth.uid()\n              AND e.organization_id = public.current_org_id()\n          )\n        )\n    $sql$;\n  END IF;\nEND $$"}	fix_projects_rls_recursion
20251231143000	{"-- Fix Visibility and RLS according to updates.md\n\n-- 1. Helper Functions for Roles\nCREATE OR REPLACE FUNCTION public.is_tenant_admin(_user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.user_roles\n    WHERE user_id = _user_id AND role = 'tenant_admin'\n  )\n$$","CREATE OR REPLACE FUNCTION public.is_manager(_user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.user_roles\n    WHERE user_id = _user_id AND role = 'manager'\n  )\n$$","CREATE OR REPLACE FUNCTION public.is_hr(_user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.user_roles\n    WHERE user_id = _user_id AND role = 'hr'\n  )\n$$","-- 2. Update RLS for Leads\nDROP POLICY IF EXISTS \\"Authenticated users can view leads\\" ON public.leads","DROP POLICY IF EXISTS \\"Authenticated users can create leads\\" ON public.leads","DROP POLICY IF EXISTS \\"Assigned users can update leads\\" ON public.leads","DROP POLICY IF EXISTS \\"Admins can delete leads\\" ON public.leads","-- Tenant Admin: ALL\n-- Manager: Assigned OR Created (Strict \\"only their leads\\" per spec 4.2)\n-- Employee: Assigned OR Created\nCREATE POLICY \\"tenant_admin_view_all_leads\\" ON public.leads\n  FOR SELECT USING (public.is_tenant_admin(auth.uid()))","CREATE POLICY \\"users_view_own_leads\\" ON public.leads\n  FOR SELECT USING (\n    auth.uid() = assigned_to \n    OR auth.uid() = created_by\n  )","-- Create: Tenant Admin, Manager (Spec 4.2), Employee (implied if they can view assigned, but spec 4.2 only mentions Manager/Tenant Admin creating)\n-- Spec 4.2: \\"Manager can create leads\\", \\"Tenant Admin can create leads\\". Employee creation not explicitly mentioned, but usually allowed?\n-- Spec 134: \\"Employee can update but not delete\\".\n-- Let's allow Manager/Admin to create. Employee? \\"Employee -> only assigned leads\\".\n-- If Employee creates, they are created_by.\n-- I'll allow Authenticated to create (simplifies \\"Contact Us\\" forms etc if integrated later, but for internal app, stick to roles).\n-- Spec 4.2: \\"Manager can create leads\\", \\"Tenant Admin can create leads\\".\n-- I will restrict creation to Admin/Manager/HR?\n-- Let's stick to: Authenticated can create (fallback), but visibility is restricted.\nCREATE POLICY \\"authenticated_create_leads\\" ON public.leads\n  FOR INSERT WITH CHECK (auth.uid() = created_by)","-- Update: Assigned or Creator or Admin/Manager\nCREATE POLICY \\"users_update_own_leads\\" ON public.leads\n  FOR UPDATE USING (\n    auth.uid() = assigned_to \n    OR auth.uid() = created_by\n    OR public.is_tenant_admin(auth.uid())\n    OR public.is_manager(auth.uid())\n  )","-- Delete: Tenant Admin only? Spec doesn't specify delete for Manager.\n-- Spec 134: \\"Employee can update but not delete\\".\n-- Spec 3.1: Super Admin deletes tenants.\n-- Tenant Admin \\"Full control\\".\nCREATE POLICY \\"tenant_admin_delete_leads\\" ON public.leads\n  FOR DELETE USING (public.is_tenant_admin(auth.uid()))","-- 3. Update RLS for Deals\nDROP POLICY IF EXISTS \\"Authenticated users can view deals\\" ON public.deals","-- Spec 4.4: \\"Manager -> all deals\\", \\"Employee -> assigned deals only\\", \\"Tenant Admin -> Full\\"\nCREATE POLICY \\"admin_manager_view_all_deals\\" ON public.deals\n  FOR SELECT USING (\n    public.is_tenant_admin(auth.uid()) \n    OR public.is_manager(auth.uid())\n  )","CREATE POLICY \\"employee_view_assigned_deals\\" ON public.deals\n  FOR SELECT USING (\n    auth.uid() = assigned_to \n    OR auth.uid() = created_by\n  )","-- 4. Update RLS for Employees (Table)\nDROP POLICY IF EXISTS \\"Authenticated users can view employees\\" ON public.employees","-- Spec 3.2 Tenant Admin full, Spec 3.4 HR access HR modules.\n-- Spec 3.5 Employee \\"Cannot see payroll of others\\".\n-- Final.md: \\"Restrict non-HR/Tenant Admin reads\\".\nCREATE POLICY \\"hr_admin_view_all_employees\\" ON public.employees\n  FOR SELECT USING (\n    public.is_tenant_admin(auth.uid()) \n    OR public.is_hr(auth.uid())\n  )","-- Exception: User might need to see their own employee record?\nCREATE POLICY \\"user_view_own_employee_record\\" ON public.employees\n  FOR SELECT USING (user_id = auth.uid())","-- 5. Auto-create Company/Contact on Lead Qualification\nCREATE OR REPLACE FUNCTION public.handle_lead_qualification()\nRETURNS TRIGGER AS $$\nDECLARE\n  _company_id UUID;\n  _contact_id UUID;\nBEGIN\n  IF NEW.status = 'qualified' AND OLD.status <> 'qualified' THEN\n    -- 1. Create Company if missing\n    IF NEW.company_id IS NULL AND NEW.company_name IS NOT NULL THEN\n       -- Check if exists by name to avoid duplicates?\n       SELECT id INTO _company_id FROM public.companies WHERE name = NEW.company_name LIMIT 1;\n       \n       IF _company_id IS NULL THEN\n         INSERT INTO public.companies (name, created_by, organization_id)\n         VALUES (NEW.company_name, NEW.created_by, NEW.organization_id)\n         RETURNING id INTO _company_id;\n       END IF;\n       \n       NEW.company_id := _company_id;\n    END IF;\n\n    -- 2. Create Contact if missing\n    IF NEW.contact_id IS NULL AND NEW.contact_name IS NOT NULL THEN\n       -- Split name?\n       INSERT INTO public.contacts (first_name, last_name, company_id, created_by, organization_id)\n       VALUES (\n         split_part(NEW.contact_name, ' ', 1), \n         CASE WHEN strpos(NEW.contact_name, ' ') > 0 THEN substr(NEW.contact_name, strpos(NEW.contact_name, ' ') + 1) ELSE '' END,\n         NEW.company_id,\n         NEW.created_by,\n         NEW.organization_id\n       )\n       RETURNING id INTO _contact_id;\n       \n       NEW.contact_id := _contact_id;\n    END IF;\n    \n    -- 3. Auto-convert to Deal? (Optional per spec, but useful)\n    -- Spec 4.3 \\"Convert Lead -> Deal\\".\n    -- Let's just link Company/Contact for now.\n    \n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_lead_qualified ON public.leads","CREATE TRIGGER trg_lead_qualified\nBEFORE UPDATE ON public.leads\nFOR EACH ROW EXECUTE FUNCTION public.handle_lead_qualification()","-- 6. Activity Logs for Deals and Tasks\nCREATE OR REPLACE FUNCTION public.log_activity()\nRETURNS TRIGGER AS $$\nDECLARE\n  _action TEXT;\n  _desc TEXT;\nBEGIN\n  IF TG_OP = 'INSERT' THEN\n    _action := 'created';\n    _desc := 'Created ' || TG_TABLE_NAME;\n  ELSIF TG_OP = 'UPDATE' THEN\n    _action := 'updated';\n    _desc := 'Updated ' || TG_TABLE_NAME;\n  ELSIF TG_OP = 'DELETE' THEN\n    _action := 'deleted';\n    _desc := 'Deleted ' || TG_TABLE_NAME;\n  END IF;\n\n  INSERT INTO public.activity_logs (user_id, action, entity_type, entity_id, description, organization_id)\n  VALUES (auth.uid(), _action, TG_TABLE_NAME, COALESCE(NEW.id, OLD.id), _desc, COALESCE(NEW.organization_id, OLD.organization_id));\n  \n  RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_log_deals ON public.deals","CREATE TRIGGER trg_log_deals\nAFTER INSERT OR UPDATE OR DELETE ON public.deals\nFOR EACH ROW EXECUTE FUNCTION public.log_activity()","DROP TRIGGER IF EXISTS trg_log_tasks ON public.tasks","CREATE TRIGGER trg_log_tasks\nAFTER INSERT OR UPDATE OR DELETE ON public.tasks\nFOR EACH ROW EXECUTE FUNCTION public.log_activity()","-- 7. Fix Project Chat Members (Ensure all members added)\n-- Existing trigger might only add NEW member.\n-- We need a function to sync all members if needed.\n-- But for now, let's trust the existing trigger for NEW members.\n-- If we need to backfill, we can run a one-off script.\n\n-- 8. Attendance/Payroll RLS Updates\nDROP POLICY IF EXISTS \\"Employees can view their own attendance\\" ON public.attendance","DROP POLICY IF EXISTS \\"Admins can manage attendance\\" ON public.attendance","-- HR/Admin: ALL\nCREATE POLICY \\"hr_admin_manage_attendance\\" ON public.attendance\n  FOR ALL USING (\n    public.is_tenant_admin(auth.uid()) \n    OR public.is_hr(auth.uid())\n  )","-- Employee: View Own\nCREATE POLICY \\"employee_view_own_attendance\\" ON public.attendance\n  FOR SELECT USING (\n    EXISTS (SELECT 1 FROM public.employees e WHERE e.id = attendance.employee_id AND e.user_id = auth.uid())\n  )","-- Payroll\nDROP POLICY IF EXISTS \\"Employees can view their own payroll\\" ON public.payroll","DROP POLICY IF EXISTS \\"Admins can manage payroll\\" ON public.payroll","CREATE POLICY \\"hr_admin_manage_payroll\\" ON public.payroll\n  FOR ALL USING (\n    public.is_tenant_admin(auth.uid()) \n    OR public.is_hr(auth.uid())\n  )","CREATE POLICY \\"employee_view_own_payroll\\" ON public.payroll\n  FOR SELECT USING (\n    EXISTS (SELECT 1 FROM public.employees e WHERE e.id = payroll.employee_id AND e.user_id = auth.uid())\n  )"}	fix_visibility_and_rls
20251231150000	{"-- Payroll and Leave Workflows\n\n-- 1. Payroll Status Update\nALTER TYPE public.payroll_status ADD VALUE IF NOT EXISTS 'approved' AFTER 'pending'","-- 2. Clone Payroll Function\nCREATE OR REPLACE FUNCTION public.clone_payroll_month(\n  source_month INTEGER,\n  source_year INTEGER,\n  target_month INTEGER,\n  target_year INTEGER\n)\nRETURNS INTEGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  _count INTEGER;\n  _org UUID;\nBEGIN\n  _org := public.current_org_id();\n\n  INSERT INTO public.payroll (\n    organization_id,\n    employee_id,\n    month,\n    year,\n    basic_salary,\n    allowances,\n    deductions,\n    net_salary,\n    status\n  )\n  SELECT \n    organization_id,\n    employee_id,\n    target_month,\n    target_year,\n    basic_salary,\n    allowances,\n    deductions,\n    net_salary,\n    'pending' -- Draft status\n  FROM public.payroll\n  WHERE month = source_month \n    AND year = source_year\n    AND organization_id = _org\n    AND NOT EXISTS (\n      SELECT 1 FROM public.payroll p2 \n      WHERE p2.employee_id = payroll.employee_id \n        AND p2.month = target_month \n        AND p2.year = target_year\n    );\n    \n  GET DIAGNOSTICS _count = ROW_COUNT;\n  RETURN _count;\nEND;\n$$","-- 3. Payroll RLS Refinement\nDROP POLICY IF EXISTS \\"hr_admin_manage_payroll\\" ON public.payroll","-- HR can INSERT (Create Draft)\nCREATE POLICY \\"hr_create_payroll\\" ON public.payroll\n  FOR INSERT WITH CHECK (\n    public.is_hr(auth.uid()) \n    OR public.is_tenant_admin(auth.uid())\n  )","-- HR can UPDATE (Edit Draft) - only if pending\nCREATE POLICY \\"hr_update_payroll\\" ON public.payroll\n  FOR UPDATE USING (\n    (public.is_hr(auth.uid()) AND status = 'pending')\n    OR public.is_tenant_admin(auth.uid())\n  )","-- Admin can Approve (Update status)\n-- Covered by above: Admin can update anything. \n-- HR limited to pending.\n\n-- Admin/HR can Select\nCREATE POLICY \\"hr_admin_view_payroll\\" ON public.payroll\n  FOR SELECT USING (\n    public.is_hr(auth.uid()) \n    OR public.is_tenant_admin(auth.uid())\n  )","-- Admin can Delete\nCREATE POLICY \\"admin_delete_payroll\\" ON public.payroll\n  FOR DELETE USING (public.is_tenant_admin(auth.uid()))","-- 4. Leave Requests Approval Logic\nDROP POLICY IF EXISTS \\"Admins can manage leave requests\\" ON public.leave_requests","-- HR can Update (Approve/Reject) Normal Employees\n-- Admin can Update All\nCREATE POLICY \\"hr_admin_manage_leave\\" ON public.leave_requests\n  FOR UPDATE USING (\n    public.is_tenant_admin(auth.uid())\n    OR (\n      public.is_hr(auth.uid())\n      AND NOT EXISTS (\n        -- Check if the employee being approved is an HR or Admin\n        SELECT 1 FROM public.employees e\n        JOIN public.user_roles ur ON ur.user_id = e.user_id\n        WHERE e.id = leave_requests.employee_id\n          AND ur.role IN ('hr', 'tenant_admin', 'super_admin')\n      )\n    )\n  )","-- Notification Trigger for Leave Status Change\nCREATE OR REPLACE FUNCTION public.notify_leave_status_change()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF OLD.status <> NEW.status THEN\n    INSERT INTO public.notifications (user_id, title, message, type, organization_id)\n    SELECT \n      e.user_id,\n      'Leave Request ' || NEW.status,\n      'Your leave request from ' || NEW.start_date || ' to ' || NEW.end_date || ' has been ' || NEW.status,\n      'leave_update',\n      NEW.organization_id\n    FROM public.employees e\n    WHERE e.id = NEW.employee_id;\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_notify_leave ON public.leave_requests","CREATE TRIGGER trg_notify_leave\nAFTER UPDATE ON public.leave_requests\nFOR EACH ROW EXECUTE FUNCTION public.notify_leave_status_change()"}	payroll_leave_workflow
20251231153000	{"-- Trigger to add project members to project chat\nCREATE OR REPLACE FUNCTION public.sync_project_member_to_chat()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\n  _user_id UUID;\nBEGIN\n  -- Get the user_id from employees table\n  SELECT user_id INTO _user_id\n  FROM public.employees\n  WHERE id = NEW.employee_id;\n\n  IF _user_id IS NULL THEN\n    RETURN NEW;\n  END IF;\n\n  -- Get the project chat channel\n  SELECT id INTO _channel_id\n  FROM public.chat_channels\n  WHERE project_id = NEW.project_id AND type = 'group' -- Assuming project chat is 'group' or 'project' type?\n  ORDER BY created_at DESC\n  LIMIT 1;\n  \n  -- If type 'project' was introduced, check for it\n  IF _channel_id IS NULL THEN\n     SELECT id INTO _channel_id\n     FROM public.chat_channels\n     WHERE project_id = NEW.project_id\n     ORDER BY created_at DESC\n     LIMIT 1;\n  END IF;\n\n  IF _channel_id IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)\n    VALUES (_channel_id, _user_id, (SELECT organization_id FROM public.projects WHERE id = NEW.project_id))\n    ON CONFLICT (channel_id, user_id) DO NOTHING;\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_add_member_to_chat ON public.project_members","CREATE TRIGGER trg_add_member_to_chat\nAFTER INSERT ON public.project_members\nFOR EACH ROW EXECUTE FUNCTION public.sync_project_member_to_chat()"}	project_chat_members_trigger
20251231160000	{"-- Fix Payroll RLS to prevent HR from approving\nDROP POLICY IF EXISTS \\"hr_update_payroll\\" ON public.payroll","CREATE POLICY \\"hr_update_payroll\\" ON public.payroll\n  FOR UPDATE USING (\n    (public.is_hr(auth.uid()) AND status = 'pending')\n    OR public.is_tenant_admin(auth.uid())\n  )\n  WITH CHECK (\n    (public.is_hr(auth.uid()) AND status = 'pending') -- HR cannot change status to anything else (remain pending)\n    OR public.is_tenant_admin(auth.uid())\n  )"}	fix_payroll_rls_check
20251231163000	{"ALTER TABLE public.payroll ADD COLUMN IF NOT EXISTS rejection_note TEXT"}	add_payroll_rejection_note
20251231170000	{"-- 1. Ensure all projects have a chat channel\nDO $$\nDECLARE\n  _r RECORD;\nBEGIN\n  FOR _r IN \n    SELECT p.id, p.name, p.organization_id, p.owner_id \n    FROM public.projects p\n    WHERE NOT EXISTS (SELECT 1 FROM public.chat_channels cc WHERE cc.project_id = p.id)\n  LOOP\n    INSERT INTO public.chat_channels (organization_id, type, name, project_id, created_by)\n    VALUES (_r.organization_id, 'project', _r.name, _r.id, _r.owner_id);\n  END LOOP;\nEND $$","-- 2. Ensure all project members are in the chat channel\nINSERT INTO public.chat_participants (channel_id, user_id)\nSELECT \n  cc.id,\n  e.user_id\nFROM public.project_members pm\nJOIN public.chat_channels cc ON cc.project_id = pm.project_id\nJOIN public.employees e ON e.id = pm.employee_id\nWHERE NOT EXISTS (\n  SELECT 1 FROM public.chat_participants cp \n  WHERE cp.channel_id = cc.id AND cp.user_id = e.user_id\n)","-- 3. Ensure project owners are in the chat channel\nINSERT INTO public.chat_participants (channel_id, user_id)\nSELECT \n  cc.id,\n  p.owner_id\nFROM public.projects p\nJOIN public.chat_channels cc ON cc.project_id = p.id\nWHERE p.owner_id IS NOT NULL\nAND NOT EXISTS (\n  SELECT 1 FROM public.chat_participants cp \n  WHERE cp.channel_id = cc.id AND cp.user_id = p.owner_id\n)"}	backfill_project_chats
20260101000000	{"-- Fix email_templates organization_id handling\nCREATE OR REPLACE FUNCTION public.set_org_id_on_insert_email_templates()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_set_org_on_insert_email_templates ON public.email_templates","CREATE TRIGGER trg_set_org_on_insert_email_templates\n  BEFORE INSERT ON public.email_templates\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_email_templates()","-- Ensure proper policies for insert/update/delete\nDROP POLICY IF EXISTS \\"Admins and Managers can manage templates\\" ON public.email_templates","-- Allow all authenticated users in the org to view templates (already exists as \\"Users can view their org's templates\\")\n-- But we need to ensure they can also create if they have permission, or at least admins/managers\nCREATE POLICY \\"Admins and Managers can manage templates\\" ON public.email_templates\n  FOR ALL USING (\n    organization_id = public.current_org_id() AND\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role IN ('tenant_admin', 'manager', 'hr')\n    )\n  )","-- Just in case, ensure RLS is on\nALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY"}	fix_email_templates
20251231180000	{"-- Create email_templates table\nCREATE TABLE IF NOT EXISTS public.email_templates (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\n  name TEXT NOT NULL,\n  subject TEXT NOT NULL,\n  body TEXT NOT NULL,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  created_by UUID REFERENCES public.profiles(id)\n)","-- Enable RLS for email_templates\nALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Users can view their org's templates\\" ON public.email_templates","CREATE POLICY \\"Users can view their org's templates\\" ON public.email_templates\n  FOR SELECT USING (organization_id = (SELECT organization_id FROM public.profiles WHERE id = auth.uid()))","DROP POLICY IF EXISTS \\"Admins and Managers can manage templates\\" ON public.email_templates","CREATE POLICY \\"Admins and Managers can manage templates\\" ON public.email_templates\n  FOR ALL USING (\n    organization_id = (SELECT organization_id FROM public.profiles WHERE id = auth.uid()) AND\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role IN ('tenant_admin', 'manager', 'hr')\n    )\n  )","-- Ensure project_tasks table exists and is isolated\nCREATE TABLE IF NOT EXISTS public.project_tasks (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,\n  title TEXT NOT NULL,\n  description TEXT,\n  status TEXT NOT NULL DEFAULT 'todo',\n  priority TEXT DEFAULT 'medium',\n  assigned_to UUID REFERENCES public.profiles(id),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  due_date TIMESTAMPTZ\n)","-- RLS for project_tasks\nALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Project members can view tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can view tasks\\" ON public.project_tasks\n  FOR SELECT USING (\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      WHERE pm.project_id = project_tasks.project_id AND pm.employee_id IN (\n        SELECT id FROM public.employees WHERE user_id = auth.uid()\n      )\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","DROP POLICY IF EXISTS \\"Project members can create/update tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can create/update tasks\\" ON public.project_tasks\n  FOR ALL USING (\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      WHERE pm.project_id = project_tasks.project_id AND pm.employee_id IN (\n        SELECT id FROM public.employees WHERE user_id = auth.uid()\n      )\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","-- Ensure activity_logs has organization_id\nALTER TABLE public.activity_logs ADD COLUMN IF NOT EXISTS organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE","-- Backfill organization_id for activity_logs if possible (using user_id)\nUPDATE public.activity_logs al\nSET organization_id = p.organization_id\nFROM public.profiles p\nWHERE al.user_id = p.id AND al.organization_id IS NULL","-- Trigger for activity log cleanup (Keep latest 500 per organization)\nCREATE OR REPLACE FUNCTION public.cleanup_activity_logs()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NOT NULL THEN\n    DELETE FROM public.activity_logs\n    WHERE id IN (\n      SELECT id FROM public.activity_logs\n      WHERE organization_id = NEW.organization_id\n      ORDER BY created_at DESC\n      OFFSET 500\n    );\n  END IF;\n  RETURN NULL;\nEND;\n$$ LANGUAGE plpgsql","DROP TRIGGER IF EXISTS trigger_cleanup_activity_logs ON public.activity_logs","CREATE TRIGGER trigger_cleanup_activity_logs\nAFTER INSERT ON public.activity_logs\nFOR EACH ROW\nEXECUTE FUNCTION public.cleanup_activity_logs()"}	email_project_tasks_logs
20251231190000	{"-- Ensure tenant_admin can manage project_meetings\nALTER TABLE public.project_meetings ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Project managers can manage meetings\\" ON public.project_meetings","DROP POLICY IF EXISTS \\"Project managers and admins can manage meetings\\" ON public.project_meetings","CREATE POLICY \\"Project managers and admins can manage meetings\\" ON public.project_meetings\n  FOR ALL USING (\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_meetings.project_id\n        AND e.user_id = auth.uid()\n        AND lower(pm.role) = 'manager'\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_meetings.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","-- Ensure tenant_admin can manage project_members\n-- Existing policies might be \\"org_insert_project_members\\" etc.\n-- We'll create a comprehensive policy for management\n\nDROP POLICY IF EXISTS \\"Managers and Admins can manage project members\\" ON public.project_members","CREATE POLICY \\"Managers and Admins can manage project members\\" ON public.project_members\n  FOR ALL USING (\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_members.project_id\n      AND (\n        p.owner_id = auth.uid() OR\n        EXISTS (\n            SELECT 1 FROM public.project_members pm\n            JOIN public.employees e ON e.id = pm.employee_id\n            WHERE pm.project_id = p.id AND e.user_id = auth.uid() AND lower(pm.role) = 'manager'\n        ) OR\n        EXISTS (\n          SELECT 1 FROM public.user_roles ur\n          WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n        )\n      )\n    )\n  )"}	fix_tenant_admin_project_access
20251231200000	{"-- Consolidate project chat triggers and functions to avoid conflicts\n\n-- Drop existing potential triggers\nDROP TRIGGER IF EXISTS trg_add_member_to_chat ON public.project_members","DROP TRIGGER IF EXISTS trg_add_member_to_project_chat ON public.project_members","DROP TRIGGER IF EXISTS trg_join_project_chat ON public.project_members","DROP TRIGGER IF EXISTS trg_create_project_chat ON public.projects","-- Drop existing potential functions\nDROP FUNCTION IF EXISTS public.sync_project_member_to_chat()","DROP FUNCTION IF EXISTS public.add_member_to_project_chat()","DROP FUNCTION IF EXISTS public.join_project_chat_channel()","DROP FUNCTION IF EXISTS public.create_project_chat()","DROP FUNCTION IF EXISTS public.create_project_chat_channel()","-- Re-create robust functions\n\n-- 1. Auto-create project chat channel\nCREATE OR REPLACE FUNCTION public.handle_new_project_chat()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\n  _owner_id UUID;\nBEGIN\n  _owner_id := COALESCE(NEW.owner_id, auth.uid());\n  \n  -- Check if channel already exists (should not happen on insert, but safe check)\n  SELECT id INTO _channel_id FROM public.chat_channels WHERE project_id = NEW.id LIMIT 1;\n  \n  IF _channel_id IS NULL THEN\n    INSERT INTO public.chat_channels (organization_id, project_id, name, type, created_by)\n    VALUES (NEW.organization_id, NEW.id, COALESCE('Project: ' || NEW.name, 'Project Chat'), 'group', _owner_id)\n    RETURNING id INTO _channel_id;\n  END IF;\n\n  -- Add owner as participant\n  IF _owner_id IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)\n    VALUES (_channel_id, _owner_id, NEW.organization_id)\n    ON CONFLICT (channel_id, user_id) DO NOTHING;\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","CREATE TRIGGER trg_handle_new_project_chat\n  AFTER INSERT ON public.projects\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_project_chat()","-- 2. Auto-join project members to chat\nCREATE OR REPLACE FUNCTION public.handle_new_project_member()\nRETURNS TRIGGER AS $$\nDECLARE\n  _channel_id UUID;\n  _user_id UUID;\n  _org_id UUID;\nBEGIN\n  -- Get project channel and org_id\n  SELECT id, organization_id INTO _channel_id, _org_id\n  FROM public.chat_channels\n  WHERE project_id = NEW.project_id\n  LIMIT 1;\n\n  -- If no channel linked to project, try to find one or bail out (usually created by project trigger)\n  IF _channel_id IS NULL THEN\n    -- Fallback: Check if we can create one? No, better to wait or log.\n    -- But for now, let's just return.\n    RETURN NEW;\n  END IF;\n\n  -- Get user_id from employee\n  SELECT user_id INTO _user_id\n  FROM public.employees\n  WHERE id = NEW.employee_id;\n\n  IF _user_id IS NOT NULL THEN\n    INSERT INTO public.chat_participants (channel_id, user_id, organization_id)\n    VALUES (_channel_id, _user_id, _org_id)\n    ON CONFLICT (channel_id, user_id) DO NOTHING;\n  END IF;\n\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","CREATE TRIGGER trg_handle_new_project_member\n  AFTER INSERT ON public.project_members\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_project_member()","-- Ensure RLS policies for project_tasks are correct (Double check)\n-- Users should see tasks if they are:\n-- 1. Tenant Admin\n-- 2. Project Owner\n-- 3. Project Member (Manager or Employee role in project)\n\nDROP POLICY IF EXISTS \\"Project members can view tasks\\" ON public.project_tasks","DROP POLICY IF EXISTS \\"Project members can create tasks\\" ON public.project_tasks","DROP POLICY IF EXISTS \\"Project members can update tasks\\" ON public.project_tasks","DROP POLICY IF EXISTS \\"Project members can delete tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can view tasks\\" ON public.project_tasks\n  FOR SELECT USING (\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","CREATE POLICY \\"Project members can create tasks\\" ON public.project_tasks\n  FOR INSERT WITH CHECK (\n    -- Similar logic, usually members can create tasks\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","CREATE POLICY \\"Project members can update tasks\\" ON public.project_tasks\n  FOR UPDATE USING (\n    -- Members can update tasks (e.g. status)\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","CREATE POLICY \\"Project members can delete tasks\\" ON public.project_tasks\n  FOR DELETE USING (\n    -- Maybe only managers/admins/owners?\n    -- For now, let's allow members to delete tasks they created? \n    -- But we don't track creator in project_tasks explicitly (created_by?).\n    -- Let's restrict delete to project managers (role='manager' in project_members) or owner/admin.\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id \n        AND e.user_id = auth.uid()\n        AND lower(pm.role) = 'manager'\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.projects p\n      WHERE p.id = project_tasks.project_id AND p.owner_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )"}	consolidate_project_triggers
20251231210000	{"-- Add explicit foreign key from employees.user_id to profiles.id to enable embedding in PostgREST\n-- PostgREST only detects relationships to exposed tables (public schema).\n-- The existing FK to auth.users is not visible for embedding profiles.\n\nDO $$\nBEGIN\n  -- We attempt to add the constraint. \n  -- If there are employees with user_ids that don't have profiles, this might fail.\n  -- Ideally, every user should have a profile.\n  \n  -- Check if the constraint already exists to avoid error\n  IF NOT EXISTS (\n    SELECT 1 FROM information_schema.table_constraints \n    WHERE constraint_name = 'employees_user_id_fkey_profiles' \n    AND table_name = 'employees'\n  ) THEN\n    ALTER TABLE public.employees\n      ADD CONSTRAINT employees_user_id_fkey_profiles\n      FOREIGN KEY (user_id)\n      REFERENCES public.profiles(id);\n  END IF;\nEND $$"}	fix_employees_profiles_fk
20251231220000	{"-- Fix infinite recursion between projects and project_members\n\n-- 1. Helper to get project owner without triggering RLS on projects\nCREATE OR REPLACE FUNCTION public.get_project_owner(p_id UUID)\nRETURNS UUID\nLANGUAGE sql\nSECURITY DEFINER\nSTABLE\nAS $$\n  SELECT owner_id FROM public.projects WHERE id = p_id\n$$","-- 2. Update project_members policy to use the helper\nDROP POLICY IF EXISTS \\"Managers and Admins can manage project members\\" ON public.project_members","CREATE POLICY \\"Managers and Admins can manage project members\\" ON public.project_members\n  FOR ALL USING (\n    -- 1. Project Owner (via Security Definer to avoid recursion)\n    (public.get_project_owner(project_members.project_id) = auth.uid()) OR\n    \n    -- 2. Project Manager (Member with role 'manager')\n    EXISTS (\n        SELECT 1 FROM public.project_members pm\n        JOIN public.employees e ON e.id = pm.employee_id\n        WHERE pm.project_id = project_members.project_id \n          AND e.user_id = auth.uid() \n          AND lower(pm.role) = 'manager'\n    ) OR\n    \n    -- 3. Tenant Admin\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","-- 3. Update project_meetings policy to use the helper (Optimization/Safety)\nDROP POLICY IF EXISTS \\"Project managers and admins can manage meetings\\" ON public.project_meetings","CREATE POLICY \\"Project managers and admins can manage meetings\\" ON public.project_meetings\n  FOR ALL USING (\n    -- 1. Project Owner\n    (public.get_project_owner(project_meetings.project_id) = auth.uid()) OR\n\n    -- 2. Project Manager\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_meetings.project_id\n        AND e.user_id = auth.uid()\n        AND lower(pm.role) = 'manager'\n    ) OR\n    \n    -- 3. Tenant Admin\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","-- 4. Update project_tasks policies to use the helper (Optimization/Safety)\n-- Re-apply policies from 20251231200000 with the fix\n\nDROP POLICY IF EXISTS \\"Project members can view tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can view tasks\\" ON public.project_tasks\n  FOR SELECT USING (\n    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","DROP POLICY IF EXISTS \\"Project members can create tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can create tasks\\" ON public.project_tasks\n  FOR INSERT WITH CHECK (\n    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","DROP POLICY IF EXISTS \\"Project members can update tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can update tasks\\" ON public.project_tasks\n  FOR UPDATE USING (\n    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id AND e.user_id = auth.uid()\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","DROP POLICY IF EXISTS \\"Project members can delete tasks\\" ON public.project_tasks","CREATE POLICY \\"Project members can delete tasks\\" ON public.project_tasks\n  FOR DELETE USING (\n    (public.get_project_owner(project_tasks.project_id) = auth.uid()) OR\n    EXISTS (\n      SELECT 1 FROM public.project_members pm\n      JOIN public.employees e ON e.id = pm.employee_id\n      WHERE pm.project_id = project_tasks.project_id \n        AND e.user_id = auth.uid()\n        AND lower(pm.role) = 'manager'\n    ) OR\n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )"}	fix_projects_recursion_final
20251231223000	{"-- Fix RLS Recursion by using Security Definer functions for both sides of the relationship\n\n-- 1. Function to check if user is a project member (Security Definer)\n-- Used by: projects table policy\nCREATE OR REPLACE FUNCTION public.is_project_member_or_owner(_project_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  -- Check if owner\n  IF EXISTS (SELECT 1 FROM public.projects WHERE id = _project_id AND owner_id = _user_id) THEN\n    RETURN TRUE;\n  END IF;\n\n  -- Check if member\n  IF EXISTS (\n    SELECT 1 FROM public.project_members pm\n    JOIN public.employees e ON e.id = pm.employee_id\n    WHERE pm.project_id = _project_id AND e.user_id = _user_id\n  ) THEN\n    RETURN TRUE;\n  END IF;\n  \n  RETURN FALSE;\nEND;\n$$","-- 2. Update Projects Policy to use the SD function\n-- This prevents projects -> project_members -> projects loop\nDROP POLICY IF EXISTS \\"creator_or_member_select_projects\\" ON public.projects","CREATE POLICY \\"creator_or_member_select_projects\\" ON public.projects\n  FOR SELECT USING (\n    organization_id = public.current_org_id()\n    AND (\n      owner_id = auth.uid()\n      OR public.is_project_member_or_owner(id, auth.uid())\n    )\n  )","-- 3. Cleanup conflicting policies on project_members from 20251230014000\n-- These were likely causing issues because they query 'projects' table directly\nDROP POLICY IF EXISTS \\"org_select_project_members\\" ON public.project_members","DROP POLICY IF EXISTS \\"org_insert_project_members\\" ON public.project_members","DROP POLICY IF EXISTS \\"org_update_project_members\\" ON public.project_members","DROP POLICY IF EXISTS \\"org_delete_project_members\\" ON public.project_members","-- 4. Ensure project_members policies are safe\n-- We already have \\"Managers and Admins can manage project members\\" (FOR ALL)\n-- and \\"employee_self_select_project_members\\" (FOR SELECT)\n\n-- Re-verify \\"Managers and Admins can manage project members\\" uses get_project_owner (SD)\n-- (It was updated in 20251231220000, but let's be sure we don't have others)\n\n-- 5. Additional Cleanup for other potentially recursive tables\n\n-- Project Meetings\n-- Uses get_project_owner (SD) in \\"Project managers and admins can manage meetings\\" (FOR ALL)\n-- \\"project_members_select_meetings\\" (FOR SELECT) queries project_members and projects.\n-- Let's update \\"project_members_select_meetings\\" to use SD function too.\n\nDROP POLICY IF EXISTS \\"project_members_select_meetings\\" ON public.project_meetings","CREATE POLICY \\"project_members_select_meetings\\" ON public.project_meetings\n  FOR SELECT USING (\n    public.is_project_member_or_owner(project_id, auth.uid())\n    OR \n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","-- Project Tasks\n-- \\"project_members_select_tasks\\" queries project_members/projects. Update to use SD.\nDROP POLICY IF EXISTS \\"project_members_select_tasks\\" ON public.project_tasks","CREATE POLICY \\"project_members_select_tasks\\" ON public.project_tasks\n  FOR SELECT USING (\n    public.is_project_member_or_owner(project_id, auth.uid())\n    OR \n    EXISTS (\n      SELECT 1 FROM public.user_roles ur\n      WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin'\n    )\n  )","-- 6. Grant execute permissions (just in case)\nGRANT EXECUTE ON FUNCTION public.is_project_member_or_owner(UUID, UUID) TO authenticated","GRANT EXECUTE ON FUNCTION public.get_project_owner(UUID) TO authenticated"}	break_recursion_hard
20251231223500	{"-- Helper functions and safe policies for project_members\nCREATE OR REPLACE FUNCTION public.is_project_manager(_project_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSECURITY DEFINER\nSTABLE\nAS $$\n  SELECT EXISTS (\n    SELECT 1\n    FROM public.project_members pm\n    JOIN public.employees e ON e.id = pm.employee_id\n    WHERE pm.project_id = _project_id\n      AND e.user_id = _user_id\n      AND lower(pm.role) = 'manager'\n  )\n$$","DROP POLICY IF EXISTS \\"Managers and Admins can manage project members\\" ON public.project_members","CREATE POLICY \\"manage_project_members\\" ON public.project_members\n  FOR ALL\n  USING (\n    public.get_project_owner(project_members.project_id) = auth.uid()\n    OR public.is_project_manager(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )\n  WITH CHECK (\n    public.get_project_owner(project_members.project_id) = auth.uid()\n    OR public.is_project_manager(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )","DROP POLICY IF EXISTS \\"employee_self_select_project_members\\" ON public.project_members","CREATE POLICY \\"select_project_members_visible\\" ON public.project_members\n  FOR SELECT\n  USING (\n    public.is_project_member_or_owner(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )","GRANT EXECUTE ON FUNCTION public.is_project_manager(UUID, UUID) TO authenticated"}	fix_project_members_policies
20251231224000	{"ALTER TABLE public.events ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id)","CREATE TABLE IF NOT EXISTS public.event_attendees (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,\n  user_id UUID NOT NULL REFERENCES auth.users(id),\n  organization_id UUID\n)","ALTER TABLE public.event_attendees ENABLE ROW LEVEL SECURITY","CREATE OR REPLACE FUNCTION public.is_event_creator(_event_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSECURITY DEFINER\nSTABLE\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.events e\n    WHERE e.id = _event_id AND e.created_by = _user_id\n  )\n$$","CREATE POLICY \\"org_select_event_attendees\\" ON public.event_attendees\n  FOR SELECT USING (organization_id = public.current_org_id())","CREATE POLICY \\"org_insert_event_attendees\\" ON public.event_attendees\n  FOR INSERT WITH CHECK (\n    organization_id = public.current_org_id()\n    AND (\n      public.is_event_creator(event_id, auth.uid())\n      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n    )\n  )","CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_event_attendees()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_set_org_on_insert_event_attendees ON public.event_attendees","CREATE TRIGGER trg_set_org_on_insert_event_attendees\n  BEFORE INSERT ON public.event_attendees\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_event_attendees()","GRANT EXECUTE ON FUNCTION public.is_event_creator(UUID, UUID) TO authenticated"}	events_attendees
20251231224500	{"-- Generic messages/comments table for entities (leads, deals, tasks, etc.)\nCREATE TABLE IF NOT EXISTS public.messages (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  entity_type TEXT NOT NULL,\n  entity_id UUID NOT NULL,\n  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,\n  content TEXT NOT NULL,\n  mentions UUID[] DEFAULT '{}',\n  organization_id UUID,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY","ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS organization_id UUID","DO $$\nBEGIN\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'messages' AND policyname = 'org_select_messages'\n  ) THEN\n    EXECUTE 'CREATE POLICY \\"org_select_messages\\" ON public.messages FOR SELECT USING (organization_id = public.current_org_id())';\n  END IF;\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies \n    WHERE schemaname = 'public' AND tablename = 'messages' AND policyname = 'org_insert_messages'\n  ) THEN\n    EXECUTE 'CREATE POLICY \\"org_insert_messages\\" ON public.messages FOR INSERT WITH CHECK (organization_id = public.current_org_id())';\n  END IF;\nEND $$","CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_messages()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_set_org_on_insert_messages ON public.messages","CREATE TRIGGER trg_set_org_on_insert_messages\n  BEFORE INSERT ON public.messages\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_messages()"}	add_messages_table
20251231224550	{"-- Ensure messages has organization_id and insert trigger\nALTER TABLE public.messages ADD COLUMN IF NOT EXISTS organization_id UUID","CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_messages()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_set_org_on_insert_messages ON public.messages","CREATE TRIGGER trg_set_org_on_insert_messages\n  BEFORE INSERT ON public.messages\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_messages()"}	fix_messages_org
20251231224600	{"-- Allow deleting event attendees for event creators and tenant admins\nDROP POLICY IF EXISTS \\"org_delete_event_attendees\\" ON public.event_attendees","CREATE POLICY \\"org_delete_event_attendees\\" ON public.event_attendees\n  FOR DELETE USING (\n    organization_id = public.current_org_id()\n    AND (\n      public.is_event_creator(event_id, auth.uid())\n      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n    )\n  )"}	event_attendees_delete_policy
20251231224700	{"-- Basic emails outbox for tracking bulk sends\nCREATE TABLE IF NOT EXISTS public.emails_outbox (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  template_id UUID REFERENCES public.email_templates(id) ON DELETE SET NULL,\n  recipient_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,\n  recipient_email TEXT,\n  status TEXT NOT NULL DEFAULT 'queued',\n  sent_at TIMESTAMPTZ,\n  organization_id UUID,\n  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","ALTER TABLE public.emails_outbox ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"org_select_emails_outbox\\" ON public.emails_outbox\n  FOR SELECT USING (organization_id = public.current_org_id())","CREATE POLICY \\"org_insert_emails_outbox\\" ON public.emails_outbox\n  FOR INSERT WITH CHECK (organization_id = public.current_org_id())","CREATE OR REPLACE FUNCTION public.set_org_id_on_insert_emails_outbox()\nRETURNS TRIGGER AS $$\nBEGIN\n  IF NEW.organization_id IS NULL THEN\n    NEW.organization_id = public.current_org_id();\n  END IF;\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","DROP TRIGGER IF EXISTS trg_set_org_on_insert_emails_outbox ON public.emails_outbox","CREATE TRIGGER trg_set_org_on_insert_emails_outbox\n  BEFORE INSERT ON public.emails_outbox\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_emails_outbox()"}	emails_outbox
20260101100000	{"-- Add status to organizations\nALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS status TEXT CHECK (status IN ('active', 'suspended')) DEFAULT 'active'","-- Enable RLS on organizations\nALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY","-- Helper for super admin check\nCREATE OR REPLACE FUNCTION public.is_super_admin()\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nAS $$\n  SELECT COALESCE(super_admin, false) FROM public.profiles WHERE id = auth.uid();\n$$","-- Policies for organizations\nDROP POLICY IF EXISTS \\"Super admin full access on organizations\\" ON public.organizations","CREATE POLICY \\"Super admin full access on organizations\\"\nON public.organizations\nFOR ALL\nUSING (public.is_super_admin())","DROP POLICY IF EXISTS \\"Users can view their own organization\\" ON public.organizations","CREATE POLICY \\"Users can view their own organization\\"\nON public.organizations\nFOR SELECT\nUSING (id = public.current_org_id())","-- Tenant Modules policies\nALTER TABLE public.tenant_modules ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Super admin full access on tenant_modules\\" ON public.tenant_modules","CREATE POLICY \\"Super admin full access on tenant_modules\\"\nON public.tenant_modules\nFOR ALL\nUSING (public.is_super_admin())","DROP POLICY IF EXISTS \\"Tenant admin can view tenant_modules\\" ON public.tenant_modules","CREATE POLICY \\"Tenant admin can view tenant_modules\\"\nON public.tenant_modules\nFOR SELECT\nUSING (organization_id = public.current_org_id())","-- Ensure Super Admin can view all profiles (to assign admins)\nDROP POLICY IF EXISTS \\"Super admin view all profiles\\" ON public.profiles","CREATE POLICY \\"Super admin view all profiles\\"\nON public.profiles\nFOR SELECT\nUSING (public.is_super_admin())","-- Ensure Super Admin can view/edit user_roles\nDROP POLICY IF EXISTS \\"Super admin manage user_roles\\" ON public.user_roles","CREATE POLICY \\"Super admin manage user_roles\\"\nON public.user_roles\nFOR ALL\nUSING (public.is_super_admin())"}	super_admin_setup
20260101110000	{"-- Fix RLS Recursion by using Security Definer functions for both sides of the relationship\n-- and ensuring strict search_path.\n\n-- 1. Redefine helper to get project owner safely\nCREATE OR REPLACE FUNCTION public.get_project_owner(p_id UUID)\nRETURNS UUID\nLANGUAGE sql\nSECURITY DEFINER\nSTABLE\nSET search_path = public, pg_temp\nAS $$\n  SELECT owner_id FROM public.projects WHERE id = p_id\n$$","-- 2. Redefine is_project_member_or_owner safely (breaking recursion)\nCREATE OR REPLACE FUNCTION public.is_project_member_or_owner(_project_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nSET search_path = public, pg_temp\nAS $$\nBEGIN\n  -- Direct check on project_members (bypassing RLS due to SD)\n  IF EXISTS (\n    SELECT 1 FROM public.project_members pm\n    JOIN public.employees e ON e.id = pm.employee_id\n    WHERE pm.project_id = _project_id AND e.user_id = _user_id\n  ) THEN\n    RETURN TRUE;\n  END IF;\n\n  -- Direct check on projects (bypassing RLS due to SD)\n  IF EXISTS (SELECT 1 FROM public.projects WHERE id = _project_id AND owner_id = _user_id) THEN\n    RETURN TRUE;\n  END IF;\n  \n  RETURN FALSE;\nEND;\n$$","-- 3. Redefine is_project_manager safely\nCREATE OR REPLACE FUNCTION public.is_project_manager(_project_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nSET search_path = public, pg_temp\nAS $$\nBEGIN\n  RETURN EXISTS (\n    SELECT 1\n    FROM public.project_members pm\n    JOIN public.employees e ON e.id = pm.employee_id\n    WHERE pm.project_id = _project_id\n      AND e.user_id = _user_id\n      AND lower(pm.role) = 'manager'\n  );\nEND;\n$$","-- 4. Re-apply policies using these safe functions\n\n-- Projects Policy\nDROP POLICY IF EXISTS \\"creator_or_member_select_projects\\" ON public.projects","CREATE POLICY \\"creator_or_member_select_projects\\" ON public.projects\n  FOR SELECT USING (\n    organization_id = public.current_org_id()\n    AND (\n      owner_id = auth.uid()\n      OR public.is_project_member_or_owner(id, auth.uid())\n      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n    )\n  )","-- Project Members Policy\nDROP POLICY IF EXISTS \\"select_project_members_visible\\" ON public.project_members","CREATE POLICY \\"select_project_members_visible\\" ON public.project_members\n  FOR SELECT\n  USING (\n    public.is_project_member_or_owner(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )","DROP POLICY IF EXISTS \\"manage_project_members\\" ON public.project_members","CREATE POLICY \\"manage_project_members\\" ON public.project_members\n  FOR ALL\n  USING (\n    public.get_project_owner(project_members.project_id) = auth.uid()\n    OR public.is_project_manager(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )\n  WITH CHECK (\n    public.get_project_owner(project_members.project_id) = auth.uid()\n    OR public.is_project_manager(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )","-- Grant execute to authenticated users\nGRANT EXECUTE ON FUNCTION public.get_project_owner(UUID) TO authenticated","GRANT EXECUTE ON FUNCTION public.is_project_member_or_owner(UUID, UUID) TO authenticated","GRANT EXECUTE ON FUNCTION public.is_project_manager(UUID, UUID) TO authenticated"}	fix_recursion_final
20260101113000	{"-- Fix RLS Recursion by using Security Definer functions for both sides of the relationship\n-- and ensuring strict search_path.\n\n-- 1. Redefine helper to get project owner safely\nCREATE OR REPLACE FUNCTION public.get_project_owner(p_id UUID)\nRETURNS UUID\nLANGUAGE sql\nSECURITY DEFINER\nSTABLE\nSET search_path = public, pg_temp\nAS $$\n  SELECT owner_id FROM public.projects WHERE id = p_id\n$$","-- 2. Redefine is_project_member_or_owner safely (breaking recursion)\nCREATE OR REPLACE FUNCTION public.is_project_member_or_owner(_project_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nSET search_path = public, pg_temp\nAS $$\nBEGIN\n  -- Direct check on project_members (bypassing RLS due to SD)\n  IF EXISTS (\n    SELECT 1 FROM public.project_members pm\n    JOIN public.employees e ON e.id = pm.employee_id\n    WHERE pm.project_id = _project_id AND e.user_id = _user_id\n  ) THEN\n    RETURN TRUE;\n  END IF;\n\n  -- Direct check on projects (bypassing RLS due to SD)\n  IF EXISTS (SELECT 1 FROM public.projects WHERE id = _project_id AND owner_id = _user_id) THEN\n    RETURN TRUE;\n  END IF;\n  \n  RETURN FALSE;\nEND;\n$$","-- 3. Redefine is_project_manager safely\nCREATE OR REPLACE FUNCTION public.is_project_manager(_project_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nSET search_path = public, pg_temp\nAS $$\nBEGIN\n  RETURN EXISTS (\n    SELECT 1\n    FROM public.project_members pm\n    JOIN public.employees e ON e.id = pm.employee_id\n    WHERE pm.project_id = _project_id\n      AND e.user_id = _user_id\n      AND lower(pm.role) = 'manager'\n  );\nEND;\n$$","-- 4. Re-apply policies using these safe functions\n\n-- Projects Policy\nDROP POLICY IF EXISTS \\"creator_or_member_select_projects\\" ON public.projects","CREATE POLICY \\"creator_or_member_select_projects\\" ON public.projects\n  FOR SELECT USING (\n    organization_id = public.current_org_id()\n    AND (\n      owner_id = auth.uid()\n      OR public.is_project_member_or_owner(id, auth.uid())\n      OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n    )\n  )","-- Project Members Policy\nDROP POLICY IF EXISTS \\"select_project_members_visible\\" ON public.project_members","CREATE POLICY \\"select_project_members_visible\\" ON public.project_members\n  FOR SELECT\n  USING (\n    public.is_project_member_or_owner(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )","DROP POLICY IF EXISTS \\"manage_project_members\\" ON public.project_members","CREATE POLICY \\"manage_project_members\\" ON public.project_members\n  FOR ALL\n  USING (\n    public.get_project_owner(project_members.project_id) = auth.uid()\n    OR public.is_project_manager(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )\n  WITH CHECK (\n    public.get_project_owner(project_members.project_id) = auth.uid()\n    OR public.is_project_manager(project_members.project_id, auth.uid())\n    OR EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'tenant_admin')\n  )","-- Grant execute to authenticated users\nGRANT EXECUTE ON FUNCTION public.get_project_owner(UUID) TO authenticated","GRANT EXECUTE ON FUNCTION public.is_project_member_or_owner(UUID, UUID) TO authenticated","GRANT EXECUTE ON FUNCTION public.is_project_manager(UUID, UUID) TO authenticated"}	fix_recursion_final
20260101120000	{"-- Add status to organizations\nALTER TABLE public.organizations ADD COLUMN IF NOT EXISTS status TEXT CHECK (status IN ('active', 'suspended')) DEFAULT 'active'","-- Enable RLS on tenant_modules if not already\nALTER TABLE public.tenant_modules ENABLE ROW LEVEL SECURITY","-- Super Admin Policies for tenant_modules\nDROP POLICY IF EXISTS \\"Super admin full access on tenant_modules\\" ON public.tenant_modules","CREATE POLICY \\"Super admin full access on tenant_modules\\"\nON public.tenant_modules\nFOR ALL\nUSING (public.is_super_admin())","DROP POLICY IF EXISTS \\"Users can view their own organization modules\\" ON public.tenant_modules","CREATE POLICY \\"Users can view their own organization modules\\"\nON public.tenant_modules\nFOR SELECT\nUSING (organization_id = public.current_org_id())","-- Super Admin Policies for profiles (to manage Tenant Admins)\n-- Note: Profiles usually has broad SELECT, but we need to ensure INSERT/UPDATE for Super Admin\nDROP POLICY IF EXISTS \\"Super admin full access on profiles\\" ON public.profiles","CREATE POLICY \\"Super admin full access on profiles\\"\nON public.profiles\nFOR ALL\nUSING (public.is_super_admin())","-- Ensure Organizations RLS allows Super Admin to update status\nDROP POLICY IF EXISTS \\"Super admin full access on organizations\\" ON public.organizations","CREATE POLICY \\"Super admin full access on organizations\\"\nON public.organizations\nFOR ALL\nUSING (public.is_super_admin())","-- Super Admin Policies for activity_logs\nDROP POLICY IF EXISTS \\"Super admin view all activity_logs\\" ON public.activity_logs","CREATE POLICY \\"Super admin view all activity_logs\\"\nON public.activity_logs\nFOR SELECT\nUSING (public.is_super_admin())"}	super_admin_enhancements
20260101140000	{"-- Create Invitations System\r\nCREATE TABLE IF NOT EXISTS public.invitations (\r\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  email TEXT NOT NULL,\r\n  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\r\n  role TEXT NOT NULL DEFAULT 'employee', -- 'tenant_admin', 'manager', 'employee'\r\n  token TEXT DEFAULT gen_random_uuid()::text,\r\n  status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'accepted'\r\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n  created_by UUID REFERENCES auth.users(id),\r\n  CONSTRAINT unique_active_invite UNIQUE (email, organization_id)\r\n)","-- RLS for Invitations\r\nALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY","-- Tenant Admins can view/create invites for their org\r\nCREATE POLICY \\"Tenant Admins can view invites\\" ON public.invitations\r\n  FOR SELECT USING (\r\n    organization_id = public.current_org_id() \r\n    AND EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'tenant_admin')\r\n  )","CREATE POLICY \\"Tenant Admins can create invites\\" ON public.invitations\r\n  FOR INSERT WITH CHECK (\r\n    organization_id = public.current_org_id()\r\n    AND EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'tenant_admin')\r\n  )","CREATE POLICY \\"Tenant Admins can delete invites\\" ON public.invitations\r\n  FOR DELETE USING (\r\n    organization_id = public.current_org_id()\r\n    AND EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'tenant_admin')\r\n  )","-- Super Admins can view/manage all invites\r\nCREATE POLICY \\"Super Admins can manage all invites\\" ON public.invitations\r\n  FOR ALL USING (public.is_super_admin())","-- Update handle_new_user to process invites\r\nCREATE OR REPLACE FUNCTION public.handle_new_user()\r\nRETURNS TRIGGER\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER SET search_path = public\r\nAS $$\r\nDECLARE\r\n  _org_id UUID;\r\n  _role TEXT;\r\n  _invite_id UUID;\r\nBEGIN\r\n  -- 1. Check for valid invitation by email\r\n  SELECT organization_id, role, id INTO _org_id, _role, _invite_id\r\n  FROM public.invitations\r\n  WHERE email = NEW.email AND status = 'pending'\r\n  ORDER BY created_at DESC\r\n  LIMIT 1;\r\n\r\n  -- 2. If no invite, try to assign to Default Organization (fallback)\r\n  IF _org_id IS NULL THEN\r\n    SELECT id INTO _org_id FROM public.organizations WHERE name = 'Default Organization' LIMIT 1;\r\n    _role := 'employee';\r\n    -- If no Default Org, pick the first one (fallback for local dev)\r\n    IF _org_id IS NULL THEN\r\n       SELECT id INTO _org_id FROM public.organizations ORDER BY created_at LIMIT 1;\r\n    END IF;\r\n  END IF;\r\n\r\n  -- 3. Insert Profile with Organization ID\r\n  INSERT INTO public.profiles (id, email, full_name, organization_id)\r\n  VALUES (\r\n    NEW.id, \r\n    NEW.email, \r\n    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.email),\r\n    _org_id\r\n  );\r\n  \r\n  -- 4. Insert User Role\r\n  INSERT INTO public.user_roles (user_id, role, organization_id)\r\n  VALUES (NEW.id, COALESCE(_role, 'employee'), _org_id);\r\n\r\n  -- 5. Mark invite as accepted if exists\r\n  IF _invite_id IS NOT NULL THEN\r\n    UPDATE public.invitations SET status = 'accepted' WHERE id = _invite_id;\r\n  END IF;\r\n  \r\n  RETURN NEW;\r\nEND;\r\n$$"}	invitation_system
20260101150000	{"-- Add organization_id to project related tables\n-- This ensures strict multi-tenancy compliance as per requirements\n\n-- 1. project_members\nALTER TABLE public.project_members ADD COLUMN IF NOT EXISTS organization_id UUID","-- Backfill from projects\nUPDATE public.project_members pm\nSET organization_id = p.organization_id\nFROM public.projects p\nWHERE pm.project_id = p.id\nAND pm.organization_id IS NULL","-- Make NOT NULL and Add FK\nALTER TABLE public.project_members \n  ALTER COLUMN organization_id SET NOT NULL,\n  ADD CONSTRAINT project_members_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE","-- 2. project_tasks\nALTER TABLE public.project_tasks ADD COLUMN IF NOT EXISTS organization_id UUID","-- Backfill from projects\nUPDATE public.project_tasks pt\nSET organization_id = p.organization_id\nFROM public.projects p\nWHERE pt.project_id = p.id\nAND pt.organization_id IS NULL","-- Make NOT NULL and Add FK\nALTER TABLE public.project_tasks \n  ALTER COLUMN organization_id SET NOT NULL,\n  ADD CONSTRAINT project_tasks_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE","-- 3. project_meetings\nALTER TABLE public.project_meetings ADD COLUMN IF NOT EXISTS organization_id UUID","-- Backfill from projects\nUPDATE public.project_meetings pm\nSET organization_id = p.organization_id\nFROM public.projects p\nWHERE pm.project_id = p.id\nAND pm.organization_id IS NULL","-- Make NOT NULL and Add FK\nALTER TABLE public.project_meetings \n  ALTER COLUMN organization_id SET NOT NULL,\n  ADD CONSTRAINT project_meetings_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE","-- 4. Update RLS Policies to use organization_id for better performance and security\n\n-- project_members\nDROP POLICY IF EXISTS \\"Users can view members of their projects\\" ON public.project_members","CREATE POLICY \\"Users can view members of their organization projects\\" ON public.project_members\n  FOR SELECT USING (organization_id = public.current_org_id())","-- project_tasks\nDROP POLICY IF EXISTS \\"Users can view tasks of their projects\\" ON public.project_tasks","CREATE POLICY \\"Users can view tasks of their organization projects\\" ON public.project_tasks\n  FOR SELECT USING (organization_id = public.current_org_id())","DROP POLICY IF EXISTS \\"Users can create tasks in their projects\\" ON public.project_tasks","CREATE POLICY \\"Users can create tasks in their organization projects\\" ON public.project_tasks\n  FOR INSERT WITH CHECK (organization_id = public.current_org_id())","DROP POLICY IF EXISTS \\"Users can update tasks in their projects\\" ON public.project_tasks","CREATE POLICY \\"Users can update tasks in their organization projects\\" ON public.project_tasks\n  FOR UPDATE USING (organization_id = public.current_org_id())","DROP POLICY IF EXISTS \\"Users can delete tasks in their projects\\" ON public.project_tasks","CREATE POLICY \\"Users can delete tasks in their organization projects\\" ON public.project_tasks\n  FOR DELETE USING (organization_id = public.current_org_id())","-- project_meetings\nDROP POLICY IF EXISTS \\"Users can view meetings of their projects\\" ON public.project_meetings","CREATE POLICY \\"Users can view meetings of their organization projects\\" ON public.project_meetings\n  FOR SELECT USING (organization_id = public.current_org_id())","-- Add triggers to auto-set organization_id on insert if missing\n-- (Reuse the existing generic trigger function if possible, or create specific ones if needed, \n-- but the generic one 'set_org_id_on_insert' relies on the column being present, which we just added)\n\nCREATE TRIGGER trg_set_org_on_insert_project_members\n  BEFORE INSERT ON public.project_members\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()","CREATE TRIGGER trg_set_org_on_insert_project_tasks\n  BEFORE INSERT ON public.project_tasks\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()","CREATE TRIGGER trg_set_org_on_insert_project_meetings\n  BEFORE INSERT ON public.project_meetings\n  FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert()"}	add_org_id_to_project_tables
20260101160000	{"-- Fix schema for Department Auto Chat\n-- Add missing columns required by the trigger in 20251231130000_department_auto_chat.sql\n\n-- 1. Add manager_id to departments\nALTER TABLE public.departments ADD COLUMN IF NOT EXISTS manager_id UUID REFERENCES auth.users(id)","-- 2. Add department_id to chat_channels\nALTER TABLE public.chat_channels ADD COLUMN IF NOT EXISTS department_id UUID REFERENCES public.departments(id) ON DELETE CASCADE","-- 3. Add index for performance\nCREATE INDEX IF NOT EXISTS idx_chat_channels_department_id ON public.chat_channels(department_id)","CREATE INDEX IF NOT EXISTS idx_departments_manager_id ON public.departments(manager_id)","-- 4. Re-apply the trigger function to ensure it works with the new columns (just in case it failed before)\n-- (The function body in 20251231130000_department_auto_chat.sql is correct, assuming columns exist.\n--  We don't need to redefine it if it's already there, but if the migration failed, it might not be there.\n--  Safest is to just reload the function def here to be sure, but I'll trust the previous migration applied the function text even if execution failed?\n--  Actually, if the previous migration failed, it wouldn't be applied. But usually migrations are transactional.\n--  If it succeeded but columns were missing... wait, PL/PGSQL functions are validated at runtime usually, but if columns are referenced in SQL statements inside, it might pass creation but fail execution.\n--  So the function probably exists. I'll leave it.)"}	fix_department_chat_schema
20260101161000	{"-- Ensure chat_type enum has all required values\nALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'project'","ALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'department'","ALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'group'","ALTER TYPE public.chat_type ADD VALUE IF NOT EXISTS 'direct'"}	ensure_chat_types
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 74, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 40077, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_employee_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_employee_id_date_key UNIQUE (employee_id, date);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: chat_channels chat_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_channels
    ADD CONSTRAINT chat_channels_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: chat_participants chat_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_participants
    ADD CONSTRAINT chat_participants_pkey PRIMARY KEY (channel_id, user_id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: deals deals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: email_templates email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_pkey PRIMARY KEY (id);


--
-- Name: emails_outbox emails_outbox_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails_outbox
    ADD CONSTRAINT emails_outbox_pkey PRIMARY KEY (id);


--
-- Name: employees employees_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_employee_id_key UNIQUE (employee_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: event_attendees event_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_attendees
    ADD CONSTRAINT event_attendees_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: payroll payroll_employee_id_month_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll
    ADD CONSTRAINT payroll_employee_id_month_year_key UNIQUE (employee_id, month, year);


--
-- Name: payroll payroll_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll
    ADD CONSTRAINT payroll_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: project_meetings project_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_meetings
    ADD CONSTRAINT project_meetings_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_project_id_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_project_id_employee_id_key UNIQUE (project_id, employee_id);


--
-- Name: project_tasks project_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_tasks
    ADD CONSTRAINT project_tasks_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: role_capabilities role_capabilities_organization_id_role_module_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_capabilities
    ADD CONSTRAINT role_capabilities_organization_id_role_module_key UNIQUE (organization_id, role, module);


--
-- Name: role_capabilities role_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_capabilities
    ADD CONSTRAINT role_capabilities_pkey PRIMARY KEY (id);


--
-- Name: settings settings_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_key_key UNIQUE (key);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: task_collaborators task_collaborators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_collaborators
    ADD CONSTRAINT task_collaborators_pkey PRIMARY KEY (id);


--
-- Name: task_collaborators task_collaborators_task_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_collaborators
    ADD CONSTRAINT task_collaborators_task_id_user_id_key UNIQUE (task_id, user_id);


--
-- Name: task_timings task_timings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_timings
    ADD CONSTRAINT task_timings_pkey PRIMARY KEY (task_id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: tenant_modules tenant_modules_organization_id_module_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_modules
    ADD CONSTRAINT tenant_modules_organization_id_module_key UNIQUE (organization_id, module);


--
-- Name: tenant_modules tenant_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_modules
    ADD CONSTRAINT tenant_modules_pkey PRIMARY KEY (id);


--
-- Name: invitations unique_active_invite; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT unique_active_invite UNIQUE (email, organization_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_12_29 messages_2025_12_29_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_12_29
    ADD CONSTRAINT messages_2025_12_29_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_12_30 messages_2025_12_30_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_12_30
    ADD CONSTRAINT messages_2025_12_30_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_12_31 messages_2025_12_31_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_12_31
    ADD CONSTRAINT messages_2025_12_31_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_01_01 messages_2026_01_01_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_01_01
    ADD CONSTRAINT messages_2026_01_01_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_01_02 messages_2026_01_02_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_01_02
    ADD CONSTRAINT messages_2026_01_02_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_01_03 messages_2026_01_03_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_01_03
    ADD CONSTRAINT messages_2026_01_03_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_01_04 messages_2026_01_04_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_01_04
    ADD CONSTRAINT messages_2026_01_04_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_activity_logs_module; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_module ON public.activity_logs USING btree (module);


--
-- Name: idx_activity_logs_record; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_logs_record ON public.activity_logs USING btree (record_id);


--
-- Name: idx_attendance_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_date ON public.attendance USING btree (date);


--
-- Name: idx_chat_channels_department_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_channels_department_id ON public.chat_channels USING btree (department_id);


--
-- Name: idx_chat_channels_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_channels_project ON public.chat_channels USING btree (project_id);


--
-- Name: idx_chat_messages_channel; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_channel ON public.chat_messages USING btree (channel_id, created_at);


--
-- Name: idx_chat_participants_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_participants_user ON public.chat_participants USING btree (user_id);


--
-- Name: idx_contacts_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contacts_name ON public.contacts USING btree (name);


--
-- Name: idx_deals_amount; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_amount ON public.deals USING btree (amount);


--
-- Name: idx_deals_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_assigned_to ON public.deals USING btree (assigned_to);


--
-- Name: idx_deals_stage; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_stage ON public.deals USING btree (stage);


--
-- Name: idx_departments_manager_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_departments_manager_id ON public.departments USING btree (manager_id);


--
-- Name: idx_employees_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employees_status ON public.employees USING btree (status);


--
-- Name: idx_events_meeting_link; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_meeting_link ON public.events USING btree (meeting_link);


--
-- Name: idx_events_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_time ON public.events USING btree (start_time, end_time);


--
-- Name: idx_events_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_type ON public.events USING btree (type);


--
-- Name: idx_leads_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leads_assigned_to ON public.leads USING btree (assigned_to);


--
-- Name: idx_leads_company_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leads_company_name ON public.leads USING btree (company_name);


--
-- Name: idx_leads_contact_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leads_contact_name ON public.leads USING btree (contact_name);


--
-- Name: idx_leads_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leads_email ON public.leads USING btree (email);


--
-- Name: idx_leads_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leads_name ON public.leads USING btree (name);


--
-- Name: idx_leads_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leads_status ON public.leads USING btree (status);


--
-- Name: idx_leave_requests_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_requests_status ON public.leave_requests USING btree (status);


--
-- Name: idx_messages_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_entity ON public.messages USING btree (entity_type, entity_id, created_at);


--
-- Name: idx_notifications_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_project ON public.notifications USING btree (project_id);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id, created_at, read);


--
-- Name: idx_payments_deal; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_deal ON public.payments USING btree (deal_id);


--
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- Name: idx_payroll_month_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payroll_month_year ON public.payroll USING btree (month, year);


--
-- Name: idx_project_members_employee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_project_members_employee ON public.project_members USING btree (employee_id);


--
-- Name: idx_project_members_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_project_members_project ON public.project_members USING btree (project_id);


--
-- Name: idx_projects_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_name ON public.projects USING btree (name);


--
-- Name: idx_settings_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_settings_key ON public.settings USING btree (key);


--
-- Name: idx_tasks_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_assigned_to ON public.tasks USING btree (assigned_to);


--
-- Name: idx_tasks_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_project_id ON public.tasks USING btree (project_id);


--
-- Name: idx_tasks_related; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_related ON public.tasks USING btree (related_type, related_id);


--
-- Name: idx_tasks_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_status ON public.tasks USING btree (status);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_12_29_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_12_29_inserted_at_topic_idx ON realtime.messages_2025_12_29 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_12_30_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_12_30_inserted_at_topic_idx ON realtime.messages_2025_12_30 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_12_31_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_12_31_inserted_at_topic_idx ON realtime.messages_2025_12_31 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_01_01_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_01_01_inserted_at_topic_idx ON realtime.messages_2026_01_01 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_01_02_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_01_02_inserted_at_topic_idx ON realtime.messages_2026_01_02 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_01_03_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_01_03_inserted_at_topic_idx ON realtime.messages_2026_01_03 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_01_04_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_01_04_inserted_at_topic_idx ON realtime.messages_2026_01_04 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: messages_2025_12_29_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_12_29_inserted_at_topic_idx;


--
-- Name: messages_2025_12_29_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_12_29_pkey;


--
-- Name: messages_2025_12_30_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_12_30_inserted_at_topic_idx;


--
-- Name: messages_2025_12_30_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_12_30_pkey;


--
-- Name: messages_2025_12_31_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_12_31_inserted_at_topic_idx;


--
-- Name: messages_2025_12_31_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_12_31_pkey;


--
-- Name: messages_2026_01_01_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_01_01_inserted_at_topic_idx;


--
-- Name: messages_2026_01_01_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_01_01_pkey;


--
-- Name: messages_2026_01_02_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_01_02_inserted_at_topic_idx;


--
-- Name: messages_2026_01_02_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_01_02_pkey;


--
-- Name: messages_2026_01_03_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_01_03_inserted_at_topic_idx;


--
-- Name: messages_2026_01_03_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_01_03_pkey;


--
-- Name: messages_2026_01_04_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_01_04_inserted_at_topic_idx;


--
-- Name: messages_2026_01_04_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_01_04_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: chat_channels trg_add_creator_to_participants; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_add_creator_to_participants AFTER INSERT ON public.chat_channels FOR EACH ROW EXECUTE FUNCTION public.add_creator_to_participants();


--
-- Name: departments trg_create_department_chat; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_create_department_chat AFTER INSERT ON public.departments FOR EACH ROW EXECUTE FUNCTION public.create_department_chat_channel();


--
-- Name: user_roles trg_enforce_single_tenant_admin; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_enforce_single_tenant_admin BEFORE INSERT OR UPDATE ON public.user_roles FOR EACH ROW EXECUTE FUNCTION public.enforce_single_tenant_admin();


--
-- Name: projects trg_handle_new_project_chat; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_handle_new_project_chat AFTER INSERT ON public.projects FOR EACH ROW EXECUTE FUNCTION public.handle_new_project_chat();


--
-- Name: project_members trg_handle_new_project_member; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_handle_new_project_member AFTER INSERT ON public.project_members FOR EACH ROW EXECUTE FUNCTION public.handle_new_project_member();


--
-- Name: employees trg_join_department_chat; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_join_department_chat AFTER INSERT OR UPDATE OF department_id ON public.employees FOR EACH ROW EXECUTE FUNCTION public.join_department_chat_channel();


--
-- Name: leads trg_lead_qualified; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_lead_qualified BEFORE UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.handle_lead_qualification();


--
-- Name: companies trg_log_companies; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_companies AFTER INSERT OR DELETE OR UPDATE ON public.companies FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();


--
-- Name: contacts trg_log_contacts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_contacts AFTER INSERT OR DELETE OR UPDATE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();


--
-- Name: deals trg_log_deals; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_deals AFTER INSERT OR DELETE OR UPDATE ON public.deals FOR EACH ROW EXECUTE FUNCTION public.log_activity();


--
-- Name: employees trg_log_employees; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_employees AFTER INSERT OR DELETE OR UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();


--
-- Name: leads trg_log_leads; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_leads AFTER INSERT OR DELETE OR UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.log_activity_fn();


--
-- Name: tasks trg_log_tasks; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_tasks AFTER INSERT OR DELETE OR UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.log_activity();


--
-- Name: chat_messages trg_notify_chat_participants; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_chat_participants AFTER INSERT ON public.chat_messages FOR EACH ROW EXECUTE FUNCTION public.notify_chat_participants();


--
-- Name: leave_requests trg_notify_leave; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_leave AFTER UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.notify_leave_status_change();


--
-- Name: leave_requests trg_notify_leave_decision; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_leave_decision AFTER UPDATE OF status ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.notify_leave_decision();


--
-- Name: payroll trg_notify_payroll_approval; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_notify_payroll_approval AFTER UPDATE OF approval_status ON public.payroll FOR EACH ROW EXECUTE FUNCTION public.notify_payroll_approval();


--
-- Name: activity_logs trg_retain_activity_logs_limit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_retain_activity_logs_limit AFTER INSERT ON public.activity_logs FOR EACH STATEMENT EXECUTE FUNCTION public.retain_activity_logs_limit();


--
-- Name: activity_logs trg_set_org_on_insert_activity_logs; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_activity_logs BEFORE INSERT ON public.activity_logs FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: attendance trg_set_org_on_insert_attendance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_attendance BEFORE INSERT ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: chat_channels trg_set_org_on_insert_chat_channels; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_chat_channels BEFORE INSERT ON public.chat_channels FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: chat_messages trg_set_org_on_insert_chat_messages; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_chat_messages BEFORE INSERT ON public.chat_messages FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: chat_participants trg_set_org_on_insert_chat_participants; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_chat_participants BEFORE INSERT ON public.chat_participants FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: companies trg_set_org_on_insert_companies; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_companies BEFORE INSERT ON public.companies FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: contacts trg_set_org_on_insert_contacts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_contacts BEFORE INSERT ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: deals trg_set_org_on_insert_deals; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_deals BEFORE INSERT ON public.deals FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: departments trg_set_org_on_insert_departments; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_departments BEFORE INSERT ON public.departments FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: designations trg_set_org_on_insert_designations; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_designations BEFORE INSERT ON public.designations FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: email_templates trg_set_org_on_insert_email_templates; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_email_templates BEFORE INSERT ON public.email_templates FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_email_templates();


--
-- Name: emails_outbox trg_set_org_on_insert_emails_outbox; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_emails_outbox BEFORE INSERT ON public.emails_outbox FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_emails_outbox();


--
-- Name: employees trg_set_org_on_insert_employees; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_employees BEFORE INSERT ON public.employees FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: event_attendees trg_set_org_on_insert_event_attendees; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_event_attendees BEFORE INSERT ON public.event_attendees FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_event_attendees();


--
-- Name: leads trg_set_org_on_insert_leads; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_leads BEFORE INSERT ON public.leads FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: leave_requests trg_set_org_on_insert_leave_requests; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_leave_requests BEFORE INSERT ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: messages trg_set_org_on_insert_messages; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_messages BEFORE INSERT ON public.messages FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert_messages();


--
-- Name: notifications trg_set_org_on_insert_notifications; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_notifications BEFORE INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: payroll trg_set_org_on_insert_payroll; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_payroll BEFORE INSERT ON public.payroll FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: profiles trg_set_org_on_insert_profiles; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_profiles BEFORE INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: project_meetings trg_set_org_on_insert_project_meetings; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_project_meetings BEFORE INSERT ON public.project_meetings FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: project_members trg_set_org_on_insert_project_members; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_project_members BEFORE INSERT ON public.project_members FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: project_tasks trg_set_org_on_insert_project_tasks; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_project_tasks BEFORE INSERT ON public.project_tasks FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: projects trg_set_org_on_insert_projects; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_projects BEFORE INSERT ON public.projects FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: tasks trg_set_org_on_insert_tasks; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_tasks BEFORE INSERT ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: user_roles trg_set_org_on_insert_user_roles; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_org_on_insert_user_roles BEFORE INSERT ON public.user_roles FOR EACH ROW EXECUTE FUNCTION public.set_org_id_on_insert();


--
-- Name: activity_logs trigger_cleanup_activity_logs; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_cleanup_activity_logs AFTER INSERT ON public.activity_logs FOR EACH ROW EXECUTE FUNCTION public.cleanup_activity_logs();


--
-- Name: attendance update_attendance_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_attendance_updated_at BEFORE UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: companies update_companies_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON public.companies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: contacts update_contacts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON public.contacts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: deals update_deals_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_deals_updated_at BEFORE UPDATE ON public.deals FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: departments update_departments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: designations update_designations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_designations_updated_at BEFORE UPDATE ON public.designations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employees update_employees_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leads update_leads_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_requests update_leave_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_leave_requests_updated_at BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: payroll update_payroll_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_payroll_updated_at BEFORE UPDATE ON public.payroll FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: profiles update_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tasks update_tasks_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: activity_logs activity_logs_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: activity_logs activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: attendance attendance_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: attendance attendance_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: chat_channels chat_channels_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_channels
    ADD CONSTRAINT chat_channels_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: chat_channels chat_channels_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_channels
    ADD CONSTRAINT chat_channels_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: chat_channels chat_channels_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_channels
    ADD CONSTRAINT chat_channels_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: chat_channels chat_channels_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_channels
    ADD CONSTRAINT chat_channels_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: chat_messages chat_messages_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.chat_channels(id) ON DELETE CASCADE;


--
-- Name: chat_messages chat_messages_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: chat_messages chat_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: chat_participants chat_participants_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_participants
    ADD CONSTRAINT chat_participants_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.chat_channels(id) ON DELETE CASCADE;


--
-- Name: chat_participants chat_participants_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_participants
    ADD CONSTRAINT chat_participants_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: chat_participants chat_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_participants
    ADD CONSTRAINT chat_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: companies companies_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: companies companies_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: contacts contacts_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;


--
-- Name: contacts contacts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: contacts contacts_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: deals deals_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES auth.users(id);


--
-- Name: deals deals_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;


--
-- Name: deals deals_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id) ON DELETE SET NULL;


--
-- Name: deals deals_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: deals deals_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.leads(id) ON DELETE SET NULL;


--
-- Name: deals deals_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: departments departments_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES auth.users(id);


--
-- Name: departments departments_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: designations designations_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: designations designations_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: email_templates email_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id);


--
-- Name: email_templates email_templates_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: emails_outbox emails_outbox_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails_outbox
    ADD CONSTRAINT emails_outbox_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: emails_outbox emails_outbox_recipient_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails_outbox
    ADD CONSTRAINT emails_outbox_recipient_user_id_fkey FOREIGN KEY (recipient_user_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: emails_outbox emails_outbox_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails_outbox
    ADD CONSTRAINT emails_outbox_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.email_templates(id) ON DELETE SET NULL;


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: employees employees_designation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES public.designations(id) ON DELETE SET NULL;


--
-- Name: employees employees_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: employees employees_user_id_fkey_profiles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey_profiles FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: event_attendees event_attendees_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_attendees
    ADD CONSTRAINT event_attendees_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_attendees event_attendees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_attendees
    ADD CONSTRAINT event_attendees_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: events events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: invitations invitations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: invitations invitations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: leads leads_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES auth.users(id);


--
-- Name: leads leads_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;


--
-- Name: leads leads_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id) ON DELETE SET NULL;


--
-- Name: leads leads_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: leads leads_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES auth.users(id);


--
-- Name: leave_requests leave_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: messages messages_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: notifications notifications_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.events(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: notifications notifications_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: payments payments_deal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_deal_id_fkey FOREIGN KEY (deal_id) REFERENCES public.deals(id) ON DELETE SET NULL;


--
-- Name: payroll payroll_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll
    ADD CONSTRAINT payroll_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: payroll payroll_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll
    ADD CONSTRAINT payroll_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: payroll payroll_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll
    ADD CONSTRAINT payroll_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE RESTRICT;


--
-- Name: project_meetings project_meetings_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_meetings
    ADD CONSTRAINT project_meetings_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: project_meetings project_meetings_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_meetings
    ADD CONSTRAINT project_meetings_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: project_meetings project_meetings_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_meetings
    ADD CONSTRAINT project_meetings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_members project_members_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: project_members project_members_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: project_members project_members_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_tasks project_tasks_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_tasks
    ADD CONSTRAINT project_tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES auth.users(id);


--
-- Name: project_tasks project_tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_tasks
    ADD CONSTRAINT project_tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: project_tasks project_tasks_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_tasks
    ADD CONSTRAINT project_tasks_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: project_tasks project_tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_tasks
    ADD CONSTRAINT project_tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: projects projects_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: projects projects_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: role_capabilities role_capabilities_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_capabilities
    ADD CONSTRAINT role_capabilities_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: task_collaborators task_collaborators_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_collaborators
    ADD CONSTRAINT task_collaborators_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_collaborators task_collaborators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_collaborators
    ADD CONSTRAINT task_collaborators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: task_timings task_timings_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_timings
    ADD CONSTRAINT task_timings_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES auth.users(id);


--
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: tasks tasks_deal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_deal_id_fkey FOREIGN KEY (deal_id) REFERENCES public.deals(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tasks tasks_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.leads(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tasks tasks_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_owner_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_owner_id_fk FOREIGN KEY (owner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tenant_modules tenant_modules_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_modules
    ADD CONSTRAINT tenant_modules_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_org_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_org_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: email_templates Admins and Managers can manage templates; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins and Managers can manage templates" ON public.email_templates USING (((organization_id = public.current_org_id()) AND (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = ANY (ARRAY['tenant_admin'::public.app_role, 'manager'::public.app_role, 'hr'::public.app_role])))))));


--
-- Name: companies Admins can delete companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can delete companies" ON public.companies FOR DELETE USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: contacts Admins can delete contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can delete contacts" ON public.contacts FOR DELETE USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: deals Admins can delete deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can delete deals" ON public.deals FOR DELETE USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: user_roles Admins can manage all roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage all roles" ON public.user_roles USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- Name: departments Admins can manage departments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage departments" ON public.departments USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: designations Admins can manage designations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage designations" ON public.designations USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: employees Admins can manage employees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage employees" ON public.employees USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: profiles Admins can view all profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all profiles" ON public.profiles FOR SELECT USING (public.is_admin_or_manager(auth.uid()));


--
-- Name: deals Assigned users can update deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Assigned users can update deals" ON public.deals FOR UPDATE USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by) OR public.is_admin_or_manager(auth.uid())));


--
-- Name: tasks Assigned users can update tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Assigned users can update tasks" ON public.tasks FOR UPDATE USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by) OR public.is_admin_or_manager(auth.uid())));


--
-- Name: companies Authenticated users can create companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can create companies" ON public.companies FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));


--
-- Name: contacts Authenticated users can create contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can create contacts" ON public.contacts FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));


--
-- Name: deals Authenticated users can create deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can create deals" ON public.deals FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));


--
-- Name: tasks Authenticated users can create tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can create tasks" ON public.tasks FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));


--
-- Name: activity_logs Authenticated users can view all logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view all logs" ON public.activity_logs FOR SELECT TO authenticated USING (true);


--
-- Name: profiles Authenticated users can view all profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view all profiles" ON public.profiles FOR SELECT TO authenticated USING (true);


--
-- Name: companies Authenticated users can view companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view companies" ON public.companies FOR SELECT TO authenticated USING (true);


--
-- Name: contacts Authenticated users can view contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view contacts" ON public.contacts FOR SELECT TO authenticated USING (true);


--
-- Name: departments Authenticated users can view departments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view departments" ON public.departments FOR SELECT TO authenticated USING (true);


--
-- Name: designations Authenticated users can view designations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view designations" ON public.designations FOR SELECT TO authenticated USING (true);


--
-- Name: tasks Authenticated users can view tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view tasks" ON public.tasks FOR SELECT TO authenticated USING (true);


--
-- Name: tasks Creators can delete tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Creators can delete tasks" ON public.tasks FOR DELETE USING (((auth.uid() = created_by) OR public.is_admin_or_manager(auth.uid())));


--
-- Name: leave_requests Employees can create leave requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Employees can create leave requests" ON public.leave_requests FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.id = leave_requests.employee_id) AND (employees.user_id = auth.uid())))));


--
-- Name: leave_requests Employees can delete their pending requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Employees can delete their pending requests" ON public.leave_requests FOR DELETE USING (((EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.id = leave_requests.employee_id) AND (employees.user_id = auth.uid())))) AND (status = 'pending'::public.leave_status)));


--
-- Name: leave_requests Employees can view their own leave requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Employees can view their own leave requests" ON public.leave_requests FOR SELECT USING (((EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.id = leave_requests.employee_id) AND (employees.user_id = auth.uid())))) OR public.is_admin_or_manager(auth.uid())));


--
-- Name: chat_participants Participants can add others; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Participants can add others" ON public.chat_participants FOR INSERT WITH CHECK ((public.is_chat_participant(channel_id) OR public.is_channel_creator(channel_id)));


--
-- Name: project_meetings Project managers and admins can manage meetings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Project managers and admins can manage meetings" ON public.project_meetings USING (((public.get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_meetings.project_id) AND (e.user_id = auth.uid()) AND (lower(pm.role) = 'manager'::text)))) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks Project members can create tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Project members can create tasks" ON public.project_tasks FOR INSERT WITH CHECK (((public.get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks Project members can create/update tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Project members can create/update tasks" ON public.project_tasks USING (((EXISTS ( SELECT 1
   FROM public.project_members pm
  WHERE ((pm.project_id = project_tasks.project_id) AND (pm.employee_id IN ( SELECT employees.id
           FROM public.employees
          WHERE (employees.user_id = auth.uid())))))) OR (EXISTS ( SELECT 1
   FROM public.projects p
  WHERE ((p.id = project_tasks.project_id) AND (p.owner_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks Project members can delete tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Project members can delete tasks" ON public.project_tasks FOR DELETE USING (((public.get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid()) AND (lower(pm.role) = 'manager'::text)))) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks Project members can update tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Project members can update tasks" ON public.project_tasks FOR UPDATE USING (((public.get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks Project members can view tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Project members can view tasks" ON public.project_tasks FOR SELECT USING (((public.get_project_owner(project_id) = auth.uid()) OR (EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: invitations Super Admins can manage all invites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super Admins can manage all invites" ON public.invitations USING (public.is_super_admin());


--
-- Name: organizations Super admin full access on organizations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super admin full access on organizations" ON public.organizations USING (public.is_super_admin());


--
-- Name: profiles Super admin full access on profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super admin full access on profiles" ON public.profiles USING (public.is_super_admin());


--
-- Name: tenant_modules Super admin full access on tenant_modules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super admin full access on tenant_modules" ON public.tenant_modules USING (public.is_super_admin());


--
-- Name: user_roles Super admin manage user_roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super admin manage user_roles" ON public.user_roles USING (public.is_super_admin());


--
-- Name: activity_logs Super admin view all activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super admin view all activity_logs" ON public.activity_logs FOR SELECT USING (public.is_super_admin());


--
-- Name: profiles Super admin view all profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Super admin view all profiles" ON public.profiles FOR SELECT USING (public.is_super_admin());


--
-- Name: activity_logs System can create logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "System can create logs" ON public.activity_logs FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: invitations Tenant Admins can create invites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tenant Admins can create invites" ON public.invitations FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND (EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'tenant_admin'::public.app_role))))));


--
-- Name: invitations Tenant Admins can delete invites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tenant Admins can delete invites" ON public.invitations FOR DELETE USING (((organization_id = public.current_org_id()) AND (EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'tenant_admin'::public.app_role))))));


--
-- Name: invitations Tenant Admins can view invites; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tenant Admins can view invites" ON public.invitations FOR SELECT USING (((organization_id = public.current_org_id()) AND (EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'tenant_admin'::public.app_role))))));


--
-- Name: tenant_modules Tenant admin can view tenant_modules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Tenant admin can view tenant_modules" ON public.tenant_modules FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: chat_channels Users can create channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can create channels" ON public.chat_channels FOR INSERT WITH CHECK ((auth.uid() = created_by));


--
-- Name: project_tasks Users can create tasks in their organization projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can create tasks in their organization projects" ON public.project_tasks FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: project_tasks Users can delete tasks in their organization projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete tasks in their organization projects" ON public.project_tasks FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: chat_messages Users can send messages to their channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can send messages to their channels" ON public.chat_messages FOR INSERT WITH CHECK ((public.is_chat_participant(channel_id) AND (sender_id = auth.uid())));


--
-- Name: project_tasks Users can update tasks in their organization projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update tasks in their organization projects" ON public.project_tasks FOR UPDATE USING ((organization_id = public.current_org_id()));


--
-- Name: companies Users can update their own companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own companies" ON public.companies FOR UPDATE USING (((auth.uid() = created_by) OR public.is_admin_or_manager(auth.uid())));


--
-- Name: contacts Users can update their own contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own contacts" ON public.contacts FOR UPDATE USING (((auth.uid() = created_by) OR public.is_admin_or_manager(auth.uid())));


--
-- Name: profiles Users can update their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- Name: chat_channels Users can view channels they are in or created; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view channels they are in or created" ON public.chat_channels FOR SELECT USING ((public.is_chat_participant(id) OR (created_by = auth.uid())));


--
-- Name: project_meetings Users can view meetings of their organization projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view meetings of their organization projects" ON public.project_meetings FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: project_members Users can view members of their organization projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view members of their organization projects" ON public.project_members FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: chat_messages Users can view messages in their channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view messages in their channels" ON public.chat_messages FOR SELECT USING (public.is_chat_participant(channel_id));


--
-- Name: chat_participants Users can view participants of their channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view participants of their channels" ON public.chat_participants FOR SELECT USING (public.is_chat_participant(channel_id));


--
-- Name: project_tasks Users can view tasks of their organization projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view tasks of their organization projects" ON public.project_tasks FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: email_templates Users can view their org's templates; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their org's templates" ON public.email_templates FOR SELECT USING ((organization_id = ( SELECT profiles.organization_id
   FROM public.profiles
  WHERE (profiles.id = auth.uid()))));


--
-- Name: organizations Users can view their own organization; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own organization" ON public.organizations FOR SELECT USING ((id = public.current_org_id()));


--
-- Name: tenant_modules Users can view their own organization modules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own organization modules" ON public.tenant_modules FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: user_roles Users can view their own roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own roles" ON public.user_roles FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: payroll admin_delete_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_delete_payroll ON public.payroll FOR DELETE USING (public.is_tenant_admin(auth.uid()));


--
-- Name: deals admin_manager_view_all_deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_manager_view_all_deals ON public.deals FOR SELECT USING ((public.is_tenant_admin(auth.uid()) OR public.is_manager(auth.uid())));


--
-- Name: projects admin_or_manager_insert_projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_or_manager_insert_projects ON public.projects FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.organization_id = public.current_org_id()) AND (ur.role = ANY (ARRAY['tenant_admin'::public.app_role, 'manager'::public.app_role])))))));


--
-- Name: leads authenticated_create_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY authenticated_create_leads ON public.leads FOR INSERT WITH CHECK ((auth.uid() = created_by));


--
-- Name: projects creator_or_member_select_projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY creator_or_member_select_projects ON public.projects FOR SELECT USING (((organization_id = public.current_org_id()) AND ((owner_id = auth.uid()) OR public.is_project_member_or_owner(id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role)))))));


--
-- Name: deals employee_view_assigned_deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY employee_view_assigned_deals ON public.deals FOR SELECT USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by)));


--
-- Name: attendance employee_view_own_attendance; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY employee_view_own_attendance ON public.attendance FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.employees e
  WHERE ((e.id = attendance.employee_id) AND (e.user_id = auth.uid())))));


--
-- Name: payroll employee_view_own_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY employee_view_own_payroll ON public.payroll FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.employees e
  WHERE ((e.id = payroll.employee_id) AND (e.user_id = auth.uid())))));


--
-- Name: attendance hr_admin_manage_attendance; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hr_admin_manage_attendance ON public.attendance USING ((public.is_tenant_admin(auth.uid()) OR public.is_hr(auth.uid())));


--
-- Name: leave_requests hr_admin_manage_leave; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hr_admin_manage_leave ON public.leave_requests FOR UPDATE USING ((public.is_tenant_admin(auth.uid()) OR (public.is_hr(auth.uid()) AND (NOT (EXISTS ( SELECT 1
   FROM (public.employees e
     JOIN public.user_roles ur ON ((ur.user_id = e.user_id)))
  WHERE ((e.id = leave_requests.employee_id) AND (ur.role = ANY (ARRAY['hr'::public.app_role, 'tenant_admin'::public.app_role, 'super_admin'::public.app_role])))))))));


--
-- Name: employees hr_admin_view_all_employees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hr_admin_view_all_employees ON public.employees FOR SELECT USING ((public.is_tenant_admin(auth.uid()) OR public.is_hr(auth.uid())));


--
-- Name: payroll hr_admin_view_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hr_admin_view_payroll ON public.payroll FOR SELECT USING ((public.is_hr(auth.uid()) OR public.is_tenant_admin(auth.uid())));


--
-- Name: payroll hr_create_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hr_create_payroll ON public.payroll FOR INSERT WITH CHECK ((public.is_hr(auth.uid()) OR public.is_tenant_admin(auth.uid())));


--
-- Name: payroll hr_update_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY hr_update_payroll ON public.payroll FOR UPDATE USING (((public.is_hr(auth.uid()) AND (status = 'pending'::public.payroll_status)) OR public.is_tenant_admin(auth.uid()))) WITH CHECK (((public.is_hr(auth.uid()) AND (status = 'pending'::public.payroll_status)) OR public.is_tenant_admin(auth.uid())));


--
-- Name: invitations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

--
-- Name: project_members manage_project_members; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY manage_project_members ON public.project_members USING (((public.get_project_owner(project_id) = auth.uid()) OR public.is_project_manager(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role)))))) WITH CHECK (((public.get_project_owner(project_id) = auth.uid()) OR public.is_project_manager(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: activity_logs org_delete_activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_activity_logs ON public.activity_logs FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: attendance org_delete_attendance; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_attendance ON public.attendance FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: chat_channels org_delete_chat_channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_chat_channels ON public.chat_channels FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: chat_messages org_delete_chat_messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_chat_messages ON public.chat_messages FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: chat_participants org_delete_chat_participants; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_chat_participants ON public.chat_participants FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: companies org_delete_companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_companies ON public.companies FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: contacts org_delete_contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_contacts ON public.contacts FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: deals org_delete_deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_deals ON public.deals FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: departments org_delete_departments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_departments ON public.departments FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: designations org_delete_designations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_designations ON public.designations FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: employees org_delete_employees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_employees ON public.employees FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: event_attendees org_delete_event_attendees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_event_attendees ON public.event_attendees FOR DELETE USING (((organization_id = public.current_org_id()) AND (public.is_event_creator(event_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role)))))));


--
-- Name: leads org_delete_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_leads ON public.leads FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: leave_requests org_delete_leave_requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_leave_requests ON public.leave_requests FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: payroll org_delete_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_payroll ON public.payroll FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: projects org_delete_projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_projects ON public.projects FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: tasks org_delete_tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_delete_tasks ON public.tasks FOR DELETE USING ((organization_id = public.current_org_id()));


--
-- Name: activity_logs org_insert_activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_activity_logs ON public.activity_logs FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: attendance org_insert_attendance; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_attendance ON public.attendance FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: chat_channels org_insert_chat_channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_chat_channels ON public.chat_channels FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: chat_messages org_insert_chat_messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_chat_messages ON public.chat_messages FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: chat_participants org_insert_chat_participants; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_chat_participants ON public.chat_participants FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: companies org_insert_companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_companies ON public.companies FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: contacts org_insert_contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_contacts ON public.contacts FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: deals org_insert_deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_deals ON public.deals FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'deals'::text, 'can_create'::text)));


--
-- Name: departments org_insert_departments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_departments ON public.departments FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: designations org_insert_designations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_designations ON public.designations FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: emails_outbox org_insert_emails_outbox; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_emails_outbox ON public.emails_outbox FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: employees org_insert_employees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_employees ON public.employees FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: event_attendees org_insert_event_attendees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_event_attendees ON public.event_attendees FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND (public.is_event_creator(event_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role)))))));


--
-- Name: leads org_insert_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_leads ON public.leads FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'leads'::text, 'can_create'::text)));


--
-- Name: leave_requests org_insert_leave_requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_leave_requests ON public.leave_requests FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'leave_requests'::text, 'can_create'::text)));


--
-- Name: messages org_insert_messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_messages ON public.messages FOR INSERT WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: payroll org_insert_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_payroll ON public.payroll FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'payroll'::text, 'can_create'::text)));


--
-- Name: tasks org_insert_tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_insert_tasks ON public.tasks FOR INSERT WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'tasks'::text, 'can_create'::text)));


--
-- Name: activity_logs org_select_activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_activity_logs ON public.activity_logs FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: attendance org_select_attendance; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_attendance ON public.attendance FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: chat_channels org_select_chat_channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_chat_channels ON public.chat_channels FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: chat_messages org_select_chat_messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_chat_messages ON public.chat_messages FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: chat_participants org_select_chat_participants; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_chat_participants ON public.chat_participants FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: companies org_select_companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_companies ON public.companies FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: contacts org_select_contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_contacts ON public.contacts FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: deals org_select_deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_deals ON public.deals FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: departments org_select_departments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_departments ON public.departments FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: designations org_select_designations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_designations ON public.designations FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: emails_outbox org_select_emails_outbox; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_emails_outbox ON public.emails_outbox FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: employees org_select_employees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_employees ON public.employees FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: event_attendees org_select_event_attendees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_event_attendees ON public.event_attendees FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: leads org_select_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_leads ON public.leads FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: leave_requests org_select_leave_requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_leave_requests ON public.leave_requests FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: messages org_select_messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_messages ON public.messages FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: payroll org_select_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_payroll ON public.payroll FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: tasks org_select_tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_select_tasks ON public.tasks FOR SELECT USING ((organization_id = public.current_org_id()));


--
-- Name: activity_logs org_update_activity_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_activity_logs ON public.activity_logs FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: attendance org_update_attendance; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_attendance ON public.attendance FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: chat_channels org_update_chat_channels; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_chat_channels ON public.chat_channels FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: chat_messages org_update_chat_messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_chat_messages ON public.chat_messages FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: chat_participants org_update_chat_participants; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_chat_participants ON public.chat_participants FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: companies org_update_companies; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_companies ON public.companies FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: contacts org_update_contacts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_contacts ON public.contacts FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: deals org_update_deals; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_deals ON public.deals FOR UPDATE USING (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'deals'::text, 'can_edit'::text))) WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'deals'::text, 'can_edit'::text)));


--
-- Name: departments org_update_departments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_departments ON public.departments FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: designations org_update_designations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_designations ON public.designations FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: employees org_update_employees; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_employees ON public.employees FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: leads org_update_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_leads ON public.leads FOR UPDATE USING (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'leads'::text, 'can_edit'::text))) WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'leads'::text, 'can_edit'::text)));


--
-- Name: leave_requests org_update_leave_requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_leave_requests ON public.leave_requests FOR UPDATE USING (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'leave_requests'::text, 'can_approve'::text))) WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'leave_requests'::text, 'can_approve'::text)));


--
-- Name: payroll org_update_payroll; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_payroll ON public.payroll FOR UPDATE USING (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'payroll'::text, 'can_edit'::text))) WITH CHECK (((organization_id = public.current_org_id()) AND public.can_capability(auth.uid(), 'payroll'::text, 'can_edit'::text)));


--
-- Name: projects org_update_projects; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_projects ON public.projects FOR UPDATE USING ((organization_id = public.current_org_id())) WITH CHECK ((organization_id = public.current_org_id()));


--
-- Name: tasks org_update_tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY org_update_tasks ON public.tasks FOR UPDATE USING (((organization_id = public.current_org_id()) AND (public.can_capability(auth.uid(), 'tasks'::text, 'can_edit'::text) OR (assigned_to = auth.uid()) OR (created_by = auth.uid())))) WITH CHECK (((organization_id = public.current_org_id()) AND (public.can_capability(auth.uid(), 'tasks'::text, 'can_edit'::text) OR (assigned_to = auth.uid()) OR (created_by = auth.uid()))));


--
-- Name: organizations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications own_delete_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY own_delete_notifications ON public.notifications FOR DELETE USING (((user_id = auth.uid()) AND (organization_id = public.current_org_id())));


--
-- Name: notifications own_insert_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY own_insert_notifications ON public.notifications FOR INSERT WITH CHECK (((user_id = auth.uid()) AND (organization_id = public.current_org_id())));


--
-- Name: notifications own_select_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY own_select_notifications ON public.notifications FOR SELECT USING (((user_id = auth.uid()) AND (organization_id = public.current_org_id())));


--
-- Name: notifications own_update_notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY own_update_notifications ON public.notifications FOR UPDATE USING (((user_id = auth.uid()) AND (organization_id = public.current_org_id()))) WITH CHECK (((user_id = auth.uid()) AND (organization_id = public.current_org_id())));


--
-- Name: project_meetings project_manager_insert_meetings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY project_manager_insert_meetings ON public.project_meetings FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_meetings.project_id) AND (e.user_id = auth.uid()) AND (lower(pm.role) = 'manager'::text)))));


--
-- Name: project_tasks project_members_modify_tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY project_members_modify_tasks ON public.project_tasks USING (((EXISTS ( SELECT 1
   FROM (public.project_members pm
     JOIN public.employees e ON ((e.id = pm.employee_id)))
  WHERE ((pm.project_id = project_tasks.project_id) AND (e.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.projects p
  WHERE ((p.id = project_tasks.project_id) AND (p.owner_id = auth.uid()))))));


--
-- Name: project_meetings project_members_select_meetings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY project_members_select_meetings ON public.project_meetings FOR SELECT USING ((public.is_project_member_or_owner(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks project_members_select_tasks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY project_members_select_tasks ON public.project_tasks FOR SELECT USING ((public.is_project_member_or_owner(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: project_tasks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: projects; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

--
-- Name: project_members select_project_members_visible; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY select_project_members_visible ON public.project_members FOR SELECT USING ((public.is_project_member_or_owner(project_id, auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.user_roles ur
  WHERE ((ur.user_id = auth.uid()) AND (ur.role = 'tenant_admin'::public.app_role))))));


--
-- Name: leads tenant_admin_delete_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_admin_delete_leads ON public.leads FOR DELETE USING (public.is_tenant_admin(auth.uid()));


--
-- Name: leads tenant_admin_view_all_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_admin_view_all_leads ON public.leads FOR SELECT USING (public.is_tenant_admin(auth.uid()));


--
-- Name: tenant_modules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tenant_modules ENABLE ROW LEVEL SECURITY;

--
-- Name: employees user_view_own_employee_record; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY user_view_own_employee_record ON public.employees FOR SELECT USING ((user_id = auth.uid()));


--
-- Name: leads users_update_own_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_update_own_leads ON public.leads FOR UPDATE USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by) OR public.is_tenant_admin(auth.uid()) OR public.is_manager(auth.uid())));


--
-- Name: leads users_view_own_leads; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY users_view_own_leads ON public.leads FOR SELECT USING (((auth.uid() = assigned_to) OR (auth.uid() = created_by)));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime chat_channels; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.chat_channels;


--
-- Name: supabase_realtime chat_messages; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.chat_messages;


--
-- Name: supabase_realtime chat_participants; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.chat_participants;


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION add_creator_to_participants(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_creator_to_participants() TO anon;
GRANT ALL ON FUNCTION public.add_creator_to_participants() TO authenticated;
GRANT ALL ON FUNCTION public.add_creator_to_participants() TO service_role;


--
-- Name: FUNCTION can_capability(_user_id uuid, _module text, _cap text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.can_capability(_user_id uuid, _module text, _cap text) TO anon;
GRANT ALL ON FUNCTION public.can_capability(_user_id uuid, _module text, _cap text) TO authenticated;
GRANT ALL ON FUNCTION public.can_capability(_user_id uuid, _module text, _cap text) TO service_role;


--
-- Name: FUNCTION cleanup_activity_logs(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cleanup_activity_logs() TO anon;
GRANT ALL ON FUNCTION public.cleanup_activity_logs() TO authenticated;
GRANT ALL ON FUNCTION public.cleanup_activity_logs() TO service_role;


--
-- Name: FUNCTION clone_payroll_month(source_month integer, source_year integer, target_month integer, target_year integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.clone_payroll_month(source_month integer, source_year integer, target_month integer, target_year integer) TO anon;
GRANT ALL ON FUNCTION public.clone_payroll_month(source_month integer, source_year integer, target_month integer, target_year integer) TO authenticated;
GRANT ALL ON FUNCTION public.clone_payroll_month(source_month integer, source_year integer, target_month integer, target_year integer) TO service_role;


--
-- Name: FUNCTION create_department_chat_channel(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_department_chat_channel() TO anon;
GRANT ALL ON FUNCTION public.create_department_chat_channel() TO authenticated;
GRANT ALL ON FUNCTION public.create_department_chat_channel() TO service_role;


--
-- Name: FUNCTION current_org_id(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.current_org_id() TO anon;
GRANT ALL ON FUNCTION public.current_org_id() TO authenticated;
GRANT ALL ON FUNCTION public.current_org_id() TO service_role;


--
-- Name: FUNCTION enforce_single_tenant_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.enforce_single_tenant_admin() TO anon;
GRANT ALL ON FUNCTION public.enforce_single_tenant_admin() TO authenticated;
GRANT ALL ON FUNCTION public.enforce_single_tenant_admin() TO service_role;


--
-- Name: FUNCTION get_project_owner(p_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_project_owner(p_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_project_owner(p_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_project_owner(p_id uuid) TO service_role;


--
-- Name: FUNCTION handle_lead_qualification(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_lead_qualification() TO anon;
GRANT ALL ON FUNCTION public.handle_lead_qualification() TO authenticated;
GRANT ALL ON FUNCTION public.handle_lead_qualification() TO service_role;


--
-- Name: FUNCTION handle_new_project_chat(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_project_chat() TO anon;
GRANT ALL ON FUNCTION public.handle_new_project_chat() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_project_chat() TO service_role;


--
-- Name: FUNCTION handle_new_project_member(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_project_member() TO anon;
GRANT ALL ON FUNCTION public.handle_new_project_member() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_project_member() TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION has_role(_user_id uuid, _role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO anon;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO authenticated;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO service_role;


--
-- Name: FUNCTION is_admin_or_manager(_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_admin_or_manager(_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_admin_or_manager(_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_admin_or_manager(_user_id uuid) TO service_role;


--
-- Name: FUNCTION is_channel_creator(_channel_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_channel_creator(_channel_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_channel_creator(_channel_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_channel_creator(_channel_id uuid) TO service_role;


--
-- Name: FUNCTION is_chat_participant(_channel_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_chat_participant(_channel_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_chat_participant(_channel_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_chat_participant(_channel_id uuid) TO service_role;


--
-- Name: FUNCTION is_event_creator(_event_id uuid, _user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_event_creator(_event_id uuid, _user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_event_creator(_event_id uuid, _user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_event_creator(_event_id uuid, _user_id uuid) TO service_role;


--
-- Name: FUNCTION is_hr(_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_hr(_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_hr(_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_hr(_user_id uuid) TO service_role;


--
-- Name: FUNCTION is_manager(_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_manager(_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_manager(_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_manager(_user_id uuid) TO service_role;


--
-- Name: FUNCTION is_project_manager(_project_id uuid, _user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_project_manager(_project_id uuid, _user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_project_manager(_project_id uuid, _user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_project_manager(_project_id uuid, _user_id uuid) TO service_role;


--
-- Name: FUNCTION is_project_member_or_owner(_project_id uuid, _user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_project_member_or_owner(_project_id uuid, _user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_project_member_or_owner(_project_id uuid, _user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_project_member_or_owner(_project_id uuid, _user_id uuid) TO service_role;


--
-- Name: FUNCTION is_super_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_super_admin() TO anon;
GRANT ALL ON FUNCTION public.is_super_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_super_admin() TO service_role;


--
-- Name: FUNCTION is_tenant_admin(_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_tenant_admin(_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_tenant_admin(_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_tenant_admin(_user_id uuid) TO service_role;


--
-- Name: FUNCTION join_department_chat_channel(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.join_department_chat_channel() TO anon;
GRANT ALL ON FUNCTION public.join_department_chat_channel() TO authenticated;
GRANT ALL ON FUNCTION public.join_department_chat_channel() TO service_role;


--
-- Name: FUNCTION log_activity(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_activity() TO anon;
GRANT ALL ON FUNCTION public.log_activity() TO authenticated;
GRANT ALL ON FUNCTION public.log_activity() TO service_role;


--
-- Name: FUNCTION log_activity_fn(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_activity_fn() TO anon;
GRANT ALL ON FUNCTION public.log_activity_fn() TO authenticated;
GRANT ALL ON FUNCTION public.log_activity_fn() TO service_role;


--
-- Name: FUNCTION notify_chat_participants(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_chat_participants() TO anon;
GRANT ALL ON FUNCTION public.notify_chat_participants() TO authenticated;
GRANT ALL ON FUNCTION public.notify_chat_participants() TO service_role;


--
-- Name: FUNCTION notify_leave_decision(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_leave_decision() TO anon;
GRANT ALL ON FUNCTION public.notify_leave_decision() TO authenticated;
GRANT ALL ON FUNCTION public.notify_leave_decision() TO service_role;


--
-- Name: FUNCTION notify_leave_status_change(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_leave_status_change() TO anon;
GRANT ALL ON FUNCTION public.notify_leave_status_change() TO authenticated;
GRANT ALL ON FUNCTION public.notify_leave_status_change() TO service_role;


--
-- Name: FUNCTION notify_payroll_approval(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.notify_payroll_approval() TO anon;
GRANT ALL ON FUNCTION public.notify_payroll_approval() TO authenticated;
GRANT ALL ON FUNCTION public.notify_payroll_approval() TO service_role;


--
-- Name: FUNCTION retain_activity_logs_limit(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.retain_activity_logs_limit() TO anon;
GRANT ALL ON FUNCTION public.retain_activity_logs_limit() TO authenticated;
GRANT ALL ON FUNCTION public.retain_activity_logs_limit() TO service_role;


--
-- Name: FUNCTION set_org_id_on_insert(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_org_id_on_insert() TO anon;
GRANT ALL ON FUNCTION public.set_org_id_on_insert() TO authenticated;
GRANT ALL ON FUNCTION public.set_org_id_on_insert() TO service_role;


--
-- Name: FUNCTION set_org_id_on_insert_email_templates(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_org_id_on_insert_email_templates() TO anon;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_email_templates() TO authenticated;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_email_templates() TO service_role;


--
-- Name: FUNCTION set_org_id_on_insert_emails_outbox(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_org_id_on_insert_emails_outbox() TO anon;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_emails_outbox() TO authenticated;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_emails_outbox() TO service_role;


--
-- Name: FUNCTION set_org_id_on_insert_event_attendees(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_org_id_on_insert_event_attendees() TO anon;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_event_attendees() TO authenticated;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_event_attendees() TO service_role;


--
-- Name: FUNCTION set_org_id_on_insert_messages(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_org_id_on_insert_messages() TO anon;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_messages() TO authenticated;
GRANT ALL ON FUNCTION public.set_org_id_on_insert_messages() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE activity_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.activity_logs TO anon;
GRANT ALL ON TABLE public.activity_logs TO authenticated;
GRANT ALL ON TABLE public.activity_logs TO service_role;


--
-- Name: TABLE attendance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.attendance TO anon;
GRANT ALL ON TABLE public.attendance TO authenticated;
GRANT ALL ON TABLE public.attendance TO service_role;


--
-- Name: TABLE chat_channels; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_channels TO anon;
GRANT ALL ON TABLE public.chat_channels TO authenticated;
GRANT ALL ON TABLE public.chat_channels TO service_role;


--
-- Name: TABLE chat_messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_messages TO anon;
GRANT ALL ON TABLE public.chat_messages TO authenticated;
GRANT ALL ON TABLE public.chat_messages TO service_role;


--
-- Name: TABLE chat_participants; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_participants TO anon;
GRANT ALL ON TABLE public.chat_participants TO authenticated;
GRANT ALL ON TABLE public.chat_participants TO service_role;


--
-- Name: TABLE companies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.companies TO anon;
GRANT ALL ON TABLE public.companies TO authenticated;
GRANT ALL ON TABLE public.companies TO service_role;


--
-- Name: TABLE contacts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.contacts TO anon;
GRANT ALL ON TABLE public.contacts TO authenticated;
GRANT ALL ON TABLE public.contacts TO service_role;


--
-- Name: TABLE deals; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.deals TO anon;
GRANT ALL ON TABLE public.deals TO authenticated;
GRANT ALL ON TABLE public.deals TO service_role;


--
-- Name: TABLE departments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.departments TO anon;
GRANT ALL ON TABLE public.departments TO authenticated;
GRANT ALL ON TABLE public.departments TO service_role;


--
-- Name: TABLE designations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.designations TO anon;
GRANT ALL ON TABLE public.designations TO authenticated;
GRANT ALL ON TABLE public.designations TO service_role;


--
-- Name: TABLE email_templates; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.email_templates TO anon;
GRANT ALL ON TABLE public.email_templates TO authenticated;
GRANT ALL ON TABLE public.email_templates TO service_role;


--
-- Name: TABLE emails_outbox; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.emails_outbox TO anon;
GRANT ALL ON TABLE public.emails_outbox TO authenticated;
GRANT ALL ON TABLE public.emails_outbox TO service_role;


--
-- Name: TABLE employees; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.employees TO anon;
GRANT ALL ON TABLE public.employees TO authenticated;
GRANT ALL ON TABLE public.employees TO service_role;


--
-- Name: TABLE event_attendees; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.event_attendees TO anon;
GRANT ALL ON TABLE public.event_attendees TO authenticated;
GRANT ALL ON TABLE public.event_attendees TO service_role;


--
-- Name: TABLE events; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.events TO anon;
GRANT ALL ON TABLE public.events TO authenticated;
GRANT ALL ON TABLE public.events TO service_role;


--
-- Name: TABLE invitations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.invitations TO anon;
GRANT ALL ON TABLE public.invitations TO authenticated;
GRANT ALL ON TABLE public.invitations TO service_role;


--
-- Name: TABLE leads; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.leads TO anon;
GRANT ALL ON TABLE public.leads TO authenticated;
GRANT ALL ON TABLE public.leads TO service_role;


--
-- Name: TABLE leave_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.leave_requests TO anon;
GRANT ALL ON TABLE public.leave_requests TO authenticated;
GRANT ALL ON TABLE public.leave_requests TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- Name: TABLE organizations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.organizations TO anon;
GRANT ALL ON TABLE public.organizations TO authenticated;
GRANT ALL ON TABLE public.organizations TO service_role;


--
-- Name: TABLE payments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payments TO anon;
GRANT ALL ON TABLE public.payments TO authenticated;
GRANT ALL ON TABLE public.payments TO service_role;


--
-- Name: TABLE payroll; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payroll TO anon;
GRANT ALL ON TABLE public.payroll TO authenticated;
GRANT ALL ON TABLE public.payroll TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE project_meetings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project_meetings TO anon;
GRANT ALL ON TABLE public.project_meetings TO authenticated;
GRANT ALL ON TABLE public.project_meetings TO service_role;


--
-- Name: TABLE project_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project_members TO anon;
GRANT ALL ON TABLE public.project_members TO authenticated;
GRANT ALL ON TABLE public.project_members TO service_role;


--
-- Name: TABLE project_tasks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project_tasks TO anon;
GRANT ALL ON TABLE public.project_tasks TO authenticated;
GRANT ALL ON TABLE public.project_tasks TO service_role;


--
-- Name: TABLE projects; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.projects TO anon;
GRANT ALL ON TABLE public.projects TO authenticated;
GRANT ALL ON TABLE public.projects TO service_role;


--
-- Name: TABLE role_capabilities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.role_capabilities TO anon;
GRANT ALL ON TABLE public.role_capabilities TO authenticated;
GRANT ALL ON TABLE public.role_capabilities TO service_role;


--
-- Name: TABLE settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.settings TO anon;
GRANT ALL ON TABLE public.settings TO authenticated;
GRANT ALL ON TABLE public.settings TO service_role;


--
-- Name: TABLE task_collaborators; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.task_collaborators TO anon;
GRANT ALL ON TABLE public.task_collaborators TO authenticated;
GRANT ALL ON TABLE public.task_collaborators TO service_role;


--
-- Name: TABLE task_timings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.task_timings TO anon;
GRANT ALL ON TABLE public.task_timings TO authenticated;
GRANT ALL ON TABLE public.task_timings TO service_role;


--
-- Name: TABLE tasks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tasks TO anon;
GRANT ALL ON TABLE public.tasks TO authenticated;
GRANT ALL ON TABLE public.tasks TO service_role;


--
-- Name: TABLE tenant_modules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tenant_modules TO anon;
GRANT ALL ON TABLE public.tenant_modules TO authenticated;
GRANT ALL ON TABLE public.tenant_modules TO service_role;


--
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO anon;
GRANT ALL ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_12_29; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_12_29 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_12_29 TO dashboard_user;


--
-- Name: TABLE messages_2025_12_30; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_12_30 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_12_30 TO dashboard_user;


--
-- Name: TABLE messages_2025_12_31; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_12_31 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_12_31 TO dashboard_user;


--
-- Name: TABLE messages_2026_01_01; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_01_01 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_01_01 TO dashboard_user;


--
-- Name: TABLE messages_2026_01_02; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_01_02 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_01_02 TO dashboard_user;


--
-- Name: TABLE messages_2026_01_03; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_01_03 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_01_03 TO dashboard_user;


--
-- Name: TABLE messages_2026_01_04; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_01_04 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_01_04 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

