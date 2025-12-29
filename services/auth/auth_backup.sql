--
-- PostgreSQL database dump
--

\restrict d4AK9D2bYMeOPOvlkCn2zvPxtDYR4fXbauWQgf3SDXX6THg1xNPjm7bmn9LjEMH

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.11 (Debian 16.11-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked boolean DEFAULT false,
    created_at timestamp with time zone
);


ALTER TABLE public.auth_refresh_tokens OWNER TO postgres;

--
-- Name: auth_superadmin_refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_superadmin_refresh_tokens (
    id uuid NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    superadmin_id uuid
);


ALTER TABLE public.auth_superadmin_refresh_tokens OWNER TO postgres;

--
-- Name: auth_superadmins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_superadmins (
    id uuid NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    email_verified boolean DEFAULT false NOT NULL,
    last_login timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    last_failed_attempt timestamp with time zone,
    failed_login_attempts integer DEFAULT 0,
    locked_until timestamp with time zone
);


ALTER TABLE public.auth_superadmins OWNER TO postgres;

--
-- Name: auth_user_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_profiles (
    user_id uuid NOT NULL,
    full_name character varying(255),
    avatar_url text,
    address text,
    emergency_contact jsonb,
    metadata jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user_profiles OWNER TO postgres;

--
-- Name: auth_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    phone character varying(255),
    password_hash text NOT NULL,
    role text NOT NULL,
    is_active boolean DEFAULT true,
    email_verified boolean DEFAULT false,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT auth_users_role_check CHECK ((role = ANY (ARRAY['PASSENGER'::text, 'COMPANY_ADMIN'::text, 'DRIVER'::text, 'SUPERADMIN'::text])))
);


ALTER TABLE public.auth_users OWNER TO postgres;

--
-- Data for Name: auth_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_refresh_tokens (id, user_id, token, expires_at, revoked, created_at) FROM stdin;
ccbe19e6-5298-45aa-89a1-93d04350783f	24df0e58-d824-455e-b8a2-cd7c1c1f4061	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjI0ZGYwZTU4LWQ4MjQtNDU1ZS1iOGEyLWNkN2MxYzFmNDA2MSIsImlhdCI6MTc2NjEyNTQwNywiZXhwIjoxNzY2NzMwMjA3fQ.SEW1awLsUR98eyASsc1dbeV1QucQm9CND81OAoy-xFQ	2025-12-26 06:23:27.511+00	f	2025-12-19 06:23:27.512+00
726e0f45-03aa-4e88-aab6-0664cb2dc68c	24df0e58-d824-455e-b8a2-cd7c1c1f4061	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjI0ZGYwZTU4LWQ4MjQtNDU1ZS1iOGEyLWNkN2MxYzFmNDA2MSIsImlhdCI6MTc2NjEyNjE2MSwiZXhwIjoxNzY2NzMwOTYxfQ.8-w9IVWx5q-Ftwgjkz4ojh_O6qBX8K6Cvl7MFcj-ZBo	2025-12-26 06:36:01.814+00	f	2025-12-19 06:36:01.826+00
\.


--
-- Data for Name: auth_superadmin_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_superadmin_refresh_tokens (id, token, expires_at, revoked, created_at, superadmin_id) FROM stdin;
\.


--
-- Data for Name: auth_superadmins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_superadmins (id, email, password_hash, is_active, email_verified, last_login, created_at, updated_at, last_failed_attempt, failed_login_attempts, locked_until) FROM stdin;
\.


--
-- Data for Name: auth_user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_profiles (user_id, full_name, avatar_url, address, emergency_contact, metadata, created_at, updated_at) FROM stdin;
24df0e58-d824-455e-b8a2-cd7c1c1f4061	harold ekemkpa	\N	\N	\N	\N	2025-12-16 10:27:01.327+00	2025-12-16 10:27:01.327+00
95bed5cf-e29c-4d9a-b42d-14f78ebab590	harold ekemkpa	\N	\N	\N	\N	2025-12-16 10:33:48.273+00	2025-12-16 10:33:48.273+00
6a29ebab-abf5-4e8d-b494-ebd77da6e1ee	harold ekemkpa	\N	\N	\N	\N	2025-12-16 10:34:20.117+00	2025-12-16 10:34:20.117+00
\.


--
-- Data for Name: auth_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_users (id, email, phone, password_hash, role, is_active, email_verified, created_at, updated_at) FROM stdin;
24df0e58-d824-455e-b8a2-cd7c1c1f4061	haroldonyebuchi507@gmail.com	+2348012345678	$2b$10$SsFlLVPw69cSCnVizfCvFuqaI59sg9Let1qjsAllDAd0p8MnzUINK	PASSENGER	t	f	2025-12-16 10:27:01.308+00	2025-12-16 10:27:01.308+00
95bed5cf-e29c-4d9a-b42d-14f78ebab590	abrahamemmanuelf@gmail.com	+2348012345678	$2b$10$qszKp0fMoQsSPaF3r.HBL.zsY7eg4Hhif.Dw4Cq2003IS1pGePMnq	PASSENGER	t	f	2025-12-16 10:33:48.264+00	2025-12-16 10:33:48.264+00
6a29ebab-abf5-4e8d-b494-ebd77da6e1ee	estherokani2433@gmail.com	+2348012345678	$2b$10$lEdK.KfjeEFEXuAnxKosK.RlsR0lj4X1Imi57E75zQbfsJ/9xWvHK	PASSENGER	t	f	2025-12-16 10:34:20.112+00	2025-12-16 10:34:20.112+00
\.


--
-- Name: auth_refresh_tokens auth_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_refresh_tokens
    ADD CONSTRAINT auth_refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: auth_superadmin_refresh_tokens auth_superadmin_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmin_refresh_tokens
    ADD CONSTRAINT auth_superadmin_refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: auth_superadmins auth_superadmins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key1 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key10 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key100; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key100 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key101; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key101 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key102; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key102 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key103; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key103 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key104; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key104 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key105; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key105 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key106; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key106 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key107; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key107 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key108; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key108 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key109; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key109 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key11 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key110; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key110 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key111; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key111 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key112; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key112 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key113; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key113 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key114; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key114 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key115; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key115 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key116; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key116 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key117; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key117 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key118; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key118 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key119; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key119 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key12 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key13 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key14 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key15 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key16; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key16 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key17; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key17 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key18 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key19; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key19 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key2 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key20; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key20 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key21; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key21 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key22 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key23; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key23 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key24; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key24 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key25; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key25 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key26; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key26 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key27; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key27 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key28 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key29; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key29 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key3 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key30; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key30 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key31; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key31 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key32; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key32 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key33; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key33 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key34; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key34 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key35; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key35 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key36; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key36 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key37; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key37 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key38; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key38 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key39; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key39 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key4 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key40; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key40 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key41; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key41 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key42; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key42 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key43; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key43 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key44; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key44 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key45; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key45 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key46; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key46 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key47; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key47 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key48; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key48 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key49; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key49 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key5 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key50; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key50 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key51; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key51 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key52; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key52 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key53; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key53 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key54; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key54 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key55; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key55 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key56; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key56 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key57 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key58; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key58 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key59; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key59 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key6 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key60; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key60 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key61; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key61 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key62; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key62 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key63; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key63 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key64; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key64 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key65; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key65 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key66; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key66 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key67; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key67 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key68; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key68 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key69; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key69 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key7 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key70; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key70 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key71; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key71 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key72; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key72 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key73; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key73 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key74; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key74 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key75; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key75 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key76; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key76 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key77; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key77 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key78; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key78 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key79; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key79 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key8 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key80; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key80 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key81; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key81 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key82; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key82 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key83; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key83 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key84; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key84 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key85; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key85 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key86; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key86 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key87; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key87 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key88; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key88 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key89; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key89 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key9 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key90; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key90 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key91; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key91 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key92; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key92 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key93; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key93 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key94; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key94 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key95; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key95 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key96; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key96 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key97; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key97 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key98; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key98 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_email_key99; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_email_key99 UNIQUE (email);


--
-- Name: auth_superadmins auth_superadmins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmins
    ADD CONSTRAINT auth_superadmins_pkey PRIMARY KEY (id);


--
-- Name: auth_user_profiles auth_user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_profiles
    ADD CONSTRAINT auth_user_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: auth_users auth_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key UNIQUE (email);


--
-- Name: auth_users auth_users_email_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key1 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key10 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key11 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key12 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key13 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key2 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key3 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key4 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key5 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key6 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key7 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key8 UNIQUE (email);


--
-- Name: auth_users auth_users_email_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key9 UNIQUE (email);


--
-- Name: auth_users auth_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_pkey PRIMARY KEY (id);


--
-- Name: auth_refresh_tokens auth_refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_refresh_tokens
    ADD CONSTRAINT auth_refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_superadmin_refresh_tokens auth_superadmin_refresh_tokens_superadmin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_superadmin_refresh_tokens
    ADD CONSTRAINT auth_superadmin_refresh_tokens_superadmin_id_fkey FOREIGN KEY (superadmin_id) REFERENCES public.auth_superadmins(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_user_profiles auth_user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_profiles
    ADD CONSTRAINT auth_user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict d4AK9D2bYMeOPOvlkCn2zvPxtDYR4fXbauWQgf3SDXX6THg1xNPjm7bmn9LjEMH

