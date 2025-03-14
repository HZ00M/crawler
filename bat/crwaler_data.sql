PGDMP  ;    $    
            }            crawler    14.1 (Debian 14.1-1.pgdg110+1)    16.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    20119    crawler    DATABASE     r   CREATE DATABASE crawler WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE crawler;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    6                        3079    20120    dblink 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;
    DROP EXTENSION dblink;
                   false    6            �           0    0    EXTENSION dblink    COMMENT     _   COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';
                        false    2            �            1259    20166    applicationPlugins    TABLE     o  CREATE TABLE public."applicationPlugins" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    "packageName" character varying(255),
    version character varying(255),
    enabled boolean,
    installed boolean,
    "builtIn" boolean,
    options json
);
 (   DROP TABLE public."applicationPlugins";
       public         heap    postgres    false    6            �            1259    20171    applicationPlugins_id_seq    SEQUENCE     �   CREATE SEQUENCE public."applicationPlugins_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."applicationPlugins_id_seq";
       public          postgres    false    213    6            �           0    0    applicationPlugins_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."applicationPlugins_id_seq" OWNED BY public."applicationPlugins".id;
          public          postgres    false    214            �            1259    20172    applicationVersion    TABLE     g   CREATE TABLE public."applicationVersion" (
    id bigint NOT NULL,
    value character varying(255)
);
 (   DROP TABLE public."applicationVersion";
       public         heap    postgres    false    6            �            1259    20175    applicationVersion_id_seq    SEQUENCE     �   CREATE SEQUENCE public."applicationVersion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."applicationVersion_id_seq";
       public          postgres    false    215    6            �           0    0    applicationVersion_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public."applicationVersion_id_seq" OWNED BY public."applicationVersion".id;
          public          postgres    false    216            �            1259    20176    attachments    TABLE     �  CREATE TABLE public.attachments (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    filename character varying(255),
    extname character varying(255),
    size integer,
    mimetype character varying(255),
    "storageId" bigint,
    path character varying(255),
    meta jsonb DEFAULT '{}'::jsonb,
    url character varying(255),
    "createdById" bigint,
    "updatedById" bigint
);
    DROP TABLE public.attachments;
       public         heap    postgres    false    6            �           0    0    COLUMN attachments.title    COMMENT     V   COMMENT ON COLUMN public.attachments.title IS '用户文件名（不含扩展名）';
          public          postgres    false    217            �           0    0    COLUMN attachments.filename    COMMENT     V   COMMENT ON COLUMN public.attachments.filename IS '系统文件名（含扩展名）';
          public          postgres    false    217            �           0    0    COLUMN attachments.extname    COMMENT     M   COMMENT ON COLUMN public.attachments.extname IS '扩展名（含“.”）';
          public          postgres    false    217            �           0    0    COLUMN attachments.size    COMMENT     I   COMMENT ON COLUMN public.attachments.size IS '文件体积（字节）';
          public          postgres    false    217            �           0    0    COLUMN attachments.path    COMMENT     S   COMMENT ON COLUMN public.attachments.path IS '相对路径（含“/”前缀）';
          public          postgres    false    217            �           0    0    COLUMN attachments.meta    COMMENT     [   COMMENT ON COLUMN public.attachments.meta IS '其他文件信息（如图片的宽高）';
          public          postgres    false    217            �           0    0    COLUMN attachments.url    COMMENT     B   COMMENT ON COLUMN public.attachments.url IS '网络访问地址';
          public          postgres    false    217            �            1259    20182    attachments_id_seq    SEQUENCE     {   CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.attachments_id_seq;
       public          postgres    false    6    217            �           0    0    attachments_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;
          public          postgres    false    218            �            1259    20183    authenticators    TABLE       CREATE TABLE public.authenticators (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "authType" character varying(255) NOT NULL,
    title character varying(255),
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    options json DEFAULT '{}'::json NOT NULL,
    enabled boolean DEFAULT false,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);
 "   DROP TABLE public.authenticators;
       public         heap    postgres    false    6            �            1259    20191    authenticators_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.authenticators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.authenticators_id_seq;
       public          postgres    false    219    6            �           0    0    authenticators_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.authenticators_id_seq OWNED BY public.authenticators.id;
          public          postgres    false    220            �            1259    20192    chinaRegions    TABLE       CREATE TABLE public."chinaRegions" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255),
    "parentCode" character varying(255),
    level integer
);
 "   DROP TABLE public."chinaRegions";
       public         heap    postgres    false    6            �            1259    20197    collectionCategories    TABLE     &  CREATE TABLE public."collectionCategories" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    color character varying(255) DEFAULT 'default'::character varying,
    sort bigint
);
 *   DROP TABLE public."collectionCategories";
       public         heap    postgres    false    6            �            1259    20203    collectionCategories_id_seq    SEQUENCE     �   CREATE SEQUENCE public."collectionCategories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."collectionCategories_id_seq";
       public          postgres    false    6    222            �           0    0    collectionCategories_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."collectionCategories_id_seq" OWNED BY public."collectionCategories".id;
          public          postgres    false    223            �            1259    20204    collectionCategory    TABLE     �   CREATE TABLE public."collectionCategory" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "collectionName" character varying(255) NOT NULL,
    "categoryId" bigint NOT NULL
);
 (   DROP TABLE public."collectionCategory";
       public         heap    postgres    false    6            �            1259    20207    collections    TABLE     3  CREATE TABLE public.collections (
    key character varying(255) NOT NULL,
    name character varying(255),
    title character varying(255),
    inherit boolean DEFAULT false,
    hidden boolean DEFAULT false,
    options json DEFAULT '{}'::json,
    description character varying(255),
    sort bigint
);
    DROP TABLE public.collections;
       public         heap    postgres    false    6            �            1259    20215    customRequests    TABLE     �   CREATE TABLE public."customRequests" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    options json
);
 $   DROP TABLE public."customRequests";
       public         heap    postgres    false    6            �            1259    20220    customRequestsRoles    TABLE     �   CREATE TABLE public."customRequestsRoles" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "customRequestKey" character varying(255) NOT NULL,
    "roleName" character varying(255) NOT NULL
);
 )   DROP TABLE public."customRequestsRoles";
       public         heap    postgres    false    6            �            1259    20225    dataSources    TABLE     U  CREATE TABLE public."dataSources" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    "displayName" character varying(255),
    type character varying(255),
    options json,
    enabled boolean DEFAULT true,
    fixed boolean DEFAULT false
);
 !   DROP TABLE public."dataSources";
       public         heap    postgres    false    6            �            1259    20232    dataSourcesCollections    TABLE     �   CREATE TABLE public."dataSourcesCollections" (
    key character varying(255) NOT NULL,
    name character varying(255),
    options json,
    "dataSourceKey" character varying(255)
);
 ,   DROP TABLE public."dataSourcesCollections";
       public         heap    postgres    false    6            �            1259    20237    dataSourcesFields    TABLE     �  CREATE TABLE public."dataSourcesFields" (
    key character varying(255) NOT NULL,
    name character varying(255),
    "collectionName" character varying(255),
    interface character varying(255),
    description character varying(255),
    "uiSchema" json,
    "collectionKey" character varying(255),
    options json DEFAULT '{}'::json,
    "dataSourceKey" character varying(255)
);
 '   DROP TABLE public."dataSourcesFields";
       public         heap    postgres    false    6            �            1259    20243    dataSourcesRoles    TABLE     �   CREATE TABLE public."dataSourcesRoles" (
    id character varying(255) NOT NULL,
    strategy json,
    "dataSourceKey" character varying(255),
    "roleName" character varying(255)
);
 &   DROP TABLE public."dataSourcesRoles";
       public         heap    postgres    false    6            �            1259    20248    dataSourcesRolesResources    TABLE     j  CREATE TABLE public."dataSourcesRolesResources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "dataSourceKey" character varying(255) DEFAULT 'main'::character varying,
    name character varying(255),
    "usingActionsConfig" boolean,
    "roleName" character varying(255)
);
 /   DROP TABLE public."dataSourcesRolesResources";
       public         heap    postgres    false    6            �            1259    20254     dataSourcesRolesResourcesActions    TABLE     4  CREATE TABLE public."dataSourcesRolesResourcesActions" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    fields jsonb DEFAULT '[]'::jsonb,
    "scopeId" bigint,
    "rolesResourceId" bigint
);
 6   DROP TABLE public."dataSourcesRolesResourcesActions";
       public         heap    postgres    false    6            �            1259    20260 '   dataSourcesRolesResourcesActions_id_seq    SEQUENCE     �   CREATE SEQUENCE public."dataSourcesRolesResourcesActions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."dataSourcesRolesResourcesActions_id_seq";
       public          postgres    false    233    6            �           0    0 '   dataSourcesRolesResourcesActions_id_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public."dataSourcesRolesResourcesActions_id_seq" OWNED BY public."dataSourcesRolesResourcesActions".id;
          public          postgres    false    234            �            1259    20261    dataSourcesRolesResourcesScopes    TABLE     �  CREATE TABLE public."dataSourcesRolesResourcesScopes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    "dataSourceKey" character varying(255) DEFAULT 'main'::character varying,
    name character varying(255),
    "resourceName" character varying(255),
    scope json
);
 5   DROP TABLE public."dataSourcesRolesResourcesScopes";
       public         heap    postgres    false    6            �            1259    20267 &   dataSourcesRolesResourcesScopes_id_seq    SEQUENCE     �   CREATE SEQUENCE public."dataSourcesRolesResourcesScopes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public."dataSourcesRolesResourcesScopes_id_seq";
       public          postgres    false    6    235            �           0    0 &   dataSourcesRolesResourcesScopes_id_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public."dataSourcesRolesResourcesScopes_id_seq" OWNED BY public."dataSourcesRolesResourcesScopes".id;
          public          postgres    false    236            �            1259    20268     dataSourcesRolesResources_id_seq    SEQUENCE     �   CREATE SEQUENCE public."dataSourcesRolesResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."dataSourcesRolesResources_id_seq";
       public          postgres    false    232    6            �           0    0     dataSourcesRolesResources_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."dataSourcesRolesResources_id_seq" OWNED BY public."dataSourcesRolesResources".id;
          public          postgres    false    237            �            1259    20269 
   executions    TABLE     '  CREATE TABLE public.executions (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    "eventKey" character varying(255),
    context json,
    status integer,
    "workflowId" bigint
);
    DROP TABLE public.executions;
       public         heap    postgres    false    6            �            1259    20274    executions_id_seq    SEQUENCE     z   CREATE SEQUENCE public.executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.executions_id_seq;
       public          postgres    false    6    238            �           0    0    executions_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.executions_id_seq OWNED BY public.executions.id;
          public          postgres    false    239            �            1259    20275    fields    TABLE     �  CREATE TABLE public.fields (
    key character varying(255) NOT NULL,
    name character varying(255),
    type character varying(255),
    interface character varying(255),
    description character varying(255),
    "collectionName" character varying(255),
    "parentKey" character varying(255),
    "reverseKey" character varying(255),
    options json DEFAULT '{}'::json,
    sort bigint
);
    DROP TABLE public.fields;
       public         heap    postgres    false    6            �            1259    20281 
   flow_nodes    TABLE     �  CREATE TABLE public.flow_nodes (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    title character varying(255),
    "upstreamId" bigint,
    "branchIndex" integer,
    "downstreamId" bigint,
    type character varying(255),
    config json DEFAULT '{}'::json,
    "workflowId" bigint
);
    DROP TABLE public.flow_nodes;
       public         heap    postgres    false    6            �            1259    20287    flow_nodes_id_seq    SEQUENCE     z   CREATE SEQUENCE public.flow_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.flow_nodes_id_seq;
       public          postgres    false    241    6            �           0    0    flow_nodes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.flow_nodes_id_seq OWNED BY public.flow_nodes.id;
          public          postgres    false    242            �            1259    20288    graphPositions    TABLE       CREATE TABLE public."graphPositions" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "collectionName" character varying(255),
    x double precision,
    y double precision
);
 $   DROP TABLE public."graphPositions";
       public         heap    postgres    false    6            �            1259    20291    graphPositions_id_seq    SEQUENCE     �   CREATE SEQUENCE public."graphPositions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."graphPositions_id_seq";
       public          postgres    false    243    6            �           0    0    graphPositions_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."graphPositions_id_seq" OWNED BY public."graphPositions".id;
          public          postgres    false    244            �            1259    20292    hello    TABLE     �   CREATE TABLE public.hello (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255)
);
    DROP TABLE public.hello;
       public         heap    postgres    false    6            �            1259    20295    hello_id_seq    SEQUENCE     u   CREATE SEQUENCE public.hello_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.hello_id_seq;
       public          postgres    false    6    245            �           0    0    hello_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.hello_id_seq OWNED BY public.hello.id;
          public          postgres    false    246            �            1259    20296 
   iframeHtml    TABLE     �   CREATE TABLE public."iframeHtml" (
    id character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    html text,
    "createdById" bigint,
    "updatedById" bigint
);
     DROP TABLE public."iframeHtml";
       public         heap    postgres    false    6            �            1259    20301    jobs    TABLE     .  CREATE TABLE public.jobs (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "executionId" bigint,
    "nodeId" bigint,
    "nodeKey" character varying(255),
    "upstreamId" bigint,
    status integer,
    result json
);
    DROP TABLE public.jobs;
       public         heap    postgres    false    6            �            1259    20306    jobs_id_seq    SEQUENCE     t   CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.jobs_id_seq;
       public          postgres    false    248    6            �           0    0    jobs_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;
          public          postgres    false    249            (           1259    20833    main_mobileRoutes_path    TABLE        CREATE TABLE public."main_mobileRoutes_path" (
    "nodePk" integer,
    path character varying(1024),
    "rootPk" integer
);
 ,   DROP TABLE public."main_mobileRoutes_path";
       public         heap    postgres    false    6            �            1259    20307 
   migrations    TABLE     M   CREATE TABLE public.migrations (
    name character varying(255) NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false    6            '           1259    20824    mobileRoutes    TABLE     �  CREATE TABLE public."mobileRoutes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "parentId" bigint,
    title character varying(255),
    icon character varying(255),
    "schemaUid" character varying(255),
    type character varying(255),
    options json,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);
 "   DROP TABLE public."mobileRoutes";
       public         heap    postgres    false    6            &           1259    20823    mobileRoutes_id_seq    SEQUENCE     ~   CREATE SEQUENCE public."mobileRoutes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."mobileRoutes_id_seq";
       public          postgres    false    6    295            �           0    0    mobileRoutes_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."mobileRoutes_id_seq" OWNED BY public."mobileRoutes".id;
          public          postgres    false    294            2           1259    20891    notificationChannels    TABLE     {  CREATE TABLE public."notificationChannels" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    options json,
    meta json,
    "notificationType" character varying(255),
    description text,
    "createdById" bigint,
    "updatedById" bigint
);
 *   DROP TABLE public."notificationChannels";
       public         heap    postgres    false    6            4           1259    20906    notificationInAppMessages    TABLE     \  CREATE TABLE public."notificationInAppMessages" (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" bigint,
    "channelName" character varying(255),
    title text,
    content text,
    status character varying(255),
    "receiveTimestamp" bigint,
    options json
);
 /   DROP TABLE public."notificationInAppMessages";
       public         heap    postgres    false    6            3           1259    20899    notificationSendLogs    TABLE     �  CREATE TABLE public."notificationSendLogs" (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "channelName" character varying(255),
    "channelTitle" character varying(255),
    "triggerFrom" character varying(255),
    "notificationType" character varying(255),
    status character varying(255),
    message json,
    reason text
);
 *   DROP TABLE public."notificationSendLogs";
       public         heap    postgres    false    6            �            1259    20310    roles    TABLE     �  CREATE TABLE public.roles (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255),
    description character varying(255),
    strategy json,
    "default" boolean DEFAULT false,
    hidden boolean DEFAULT false,
    "allowConfigure" boolean,
    "allowNewMenu" boolean,
    snippets jsonb DEFAULT '["!ui.*", "!pm", "!pm.*"]'::jsonb,
    sort bigint,
    "allowNewMobileMenu" boolean
);
    DROP TABLE public.roles;
       public         heap    postgres    false    6            )           1259    20839    rolesMobileRoutes    TABLE     �   CREATE TABLE public."rolesMobileRoutes" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "mobileRouteId" bigint NOT NULL,
    "roleName" character varying(255) NOT NULL
);
 '   DROP TABLE public."rolesMobileRoutes";
       public         heap    postgres    false    6            �            1259    20318    rolesResources    TABLE       CREATE TABLE public."rolesResources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "roleName" character varying(255),
    name character varying(255),
    "usingActionsConfig" boolean
);
 $   DROP TABLE public."rolesResources";
       public         heap    postgres    false    6            �            1259    20323    rolesResourcesActions    TABLE     )  CREATE TABLE public."rolesResourcesActions" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "rolesResourceId" bigint,
    name character varying(255),
    fields jsonb DEFAULT '[]'::jsonb,
    "scopeId" bigint
);
 +   DROP TABLE public."rolesResourcesActions";
       public         heap    postgres    false    6            �            1259    20329    rolesResourcesActions_id_seq    SEQUENCE     �   CREATE SEQUENCE public."rolesResourcesActions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."rolesResourcesActions_id_seq";
       public          postgres    false    6    253            �           0    0    rolesResourcesActions_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."rolesResourcesActions_id_seq" OWNED BY public."rolesResourcesActions".id;
          public          postgres    false    254            �            1259    20330    rolesResourcesScopes    TABLE     )  CREATE TABLE public."rolesResourcesScopes" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    name character varying(255),
    "resourceName" character varying(255),
    scope json
);
 *   DROP TABLE public."rolesResourcesScopes";
       public         heap    postgres    false    6                        1259    20335    rolesResourcesScopes_id_seq    SEQUENCE     �   CREATE SEQUENCE public."rolesResourcesScopes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."rolesResourcesScopes_id_seq";
       public          postgres    false    6    255            �           0    0    rolesResourcesScopes_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public."rolesResourcesScopes_id_seq" OWNED BY public."rolesResourcesScopes".id;
          public          postgres    false    256                       1259    20336    rolesResources_id_seq    SEQUENCE     �   CREATE SEQUENCE public."rolesResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."rolesResources_id_seq";
       public          postgres    false    252    6            �           0    0    rolesResources_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."rolesResources_id_seq" OWNED BY public."rolesResources".id;
          public          postgres    false    257                       1259    20337    rolesUischemas    TABLE     �   CREATE TABLE public."rolesUischemas" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "roleName" character varying(255) NOT NULL,
    "uiSchemaXUid" character varying(255) NOT NULL
);
 $   DROP TABLE public."rolesUischemas";
       public         heap    postgres    false    6                       1259    20342 
   rolesUsers    TABLE     �   CREATE TABLE public."rolesUsers" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "default" boolean,
    "roleName" character varying(255) NOT NULL,
    "userId" bigint NOT NULL
);
     DROP TABLE public."rolesUsers";
       public         heap    postgres    false    6                       1259    20345 	   sequences    TABLE     >  CREATE TABLE public.sequences (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    collection character varying(255),
    field character varying(255),
    key integer,
    current bigint,
    "lastGeneratedAt" timestamp with time zone
);
    DROP TABLE public.sequences;
       public         heap    postgres    false    6                       1259    20350    sequences_id_seq    SEQUENCE     y   CREATE SEQUENCE public.sequences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.sequences_id_seq;
       public          postgres    false    6    260            �           0    0    sequences_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.sequences_id_seq OWNED BY public.sequences.id;
          public          postgres    false    261                       1259    20351    storages    TABLE       CREATE TABLE public.storages (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    name character varying(255),
    type character varying(255),
    options jsonb DEFAULT '{}'::jsonb,
    rules jsonb DEFAULT '{}'::jsonb,
    path character varying(255) DEFAULT ''::character varying,
    "baseUrl" character varying(255) DEFAULT ''::character varying,
    "default" boolean DEFAULT false,
    paranoid boolean DEFAULT false
);
    DROP TABLE public.storages;
       public         heap    postgres    false    6            �           0    0    COLUMN storages.title    COMMENT     A   COMMENT ON COLUMN public.storages.title IS '存储引擎名称';
          public          postgres    false    262            �           0    0    COLUMN storages.type    COMMENT     R   COMMENT ON COLUMN public.storages.type IS '类型标识，如 local/ali-oss 等';
          public          postgres    false    262            �           0    0    COLUMN storages.options    COMMENT     :   COMMENT ON COLUMN public.storages.options IS '配置项';
          public          postgres    false    262            �           0    0    COLUMN storages.rules    COMMENT     ;   COMMENT ON COLUMN public.storages.rules IS '文件规则';
          public          postgres    false    262            �           0    0    COLUMN storages.path    COMMENT     F   COMMENT ON COLUMN public.storages.path IS '存储相对路径模板';
          public          postgres    false    262            �           0    0    COLUMN storages."baseUrl"    COMMENT     E   COMMENT ON COLUMN public.storages."baseUrl" IS '访问地址前缀';
          public          postgres    false    262            �           0    0    COLUMN storages."default"    COMMENT     ?   COMMENT ON COLUMN public.storages."default" IS '默认引擎';
          public          postgres    false    262                       1259    20362    storages_id_seq    SEQUENCE     x   CREATE SEQUENCE public.storages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.storages_id_seq;
       public          postgres    false    6    262            �           0    0    storages_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.storages_id_seq OWNED BY public.storages.id;
          public          postgres    false    263                       1259    20363    systemSettings    TABLE       CREATE TABLE public."systemSettings" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    "showLogoOnly" boolean,
    "allowSignUp" boolean DEFAULT true,
    "smsAuthEnabled" boolean DEFAULT false,
    "logoId" bigint,
    "enabledLanguages" json DEFAULT '[]'::json,
    "appLang" character varying(255),
    options json DEFAULT '{}'::json,
    "enableEditProfile" boolean,
    "enableChangePassword" boolean
);
 $   DROP TABLE public."systemSettings";
       public         heap    postgres    false    6            	           1259    20372    systemSettings_id_seq    SEQUENCE     �   CREATE SEQUENCE public."systemSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."systemSettings_id_seq";
       public          postgres    false    6    264            �           0    0    systemSettings_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."systemSettings_id_seq" OWNED BY public."systemSettings".id;
          public          postgres    false    265            
           1259    20373    t_5b605e856ok    TABLE     �   CREATE TABLE public.t_5b605e856ok (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    f_u97bd0zhaxy bigint NOT NULL,
    f_je0bovkl4j2 bigint NOT NULL
);
 !   DROP TABLE public.t_5b605e856ok;
       public         heap    postgres    false    6                       1259    20376    t_job_execute    TABLE     �  CREATE TABLE public.t_job_execute (
    id bigint NOT NULL,
    "createdById" bigint,
    "updatedById" bigint,
    namespace character varying(255),
    image character varying(255),
    command character varying(255),
    cron character varying(255),
    result_table_name character varying(255) DEFAULT 't_job_record'::character varying,
    execute_name character varying(255),
    data_size bigint,
    "createdAt" timestamp without time zone,
    created_at timestamp with time zone,
    key_word character varying(255),
    begin_time timestamp with time zone,
    end_time timestamp with time zone,
    "updatedAt" timestamp without time zone,
    job_status bigint DEFAULT 0,
    job_type integer DEFAULT 0,
    job_group character varying(255),
    f_meta_id bigint,
    meta_id bigint,
    meta_name character varying(255),
    parallel_num bigint DEFAULT 1,
    execute_count bigint DEFAULT 0,
    env_args text,
    exe_args text,
    ignore_word character varying(255),
    app_label_name character varying(255),
    job_label_name character varying(255),
    finish_count bigint DEFAULT '0'::double precision,
    fail_count bigint DEFAULT '0'::double precision,
    project_name character varying(255),
    storage_flag bigint
);
 !   DROP TABLE public.t_job_execute;
       public         heap    postgres    false    6                       1259    20388    t_job_execute_id_seq    SEQUENCE     }   CREATE SEQUENCE public.t_job_execute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.t_job_execute_id_seq;
       public          postgres    false    6    267            �           0    0    t_job_execute_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.t_job_execute_id_seq OWNED BY public.t_job_execute.id;
          public          postgres    false    268                       1259    20389    t_job_execute_view    TABLE     �  CREATE TABLE public.t_job_execute_view (
    id bigint NOT NULL,
    execute_name character varying(255),
    job_type character varying(255),
    key_word character varying(255),
    begin_time timestamp with time zone,
    end_time timestamp with time zone,
    cron character varying(255),
    f_meta_id bigint,
    parallel_num bigint DEFAULT 1,
    ignore_word character varying(255),
    project_name character varying(255),
    storage_flag character varying(255) DEFAULT '1'::character varying
);
 &   DROP TABLE public.t_job_execute_view;
       public         heap    postgres    false    6                       1259    20396    t_job_execute_view_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_job_execute_view_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.t_job_execute_view_id_seq;
       public          postgres    false    6    269            �           0    0    t_job_execute_view_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.t_job_execute_view_id_seq OWNED BY public.t_job_execute_view.id;
          public          postgres    false    270                       1259    20397 
   t_job_meta    TABLE     e  CREATE TABLE public.t_job_meta (
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    id bigint NOT NULL,
    "createdById" bigint,
    "updatedById" bigint,
    command text,
    namespace text,
    image_name text,
    meta_name text,
    f_u1dygf73ly9 bigint,
    f_styaowp9srm bigint,
    env_args text,
    exe_args text,
    language text,
    label_name text,
    plugin_path text,
    lable_name character varying,
    repo_url text,
    repo_username character varying(255),
    repo_password text,
    repo_branch text,
    repo_token text,
    repo_user_name text
);
    DROP TABLE public.t_job_meta;
       public         heap    postgres    false    6                       1259    20402    t_job_meta_id_seq    SEQUENCE     z   CREATE SEQUENCE public.t_job_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.t_job_meta_id_seq;
       public          postgres    false    6    271            �           0    0    t_job_meta_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.t_job_meta_id_seq OWNED BY public.t_job_meta.id;
          public          postgres    false    272                       1259    20403    t_job_record    TABLE     �  CREATE TABLE public.t_job_record (
    id integer NOT NULL,
    flag_main bigint,
    target_obj_id character varying(255),
    key_word character varying(255),
    execute_id bigint,
    web_site character varying(255),
    title character varying(255),
    content text,
    label character varying(255),
    subject character varying(255),
    author character varying(255),
    record_url text,
    msg_time character varying(255),
    take_time character varying(255),
    fans_count bigint,
    interest_count bigint,
    user_id character varying(255),
    user_homepage text,
    user_level bigint,
    execute_name character varying(255),
    "createdAt" timestamp with time zone,
    record_ur character varying(255),
    active_count bigint,
    read_count bigint,
    like_count bigint,
    coin_count bigint,
    mark_count bigint,
    share_count bigint,
    comments_count bigint,
    barrage_count bigint,
    tag text,
    comment text,
    commenter_name text,
    comment_time text,
    user_member text,
    user_likes text,
    user_describe text,
    developer_word text,
    android_last_update text,
    ios_last_update text,
    mark character varying(255),
    data_type text,
    book_count bigint,
    down_count bigint,
    download_count bigint,
    book_num bigint,
    ignore_word character varying(255),
    comment_reply_num bigint,
    project_name character varying(255),
    storage_flag bigint
);
     DROP TABLE public.t_job_record;
       public         heap    postgres    false    6                       1259    20408    t_job_record_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_job_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.t_job_record_id_seq;
       public          postgres    false    6    273            �           0    0    t_job_record_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.t_job_record_id_seq OWNED BY public.t_job_record.id;
          public          postgres    false    274                       1259    20409    t_key_word_search    TABLE     X  CREATE TABLE public.t_key_word_search (
    id bigint NOT NULL,
    key_word text DEFAULT ''::text,
    mask_word text,
    start_date timestamp with time zone,
    end_data timestamp with time zone,
    execute_name character varying(255),
    cron character varying(255),
    job_type character varying(255) DEFAULT '0'::character varying
);
 %   DROP TABLE public.t_key_word_search;
       public         heap    postgres    false    6                       1259    20416    t_key_word_search_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_key_word_search_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.t_key_word_search_id_seq;
       public          postgres    false    6    275                        0    0    t_key_word_search_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.t_key_word_search_id_seq OWNED BY public.t_key_word_search.id;
          public          postgres    false    276                       1259    20417    t_xfztfz2cag0    TABLE     �   CREATE TABLE public.t_xfztfz2cag0 (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    f_6d2sjvn53y4 bigint NOT NULL,
    f_m0dcmr7kq5r bigint NOT NULL
);
 !   DROP TABLE public.t_xfztfz2cag0;
       public         heap    postgres    false    6            6           1259    21315    themeConfig    TABLE     )  CREATE TABLE public."themeConfig" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    config json,
    optional boolean,
    "isBuiltIn" boolean,
    uid character varying(255),
    "default" boolean DEFAULT false
);
 !   DROP TABLE public."themeConfig";
       public         heap    postgres    false    6            5           1259    21314    themeConfig_id_seq    SEQUENCE     }   CREATE SEQUENCE public."themeConfig_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."themeConfig_id_seq";
       public          postgres    false    310    6                       0    0    themeConfig_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."themeConfig_id_seq" OWNED BY public."themeConfig".id;
          public          postgres    false    309                       1259    20420    tokenBlacklist    TABLE     �   CREATE TABLE public."tokenBlacklist" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    token character varying(255),
    expiration timestamp with time zone
);
 $   DROP TABLE public."tokenBlacklist";
       public         heap    postgres    false    6                       1259    20423    tokenBlacklist_id_seq    SEQUENCE     �   CREATE SEQUENCE public."tokenBlacklist_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."tokenBlacklist_id_seq";
       public          postgres    false    6    278                       0    0    tokenBlacklist_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."tokenBlacklist_id_seq" OWNED BY public."tokenBlacklist".id;
          public          postgres    false    279                       1259    20424    uiSchemaServerHooks    TABLE       CREATE TABLE public."uiSchemaServerHooks" (
    id bigint NOT NULL,
    uid character varying(255),
    type character varying(255),
    collection character varying(255),
    field character varying(255),
    method character varying(255),
    params json
);
 )   DROP TABLE public."uiSchemaServerHooks";
       public         heap    postgres    false    6                       1259    20429    uiSchemaServerHooks_id_seq    SEQUENCE     �   CREATE SEQUENCE public."uiSchemaServerHooks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."uiSchemaServerHooks_id_seq";
       public          postgres    false    280    6                       0    0    uiSchemaServerHooks_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."uiSchemaServerHooks_id_seq" OWNED BY public."uiSchemaServerHooks".id;
          public          postgres    false    281                       1259    20430    uiSchemaTemplates    TABLE     �  CREATE TABLE public."uiSchemaTemplates" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255),
    "componentName" character varying(255),
    "associationName" character varying(255),
    "resourceName" character varying(255),
    "collectionName" character varying(255),
    "dataSourceKey" character varying(255),
    uid character varying(255)
);
 '   DROP TABLE public."uiSchemaTemplates";
       public         heap    postgres    false    6                       1259    20435    uiSchemaTreePath    TABLE     �   CREATE TABLE public."uiSchemaTreePath" (
    ancestor character varying(255) NOT NULL,
    descendant character varying(255) NOT NULL,
    depth integer,
    async boolean,
    type character varying(255),
    sort integer
);
 &   DROP TABLE public."uiSchemaTreePath";
       public         heap    postgres    false    6                       0    0    COLUMN "uiSchemaTreePath".type    COMMENT     D   COMMENT ON COLUMN public."uiSchemaTreePath".type IS 'type of node';
          public          postgres    false    283                       0    0    COLUMN "uiSchemaTreePath".sort    COMMENT     Q   COMMENT ON COLUMN public."uiSchemaTreePath".sort IS 'sort of node in adjacency';
          public          postgres    false    283                       1259    20440 	   uiSchemas    TABLE     �   CREATE TABLE public."uiSchemas" (
    "x-uid" character varying(255) NOT NULL,
    name character varying(255),
    schema json DEFAULT '{}'::json
);
    DROP TABLE public."uiSchemas";
       public         heap    postgres    false    6            -           1259    20856    userDataSyncRecords    TABLE     l  CREATE TABLE public."userDataSyncRecords" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "sourceName" character varying(255) NOT NULL,
    "sourceUk" character varying(255) NOT NULL,
    "dataType" character varying(255) NOT NULL,
    "metaData" json,
    "lastMetaData" json
);
 )   DROP TABLE public."userDataSyncRecords";
       public         heap    postgres    false    6            +           1259    20846    userDataSyncRecordsResources    TABLE     #  CREATE TABLE public."userDataSyncRecordsResources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "recordId" bigint,
    resource character varying(255) NOT NULL,
    "resourcePk" character varying(255)
);
 2   DROP TABLE public."userDataSyncRecordsResources";
       public         heap    postgres    false    6            *           1259    20845 #   userDataSyncRecordsResources_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userDataSyncRecordsResources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."userDataSyncRecordsResources_id_seq";
       public          postgres    false    6    299                       0    0 #   userDataSyncRecordsResources_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public."userDataSyncRecordsResources_id_seq" OWNED BY public."userDataSyncRecordsResources".id;
          public          postgres    false    298            ,           1259    20855    userDataSyncRecords_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userDataSyncRecords_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."userDataSyncRecords_id_seq";
       public          postgres    false    301    6                       0    0    userDataSyncRecords_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."userDataSyncRecords_id_seq" OWNED BY public."userDataSyncRecords".id;
          public          postgres    false    300            /           1259    20865    userDataSyncSources    TABLE     �  CREATE TABLE public."userDataSyncSources" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "sourceType" character varying(255) NOT NULL,
    "displayName" character varying(255),
    enabled boolean DEFAULT false,
    options json DEFAULT '{}'::json NOT NULL,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);
 )   DROP TABLE public."userDataSyncSources";
       public         heap    postgres    false    6            .           1259    20864    userDataSyncSources_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userDataSyncSources_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."userDataSyncSources_id_seq";
       public          postgres    false    6    303                       0    0    userDataSyncSources_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."userDataSyncSources_id_seq" OWNED BY public."userDataSyncSources".id;
          public          postgres    false    302            1           1259    20879    userDataSyncTasks    TABLE     �  CREATE TABLE public."userDataSyncTasks" (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    batch character varying(255) NOT NULL,
    "sourceId" bigint,
    status character varying(255) NOT NULL,
    message character varying(255),
    cost integer,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint
);
 '   DROP TABLE public."userDataSyncTasks";
       public         heap    postgres    false    6            0           1259    20878    userDataSyncTasks_id_seq    SEQUENCE     �   CREATE SEQUENCE public."userDataSyncTasks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."userDataSyncTasks_id_seq";
       public          postgres    false    6    305            	           0    0    userDataSyncTasks_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."userDataSyncTasks_id_seq" OWNED BY public."userDataSyncTasks".id;
          public          postgres    false    304                       1259    20446    users    TABLE       CREATE TABLE public.users (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    nickname character varying(255),
    username character varying(255),
    email character varying(255),
    phone character varying(255),
    password character varying(255),
    "appLang" character varying(255),
    "resetToken" character varying(255),
    "systemSettings" json DEFAULT '{}'::json,
    sort bigint,
    "createdById" bigint,
    "updatedById" bigint,
    "passwordChangeTz" bigint
);
    DROP TABLE public.users;
       public         heap    postgres    false    6                       1259    20452    usersAuthenticators    TABLE     �  CREATE TABLE public."usersAuthenticators" (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    authenticator character varying(255) NOT NULL,
    "userId" bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    nickname character varying(255) DEFAULT ''::character varying NOT NULL,
    avatar character varying(255) DEFAULT ''::character varying NOT NULL,
    meta json DEFAULT '{}'::json,
    "createdById" bigint,
    "updatedById" bigint
);
 )   DROP TABLE public."usersAuthenticators";
       public         heap    postgres    false    6                       1259    20460    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    285    6            
           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    287                        1259    20461 
   users_jobs    TABLE     8  CREATE TABLE public.users_jobs (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "jobId" bigint,
    "userId" bigint,
    "executionId" bigint,
    "nodeId" bigint,
    "workflowId" bigint,
    status integer,
    result jsonb
);
    DROP TABLE public.users_jobs;
       public         heap    postgres    false    6            !           1259    20466    users_jobs_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_jobs_id_seq;
       public          postgres    false    6    288                       0    0    users_jobs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_jobs_id_seq OWNED BY public.users_jobs.id;
          public          postgres    false    289            "           1259    20467    verifications    TABLE     }  CREATE TABLE public.verifications (
    id uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    type character varying(255),
    receiver character varying(255),
    status integer DEFAULT 0,
    "expiresAt" timestamp with time zone,
    content character varying(255),
    "providerId" character varying(255)
);
 !   DROP TABLE public.verifications;
       public         heap    postgres    false    6            #           1259    20473    verifications_providers    TABLE     +  CREATE TABLE public.verifications_providers (
    id character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    title character varying(255),
    type character varying(255),
    options jsonb,
    "default" boolean
);
 +   DROP TABLE public.verifications_providers;
       public         heap    postgres    false    6            $           1259    20478 	   workflows    TABLE     <  CREATE TABLE public.workflows (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255),
    title character varying(255),
    enabled boolean DEFAULT false,
    description text,
    type character varying(255),
    "triggerTitle" character varying(255),
    config jsonb DEFAULT '{}'::jsonb,
    executed integer DEFAULT 0,
    "allExecuted" integer DEFAULT 0,
    current boolean DEFAULT false,
    sync boolean DEFAULT false,
    options jsonb DEFAULT '{}'::jsonb
);
    DROP TABLE public.workflows;
       public         heap    postgres    false    6            %           1259    20490    workflows_id_seq    SEQUENCE     y   CREATE SEQUENCE public.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.workflows_id_seq;
       public          postgres    false    292    6                       0    0    workflows_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;
          public          postgres    false    293            �           2604    20491    applicationPlugins id    DEFAULT     �   ALTER TABLE ONLY public."applicationPlugins" ALTER COLUMN id SET DEFAULT nextval('public."applicationPlugins_id_seq"'::regclass);
 F   ALTER TABLE public."applicationPlugins" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    213            �           2604    20492    applicationVersion id    DEFAULT     �   ALTER TABLE ONLY public."applicationVersion" ALTER COLUMN id SET DEFAULT nextval('public."applicationVersion_id_seq"'::regclass);
 F   ALTER TABLE public."applicationVersion" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    20493    attachments id    DEFAULT     p   ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);
 =   ALTER TABLE public.attachments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            �           2604    20494    authenticators id    DEFAULT     v   ALTER TABLE ONLY public.authenticators ALTER COLUMN id SET DEFAULT nextval('public.authenticators_id_seq'::regclass);
 @   ALTER TABLE public.authenticators ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �           2604    20495    collectionCategories id    DEFAULT     �   ALTER TABLE ONLY public."collectionCategories" ALTER COLUMN id SET DEFAULT nextval('public."collectionCategories_id_seq"'::regclass);
 H   ALTER TABLE public."collectionCategories" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222            �           2604    20496    dataSourcesRolesResources id    DEFAULT     �   ALTER TABLE ONLY public."dataSourcesRolesResources" ALTER COLUMN id SET DEFAULT nextval('public."dataSourcesRolesResources_id_seq"'::regclass);
 M   ALTER TABLE public."dataSourcesRolesResources" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    232            �           2604    20497 #   dataSourcesRolesResourcesActions id    DEFAULT     �   ALTER TABLE ONLY public."dataSourcesRolesResourcesActions" ALTER COLUMN id SET DEFAULT nextval('public."dataSourcesRolesResourcesActions_id_seq"'::regclass);
 T   ALTER TABLE public."dataSourcesRolesResourcesActions" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233            �           2604    20498 "   dataSourcesRolesResourcesScopes id    DEFAULT     �   ALTER TABLE ONLY public."dataSourcesRolesResourcesScopes" ALTER COLUMN id SET DEFAULT nextval('public."dataSourcesRolesResourcesScopes_id_seq"'::regclass);
 S   ALTER TABLE public."dataSourcesRolesResourcesScopes" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            �           2604    20499    executions id    DEFAULT     n   ALTER TABLE ONLY public.executions ALTER COLUMN id SET DEFAULT nextval('public.executions_id_seq'::regclass);
 <   ALTER TABLE public.executions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    239    238            �           2604    20500    flow_nodes id    DEFAULT     n   ALTER TABLE ONLY public.flow_nodes ALTER COLUMN id SET DEFAULT nextval('public.flow_nodes_id_seq'::regclass);
 <   ALTER TABLE public.flow_nodes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    242    241            �           2604    20501    graphPositions id    DEFAULT     z   ALTER TABLE ONLY public."graphPositions" ALTER COLUMN id SET DEFAULT nextval('public."graphPositions_id_seq"'::regclass);
 B   ALTER TABLE public."graphPositions" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    244    243            �           2604    20502    hello id    DEFAULT     d   ALTER TABLE ONLY public.hello ALTER COLUMN id SET DEFAULT nextval('public.hello_id_seq'::regclass);
 7   ALTER TABLE public.hello ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    246    245            �           2604    20503    jobs id    DEFAULT     b   ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);
 6   ALTER TABLE public.jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    248            �           2604    20827    mobileRoutes id    DEFAULT     v   ALTER TABLE ONLY public."mobileRoutes" ALTER COLUMN id SET DEFAULT nextval('public."mobileRoutes_id_seq"'::regclass);
 @   ALTER TABLE public."mobileRoutes" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    295    294    295            �           2604    20504    rolesResources id    DEFAULT     z   ALTER TABLE ONLY public."rolesResources" ALTER COLUMN id SET DEFAULT nextval('public."rolesResources_id_seq"'::regclass);
 B   ALTER TABLE public."rolesResources" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    257    252            �           2604    20505    rolesResourcesActions id    DEFAULT     �   ALTER TABLE ONLY public."rolesResourcesActions" ALTER COLUMN id SET DEFAULT nextval('public."rolesResourcesActions_id_seq"'::regclass);
 I   ALTER TABLE public."rolesResourcesActions" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    254    253            �           2604    20506    rolesResourcesScopes id    DEFAULT     �   ALTER TABLE ONLY public."rolesResourcesScopes" ALTER COLUMN id SET DEFAULT nextval('public."rolesResourcesScopes_id_seq"'::regclass);
 H   ALTER TABLE public."rolesResourcesScopes" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    256    255            �           2604    20507    sequences id    DEFAULT     l   ALTER TABLE ONLY public.sequences ALTER COLUMN id SET DEFAULT nextval('public.sequences_id_seq'::regclass);
 ;   ALTER TABLE public.sequences ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    261    260            �           2604    20508    storages id    DEFAULT     j   ALTER TABLE ONLY public.storages ALTER COLUMN id SET DEFAULT nextval('public.storages_id_seq'::regclass);
 :   ALTER TABLE public.storages ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    263    262            �           2604    20509    systemSettings id    DEFAULT     z   ALTER TABLE ONLY public."systemSettings" ALTER COLUMN id SET DEFAULT nextval('public."systemSettings_id_seq"'::regclass);
 B   ALTER TABLE public."systemSettings" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    265    264            �           2604    20510    t_job_execute id    DEFAULT     t   ALTER TABLE ONLY public.t_job_execute ALTER COLUMN id SET DEFAULT nextval('public.t_job_execute_id_seq'::regclass);
 ?   ALTER TABLE public.t_job_execute ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267            �           2604    20511    t_job_execute_view id    DEFAULT     ~   ALTER TABLE ONLY public.t_job_execute_view ALTER COLUMN id SET DEFAULT nextval('public.t_job_execute_view_id_seq'::regclass);
 D   ALTER TABLE public.t_job_execute_view ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    270    269            �           2604    20512    t_job_meta id    DEFAULT     n   ALTER TABLE ONLY public.t_job_meta ALTER COLUMN id SET DEFAULT nextval('public.t_job_meta_id_seq'::regclass);
 <   ALTER TABLE public.t_job_meta ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271            �           2604    20513    t_job_record id    DEFAULT     r   ALTER TABLE ONLY public.t_job_record ALTER COLUMN id SET DEFAULT nextval('public.t_job_record_id_seq'::regclass);
 >   ALTER TABLE public.t_job_record ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    274    273            �           2604    20514    t_key_word_search id    DEFAULT     |   ALTER TABLE ONLY public.t_key_word_search ALTER COLUMN id SET DEFAULT nextval('public.t_key_word_search_id_seq'::regclass);
 C   ALTER TABLE public.t_key_word_search ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    276    275                       2604    21318    themeConfig id    DEFAULT     t   ALTER TABLE ONLY public."themeConfig" ALTER COLUMN id SET DEFAULT nextval('public."themeConfig_id_seq"'::regclass);
 ?   ALTER TABLE public."themeConfig" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    310    309    310            �           2604    20515    tokenBlacklist id    DEFAULT     z   ALTER TABLE ONLY public."tokenBlacklist" ALTER COLUMN id SET DEFAULT nextval('public."tokenBlacklist_id_seq"'::regclass);
 B   ALTER TABLE public."tokenBlacklist" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    20516    uiSchemaServerHooks id    DEFAULT     �   ALTER TABLE ONLY public."uiSchemaServerHooks" ALTER COLUMN id SET DEFAULT nextval('public."uiSchemaServerHooks_id_seq"'::regclass);
 G   ALTER TABLE public."uiSchemaServerHooks" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    280            �           2604    20859    userDataSyncRecords id    DEFAULT     �   ALTER TABLE ONLY public."userDataSyncRecords" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncRecords_id_seq"'::regclass);
 G   ALTER TABLE public."userDataSyncRecords" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            �           2604    20849    userDataSyncRecordsResources id    DEFAULT     �   ALTER TABLE ONLY public."userDataSyncRecordsResources" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncRecordsResources_id_seq"'::regclass);
 P   ALTER TABLE public."userDataSyncRecordsResources" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299                        2604    20868    userDataSyncSources id    DEFAULT     �   ALTER TABLE ONLY public."userDataSyncSources" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncSources_id_seq"'::regclass);
 G   ALTER TABLE public."userDataSyncSources" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303                       2604    20882    userDataSyncTasks id    DEFAULT     �   ALTER TABLE ONLY public."userDataSyncTasks" ALTER COLUMN id SET DEFAULT nextval('public."userDataSyncTasks_id_seq"'::regclass);
 E   ALTER TABLE public."userDataSyncTasks" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            �           2604    20517    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    287    285            �           2604    20518    users_jobs id    DEFAULT     n   ALTER TABLE ONLY public.users_jobs ALTER COLUMN id SET DEFAULT nextval('public.users_jobs_id_seq'::regclass);
 <   ALTER TABLE public.users_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    289    288            �           2604    20519    workflows id    DEFAULT     l   ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);
 ;   ALTER TABLE public.workflows ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    293    292            p          0    20166    applicationPlugins 
   TABLE DATA           �   COPY public."applicationPlugins" (id, "createdAt", "updatedAt", name, "packageName", version, enabled, installed, "builtIn", options) FROM stdin;
    public          postgres    false    213   �;      r          0    20172    applicationVersion 
   TABLE DATA           9   COPY public."applicationVersion" (id, value) FROM stdin;
    public          postgres    false    215   6A      t          0    20176    attachments 
   TABLE DATA           �   COPY public.attachments (id, "createdAt", "updatedAt", title, filename, extname, size, mimetype, "storageId", path, meta, url, "createdById", "updatedById") FROM stdin;
    public          postgres    false    217   \A      v          0    20183    authenticators 
   TABLE DATA           �   COPY public.authenticators (id, "createdAt", "updatedAt", name, "authType", title, description, options, enabled, sort, "createdById", "updatedById") FROM stdin;
    public          postgres    false    219   hC      x          0    20192    chinaRegions 
   TABLE DATA           c   COPY public."chinaRegions" ("createdAt", "updatedAt", code, name, "parentCode", level) FROM stdin;
    public          postgres    false    221   �C      y          0    20197    collectionCategories 
   TABLE DATA           a   COPY public."collectionCategories" (id, "createdAt", "updatedAt", name, color, sort) FROM stdin;
    public          postgres    false    222   .�      {          0    20204    collectionCategory 
   TABLE DATA           h   COPY public."collectionCategory" ("createdAt", "updatedAt", "collectionName", "categoryId") FROM stdin;
    public          postgres    false    224   ��      |          0    20207    collections 
   TABLE DATA           d   COPY public.collections (key, name, title, inherit, hidden, options, description, sort) FROM stdin;
    public          postgres    false    225   u�      }          0    20215    customRequests 
   TABLE DATA           R   COPY public."customRequests" ("createdAt", "updatedAt", key, options) FROM stdin;
    public          postgres    false    226   ��      ~          0    20220    customRequestsRoles 
   TABLE DATA           i   COPY public."customRequestsRoles" ("createdAt", "updatedAt", "customRequestKey", "roleName") FROM stdin;
    public          postgres    false    227   ��                0    20225    dataSources 
   TABLE DATA           t   COPY public."dataSources" ("createdAt", "updatedAt", key, "displayName", type, options, enabled, fixed) FROM stdin;
    public          postgres    false    228   ��      �          0    20232    dataSourcesCollections 
   TABLE DATA           W   COPY public."dataSourcesCollections" (key, name, options, "dataSourceKey") FROM stdin;
    public          postgres    false    229   ��      �          0    20237    dataSourcesFields 
   TABLE DATA           �   COPY public."dataSourcesFields" (key, name, "collectionName", interface, description, "uiSchema", "collectionKey", options, "dataSourceKey") FROM stdin;
    public          postgres    false    230   �      �          0    20243    dataSourcesRoles 
   TABLE DATA           W   COPY public."dataSourcesRoles" (id, strategy, "dataSourceKey", "roleName") FROM stdin;
    public          postgres    false    231   9�      �          0    20248    dataSourcesRolesResources 
   TABLE DATA           �   COPY public."dataSourcesRolesResources" (id, "createdAt", "updatedAt", "dataSourceKey", name, "usingActionsConfig", "roleName") FROM stdin;
    public          postgres    false    232   ��      �          0    20254     dataSourcesRolesResourcesActions 
   TABLE DATA           �   COPY public."dataSourcesRolesResourcesActions" (id, "createdAt", "updatedAt", name, fields, "scopeId", "rolesResourceId") FROM stdin;
    public          postgres    false    233   .�      �          0    20261    dataSourcesRolesResourcesScopes 
   TABLE DATA           �   COPY public."dataSourcesRolesResourcesScopes" (id, "createdAt", "updatedAt", key, "dataSourceKey", name, "resourceName", scope) FROM stdin;
    public          postgres    false    235   �      �          0    20269 
   executions 
   TABLE DATA           r   COPY public.executions (id, "createdAt", "updatedAt", key, "eventKey", context, status, "workflowId") FROM stdin;
    public          postgres    false    238   ��      �          0    20275    fields 
   TABLE DATA           �   COPY public.fields (key, name, type, interface, description, "collectionName", "parentKey", "reverseKey", options, sort) FROM stdin;
    public          postgres    false    240   ��      �          0    20281 
   flow_nodes 
   TABLE DATA           �   COPY public.flow_nodes (id, "createdAt", "updatedAt", key, title, "upstreamId", "branchIndex", "downstreamId", type, config, "workflowId") FROM stdin;
    public          postgres    false    241   ��      �          0    20288    graphPositions 
   TABLE DATA           `   COPY public."graphPositions" (id, "createdAt", "updatedAt", "collectionName", x, y) FROM stdin;
    public          postgres    false    243   ��      �          0    20292    hello 
   TABLE DATA           C   COPY public.hello (id, "createdAt", "updatedAt", name) FROM stdin;
    public          postgres    false    245   ��      �          0    20296 
   iframeHtml 
   TABLE DATA           h   COPY public."iframeHtml" (id, "createdAt", "updatedAt", html, "createdById", "updatedById") FROM stdin;
    public          postgres    false    247   ,�      �          0    20301    jobs 
   TABLE DATA           ~   COPY public.jobs (id, "createdAt", "updatedAt", "executionId", "nodeId", "nodeKey", "upstreamId", status, result) FROM stdin;
    public          postgres    false    248   I�      �          0    20833    main_mobileRoutes_path 
   TABLE DATA           L   COPY public."main_mobileRoutes_path" ("nodePk", path, "rootPk") FROM stdin;
    public          postgres    false    296   f�      �          0    20307 
   migrations 
   TABLE DATA           *   COPY public.migrations (name) FROM stdin;
    public          postgres    false    250   ��      �          0    20824    mobileRoutes 
   TABLE DATA           �   COPY public."mobileRoutes" (id, "createdAt", "updatedAt", "parentId", title, icon, "schemaUid", type, options, sort, "createdById", "updatedById") FROM stdin;
    public          postgres    false    295   ��      �          0    20891    notificationChannels 
   TABLE DATA           �   COPY public."notificationChannels" ("createdAt", "updatedAt", name, title, options, meta, "notificationType", description, "createdById", "updatedById") FROM stdin;
    public          postgres    false    306   �      �          0    20906    notificationInAppMessages 
   TABLE DATA           �   COPY public."notificationInAppMessages" (id, "createdAt", "updatedAt", "userId", "channelName", title, content, status, "receiveTimestamp", options) FROM stdin;
    public          postgres    false    308   $�      �          0    20899    notificationSendLogs 
   TABLE DATA           �   COPY public."notificationSendLogs" (id, "createdAt", "updatedAt", "channelName", "channelTitle", "triggerFrom", "notificationType", status, message, reason) FROM stdin;
    public          postgres    false    307   A�      �          0    20310    roles 
   TABLE DATA           �   COPY public.roles ("createdAt", "updatedAt", name, title, description, strategy, "default", hidden, "allowConfigure", "allowNewMenu", snippets, sort, "allowNewMobileMenu") FROM stdin;
    public          postgres    false    251   ^�      �          0    20839    rolesMobileRoutes 
   TABLE DATA           d   COPY public."rolesMobileRoutes" ("createdAt", "updatedAt", "mobileRouteId", "roleName") FROM stdin;
    public          postgres    false    297   h�      �          0    20318    rolesResources 
   TABLE DATA           p   COPY public."rolesResources" (id, "createdAt", "updatedAt", "roleName", name, "usingActionsConfig") FROM stdin;
    public          postgres    false    252   ��      �          0    20323    rolesResourcesActions 
   TABLE DATA           {   COPY public."rolesResourcesActions" (id, "createdAt", "updatedAt", "rolesResourceId", name, fields, "scopeId") FROM stdin;
    public          postgres    false    253   ��      �          0    20330    rolesResourcesScopes 
   TABLE DATA           p   COPY public."rolesResourcesScopes" (id, "createdAt", "updatedAt", key, name, "resourceName", scope) FROM stdin;
    public          postgres    false    255   ��      �          0    20337    rolesUischemas 
   TABLE DATA           `   COPY public."rolesUischemas" ("createdAt", "updatedAt", "roleName", "uiSchemaXUid") FROM stdin;
    public          postgres    false    258   ��      �          0    20342 
   rolesUsers 
   TABLE DATA           a   COPY public."rolesUsers" ("createdAt", "updatedAt", "default", "roleName", "userId") FROM stdin;
    public          postgres    false    259   d�      �          0    20345 	   sequences 
   TABLE DATA           u   COPY public.sequences (id, "createdAt", "updatedAt", collection, field, key, current, "lastGeneratedAt") FROM stdin;
    public          postgres    false    260   ��      �          0    20351    storages 
   TABLE DATA           �   COPY public.storages (id, "createdAt", "updatedAt", title, name, type, options, rules, path, "baseUrl", "default", paranoid) FROM stdin;
    public          postgres    false    262   �      �          0    20363    systemSettings 
   TABLE DATA           �   COPY public."systemSettings" (id, "createdAt", "updatedAt", title, "showLogoOnly", "allowSignUp", "smsAuthEnabled", "logoId", "enabledLanguages", "appLang", options, "enableEditProfile", "enableChangePassword") FROM stdin;
    public          postgres    false    264   ��      �          0    20373    t_5b605e856ok 
   TABLE DATA           _   COPY public.t_5b605e856ok ("createdAt", "updatedAt", f_u97bd0zhaxy, f_je0bovkl4j2) FROM stdin;
    public          postgres    false    266   �      �          0    20376    t_job_execute 
   TABLE DATA           �  COPY public.t_job_execute (id, "createdById", "updatedById", namespace, image, command, cron, result_table_name, execute_name, data_size, "createdAt", created_at, key_word, begin_time, end_time, "updatedAt", job_status, job_type, job_group, f_meta_id, meta_id, meta_name, parallel_num, execute_count, env_args, exe_args, ignore_word, app_label_name, job_label_name, finish_count, fail_count, project_name, storage_flag) FROM stdin;
    public          postgres    false    267   <�      �          0    20389    t_job_execute_view 
   TABLE DATA           �   COPY public.t_job_execute_view (id, execute_name, job_type, key_word, begin_time, end_time, cron, f_meta_id, parallel_num, ignore_word, project_name, storage_flag) FROM stdin;
    public          postgres    false    269   ��      �          0    20397 
   t_job_meta 
   TABLE DATA           =  COPY public.t_job_meta ("createdAt", "updatedAt", id, "createdById", "updatedById", command, namespace, image_name, meta_name, f_u1dygf73ly9, f_styaowp9srm, env_args, exe_args, language, label_name, plugin_path, lable_name, repo_url, repo_username, repo_password, repo_branch, repo_token, repo_user_name) FROM stdin;
    public          postgres    false    271   ��      �          0    20403    t_job_record 
   TABLE DATA           �  COPY public.t_job_record (id, flag_main, target_obj_id, key_word, execute_id, web_site, title, content, label, subject, author, record_url, msg_time, take_time, fans_count, interest_count, user_id, user_homepage, user_level, execute_name, "createdAt", record_ur, active_count, read_count, like_count, coin_count, mark_count, share_count, comments_count, barrage_count, tag, comment, commenter_name, comment_time, user_member, user_likes, user_describe, developer_word, android_last_update, ios_last_update, mark, data_type, book_count, down_count, download_count, book_num, ignore_word, comment_reply_num, project_name, storage_flag) FROM stdin;
    public          postgres    false    273   ��      �          0    20409    t_key_word_search 
   TABLE DATA           x   COPY public.t_key_word_search (id, key_word, mask_word, start_date, end_data, execute_name, cron, job_type) FROM stdin;
    public          postgres    false    275   4�      �          0    20417    t_xfztfz2cag0 
   TABLE DATA           _   COPY public.t_xfztfz2cag0 ("createdAt", "updatedAt", f_6d2sjvn53y4, f_m0dcmr7kq5r) FROM stdin;
    public          postgres    false    277   ��      �          0    21315    themeConfig 
   TABLE DATA           t   COPY public."themeConfig" (id, "createdAt", "updatedAt", config, optional, "isBuiltIn", uid, "default") FROM stdin;
    public          postgres    false    310   ��      �          0    20420    tokenBlacklist 
   TABLE DATA           [   COPY public."tokenBlacklist" (id, "createdAt", "updatedAt", token, expiration) FROM stdin;
    public          postgres    false    278   w�      �          0    20424    uiSchemaServerHooks 
   TABLE DATA           a   COPY public."uiSchemaServerHooks" (id, uid, type, collection, field, method, params) FROM stdin;
    public          postgres    false    280   ��      �          0    20430    uiSchemaTemplates 
   TABLE DATA           �   COPY public."uiSchemaTemplates" ("createdAt", "updatedAt", key, name, "componentName", "associationName", "resourceName", "collectionName", "dataSourceKey", uid) FROM stdin;
    public          postgres    false    282   ��      �          0    20435    uiSchemaTreePath 
   TABLE DATA           \   COPY public."uiSchemaTreePath" (ancestor, descendant, depth, async, type, sort) FROM stdin;
    public          postgres    false    283   x�      �          0    20440 	   uiSchemas 
   TABLE DATA           <   COPY public."uiSchemas" ("x-uid", name, schema) FROM stdin;
    public          postgres    false    284   ݈      �          0    20856    userDataSyncRecords 
   TABLE DATA           �   COPY public."userDataSyncRecords" (id, "createdAt", "updatedAt", "sourceName", "sourceUk", "dataType", "metaData", "lastMetaData") FROM stdin;
    public          postgres    false    301   z�      �          0    20846    userDataSyncRecordsResources 
   TABLE DATA           z   COPY public."userDataSyncRecordsResources" (id, "createdAt", "updatedAt", "recordId", resource, "resourcePk") FROM stdin;
    public          postgres    false    299   ��      �          0    20865    userDataSyncSources 
   TABLE DATA           �   COPY public."userDataSyncSources" (id, "createdAt", "updatedAt", name, "sourceType", "displayName", enabled, options, sort, "createdById", "updatedById") FROM stdin;
    public          postgres    false    303   ��      �          0    20879    userDataSyncTasks 
   TABLE DATA           �   COPY public."userDataSyncTasks" (id, "createdAt", "updatedAt", batch, "sourceId", status, message, cost, sort, "createdById", "updatedById") FROM stdin;
    public          postgres    false    305   ��      �          0    20446    users 
   TABLE DATA           �   COPY public.users (id, "createdAt", "updatedAt", nickname, username, email, phone, password, "appLang", "resetToken", "systemSettings", sort, "createdById", "updatedById", "passwordChangeTz") FROM stdin;
    public          postgres    false    285   ��      �          0    20452    usersAuthenticators 
   TABLE DATA           �   COPY public."usersAuthenticators" ("createdAt", "updatedAt", authenticator, "userId", uuid, nickname, avatar, meta, "createdById", "updatedById") FROM stdin;
    public          postgres    false    286   6�      �          0    20461 
   users_jobs 
   TABLE DATA           �   COPY public.users_jobs (id, "createdAt", "updatedAt", "jobId", "userId", "executionId", "nodeId", "workflowId", status, result) FROM stdin;
    public          postgres    false    288   S�      �          0    20467    verifications 
   TABLE DATA           �   COPY public.verifications (id, "createdAt", "updatedAt", type, receiver, status, "expiresAt", content, "providerId") FROM stdin;
    public          postgres    false    290   p�      �          0    20473    verifications_providers 
   TABLE DATA           p   COPY public.verifications_providers (id, "createdAt", "updatedAt", title, type, options, "default") FROM stdin;
    public          postgres    false    291   ��      �          0    20478 	   workflows 
   TABLE DATA           �   COPY public.workflows (id, "createdAt", "updatedAt", key, title, enabled, description, type, "triggerTitle", config, executed, "allExecuted", current, sync, options) FROM stdin;
    public          postgres    false    292   ��                 0    0    applicationPlugins_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."applicationPlugins_id_seq"', 61, true);
          public          postgres    false    214                       0    0    applicationVersion_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."applicationVersion_id_seq"', 9, true);
          public          postgres    false    216                       0    0    attachments_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.attachments_id_seq', 8, true);
          public          postgres    false    218                       0    0    authenticators_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.authenticators_id_seq', 1, true);
          public          postgres    false    220                       0    0    collectionCategories_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."collectionCategories_id_seq"', 3, true);
          public          postgres    false    223                       0    0 '   dataSourcesRolesResourcesActions_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public."dataSourcesRolesResourcesActions_id_seq"', 1, true);
          public          postgres    false    234                       0    0 &   dataSourcesRolesResourcesScopes_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public."dataSourcesRolesResourcesScopes_id_seq"', 2, true);
          public          postgres    false    236                       0    0     dataSourcesRolesResources_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."dataSourcesRolesResources_id_seq"', 1, true);
          public          postgres    false    237                       0    0    executions_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.executions_id_seq', 12, true);
          public          postgres    false    239                       0    0    flow_nodes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.flow_nodes_id_seq', 12, true);
          public          postgres    false    242                       0    0    graphPositions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."graphPositions_id_seq"', 8, true);
          public          postgres    false    244                       0    0    hello_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.hello_id_seq', 1, true);
          public          postgres    false    246                       0    0    jobs_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.jobs_id_seq', 12, true);
          public          postgres    false    249                       0    0    mobileRoutes_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."mobileRoutes_id_seq"', 1, false);
          public          postgres    false    294                       0    0    rolesResourcesActions_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."rolesResourcesActions_id_seq"', 1, false);
          public          postgres    false    254                       0    0    rolesResourcesScopes_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."rolesResourcesScopes_id_seq"', 1, false);
          public          postgres    false    256                       0    0    rolesResources_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."rolesResources_id_seq"', 1, false);
          public          postgres    false    257                       0    0    sequences_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sequences_id_seq', 1, false);
          public          postgres    false    261                       0    0    storages_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.storages_id_seq', 1, true);
          public          postgres    false    263                        0    0    systemSettings_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."systemSettings_id_seq"', 1, true);
          public          postgres    false    265            !           0    0    t_job_execute_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.t_job_execute_id_seq', 281, true);
          public          postgres    false    268            "           0    0    t_job_execute_view_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.t_job_execute_view_id_seq', 1, false);
          public          postgres    false    270            #           0    0    t_job_meta_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.t_job_meta_id_seq', 14, true);
          public          postgres    false    272            $           0    0    t_job_record_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.t_job_record_id_seq', 130436, true);
          public          postgres    false    274            %           0    0    t_key_word_search_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.t_key_word_search_id_seq', 14, true);
          public          postgres    false    276            &           0    0    themeConfig_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."themeConfig_id_seq"', 4, true);
          public          postgres    false    309            '           0    0    tokenBlacklist_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."tokenBlacklist_id_seq"', 23, true);
          public          postgres    false    279            (           0    0    uiSchemaServerHooks_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."uiSchemaServerHooks_id_seq"', 1, false);
          public          postgres    false    281            )           0    0 #   userDataSyncRecordsResources_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."userDataSyncRecordsResources_id_seq"', 1, false);
          public          postgres    false    298            *           0    0    userDataSyncRecords_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."userDataSyncRecords_id_seq"', 1, false);
          public          postgres    false    300            +           0    0    userDataSyncSources_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."userDataSyncSources_id_seq"', 1, false);
          public          postgres    false    302            ,           0    0    userDataSyncTasks_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."userDataSyncTasks_id_seq"', 1, false);
          public          postgres    false    304            -           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 3, true);
          public          postgres    false    287            .           0    0    users_jobs_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_jobs_id_seq', 1, false);
          public          postgres    false    289            /           0    0    workflows_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.workflows_id_seq', 4, true);
          public          postgres    false    293                       2606    20607 .   applicationPlugins applicationPlugins_name_key 
   CONSTRAINT     m   ALTER TABLE ONLY public."applicationPlugins"
    ADD CONSTRAINT "applicationPlugins_name_key" UNIQUE (name);
 \   ALTER TABLE ONLY public."applicationPlugins" DROP CONSTRAINT "applicationPlugins_name_key";
       public            postgres    false    213            	           2606    20609 5   applicationPlugins applicationPlugins_packageName_key 
   CONSTRAINT     }   ALTER TABLE ONLY public."applicationPlugins"
    ADD CONSTRAINT "applicationPlugins_packageName_key" UNIQUE ("packageName");
 c   ALTER TABLE ONLY public."applicationPlugins" DROP CONSTRAINT "applicationPlugins_packageName_key";
       public            postgres    false    213                       2606    20611 *   applicationPlugins applicationPlugins_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."applicationPlugins"
    ADD CONSTRAINT "applicationPlugins_pkey" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."applicationPlugins" DROP CONSTRAINT "applicationPlugins_pkey";
       public            postgres    false    213                       2606    20613 *   applicationVersion applicationVersion_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."applicationVersion"
    ADD CONSTRAINT "applicationVersion_pkey" PRIMARY KEY (id);
 X   ALTER TABLE ONLY public."applicationVersion" DROP CONSTRAINT "applicationVersion_pkey";
       public            postgres    false    215                       2606    20615    attachments attachments_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.attachments DROP CONSTRAINT attachments_pkey;
       public            postgres    false    217                       2606    20617 &   authenticators authenticators_name_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.authenticators
    ADD CONSTRAINT authenticators_name_key UNIQUE (name);
 P   ALTER TABLE ONLY public.authenticators DROP CONSTRAINT authenticators_name_key;
       public            postgres    false    219                       2606    20619 "   authenticators authenticators_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.authenticators
    ADD CONSTRAINT authenticators_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.authenticators DROP CONSTRAINT authenticators_pkey;
       public            postgres    false    219                       2606    20621    chinaRegions chinaRegions_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."chinaRegions"
    ADD CONSTRAINT "chinaRegions_pkey" PRIMARY KEY (code);
 L   ALTER TABLE ONLY public."chinaRegions" DROP CONSTRAINT "chinaRegions_pkey";
       public            postgres    false    221                       2606    20623 .   collectionCategories collectionCategories_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."collectionCategories"
    ADD CONSTRAINT "collectionCategories_pkey" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."collectionCategories" DROP CONSTRAINT "collectionCategories_pkey";
       public            postgres    false    222                       2606    20625 *   collectionCategory collectionCategory_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."collectionCategory"
    ADD CONSTRAINT "collectionCategory_pkey" PRIMARY KEY ("collectionName", "categoryId");
 X   ALTER TABLE ONLY public."collectionCategory" DROP CONSTRAINT "collectionCategory_pkey";
       public            postgres    false    224    224                        2606    20627     collections collections_name_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_name_key UNIQUE (name);
 J   ALTER TABLE ONLY public.collections DROP CONSTRAINT collections_name_key;
       public            postgres    false    225            "           2606    20629    collections collections_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (key);
 F   ALTER TABLE ONLY public.collections DROP CONSTRAINT collections_pkey;
       public            postgres    false    225            &           2606    20631 ,   customRequestsRoles customRequestsRoles_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."customRequestsRoles"
    ADD CONSTRAINT "customRequestsRoles_pkey" PRIMARY KEY ("customRequestKey", "roleName");
 Z   ALTER TABLE ONLY public."customRequestsRoles" DROP CONSTRAINT "customRequestsRoles_pkey";
       public            postgres    false    227    227            $           2606    20633 "   customRequests customRequests_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."customRequests"
    ADD CONSTRAINT "customRequests_pkey" PRIMARY KEY (key);
 P   ALTER TABLE ONLY public."customRequests" DROP CONSTRAINT "customRequests_pkey";
       public            postgres    false    226            +           2606    20635 2   dataSourcesCollections dataSourcesCollections_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."dataSourcesCollections"
    ADD CONSTRAINT "dataSourcesCollections_pkey" PRIMARY KEY (key);
 `   ALTER TABLE ONLY public."dataSourcesCollections" DROP CONSTRAINT "dataSourcesCollections_pkey";
       public            postgres    false    229            /           2606    20637 (   dataSourcesFields dataSourcesFields_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public."dataSourcesFields"
    ADD CONSTRAINT "dataSourcesFields_pkey" PRIMARY KEY (key);
 V   ALTER TABLE ONLY public."dataSourcesFields" DROP CONSTRAINT "dataSourcesFields_pkey";
       public            postgres    false    230            <           2606    20639 F   dataSourcesRolesResourcesActions dataSourcesRolesResourcesActions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."dataSourcesRolesResourcesActions"
    ADD CONSTRAINT "dataSourcesRolesResourcesActions_pkey" PRIMARY KEY (id);
 t   ALTER TABLE ONLY public."dataSourcesRolesResourcesActions" DROP CONSTRAINT "dataSourcesRolesResourcesActions_pkey";
       public            postgres    false    233            @           2606    20641 D   dataSourcesRolesResourcesScopes dataSourcesRolesResourcesScopes_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."dataSourcesRolesResourcesScopes"
    ADD CONSTRAINT "dataSourcesRolesResourcesScopes_pkey" PRIMARY KEY (id);
 r   ALTER TABLE ONLY public."dataSourcesRolesResourcesScopes" DROP CONSTRAINT "dataSourcesRolesResourcesScopes_pkey";
       public            postgres    false    235            8           2606    20643 8   dataSourcesRolesResources dataSourcesRolesResources_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."dataSourcesRolesResources"
    ADD CONSTRAINT "dataSourcesRolesResources_pkey" PRIMARY KEY (id);
 f   ALTER TABLE ONLY public."dataSourcesRolesResources" DROP CONSTRAINT "dataSourcesRolesResources_pkey";
       public            postgres    false    232            4           2606    20645 &   dataSourcesRoles dataSourcesRoles_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."dataSourcesRoles"
    ADD CONSTRAINT "dataSourcesRoles_pkey" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."dataSourcesRoles" DROP CONSTRAINT "dataSourcesRoles_pkey";
       public            postgres    false    231            )           2606    20647    dataSources dataSources_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."dataSources"
    ADD CONSTRAINT "dataSources_pkey" PRIMARY KEY (key);
 J   ALTER TABLE ONLY public."dataSources" DROP CONSTRAINT "dataSources_pkey";
       public            postgres    false    228            C           2606    20649 "   executions executions_eventKey_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.executions
    ADD CONSTRAINT "executions_eventKey_key" UNIQUE ("eventKey");
 N   ALTER TABLE ONLY public.executions DROP CONSTRAINT "executions_eventKey_key";
       public            postgres    false    238            E           2606    20651    executions executions_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.executions
    ADD CONSTRAINT executions_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.executions DROP CONSTRAINT executions_pkey;
       public            postgres    false    238            J           2606    20653    fields fields_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (key);
 <   ALTER TABLE ONLY public.fields DROP CONSTRAINT fields_pkey;
       public            postgres    false    240            N           2606    20655    flow_nodes flow_nodes_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.flow_nodes
    ADD CONSTRAINT flow_nodes_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.flow_nodes DROP CONSTRAINT flow_nodes_pkey;
       public            postgres    false    241            R           2606    20657 0   graphPositions graphPositions_collectionName_key 
   CONSTRAINT     {   ALTER TABLE ONLY public."graphPositions"
    ADD CONSTRAINT "graphPositions_collectionName_key" UNIQUE ("collectionName");
 ^   ALTER TABLE ONLY public."graphPositions" DROP CONSTRAINT "graphPositions_collectionName_key";
       public            postgres    false    243            T           2606    20659 "   graphPositions graphPositions_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."graphPositions"
    ADD CONSTRAINT "graphPositions_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."graphPositions" DROP CONSTRAINT "graphPositions_pkey";
       public            postgres    false    243            V           2606    20661    hello hello_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.hello
    ADD CONSTRAINT hello_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.hello DROP CONSTRAINT hello_pkey;
       public            postgres    false    245            X           2606    20663    iframeHtml iframeHtml_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public."iframeHtml"
    ADD CONSTRAINT "iframeHtml_pkey" PRIMARY KEY (id);
 H   ALTER TABLE ONLY public."iframeHtml" DROP CONSTRAINT "iframeHtml_pkey";
       public            postgres    false    247            ]           2606    20665    jobs jobs_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_pkey;
       public            postgres    false    248            `           2606    20667    migrations migrations_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (name);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    250            �           2606    20831    mobileRoutes mobileRoutes_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."mobileRoutes"
    ADD CONSTRAINT "mobileRoutes_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."mobileRoutes" DROP CONSTRAINT "mobileRoutes_pkey";
       public            postgres    false    295            �           2606    20897 .   notificationChannels notificationChannels_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."notificationChannels"
    ADD CONSTRAINT "notificationChannels_pkey" PRIMARY KEY (name);
 \   ALTER TABLE ONLY public."notificationChannels" DROP CONSTRAINT "notificationChannels_pkey";
       public            postgres    false    306            �           2606    20912 8   notificationInAppMessages notificationInAppMessages_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."notificationInAppMessages"
    ADD CONSTRAINT "notificationInAppMessages_pkey" PRIMARY KEY (id);
 f   ALTER TABLE ONLY public."notificationInAppMessages" DROP CONSTRAINT "notificationInAppMessages_pkey";
       public            postgres    false    308            �           2606    20905 .   notificationSendLogs notificationSendLogs_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."notificationSendLogs"
    ADD CONSTRAINT "notificationSendLogs_pkey" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."notificationSendLogs" DROP CONSTRAINT "notificationSendLogs_pkey";
       public            postgres    false    307            �           2606    20843 (   rolesMobileRoutes rolesMobileRoutes_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."rolesMobileRoutes"
    ADD CONSTRAINT "rolesMobileRoutes_pkey" PRIMARY KEY ("mobileRouteId", "roleName");
 V   ALTER TABLE ONLY public."rolesMobileRoutes" DROP CONSTRAINT "rolesMobileRoutes_pkey";
       public            postgres    false    297    297            i           2606    20669 0   rolesResourcesActions rolesResourcesActions_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."rolesResourcesActions"
    ADD CONSTRAINT "rolesResourcesActions_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."rolesResourcesActions" DROP CONSTRAINT "rolesResourcesActions_pkey";
       public            postgres    false    253            m           2606    20671 .   rolesResourcesScopes rolesResourcesScopes_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."rolesResourcesScopes"
    ADD CONSTRAINT "rolesResourcesScopes_pkey" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."rolesResourcesScopes" DROP CONSTRAINT "rolesResourcesScopes_pkey";
       public            postgres    false    255            f           2606    20673 "   rolesResources rolesResources_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."rolesResources"
    ADD CONSTRAINT "rolesResources_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."rolesResources" DROP CONSTRAINT "rolesResources_pkey";
       public            postgres    false    252            o           2606    20675 "   rolesUischemas rolesUischemas_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public."rolesUischemas"
    ADD CONSTRAINT "rolesUischemas_pkey" PRIMARY KEY ("roleName", "uiSchemaXUid");
 P   ALTER TABLE ONLY public."rolesUischemas" DROP CONSTRAINT "rolesUischemas_pkey";
       public            postgres    false    258    258            r           2606    20677    rolesUsers rolesUsers_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."rolesUsers"
    ADD CONSTRAINT "rolesUsers_pkey" PRIMARY KEY ("roleName", "userId");
 H   ALTER TABLE ONLY public."rolesUsers" DROP CONSTRAINT "rolesUsers_pkey";
       public            postgres    false    259    259            b           2606    20679    roles roles_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (name);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    251            d           2606    20681    roles roles_title_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_title_key UNIQUE (title);
 ?   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_title_key;
       public            postgres    false    251            u           2606    20683    sequences sequences_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.sequences
    ADD CONSTRAINT sequences_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sequences DROP CONSTRAINT sequences_pkey;
       public            postgres    false    260            w           2606    20685    storages storages_name_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_name_key UNIQUE (name);
 D   ALTER TABLE ONLY public.storages DROP CONSTRAINT storages_name_key;
       public            postgres    false    262            y           2606    20687    storages storages_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.storages DROP CONSTRAINT storages_pkey;
       public            postgres    false    262            {           2606    20689 "   systemSettings systemSettings_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."systemSettings"
    ADD CONSTRAINT "systemSettings_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."systemSettings" DROP CONSTRAINT "systemSettings_pkey";
       public            postgres    false    264                       2606    20691     t_5b605e856ok t_5b605e856ok_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.t_5b605e856ok
    ADD CONSTRAINT t_5b605e856ok_pkey PRIMARY KEY (f_u97bd0zhaxy, f_je0bovkl4j2);
 J   ALTER TABLE ONLY public.t_5b605e856ok DROP CONSTRAINT t_5b605e856ok_pkey;
       public            postgres    false    266    266            �           2606    20693     t_job_execute t_job_execute_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.t_job_execute
    ADD CONSTRAINT t_job_execute_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.t_job_execute DROP CONSTRAINT t_job_execute_pkey;
       public            postgres    false    267            �           2606    20695 *   t_job_execute_view t_job_execute_view_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.t_job_execute_view
    ADD CONSTRAINT t_job_execute_view_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.t_job_execute_view DROP CONSTRAINT t_job_execute_view_pkey;
       public            postgres    false    269            �           2606    20697    t_job_meta t_job_meta_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.t_job_meta
    ADD CONSTRAINT t_job_meta_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.t_job_meta DROP CONSTRAINT t_job_meta_pkey;
       public            postgres    false    271            �           2606    20699    t_job_record t_job_record_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.t_job_record
    ADD CONSTRAINT t_job_record_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.t_job_record DROP CONSTRAINT t_job_record_pkey;
       public            postgres    false    273            �           2606    20701 (   t_key_word_search t_key_word_search_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.t_key_word_search
    ADD CONSTRAINT t_key_word_search_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.t_key_word_search DROP CONSTRAINT t_key_word_search_pkey;
       public            postgres    false    275            �           2606    20703     t_xfztfz2cag0 t_xfztfz2cag0_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.t_xfztfz2cag0
    ADD CONSTRAINT t_xfztfz2cag0_pkey PRIMARY KEY (f_6d2sjvn53y4, f_m0dcmr7kq5r);
 J   ALTER TABLE ONLY public.t_xfztfz2cag0 DROP CONSTRAINT t_xfztfz2cag0_pkey;
       public            postgres    false    277    277            �           2606    21323    themeConfig themeConfig_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."themeConfig"
    ADD CONSTRAINT "themeConfig_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."themeConfig" DROP CONSTRAINT "themeConfig_pkey";
       public            postgres    false    310            �           2606    20705 "   tokenBlacklist tokenBlacklist_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."tokenBlacklist"
    ADD CONSTRAINT "tokenBlacklist_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."tokenBlacklist" DROP CONSTRAINT "tokenBlacklist_pkey";
       public            postgres    false    278            �           2606    20707 ,   uiSchemaServerHooks uiSchemaServerHooks_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."uiSchemaServerHooks"
    ADD CONSTRAINT "uiSchemaServerHooks_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."uiSchemaServerHooks" DROP CONSTRAINT "uiSchemaServerHooks_pkey";
       public            postgres    false    280            �           2606    20709 (   uiSchemaTemplates uiSchemaTemplates_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public."uiSchemaTemplates"
    ADD CONSTRAINT "uiSchemaTemplates_pkey" PRIMARY KEY (key);
 V   ALTER TABLE ONLY public."uiSchemaTemplates" DROP CONSTRAINT "uiSchemaTemplates_pkey";
       public            postgres    false    282            �           2606    20711 &   uiSchemaTreePath uiSchemaTreePath_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public."uiSchemaTreePath"
    ADD CONSTRAINT "uiSchemaTreePath_pkey" PRIMARY KEY (ancestor, descendant);
 T   ALTER TABLE ONLY public."uiSchemaTreePath" DROP CONSTRAINT "uiSchemaTreePath_pkey";
       public            postgres    false    283    283            �           2606    20713    uiSchemas uiSchemas_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."uiSchemas"
    ADD CONSTRAINT "uiSchemas_pkey" PRIMARY KEY ("x-uid");
 F   ALTER TABLE ONLY public."uiSchemas" DROP CONSTRAINT "uiSchemas_pkey";
       public            postgres    false    284            �           2606    20853 >   userDataSyncRecordsResources userDataSyncRecordsResources_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."userDataSyncRecordsResources"
    ADD CONSTRAINT "userDataSyncRecordsResources_pkey" PRIMARY KEY (id);
 l   ALTER TABLE ONLY public."userDataSyncRecordsResources" DROP CONSTRAINT "userDataSyncRecordsResources_pkey";
       public            postgres    false    299            �           2606    20863 ,   userDataSyncRecords userDataSyncRecords_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."userDataSyncRecords"
    ADD CONSTRAINT "userDataSyncRecords_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."userDataSyncRecords" DROP CONSTRAINT "userDataSyncRecords_pkey";
       public            postgres    false    301            �           2606    20876 0   userDataSyncSources userDataSyncSources_name_key 
   CONSTRAINT     o   ALTER TABLE ONLY public."userDataSyncSources"
    ADD CONSTRAINT "userDataSyncSources_name_key" UNIQUE (name);
 ^   ALTER TABLE ONLY public."userDataSyncSources" DROP CONSTRAINT "userDataSyncSources_name_key";
       public            postgres    false    303            �           2606    20874 ,   userDataSyncSources userDataSyncSources_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."userDataSyncSources"
    ADD CONSTRAINT "userDataSyncSources_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."userDataSyncSources" DROP CONSTRAINT "userDataSyncSources_pkey";
       public            postgres    false    303            �           2606    20888 -   userDataSyncTasks userDataSyncTasks_batch_key 
   CONSTRAINT     m   ALTER TABLE ONLY public."userDataSyncTasks"
    ADD CONSTRAINT "userDataSyncTasks_batch_key" UNIQUE (batch);
 [   ALTER TABLE ONLY public."userDataSyncTasks" DROP CONSTRAINT "userDataSyncTasks_batch_key";
       public            postgres    false    305            �           2606    20886 (   userDataSyncTasks userDataSyncTasks_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."userDataSyncTasks"
    ADD CONSTRAINT "userDataSyncTasks_pkey" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public."userDataSyncTasks" DROP CONSTRAINT "userDataSyncTasks_pkey";
       public            postgres    false    305            �           2606    20715 ,   usersAuthenticators usersAuthenticators_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."usersAuthenticators"
    ADD CONSTRAINT "usersAuthenticators_pkey" PRIMARY KEY (authenticator, "userId");
 Z   ALTER TABLE ONLY public."usersAuthenticators" DROP CONSTRAINT "usersAuthenticators_pkey";
       public            postgres    false    286    286            �           2606    20717    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    285            �           2606    20719 &   users_jobs users_jobs_jobId_userId_key 
   CONSTRAINT     p   ALTER TABLE ONLY public.users_jobs
    ADD CONSTRAINT "users_jobs_jobId_userId_key" UNIQUE ("jobId", "userId");
 R   ALTER TABLE ONLY public.users_jobs DROP CONSTRAINT "users_jobs_jobId_userId_key";
       public            postgres    false    288    288            �           2606    20721    users_jobs users_jobs_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.users_jobs
    ADD CONSTRAINT users_jobs_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.users_jobs DROP CONSTRAINT users_jobs_pkey;
       public            postgres    false    288            �           2606    20723    users users_phone_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_phone_key;
       public            postgres    false    285            �           2606    20725    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    285            �           2606    20727    users users_resetToken_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_resetToken_key" UNIQUE ("resetToken");
 F   ALTER TABLE ONLY public.users DROP CONSTRAINT "users_resetToken_key";
       public            postgres    false    285            �           2606    20729    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            postgres    false    285            �           2606    20731     verifications verifications_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.verifications
    ADD CONSTRAINT verifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.verifications DROP CONSTRAINT verifications_pkey;
       public            postgres    false    290            �           2606    20733 4   verifications_providers verifications_providers_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.verifications_providers
    ADD CONSTRAINT verifications_providers_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.verifications_providers DROP CONSTRAINT verifications_providers_pkey;
       public            postgres    false    291            �           2606    20735    workflows workflows_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.workflows DROP CONSTRAINT workflows_pkey;
       public            postgres    false    292                       1259    20736    attachments_created_by_id    INDEX     Z   CREATE INDEX attachments_created_by_id ON public.attachments USING btree ("createdById");
 -   DROP INDEX public.attachments_created_by_id;
       public            postgres    false    217                       1259    20737    attachments_storage_id    INDEX     U   CREATE INDEX attachments_storage_id ON public.attachments USING btree ("storageId");
 *   DROP INDEX public.attachments_storage_id;
       public            postgres    false    217                       1259    20738    authenticators_created_by_id    INDEX     `   CREATE INDEX authenticators_created_by_id ON public.authenticators USING btree ("createdById");
 0   DROP INDEX public.authenticators_created_by_id;
       public            postgres    false    219                       1259    20739    china_regions_parent_code    INDEX     \   CREATE INDEX china_regions_parent_code ON public."chinaRegions" USING btree ("parentCode");
 -   DROP INDEX public.china_regions_parent_code;
       public            postgres    false    221                       1259    20740    collection_category_category_id    INDEX     h   CREATE INDEX collection_category_category_id ON public."collectionCategory" USING btree ("categoryId");
 3   DROP INDEX public.collection_category_category_id;
       public            postgres    false    224            '           1259    20741    custom_requests_roles_role_name    INDEX     g   CREATE INDEX custom_requests_roles_role_name ON public."customRequestsRoles" USING btree ("roleName");
 3   DROP INDEX public.custom_requests_roles_role_name;
       public            postgres    false    227            ,           1259    20742 (   data_sources_collections_data_source_key    INDEX     x   CREATE INDEX data_sources_collections_data_source_key ON public."dataSourcesCollections" USING btree ("dataSourceKey");
 <   DROP INDEX public.data_sources_collections_data_source_key;
       public            postgres    false    229            -           1259    20743 -   data_sources_collections_name_data_source_key    INDEX     �   CREATE UNIQUE INDEX data_sources_collections_name_data_source_key ON public."dataSourcesCollections" USING btree (name, "dataSourceKey");
 A   DROP INDEX public.data_sources_collections_name_data_source_key;
       public            postgres    false    229    229            0           1259    20744 "   data_sources_fields_collection_key    INDEX     m   CREATE INDEX data_sources_fields_collection_key ON public."dataSourcesFields" USING btree ("collectionKey");
 6   DROP INDEX public.data_sources_fields_collection_key;
       public            postgres    false    230            1           1259    20745 #   data_sources_fields_data_source_key    INDEX     n   CREATE INDEX data_sources_fields_data_source_key ON public."dataSourcesFields" USING btree ("dataSourceKey");
 7   DROP INDEX public.data_sources_fields_data_source_key;
       public            postgres    false    230            2           1259    20746 8   data_sources_fields_name_collection_name_data_source_key    INDEX     �   CREATE UNIQUE INDEX data_sources_fields_name_collection_name_data_source_key ON public."dataSourcesFields" USING btree (name, "collectionName", "dataSourceKey");
 L   DROP INDEX public.data_sources_fields_name_collection_name_data_source_key;
       public            postgres    false    230    230    230            5           1259    20747 "   data_sources_roles_data_source_key    INDEX     l   CREATE INDEX data_sources_roles_data_source_key ON public."dataSourcesRoles" USING btree ("dataSourceKey");
 6   DROP INDEX public.data_sources_roles_data_source_key;
       public            postgres    false    231            =           1259    20748 6   data_sources_roles_resources_actions_roles_resource_id    INDEX     �   CREATE INDEX data_sources_roles_resources_actions_roles_resource_id ON public."dataSourcesRolesResourcesActions" USING btree ("rolesResourceId");
 J   DROP INDEX public.data_sources_roles_resources_actions_roles_resource_id;
       public            postgres    false    233            >           1259    20749 -   data_sources_roles_resources_actions_scope_id    INDEX     �   CREATE INDEX data_sources_roles_resources_actions_scope_id ON public."dataSourcesRolesResourcesActions" USING btree ("scopeId");
 A   DROP INDEX public.data_sources_roles_resources_actions_scope_id;
       public            postgres    false    233            9           1259    20750 ,   data_sources_roles_resources_data_source_key    INDEX        CREATE INDEX data_sources_roles_resources_data_source_key ON public."dataSourcesRolesResources" USING btree ("dataSourceKey");
 @   DROP INDEX public.data_sources_roles_resources_data_source_key;
       public            postgres    false    232            :           1259    20751 &   data_sources_roles_resources_role_name    INDEX     t   CREATE INDEX data_sources_roles_resources_role_name ON public."dataSourcesRolesResources" USING btree ("roleName");
 :   DROP INDEX public.data_sources_roles_resources_role_name;
       public            postgres    false    232            A           1259    20752 3   data_sources_roles_resources_scopes_data_source_key    INDEX     �   CREATE INDEX data_sources_roles_resources_scopes_data_source_key ON public."dataSourcesRolesResourcesScopes" USING btree ("dataSourceKey");
 G   DROP INDEX public.data_sources_roles_resources_scopes_data_source_key;
       public            postgres    false    235            6           1259    20753    data_sources_roles_role_name    INDEX     a   CREATE INDEX data_sources_roles_role_name ON public."dataSourcesRoles" USING btree ("roleName");
 0   DROP INDEX public.data_sources_roles_role_name;
       public            postgres    false    231            F           1259    20754    executions_workflow_id    INDEX     U   CREATE INDEX executions_workflow_id ON public.executions USING btree ("workflowId");
 *   DROP INDEX public.executions_workflow_id;
       public            postgres    false    238            G           1259    20755    fields_collection_name_name    INDEX     g   CREATE UNIQUE INDEX fields_collection_name_name ON public.fields USING btree ("collectionName", name);
 /   DROP INDEX public.fields_collection_name_name;
       public            postgres    false    240    240            H           1259    20756    fields_parent_key    INDEX     K   CREATE INDEX fields_parent_key ON public.fields USING btree ("parentKey");
 %   DROP INDEX public.fields_parent_key;
       public            postgres    false    240            K           1259    20757    fields_reverse_key    INDEX     M   CREATE INDEX fields_reverse_key ON public.fields USING btree ("reverseKey");
 &   DROP INDEX public.fields_reverse_key;
       public            postgres    false    240            L           1259    20758    flow_nodes_downstream_id    INDEX     Y   CREATE INDEX flow_nodes_downstream_id ON public.flow_nodes USING btree ("downstreamId");
 ,   DROP INDEX public.flow_nodes_downstream_id;
       public            postgres    false    241            O           1259    20759    flow_nodes_upstream_id    INDEX     U   CREATE INDEX flow_nodes_upstream_id ON public.flow_nodes USING btree ("upstreamId");
 *   DROP INDEX public.flow_nodes_upstream_id;
       public            postgres    false    241            P           1259    20760    flow_nodes_workflow_id    INDEX     U   CREATE INDEX flow_nodes_workflow_id ON public.flow_nodes USING btree ("workflowId");
 *   DROP INDEX public.flow_nodes_workflow_id;
       public            postgres    false    241            Y           1259    20761    iframe_html_created_by_id    INDEX     [   CREATE INDEX iframe_html_created_by_id ON public."iframeHtml" USING btree ("createdById");
 -   DROP INDEX public.iframe_html_created_by_id;
       public            postgres    false    247            Z           1259    20762    jobs_execution_id    INDEX     K   CREATE INDEX jobs_execution_id ON public.jobs USING btree ("executionId");
 %   DROP INDEX public.jobs_execution_id;
       public            postgres    false    248            [           1259    20763    jobs_node_id    INDEX     A   CREATE INDEX jobs_node_id ON public.jobs USING btree ("nodeId");
     DROP INDEX public.jobs_node_id;
       public            postgres    false    248            ^           1259    20764    jobs_upstream_id    INDEX     I   CREATE INDEX jobs_upstream_id ON public.jobs USING btree ("upstreamId");
 $   DROP INDEX public.jobs_upstream_id;
       public            postgres    false    248            �           1259    20838    main_mobile_routes_path_path    INDEX     a   CREATE INDEX main_mobile_routes_path_path ON public."main_mobileRoutes_path" USING btree (path);
 0   DROP INDEX public.main_mobile_routes_path_path;
       public            postgres    false    296            �           1259    20832    mobile_routes_parent_id    INDEX     X   CREATE INDEX mobile_routes_parent_id ON public."mobileRoutes" USING btree ("parentId");
 +   DROP INDEX public.mobile_routes_parent_id;
       public            postgres    false    295            �           1259    20898 #   notification_channels_created_by_id    INDEX     o   CREATE INDEX notification_channels_created_by_id ON public."notificationChannels" USING btree ("createdById");
 7   DROP INDEX public.notification_channels_created_by_id;
       public            postgres    false    306            �           1259    20913 )   notification_in_app_messages_channel_name    INDEX     z   CREATE INDEX notification_in_app_messages_channel_name ON public."notificationInAppMessages" USING btree ("channelName");
 =   DROP INDEX public.notification_in_app_messages_channel_name;
       public            postgres    false    308            �           1259    20844    roles_mobile_routes_role_name    INDEX     c   CREATE INDEX roles_mobile_routes_role_name ON public."rolesMobileRoutes" USING btree ("roleName");
 1   DROP INDEX public.roles_mobile_routes_role_name;
       public            postgres    false    297            j           1259    20765 )   roles_resources_actions_roles_resource_id    INDEX     z   CREATE INDEX roles_resources_actions_roles_resource_id ON public."rolesResourcesActions" USING btree ("rolesResourceId");
 =   DROP INDEX public.roles_resources_actions_roles_resource_id;
       public            postgres    false    253            k           1259    20766     roles_resources_actions_scope_id    INDEX     i   CREATE INDEX roles_resources_actions_scope_id ON public."rolesResourcesActions" USING btree ("scopeId");
 4   DROP INDEX public.roles_resources_actions_scope_id;
       public            postgres    false    253            g           1259    20767    roles_resources_role_name_name    INDEX     n   CREATE UNIQUE INDEX roles_resources_role_name_name ON public."rolesResources" USING btree ("roleName", name);
 2   DROP INDEX public.roles_resources_role_name_name;
       public            postgres    false    252    252            p           1259    20768    roles_uischemas_ui_schema_x_uid    INDEX     f   CREATE INDEX roles_uischemas_ui_schema_x_uid ON public."rolesUischemas" USING btree ("uiSchemaXUid");
 3   DROP INDEX public.roles_uischemas_ui_schema_x_uid;
       public            postgres    false    258            s           1259    20769    roles_users_user_id    INDEX     P   CREATE INDEX roles_users_user_id ON public."rolesUsers" USING btree ("userId");
 '   DROP INDEX public.roles_users_user_id;
       public            postgres    false    259            |           1259    20770    system_settings_logo_id    INDEX     X   CREATE INDEX system_settings_logo_id ON public."systemSettings" USING btree ("logoId");
 +   DROP INDEX public.system_settings_logo_id;
       public            postgres    false    264            }           1259    20771    t_5b605e856ok_f_je0bovkl4j2    INDEX     ^   CREATE INDEX t_5b605e856ok_f_je0bovkl4j2 ON public.t_5b605e856ok USING btree (f_je0bovkl4j2);
 /   DROP INDEX public.t_5b605e856ok_f_je0bovkl4j2;
       public            postgres    false    266            �           1259    20772    t_job_execute_created_by_id    INDEX     ^   CREATE INDEX t_job_execute_created_by_id ON public.t_job_execute USING btree ("createdById");
 /   DROP INDEX public.t_job_execute_created_by_id;
       public            postgres    false    267            �           1259    20773    t_job_execute_f_meta_id    INDEX     V   CREATE INDEX t_job_execute_f_meta_id ON public.t_job_execute USING btree (f_meta_id);
 +   DROP INDEX public.t_job_execute_f_meta_id;
       public            postgres    false    267            �           1259    20774    t_job_execute_updated_by_id    INDEX     ^   CREATE INDEX t_job_execute_updated_by_id ON public.t_job_execute USING btree ("updatedById");
 /   DROP INDEX public.t_job_execute_updated_by_id;
       public            postgres    false    267            �           1259    20775    t_job_execute_view_f_meta_id    INDEX     `   CREATE INDEX t_job_execute_view_f_meta_id ON public.t_job_execute_view USING btree (f_meta_id);
 0   DROP INDEX public.t_job_execute_view_f_meta_id;
       public            postgres    false    269            �           1259    20776    t_job_meta_created_by_id    INDEX     X   CREATE INDEX t_job_meta_created_by_id ON public.t_job_meta USING btree ("createdById");
 ,   DROP INDEX public.t_job_meta_created_by_id;
       public            postgres    false    271            �           1259    20777    t_job_meta_f_styaowp9srm    INDEX     X   CREATE INDEX t_job_meta_f_styaowp9srm ON public.t_job_meta USING btree (f_styaowp9srm);
 ,   DROP INDEX public.t_job_meta_f_styaowp9srm;
       public            postgres    false    271            �           1259    20778    t_job_meta_f_u1dygf73ly9    INDEX     X   CREATE INDEX t_job_meta_f_u1dygf73ly9 ON public.t_job_meta USING btree (f_u1dygf73ly9);
 ,   DROP INDEX public.t_job_meta_f_u1dygf73ly9;
       public            postgres    false    271            �           1259    20779    t_job_meta_updated_by_id    INDEX     X   CREATE INDEX t_job_meta_updated_by_id ON public.t_job_meta USING btree ("updatedById");
 ,   DROP INDEX public.t_job_meta_updated_by_id;
       public            postgres    false    271            �           1259    20780    t_xfztfz2cag0_f_m0dcmr7kq5r    INDEX     ^   CREATE INDEX t_xfztfz2cag0_f_m0dcmr7kq5r ON public.t_xfztfz2cag0 USING btree (f_m0dcmr7kq5r);
 /   DROP INDEX public.t_xfztfz2cag0_f_m0dcmr7kq5r;
       public            postgres    false    277            �           1259    20781    token_blacklist_token    INDEX     S   CREATE INDEX token_blacklist_token ON public."tokenBlacklist" USING btree (token);
 )   DROP INDEX public.token_blacklist_token;
       public            postgres    false    278            �           1259    20782    ui_schema_server_hooks_uid    INDEX     [   CREATE INDEX ui_schema_server_hooks_uid ON public."uiSchemaServerHooks" USING btree (uid);
 .   DROP INDEX public.ui_schema_server_hooks_uid;
       public            postgres    false    280            �           1259    20783    ui_schema_templates_uid    INDEX     V   CREATE INDEX ui_schema_templates_uid ON public."uiSchemaTemplates" USING btree (uid);
 +   DROP INDEX public.ui_schema_templates_uid;
       public            postgres    false    282            �           1259    20784    ui_schema_tree_path_descendant    INDEX     c   CREATE INDEX ui_schema_tree_path_descendant ON public."uiSchemaTreePath" USING btree (descendant);
 2   DROP INDEX public.ui_schema_tree_path_descendant;
       public            postgres    false    283            �           1259    20854 *   user_data_sync_records_resources_record_id    INDEX     {   CREATE INDEX user_data_sync_records_resources_record_id ON public."userDataSyncRecordsResources" USING btree ("recordId");
 >   DROP INDEX public.user_data_sync_records_resources_record_id;
       public            postgres    false    299            �           1259    20877 $   user_data_sync_sources_created_by_id    INDEX     o   CREATE INDEX user_data_sync_sources_created_by_id ON public."userDataSyncSources" USING btree ("createdById");
 8   DROP INDEX public.user_data_sync_sources_created_by_id;
       public            postgres    false    303            �           1259    20890 "   user_data_sync_tasks_created_by_id    INDEX     k   CREATE INDEX user_data_sync_tasks_created_by_id ON public."userDataSyncTasks" USING btree ("createdById");
 6   DROP INDEX public.user_data_sync_tasks_created_by_id;
       public            postgres    false    305            �           1259    20889    user_data_sync_tasks_source_id    INDEX     d   CREATE INDEX user_data_sync_tasks_source_id ON public."userDataSyncTasks" USING btree ("sourceId");
 2   DROP INDEX public.user_data_sync_tasks_source_id;
       public            postgres    false    305            �           1259    20785 "   users_authenticators_created_by_id    INDEX     m   CREATE INDEX users_authenticators_created_by_id ON public."usersAuthenticators" USING btree ("createdById");
 6   DROP INDEX public.users_authenticators_created_by_id;
       public            postgres    false    286            �           1259    20822 "   users_authenticators_updated_by_id    INDEX     m   CREATE INDEX users_authenticators_updated_by_id ON public."usersAuthenticators" USING btree ("updatedById");
 6   DROP INDEX public.users_authenticators_updated_by_id;
       public            postgres    false    286            �           1259    20786    users_authenticators_user_id    INDEX     b   CREATE INDEX users_authenticators_user_id ON public."usersAuthenticators" USING btree ("userId");
 0   DROP INDEX public.users_authenticators_user_id;
       public            postgres    false    286            �           1259    20787    users_created_by_id    INDEX     N   CREATE INDEX users_created_by_id ON public.users USING btree ("createdById");
 '   DROP INDEX public.users_created_by_id;
       public            postgres    false    285            �           1259    20788    users_jobs_execution_id    INDEX     W   CREATE INDEX users_jobs_execution_id ON public.users_jobs USING btree ("executionId");
 +   DROP INDEX public.users_jobs_execution_id;
       public            postgres    false    288            �           1259    20789    users_jobs_job_id    INDEX     K   CREATE INDEX users_jobs_job_id ON public.users_jobs USING btree ("jobId");
 %   DROP INDEX public.users_jobs_job_id;
       public            postgres    false    288            �           1259    20790    users_jobs_node_id    INDEX     M   CREATE INDEX users_jobs_node_id ON public.users_jobs USING btree ("nodeId");
 &   DROP INDEX public.users_jobs_node_id;
       public            postgres    false    288            �           1259    20791    users_jobs_user_id    INDEX     M   CREATE INDEX users_jobs_user_id ON public.users_jobs USING btree ("userId");
 &   DROP INDEX public.users_jobs_user_id;
       public            postgres    false    288            �           1259    20792    users_jobs_workflow_id    INDEX     U   CREATE INDEX users_jobs_workflow_id ON public.users_jobs USING btree ("workflowId");
 *   DROP INDEX public.users_jobs_workflow_id;
       public            postgres    false    288            �           1259    20793    verifications_provider_id    INDEX     [   CREATE INDEX verifications_provider_id ON public.verifications USING btree ("providerId");
 -   DROP INDEX public.verifications_provider_id;
       public            postgres    false    290            �           1259    20794    workflows_key_current    INDEX     Z   CREATE UNIQUE INDEX workflows_key_current ON public.workflows USING btree (key, current);
 )   DROP INDEX public.workflows_key_current;
       public            postgres    false    292    292            p   6  x����v�8���Sd�G� �W������0��\��<�dc��O���𕊺�Q�&B�0eB|�ّ'G!�~�����Gx8��1��0���jNE�Y^��~�MޜT��j��Z�l+�$g'=��_/��tA���J��
�ږU�VW�x*����|�B��<���2L���ڂ����q�2�	��]6�*���P4���H!:��&�㞛�>�$��cL�������1�0�L'ѥ����Kw;7�5�:CC2��uH�5s�}7��R6߆d���U��*�?���Q�[ W�S]����4 Y(���1��"���K�Q:��gugm��������e�`�d�ք��Y8���j19��Gȏ�p�2H㹠��$�<�A9#&Ȼ�$���Z��4�7�M$Q8G�c��a�@������O�x|P���"�r���~h*��ߣ�5�
P���"ZYq۲��|��p�|�`v�b�ۦ�'�=��S���v��K�~悉x*";�"��yf��P\&�M��3��Y�2hA�=��ef����Seע$�-��d|��c�;f�J��^�Ց{\Ns%�Z��:֧��05׊� :�"�-Mç��\Ө6���L�*���ٞ��2��J��Y�/s�z/A�˂$��'���ּ���;G�r#��	�4�kk��S�'˛���~B͕-��J0��0�ú�]Am*�W�A+�b̔ρ�&��
&t�s.�q�~cťS�i�R�	�(�M�γ��S��t�Gt<����q���o����Z$�!�� ���GK���:	I����&����M�~���L��m&�N;ܡ�D�
�G$�3<��s���Ҍ]��5�(���W�it��N}4(F��U�Ex�����w�jB���c�L�]�t�S�gr�ۊ=&�v#��d���.MW��B��)v��F��Td���O�{���Ƚ�X��Yl��Nhm�^>��|�9����Be{���6�o�>)"Z�=��"��Yj��Ͻ%���7��.ѝ�?��x�]$��~�]�8���WK���W@�����c��܌������\7|��-�]ɦ�8�}�B@Y	�rg��/�����?�P�ad��->
�:�Td�byY�Գtb E�pc�El7u��Մ�� t<<(����^B/�>뒺t�����k���{ﵪ�|�1sӢ���RڞM��8����l�w��أ�L8��%��ַ6C�����A!;I���nU��8��^T����8 �o	=����1/��O����������X�      r      x���4�3�32����� ~      t   �  x���[n�0E��U��=>��� ?×�¶�(AQ�{%�M��i� � �\�!y���L�#ZC���l5���_�q�C��v�a;(�Z)�� �VM �3N�tܪs���v��ͥ��_�շ����o6]�0�]>v���[-����cu�E?;[���=�&o�O�JU�4����%6+TM	Ur	hb��]S���G��T��y���0��K��� e�,rD�+~!�k���FM�^A���
�WAų5���B#Li�
�c��ԋ,gj�ư�[ߓ�d^Qߐ��K%A�[��<f�m:T����"˙�^�b����u������;l���b�R������"��?j:��jț����{�����M�ڇx�ZJ�^���O��ycS�q04�9�KZ��G�
�GW{��L�ߢ�`
�-�ki�����$����<�>8�=����^f9��':����Ѓ�����4�Oϕ���e:�)J,�
Hp�b��2��N�V�?���7      v   �   x�}̻
� @���)ĵĨiC��5J7�J+������|>�ĵaC#f���nt�c�Ҭ�]�j�ڇ��l�j���xl=.6}q�&x���TG� {��]�<�vn+U�v"S��<!�5!EB?&O+g      x      x���iV]�����ӊ�F�"BوlA6Q���D]c @H�Q��^�uϵV���~�3|��{��m��+B��Y�~
���S��������](��Q��*�?}
�?��B�,�:ߓ�T���?A������?3� ��M��#
ҧg�*Ã�_3� y|]�F1H�fG�����������,w��Q�#��/���^K��F���1�����&*��b��F�s�%FKk�{������W�kI�a���Z��0��|j�Fe��A�`�9+�6��ڶ��3G���ìm�O~�"f]���tg��
b����P���)ϯ$�9���}_�'o��{������1�(t6��f�F
�S*�/�),��pkw45�0�E}��l�����\�%�#��[*�vc�=7�6��^����Y(�j��B�ي��Qo$���K
&�O�ix��ܿ&��2��0#�����̓�`x}5ܟO��<,�S��O*�Y���I�`�?L��y���'X��sV	�Z?��	#_�͝I�
�����.�$������&K�q /�&��B�l��d}�'��t�9}��$s`��q��$s��-%ǫ<��[~?Q�2�iк�I�`�_W�uA��j�:sZ�f���If��IϪ,��Ӳ�|^N_n�����Ϝ����ɓ�V�^vG2���E���IF�L�Î�I�`<3e��b?�~�ye����j�<��U�䭙|\�o�*�	�f2�H��<M����m�yX?&IfM�Nӣ���]����M����.Ւ�B/M�����^/5$f��O2��hũ�)����i�'av�=�|�IF�k���Γ�fc]9����0[�tJ$G��<06M2��܃;��a}��&��x��<����C�_g��Ʒ��3��Kh����޸4$���I�xq��<)ƖJ;�<I�t��͓J�p��_v�趇=g�p�����m)R��u�kc�?�.��#
�E��`��{#o��]���c���E�<#�Z���$c��/���T��山|�V�`%1\�s�#������p(R%|<�7N��`F�4J�Zqf$ٰvj�~�x��
o��V���cHaY������&	d���4�{���t�}���s"��t����<Ɉ�޺��8��`[-R1-���J�␏4��b��H[<��o�آ4i�(���C��Ր־k|t�_��Ñ�6n�������Q�ʒ ���;�N��"q��j�|Ɠ�
ߺUy's�wk�?iRQ"��d����;3u~#YY�I�L==S�u�h�ةB	����;�q��"I"��)Q�����F�P���hR�������=��Ó�w�=�5q���ֲ�k��y0�{�II��z:E2�|ܝ��Nf��ݪ?0)����P8�*�w2f��W2(R)t�Uީ��'*$�s��$���N����=ؑ�V��;7<�\Q�síO��U^KwWy���5��d��gR��s�q�J0��%O�<iB�l�C*Y{1ݕ�|TbHF��{0�dsf6��ʠ}ʓ��lzK�"I���c�'��q��~��$c2���mN�*�`���"as8'E�������D�\_���2l��U���R��@��H�6{�IV�y��6��]�G*�/~�8M2����KE�HF5�Xq�U�"��ʓ&����C�mvSu������5O�$G�i�'�䝻(R1U�ZG���ѽQy's�����$)�+y<���)�{Wr,)�I�ʓ��Ԭ;Ӆ#!��y|��l3V����Z%	\�+|��(V��H�`8s5�8�I���k|'d9ܷ��ɑ����C)������0�WvT>���_��]�d$q�T�JA�q�g8R9�vǷߓ�����z����s=:]N���r'Y�L�OK��G���;�)�O	%4	����4xRѪ��<��.g�&�HeI�t�"U��ʜ�p$c���3�4	7�ʜƯ���L2�������r�,G�����Ư��]�M�?������4K;?%�P���2v�ʞ�O�}d#F�.=��6�xj/w�ǁ#Ũ,��"���E�d��ӳ
�,	ֱƑ*�Xi�e��!���٘n�J��dl�THf�ON���d$��L��B�����x�x�Y�}&���B�����5�}�I�"=&
�8��8OG*��W�J����F�� ӱW+(�r���Ms��`�<����$sGS�.�ʑ�~�>����J�fUHv?5z<���
.��#���Qa�~j͎�<iB����Q�w�q��J����E#p��8�H�� }�gIE��J�߇�b���c��H��N����|��NEt5�"�̹{J�W]�%3��������;�q���|����jO<�`~]G�;Ak4��	O2���2���8H����K*I��ͻ��>`#.?h��}�I��3l)��N3K~0��2���]��SV~�CB�N�bH����xZBDſ�i�1f̨yʓ̵�5��y��AɑJ�:�Α�����B���7;͓&�qu�i
	�Y�yr�B0h�~8I"(��,O2V�AM��M�G*�.��~�TF���i1Vø>��N�r���P$c5�^f4�]���~rx8�YKwֆ�埼8;B_�������F8�˾�8T�"�e�J�E�޿mH�q7���}���eЮ�$i��p$#����xR	��n�&I��-�#�y6=���%�=��'�S�ʎz��2��������9��\�{�lQB%����6O����]48RQz�9QF�J�;ݹjE�T��<P�J��ݧM�_7a�ͮi�9o����>�K���a�Y+(�7`]�Y��yl����F�+�ș�-k��s2u�Ȟ@E�p}n���G�
�1x�f�5�{��+������?��L?+��`���t���UTD�ҥ�h]�ſ�Tc)�L�'��=f��j)R�wF��<����.ś#�j6_��&���n<����\	8�V�/��VYB��Qp��C�����q�'�Hgq�.G2��1f�F�H%t�Q��>֜�ő�ؽ�s�a�4a/�h<_��f�%I#�Y_�\�{ղ$��n-y���,By�˸�H1��7_yRQ�<Xk�#��-��Ty���MW�yoϰ�i�D0�����R$l�Μ��(�������G2W�޼��R(Z��mʍCQ�O�l1��/jC��(�;����$뽼�N�)R���_JQ#������E7�@�j#t�e��O6t�({ô�,�"z;�x�aZ�vd��6���um���Ox�Q���ȏ#%�d�KB2Ơ�<~��7h���GsKR�?�d��j}�;�y曭���~��Ê�\�a�&�b̡��׋��� �
O�`��8��fK_����x�.�<�eK�b��h4f�6�g��%w��g�L��M�/Jo����;��*XF	X�	���U�S��0U�'��-O�P�񖑬��gT�*�&>�@�?�8��	���`�#j�Ugt�dT��_#��:�E+���*4��n��\�V�4E�#MU��G�o�:4s���$���X�t���֏��1)�Th�ܝvDT��"��:���[�
��R��xK�V�i<j��Ќ,}���/ڄx�:s<-�[�#��!K��C\�*4���kS�K������fw��J�:�T�����A�C�&� 4dQ��Ҽ�B��"�<�zZ,%ͭYr��îM:j@n+�ز4@}�9�H�:��m"m{!H�"���_$�Z���&9���M��Yh��B+�Η�^mx��z�`t�E��̲�T���P�����B3Z�IO��[$7�4#��1(P�V���!�*4#��/�C_�V��v�S:4t�~D� �ٽ/G�G�A�>��|zTա$�cl�r�icM������*�0���ss�����às=h�C�[�P9����������a�]&�;~C���xyZ$��M��FK��~����!D�"�-+ьE�v�̽�Њ��YR4�,>��V-}�ҡMi��\M�Z*��l��~��%HZ%�Ν�'���ThRy߯�\�F��\��ư���?^��S~�>�ҧ����p}N9����S�>̨փ    ��2����B�]O���\fO�G,�ͅ�Q�k�[�Ѣ�.
�T���B/4�yKK�o���B3����󸷗vO�h��Hr(I��U<fg�̭A����<w{��y���O	����)�d��pvEC�p�G[h�Y���E�i� ㋟���9u���*��tVj���ж�}vۛ�ŨB�u�B�������^�^�ϫ*(c��uPLZ�-}�J-j[gc�w|57�{ա���nMUD=��j���n.��t�;ɏ?���`�m���"mLs-��%�?���nE�IZ-�1��]���C�P���{����z�Uh�b?^�S����\Ҹ֡U$����CC��͸�W��ù-�SUh�/���7��֚Fh�X�A�hT��ѐ���}-�6���~�g����뛻�IR�\t��^A�oG��I�KK��V�СI�V6��i�"i�U�҆mnQA�AC ��4��IZ��q��G�J�7�!�B+y��DU$����3Q���%5G��0����hM{P���BÄ��L2�7uP��aPZP##F'�:���T$���y���^>3*(#�s�~�?\��SB���?c��X�;���L�B���h�T��?th1��ن���1�,=��ɍh�AѢ��HZQ&r.o�А���uY��"�8�����&�Lrx�BC�G��-�f�p�'W����G.I��$�}d��Ќ�����FϨtS�U�k���τ�29�6�*4�~s������"W�8��kv0C�v�㎄�9����ñ9q?őI~�3��H�_A��ڲ��Fg&�	�{�C�ejjm	C%������^���)��.����&|_*4��TM�f�r��:4[Nu_�Mx�$#g����ɕ �7���#g�z�(���j3���dB�V,m*ߏ���yNG��|�nde"������bi��9UHZ1���,Y�f���i䄨�d��p�^����MH+�D0\�y1�j���?�k�3�4���o�������=%m]�P��ba�?/�iA<-D$�M��i�~e�uV�&�~��_Z�������K_)|�hbX�j��A��w23��EH�A�
�h�W{Y���do�4�T�U��V��y��d�c���p�O	$٪��w��B;�Y�&uħ�YH��� ���ܤ/'diл�Γ��[e�"�$�xbi�d�h��9ŗ�Y����P��dci�����VаBU���ҋeZ���4m4�]�`��)(4nog��E ��1�gZ,�Ic.}�[�T'�Rw?���(�fv����Ow:@#\ۣ�Zr�U�������j �=��-�A�A��j4��uwӴP�֟th2Au8}�B�p|Do�����Ұ���/�[�����3Z�V��p��]:r�H�`�;a�r�ލ(!-��U'�iZ�q����B+
�),�����v;����I;�2�C��*���>񒦡��~ѴR��]aY5h���,��xH>
��AT��R]�#,������
*�뮧M�a}J%}�?��O$��R�3h-&��:4��~�ӡ��fی���dt9��ȮI+b{ �H��	>�^'�i� 9���*��t��[סM� ��,�離
�L5��)Z����5�8�/�rJi���N#i� �{A�c�H~�fӠ�}dT����-)�Ӄ�|M�L-�D�?UUh�����!$�l�Ζ
Y��՚
-Si��	��|� &'��7�&�xWs�33��$�%_}�G��+�jnx�s�B�B(���-B��\��4t��B�f��C_�V��U�L�W/uh���_H�f�ՠ�4x�pǊ�!�iX_O��� ��dZ͡K��i1����B���N7�>С���ͧ�4�
8��uh�@eTߣ�ܥF�;[�AM�	ݛS��w�x�kq��т0�'��I�]�PU�!�)�w�΁;�D�<��$��3�I3��hJkZd��s�9��j�C+J�ݕ��F��ަB�=B��
�"�p�C3G��,y�W����C����!�:K��!������%{��Qs������hZ�@�a�8�
�M�i\�1�T`�1���S��i�f4��{&#X�x��Ǟͨ�ͯi�H�V�6�*���S�>-4��/����Ґ3Y�AMp���P���ɋk5Z!�7tP��c���C3G�����Ǟ�{��`a�Ʒ�����`|���!H��W]ؒ��d"�6�i{>�4�o�IҢ��ӨX�ͨ���v��l
ZIF�\��Ќ��#U1��ߴ$Y(w�������l�\���5��x���g�ъv�����a/2�E�����Ɔ-���?M+�����
f���;���J��Q`����bva�f;�@q̚�$=y��:��&�h�LlX��R�bi�	�xǯ~�5K�<g�)�?EE���*2�E�@����d����R{嚋Ҵ�H��uZ	������T����Hhl٨Ǉ�5h?��gw�I��Vx	Eӌf��Cm.���T��j��Qu)o����lr��L�S�[�0�,��9Y�N�=$�m���d�$��b̧��V��`��Y~6����d%�Ә	�4��aO�&i�}�ν�0{Ivs�X�/�А3�K#�;	4��h�[�4��a�;�4��鼡����a�n�8`�lc�i�2ڂU���������Y
�/����*EIʁoW���1gܫ���Wr���CF�ɱ��iq�t6�W:�f���BZס��f��{,;,��'�G��?*�_
�V�4��K�>��H2KV��^�"�lS��T�7s��Z� ������l�H��2�s�t�F�Qz����Vt�q��s��n�u�C+AwJ�Ouhe&�o`o7�̲;�T��l�!��R�M�j����衣Ŵz�h���d���o�bݜ���N���lrWk������w/5�v÷neë�p1�-��|��ު�$�5���U[��i�Y%�Ӵ�4�_v"�ݣ�gV
���d��<>� �v:;�9]�v�^�\�'m_�N�*"v����H�)��9�
;�����=oz?9M� ,���#Ɍsf�Q������$��ĮYX�y��"k�h��V6G/3n�I*m�T�f4�/s�E3M�%&��4͘!�܆%i� M7�z�)��\����\��;g;�$OI��愫K*@�[���{����0�w�a#�2�R�D)P_R&'����?�(��J�vK�
vf��8~�"�(���!�4�,��G?�;cz�p7��N��c�v/rםG������cH�e�?0���21���������v.sW��R0���c�(#t璇�š���š����@�i��G��:4��\�#�m�V.xů���6���zk�O�'��_��L~�(14a��cf'�dF0�җUc1� m���b�����#�İ y/���dm�����₳�x�o^�� <�`@�����7�n� M+�z��9��7o�E~y�,+�ھU<-eV��WZ1�>�Z�B�S\/5��󗤳�B�c�\)Hdi�xT�\��hH��'O;:�؏[;W�#6��t���
���YT�j���&�3O3p�Ί�����|��9����ͫt��&��@��ldiH�1�{.z�>�Eh���3��R~l9Z�i-�ck� ���5}��<��ړ�&�"5;�x�����aL�����s*�&m���-��64NԠ�K���l�4MCM��k���l
�}�7��$G�;q�X�,�v���������f޳��u�ih@���nE4�-~W�a�|Ǐ�犐d�G�t�1a�%#o��(�/���z���^~��^����BC���c����7���>H[��&i�l�ȥ E+����t�}ÿw
�Ⱦ��ܔ�h��_�Hq�&=�6\�OC�zM�
#�ьd�J���qq�&�_��%������ZS:4��?͎ߓ� ��Q��B��P�vu�<]^�Q�qz��py���Fy�0�Ȩ1�GZ,?���>޹Q�*���G��)�s�7���z��4i�0��ȄQ�,�H�n��� ����:4���o��ӝ
�ɲ��lې@ɘ�pI4�    U�++wG+�و���ۊ(t`�g�5t��O��*4�6���-7�kv3�PA|�r���pYmVq(�/%i�`6�
��rR��̉5������1�t�{
����*f|A����2	I;�0��H����N�`iq^�dj~+vɧ@�_�^޸�&i��u�~��Q�!)0��Blwl[Z,C/oThȏ�^"Zdה��>��A��mfV<Cm@|e���B&��F2UV���@��I����0�n�=M+ȝ��K��;���a���KCܗ~�{��
8�:~2o���L�?+r���>%vOI?FW���V�M�Ol����{���N��А��}��B{T BO6�1&��OG(T�d@�}����`����uZAr���
-�����MC��z-=���?<O�?&���=zB���œ��t|~�lVUS�~��4����VK�fL���ȸP����|�Ջ�4���3B&��|���q;��MkI��6vr��'�\�d��p+B�`;�Nt�C�đC����K���ޙ@�l�|�C�Vt-�v��/%b��Ḓ�>� Cih��.�cI��`���bi�h���4�Мͺ={"H��ԫi�d���F��Dl�b`Pn'M�y/�/d����v������D�G��4�~�B9���X��M���|���l(���
�����N���;w�1Ǽח�����(G��Oٙǿ�B9>n����cϭ>EC<=m�'�;�݈n(���/��%IZ)`�GZn�����u��X�%Wvܺ��жԮ)�B��M�����2�C�+����:�(H�\A֫Ќ¿�G�
����*��L����Р�<~��ʾM���XE���k�A���Ɋ�Jdݿ�X����ݒ�m��B�
mB�%.���§`|��.��
�w��C���ΥO�"	>*Ѡ��KqhZ����ݹ�xz:(̛n&W:�r�ܨ}���~gdѴ	}�Ѝ��o=M���N��A�?$}�s��wE�F�{eU���5�Zҡ[rw
����D;�e׺����,ó�����V�.0�����T�����y<vǄ��[�YU4����R�VD���4��Y�ѡM�=���bi�3�'�
��8K��	MC��͇!H�8�[��܉;�c9�M����cK����6}� M+zW�
�$���DPXƝ�֧å�:�70GÖ�[Ekn��H�1��|>I�z}�gkD��?����.�b�B�<�|MIZQr�\�����P{����I��ɲ4$-D�XڽѠI�dc;��D� �P�t磙4��nl����¿q��cq)��F��$!ѥQcQ��d�C��iFi�|�1��p�h�
v���^DR�	���-6
��h�t���,�x��sE�J�^_V��j��GV�]Y���О
-������0������ð��]@�}�fi:s��D>�\���Þ�ǉ�h��Oth�Ē�����h�[�f�ӣY�-�䷣ZQ�(��s�����|K�V,��~�ƲVl��b�)�ջ?)�D�,��ݤ�2��uh�r|��BCÐ�E�tf��]$�$4;n��UpN];q�����e�&A�`�-���
-B�ʨ�A�pc7]��)��l���t�*�4�S-���^���0Y�Nn�&ahRA�ś�L�i$��:B�Z��S�V�1���a����I�Ha�h�{�d�2�/��Xf��d�f��۹��Q�f���h2�{�ْv�0�(��=�\�7�n�fV�n/Yo��lEd��$-�(��5:u?��0�z��6�_-�$mX2E������:=�'��n-Hz:5�|C�ɼڹ��ea,���媛_��J�<T��D��0���7�&\M*4���y����Of���d�&d̐PR^7އ�u�
,͜�ӭ��F�J��Oғw,��=�,3�$%ׇ��I���^bi1��71fh�S��;��\�1��#׈���>��Њ�m'�𴒹3��r����;ޛԡM����Lӌ���h�)��v^F��:�� O��CK��uhFr�\�h�v/�%iԬ�c˸�\O�@���$� ��!Z�A+�+�9�lL�f5WgЏ4�:����W�۽�����TG�f���fz��B+��񕿔h��'��#Z��7hVl��<P궼��i%���%�:4s�;�ШUh���Mߞ5h�Qo��+.$��V
��@��ܽq]�y���gU����b�g�7Uh(�y<�6���4���ת@���/��� �lE������
���F�~U�a�=���K�P��E�JmI\�Q�8z�렌0=<í�AC���������wCU��ܹ if}��]�Z�&�u������)����8?�� �͕��4���\���Y*�:4��5µvM)2�F{��֮{��OL��I֛�o������r�H<�$��l�B��/��K+�d�9�o��u��|@�"[��ܱ�*$�.O��W��mg���򴢝ɸ�A+�h�5k��� B�`l"��B���u]�i��\f8M�|\�1����K6���}���C+J�uci��0�E�}7�Z釶�<��^��R@�f{�a^<-
��e|7Z���i�t�55W��ds�q�\�L��Š��ӠA�j͢w�˕�������C��,��cU�i�'��<�th6����B3��n�?nB��L�A�.���}r��̉����?thn�kC�����J�gHZ(ޤ�&$iH�:�-_�f�[c�u��i���3G+c&�z֎�7����IO�[���$Y.i��{/�݈\#��U���,��+��8;k$��$�-��$�V����^H>V��5�U�*��>��Խ� 7��,PBd1��[�z�i�,�[;�}V�I�y(	.B���3�	K�	��P����er�֠�v�S~�0N��tN���F �4#>����
͵ٷݮx�4-t)�<-B��,���d �}?s�C"���}�?z��B/�]��4|�5:]�`���l�[��G�C�m��Akѯ2ӾFh� ]zL�fuh%d�{e��UD�u�
M�F��>��Ҍ�|쥇w:����غ*����yZ$��һ!���Ф�j=�5�<� �&Ӵ�Zԓ��,��=��I�Z9�X���JHtt7Th���V�f��̑W_iZ��2�4c؎O]*O+IWa�`iЄ?���}�{I�9��HVQ�I
G��K@J���gi��C����C�{I�9�ͣ䢩B���h!C���VBN��Ѵr0ZZ��s�V�\�ta]�6-}|�Q���n�ȇ~h����u�Q�e��h�I�k�D�A$i��ɴ��B�3�����$M¬�+jА���`խI�_n{[��R��A�T�&�֛��:bz�D�!��o/[*4�ޛ����l��٦-����5��z���$�ѶAPz���*4��X��Ф3p�p�ihm��J�o�Y ifM_}I���|M�Hq$	���j���{sw5h��KҐ�p�z��2�W�6 G�c#�{Id}m�^֡E�/���i��-;o4��q���^"�l�֌N�r?GC�h��[m$-���v�O+Z���B�i�>鎤M�wz?�����k��<�4����|MIZ��<}�Q�I8����^&8���tg��[Z��rYO�$���dE�n,-������!ݽ�qV���պuSPy��{q�ThQ0\�W4h�V�V�|� �R�]@?�����0����?�fNVu*�-Y:(�2�
K����һ��A������~y��E$M���������b[�����W���c;a���#>4����>����Z�u��h�L(��j/��&'�>��E��68<�kֽ%���(�Y0��oN����S�����7?a�m��[`m��yOIe�rབྷ1��e.ɸu�8�6a��%-t�{�Ӿ�ܓ��tK�B��!Oɞ)����E��w;��/���O1ڬ���{H?���ɠ�q���En���z��	�,���r.�HZ�ڃ�}ZA�ّ?�ACO��I�����IG;ׇ����S̫�pp̚��ޏw�O��|D�?�7G���z�k�p-4"lˤ� ��I�Eh��ƙb��
�>�%���c    HKA����z��_xۜ��Qp_���d���&ma�hh3��&�4,��f�:�IC �w�Ѵ(�*��q���%�*�ĶPf�-(I3�mzA�aԯ!�`�E+����Ar��ލ���RR�p��Hdiyov�£#�f!i[����ZN8�c�l��zt=�B�t����
�mr�׋�4���^4�p}��AÔ�znԓ4c?=��&��07��;s�њ8>�S��9C���=�q��I�V�=>��W1㦎�����Y��~��S����Ζ�(cb�odǖ��렌(����IW���p����[p��G�n��K�`@��N��I/>��0�z?�gYZ	J~&[IZ�yw��-����;�g������Q�G��-���&di!:�'�5Zw��J~w1�%[x���hZ:4�A�t�uy<_3����ߥCӴ�]�E�nw%q�V��;�����=���#3��<�r��&u���>"f���?6�rx2���,-��7��?+Ѥ�Re+.͕5��>>Z����{�|J���=I����F.0~��8�ο�ь���;'Ir�V�S~��4�K>�HQ�Ų
7:�"~i~�)��i7��H�����4W�H�y��{�*�4�r/܎zur�G�	�ߍq�ʢ6���w#iF?g�p�&�x�5�h��<�UA�`� dz5�O�4t �頌�ٽU{�b��,��W�&���z`���!�2~���?�DҤU��w�hEɶ��Mw���(�l���w��4�nzgM32��{�����[�r��I�Ҡ��B���1�=�Ѡip�y�,M3��ǎ����b�R_;Fӊ��@�ZE�?�Th�f�Z���$M�L�I+E&��h����O�:�R������*4İ�sn�8OC�u9?�$͜����Z�F-<s4�J*JrQ�����$-F+[^��iET('�}|�ݬ����RGYCζ}7"M�(�%�B*4X"��fH�"��Rա�A��>�����[Z)Hj��ȅ�d�
Mz&�HK�>I/%����@��o�t��!��_��A���Ӵ8H����$iE��]�XN����4��Z~H�ոv/uh%t���V��ʇJY�����ҽ;$-���#�4	��產��lq'?��O�(�`�-ڞס�Bs�E4M���ՠIZ���`��7�f���3���Ќ�����!$�vw�Z�V�ʅ�m�Xm>�H�&̻�*}7�5�}��L]QzM`�>�ӎ�ʤi�̠t^n�f~�l�^�&��$iFn�����P�9�����&'i2r+�x�d4P��p�A�&�+�Ï��)G�進��B�Ř��[V�euMPUh�,k�Y�V�{0?�&��3�����V�/�\!D�y���(�$�\�k��J���z\�y,4-�B��$i�߸Q����xw�r�B�n�\�%i!h��U�Vr������-Ih懖�4-F �諣ƣ
� '���zÂHx3ThQ0윍oi�V�P6�/�4�S�;}�4�����@!�w��o��x�K��e��Y����Y��R��^��u/�H��2PC���R�/m�1�r�w}�(K3�w���
>��H�t�OOvth(-���9ICAkڟ��%ƇY����e��\4�(r���tC�f�z1M��`п�C�h��	P�f���5Z%O�79I�@�C�4h���y˗�َ����~#i�~�}��wuO4PZ�x[��!ܐ�����"��%[�0�����hRl{��kJ�[�$.V���4GC���o�I���~;5Oݻ��uy��C�1q�gY�`�Էo�iRӊ�*4i<\l�Њ���+�$U�5_KE�*���v4M�@՘��}-�ThFY����B�UW���}?�$ތ.���Њ�H��],͊Td��ے�I��M�&i��5��\b|q%�B֯�� O�k�
G����*I3w��O��i�J=i?�Ь"�I�V����:�2{&o�:���Y�j;dR�B��ɑ����
p;t�$s��K�m~V�>�Ɣ�ϗ��ǒ4�
�G:4	�����Аs�.�V��|���̌�7Uh2���n$͘37��ɆMf�z�>G����g.%9LÄ����0�E�f}ș*���`�]ͮ_�&�VvXZ,&C��C+��֟,�� ]MTh�u�y/YZŘ�3Z4 �~��s4	o�O3)ôS(��!m�~�B���?U������;Ѵ���j4��|M�:�����H�V�و^�ei�`<��n�^��*4��ێ��bi���]S�����չAkI�B���m�`k
��Uh�8�^�|ӡ�j����`i�n>���E�PԚա�p�Z�:4����M+���������gZ� =�8���i��2���2�s�"��Z6�O	q���vZ�.K4�erH0s��C3��9�3hZ����F��Ũ��OI3���srv�BC h���ףi��cw�thE�[.�4dh�o3�6,3�e��L�O�Ύ-F�|������2?V�VBB`z��BC}����A�Bx�S�A3��i��u$-�wo�;�䢌��d$if�=Ϩъ�#����Ό�l���AG��!K��%��(Z��y�ֽ�I�����ڹ�,��U�p�BC�e�6m^��@���_�����
h;F��*���t�!���p���y"����M��dI�a��W-Ѵ\���`��@��B��csq��N>���Ǎ���47\ �r#i�K����4����KҌݺTG�
��_'���w+����w���~��ҙH(�4��Ϲ0%iFs8\L��uhF`]��za�&�O����o$��Lx������.���U�xpO�غ��đ���}ܐ�ER��2�4�l ��
�(Qȇ9Z	;g<��AÈ�A���D� hH���q�&���>�A�����=�IZ�9DoUhA�[^^�АR���[OӴ���(�fn���֚-������g�������đ�(O��{��!?iW�Ld8�\�3ٟ�Uh����Q6�&��T��U�$�ήI�����24�3�>��wn����%�Ĩ@ý�
�Qo��1�߆S�q��p����APfX~��P���(9+��º�,���]jI�5Ů�T�
ۤ����L���5Z��~���

g�r8{��C��s6�ϙ����{�9NYZw��ei��?M�������FӬ���<,�~�2M+�f[U��1%The9eZZAs�,���&�x�S������W;��H�����f&�P@�;P���}5�޳4Tk�::4q�仚���c=K�`ir�P��B+�Ś�*T��;�B9Z�&��%���3��kl<�W;٪@$MZr[����rb;^D2�;Pfy9��4�,�}5����4�T�:(؃�n_�V��TIw[�*����m;I����M~�3A�BI"�=�Kՠ�6�i���$�ɞ���B3�t�$=?ס%�f��B��}m�4��I�|�t�j�5e�	����^Uh�!u�Ē(���|�A����!�B3j���x~U�f����\:�4s��̨�*V��Ќ�0Z[K�?�hb�����ޕ�q��j�s���G��AgyК֡�����^?Jw�t�E)S��Qx/�Nwth�D/�*4)8�C���43=�7�8ܐ燎�oV*���=e��ux��\���{������.�<�,o�hb�#O�c���T�H
�m���I�?��
���ߨj�BL^���|���E�)��?^G$3�a�O+�B�.!p�D
������
z�ᑻ�H�Y����}K�f��F-m��Њ�&�5h�&��t�8�4SM�.uhF@O��z"Hf1H_��*�r�T��ւ�$w�pai�0��YGʢ-�����i�V?鹚z�fN�˭����.L���R�E�`A]#J�6����l7����W�Sb���#,��]�BC+�o.���b��ʏG��m�S�|B�$���5��i�����2:ϓπ�ip����o?�O_ͻ�ǖ&�B����}:hM>6����Eg�<�� �.��ת�$-�=��_Y��ݞO��V���`��s����>�Ќ�p��~�*���і4M"��\��4#�/\���I���A1:7�:    ��4i]�oQ�=y�G;��hp��.�h������m����}��$
e��*(����?���=E�%<�9Kw���r��v���!iq��_��5��j�hа[�.���h�-٭�ЌU�z�_�$��g.�����QEM���W�?nT�)�{�� ɏ�^2j��K�e�{��+�F=�%ia �j_�&u��s�厮�ӭ��n��/�H���thq0����-�4�<>��#4I��{~�i��uh2c�w�C3
v�V�B㙫�����\�0|��y���E���Z"EC�K���� �����Sk6w�4����x�R�UA���FmE�V	��}.�9��3�aY��%Dj�Ne}!O�Gy��rg|���D���";���BC�ș3���ӊ���'��4�|ܷ���?�ɗ�~���ai!���F]��`V�YO��/e�R�3��ev.K3v��w�Zh�q��`iҍy|��Bõ��`n�?�@�b��ۙ}Z`"����}qu�4ek#}<q_�����Y�%i�8�j㝛���׆9�#$��f�bw�IZ�/�������Ǚ�%����u�,�4�r|��[h�S���f��ϧ:4#:�̻�c����́��JA�6��4YZ9^���S�U�d����	I����!h�p������r����>%tO�����B�̕%�&��j��%6B����Y�p i|����YU,-Ļ�"霐��$�Aw󫕤��H�VB	�+֣i�#��`�O�����j�ᨺ?�ϩl�r�t���ܠ�����#���X��_jYZQv$4�����Ӵ�֧�\������f��b4�ΏI3�C��\/�Ќ��q��$�l��{�9*�J�VTP(�������������-�DHmQ��}.�8�]�5}rl������C���}��C3��i!���4dX���K�P��cgUh�`���ғ�A�ݸI��mK���G�Jy��%EC������L�NJ��3㎤����֩M��haN�f���y�#i�`xz�K[����j�V�T��ZE�Qj�1c�vH��v�����Fe1��4�C�z9���;��H�C}jɻ�L9R(Ց��>�th�����_:O+�w�y�M�J@���
�,�\]rK����j4������@l���S�������Ƽ$s.�th%L��M����#���A!��3��g�q���{z�o<�>$K�9��7�Z�f�`x���!��:�{�+��I=�������R�a��7i��C���~�_�M��I%�]��om�A�4�qk���<��K:?S�޴q��9,-�>*2y桔N�W����iGhb����uhF�^���4��7�OWp��H�4�n���8��r0��K>>��*H��5rpl�J��6���>uu�hv�R��W��R���#ia�|l�T@�f��C�
4|s��N����7�j����K�`i�b���?�B��)n�yM+���wp�����!Vv��@l��|�4̉8�~-�Vv�һ���!,��Ŭ&�m��A�*�Y"�d,�H%�=]�O&Uh�Ey�K�Kns48??c���$$�|��w���I���an鯡m�w���FJ:u�CC����J��jDvv�I��iݛӡ���x;T�IJ�92��#�h�f_��� I����L�di�n�>邥!A~�JY>R����W�v�YZ�
�������C����N*�
���@Ʃ%)�I�l|�t'�&%��~&i�+�[Z��3댥aL���ҴR0���^����!�٬
�,#әcs������9������K\�65h!���-_�2)Сd�'�5���AҤ�Yf�4�`7�}Ԓ���n��hh~��}��^ٴ��M!�J��x��LM���Mb&C+�uVo�m�-	�:����51�m���}�4�uߚ0�ThE����O�C+��e�4��e2�C�H[�g�w����Sw/=��;�������?���W|��R=/������]b�a�����F�V�DL�2�\�{���-���qgS�f���$&qkЌ|�oF��:4�<d5J,��K&'�KC*�˚w��4�zc�e�4�I����t�}7B@G6�x�:���Ig?ߝ���M�9Y��:4�/�,��4ﭖ�l$ʘH˯ށ@ӊ�pjU�{a����4�ss�x7u��s#��c�hv8�ۻ�ǝ�n�u�g��X�o��]e��нv�{gL��hr�ȃ�a���H�ȧ��C�f6���l��q�t�oQ��������>$ie�ݽo��0)�eB�V�C7��!�����4-ͧ�ҴHh�ܦi1hޞ�i%�-W�hr��k����?�駔~zʿ]�܃�٘��+u$�l�V-�h�MJ֖1���R"�!�m]/�:ԠA[�IN�ThR��Oy���a*�K~Q��8��%�#�1��GP8Uh���^���4�b{�+�&cǥw�����ӐX2T���dn��2�b��zT�I՞1���膆DL"G$�fk�|U��خ�}"1K�;]~�[V��e���b蓾3M�Y���i���wkM%��������x�Rh��I�tF�B�@��$t>|q��H��$%i���;�8�4���V*4-�ĉ���(]�k�L4V�qv:�z.ZIl��N�Q�zof�Ȉ���O���5���EC|���ݻ��H��ڃ��� �2���]�f~��Fz��AC���e��eDL�hƔ{���H��[ٟI�B9k�"ihSÔ^:���D��O����@�Cgڧ��=�=��iև�8�$�+)�m2�F�Mx[Zt�Th8ѧS�����8~;ѡEr�6uh1�>�W=ZQ��,M�d`��!�ie�i��aiш�U���`M�dq4I���f�$�eI��d�-m4��
0t�5��HZGа��C��quS%�8�*�B��S�����a�ei��	�4mB*�WV���h������Ta�9>}��?n�$�ȗYx���?�Bd��"����YԮIC2�l�eiF7�5|�.M���3��\�Ќ�|�O֗uh%d���O�"K�=
��=mr%-��#�O�Ƈ��-_C�}B���d�T��0@ZS�x��	F��6����M:'�̤���ݘh��u����h�����8��X�e����{=�8Z����z���?P4|��Vvg��s����-�Swt�C+���
��ik�ւ��b|�Q��2:���Z,i���-�?$f��bI��.�'uh({y����$A�wvei�R��1�l��l���-
�_��::49�������iO�V�U�Z%HΎ�.MҐb�d�ǎF�XRLӗ5�9Y�'-<c�KޗEӐ�_�➦M�~ՇoXZ�����ê��v��+�`i2�c���"h�m�_�Ѡ!Sq��y�c&q1�l����*4��|d����s�+�hZY�k�D�P&����&��VVUh�OAr�Uk�2[KwU��|����L�h8�;���`<���r�h�[~N���X��̻�+�
��Nr�E��*|d��iZ�oBӌ���5X�fg,��g'e(ZI���\_"2g@��a�KIZ)���S�=�UC٬
� ����ݐ#4����"I#��E�wd�@Ҋ�ռ���Yk����Ι���Th���ޭ��j�w�	�/ɡ�oD.J,��G�t&i�����ES�V�>��kАe]���3�f���x��B�Y�ּ��!���X�4s�֛����I���T.O�|Ќ��z�}��P'�m7�n$�4�j�3\�p��I�q���7��pCl'r��f�%K��
���
M�H�}� M��,-��CU�-��O����y7tw��!�e�q4���L�d�*���2}�i�$���}���F���|FM�a��c�f��f�%3[-�q��O�
�6<����R�fn�V��hhZ,=�ݼ'�&�>k����їZ�t�B�2����$M��#��2,�X1�C��a������Ҡ6�����G�h%;=�n�9)�φ�o���_J�Bq�yy4͘��#?Z����yY���ك,����n�O���X�^Ļ�14���}�cXZEh�Fh�E��V�*    0�G���I��uuu��F�"|7�@ӊr���>�Y�gx�嗄���NF��ң��R�����h�`6Ӫ�1&X�Ihw��)$���Lk��Ѵ�M\�Y���Aj\�f73G��^}��"c�%��v�ݥ$	Zkw�]��b�hߧAC���}��q4tȖ�V�1L�����G��h.y����0���k�XZ�}�wf5C+J@������$��?�t/�f��9GM��>��]�,X	F�xKTh�x��B>I1l�\��bΗ��4�|�~��
M������*4dh�|� KÅy��+$-��0$�]S��-J6�B��\4���������Ж�h%мϊ�A@�wsՋ4-����F��������"hi�����\���ojCH2�
H�lWS�Qf)��$�:4�:��>NJ�p�M��&-m�Z�V�TN�Thֽ�l�BҢ`X}�(���7�
�h�����*4=V���w[�%#I��8�>H�g~�H�j��ۍ�E��i��hFvT����Ӄ%�鱲��E�iP4�e��\�'|�Ei%���.C���[��BC�ͥ���ڭI��΅*
F��r%��!(�$����h���s�{�I,J����O0ci(����~L6D�����&i�1/���2"(P�Fy�ݧ|!8��z/��^2r4[|�{_�4�?Ɵ�r��
m5C[֡!@f4�쨒4.y7Z�������'�x�W��}�j:��p4����w����t
���$k�՚ϕ*2�WE�օ
��
Mz ��G#Q!�عjM�"I���СAQo�k��"��ӗ��Ͷ�Z�L�����n5|jK�L���OF�i1�0�X�fT��sd���A2�� �
����l���	�B��$iƨAsH-��́�S�$#�p�09e,-�~�G47���]�SƸvm3.�n�aB��ڽ��R���8SoX����FF����!T�y���%JN2����&i�+��D-Ke$�����Ȗ���V�o�Њ�<^t�>���gHx�(f�oz���L^ƈ�����lu�\	�~ᾦO����mmr��=w��m(��fQ��g�{qY��yH��uhR�;���͊p�x6|�I�]�bv[2.��ri���/%i2x��*�Ȧ���b�8d��Њ�û�
;d��S�!h%I�0��y�!%&^��=?t�i�`����_4�{���
�к[��G#�����O̙�4-�J�:4�{���!i�0s������.〡kU������g��/���b2+.��c�)���̒�B)1����'����ty��3��G?V���y�膦!Qa�g<Ҵ�Tl�Uh����b�f�����
�;fF����@]�
��Fm�Ѝ��?+T4�d��e���֛t�O6���K�h�'Ѐqйs�_��X~�	���?�����pљ�o�������k����9t��<ͪ��S��6q�F�x�9VO{h ux��i:��xx��ء�-��ó}Z��W�u��a����Y�����>1l��t�I�f����w���R���'O�R�V?����*Tl�|%ڄ�,%Zh���kg�Ѵb!o�gU�9�Z���.��P�Th�tFR�E#�Gk��!ŒT:��i�B;���*�(Z�IzL����{����i��蠊��r��<�$����N�o.���*��P4-�����crp�������Ʉ�����?"Ƴ�J��=��ҏ��A�CD�oe
R��@
������C+��Vס�qUz:4#�֝���/D�\��u���X�J+�6������!غU{���M�����x���/�1R^Yei�m{b�M�p�xjC�f����,�/Ӳ{O�-q�:?0O���zҜ֡�9��n�`x?�&j�4D�!n^�������!/@��7O�h�q��4St��n& MCf��"q���bi�V����8T�0�
�||L:���BC^��s���I�~�kkЊ6[�E!����3�r��w�=��S"����
�%1$�\k{n�%O+bF�h��AC�3�Y�w��׏-�����\�6[��,�v?}�9iE���֝O��������5h��I_��z%������r��yZQ��;K�a�54'�;��E�{�;�o�p6��J�V �����aN�˒m�N�4T�<�O~'S4�U%��n��� �s�	�vjO3�����4���hiŭIa��!�Imc�[ա�R�{$UZ����5�!��r;=ΪР�o~�)I�$&���B�4l̤ͯ�24[Z՚��Q�\�jZ5hоn��o�VD��RZE:>�4*�V�u{�� n�OC�����|�#�P���ɒ4�qe�rz5KC'�/Ó-fh�3M��M��]ϤI�̮{����q��f#t0�_�q�=�j.���y��mR�?p�H�[~ա�p��s�X�-�O߸� ia0Z��qC�&#�\�&O�@̯�yZQ�W��*4��<����^���t.M�@ M���JF�B�{��F�"Lo�guhȘm��:4Ӽ<Ҡ��7�$�kn7Q�?��{�K�Xf֑4����٩'i����Wuh��%T�R04MU�w'h��B���0ݞסMش�D�h�m��B.jCL��֒
���9}<q�����:@�7]^ԠA�ZYm^:iEѤI��OV,��ft�^O�&%��p2��F�dTb���4�`�ɬBCfŉ
JzXͣ���>�q�&�~���:��\��hPwW.��5��H_��`�i��ɝ�thR!���*�R0Z�ʅI+�|�٦]���)3�'�̴z���H�x&������L-�m�bK�HZ�IN}5�<C:��IA��v�OQV6�נEᧂ�uol%�7{aFLff��)��k�bi�3��AE2�T�a/��աQٔ<ܤO�:@I@U[s�5��(1�V	�ݍL$i��{~�n�*4�A�(XS��tiNְ��D��Y���I"s�q��D����^xn�fߍ�!U�9�B�}�
�����Ll�4sT��ɝ�w3��Tm|��C�í���@�6!��J����{KO�uhT��ۧ
-�כ3,͈���JZ,�4�0IZQ�U-Z)�������p�U�U�~���b9Z��69�ڈ��F�o�ǲj�p�܌�G;k���X�$De&K�������J���c*O�I�g��
&��wI���t���B3���}!M����uM�f��̔T�s�K��giq0z]tyZ�:m�uh%i�u��C+}�-}>�i��|����p0�C�H$��h�t�B+�[}��G�h����cS�A���U�����5��U��O�k��ab���Up�4�I��> �Ґ�ښ�aM��{c���U L��v���K����0`����0C�����H�뜙�<���#��P
���y��i��}��~`��q���m�=L�P_p��V�f~�ݹ�Ӵ"����{�:�Z�N?�$��f����(Kog;d���=��(�D0��Cr��6�'���0Q��4{E�4T�T��I�4���\�G�x�o���p?`H��[�ph�8=�������d�������T7���u������d��8��g��D�Jh�^�/q۽I��h�qS��Fj��8M+�zt\_ѡ��Տ+��I���;�|J��N߆�NThH��n�A,�Mók����P�@ц1�K9���}'�f�:=��:ǖ'Gp��wOuhF/�<�N$�V4�s��m�G��#�"#4�,=���>��W$�{:��B	��6m[��3E���X֠!�R�i�,��Ͻ&z��Њ��y4h5th� =���:4���-:7:�
�A| ���M}2�0�_v;�ڽ���7�������1���А_������s���ѴF�&o�:����?~ԡU�*Y�*�	T�O:;aܵF&2X4�U�݋��W_���hD�U5Z���`�i�,t�j�V�䍇Z��4�J��ټ���>�Th���C4�^2���h�YO�J�p�{��H���i4��.1í�m;�cKCx���B3v�t�+ci����    �_t`�I�n���M&#&�I�nX߅��AC/��]��W��O�۹4-��IA�iq�l,��J��h��%xH4hp�=,���i�t0�=��J��u��:q�l[7ь��{�j&Y<t���%K���Ž*�0��Q�Y�vLK�����q���Oª�l,�7�/��b���7G����NҢ i-$�;:4���5p�V�[�%��4I�J�?Th�{��4�����6��n�B�"��T�C� ���e�I�Q��Өh��J���Z	}< ��yב�2��q.l|a�\����i,��B�xϮk�!}�7��mO������	aD�c���7h�E�Z�)c���hs����'�
��t�._�`�$X3~��@�Py�ܿ��lr�R�f{8�>�Њ2�g{F�VB��w�д2���һ����0W`H�B����
������ɢhp7%k>�-b�W���Ы;�(��b'�!��o�@�"��_uh�X}��EF�QݟN��g��ۑt������/R��&av��͏�^���\ꯍX�è�f}�DsҧY�����.Ն��ϒ9n8���U.��1:����~���B�A���O���5!	o�c�מ������%��?�ƪH�t	�4-��T$*A�M�KV^G�V��5�ǿlN����� �X
F�}4+�o6�G��u�YW&KNHz��I�
&�IN��j�4���6:Lӌ�];�1,��ɕU�ٱ�~�6O+����K�8���Q��7`�XҡM��Қe@��t���^�t�@H�'�šB����=s�uh��y�,}V�A�~\�����d�ݎ�*Ҵ"�'>ۄ���VI�49�n��M�g�3aX�-�M��v}������S�	�����:4c=���vn�V�=�Ն�;�N9brH"�j�����&���_�:�XroNv�/WX��N�+�Ґ̳�Y!*����\Q�U�|���-���G@�24�UK�YЄ�E��f5h��H����|ghp��Rc���
f�F���̌)�'R�7ŢiEw����JR��z��1Iy%i��E���,mBfR��h�fDj�|���,���W��cD縝�(Z�����Ѡ�aOtĤRDH�-~VA�r8�f:KC�&��Gӌ�ݛ��������� (�hë��_kg��Ȳ����s�BQȻ��qlAh@�Aq���l_�*�-N��Y�۽�M�q�Z|VU1d��ݲ�F�|�.5��4�*d�+���_��p��}G�fï=���激hҼU�.�滅(�sߙ9���p�<����4܋ Z�̆[�x}�[�f1�(�3�R�U�_�ӎ��>#4���vC������pߖv�4�Q>�O0i��zݷ���l��{q N��8!�.��m��R��6cq�v��g�%iw;�����X�����f��k)z*F{�Q�����}��l43Ae�(:މ��0[��Kj�����_&����i�b����c�pǌ#��$P��*�4ͬ�����V�f�|7�h��R��jox��f��iioֽ���Ƶp4p�QQCi�d���pK��[c�gd9Th8�?���Рҋ�ki���4̈́��\|c�����ƦYK;H��Е��4c{�J!��^B��n+k~lbMW���{�&�4��>�N^
����v7�3��Pތ[nѴ��-?�-�8j�ik���z���A}��9�ف�H�)��4���x�=*PB�7��íߖ�L©�m?�Ќ�߿
;_thvE���Р�p���^ߣ\�B�N�D+�e��N�ɷ��bX�soJ�d^Z.���Ͽ�I�ߖ�IKI�z6֡��V��YZ[�U���{QSi2����*4\~���^	-�jm�y�*EÅ�Y�v��R%�|�P�����4�v�akS������4�/��T�Q��r9�����tPioZjG٬m��ҽ$id��ź
M�M
I�i	�Y��مƔX�����Abi�A��B)�q���k4uh�{o"_��Y՗0[ӡ�a��MV� ��}����H�j��
��fŞ�i�Ʒ�8�.ouhX�ÛZ���e^��{�"nK��R�����th��n�ӡ����u��ik�|�b���B��p6����� �q�Z���N��y'V�?p4\�ꆥ�ͬ��u'cNӤn#,��w�h��E�v�z��ϓB���w#i(N�N^th)�pq�ehl}���)y����_��͸���*-�!*(�~��y��%GM�`j�����PX�
�hb|k���L�?O	-�EgwK�B�|lKG��%D��5v�i�M���d#ih�8�A�����{*�@*;:�5x2��B˘��'|���a�H��*�y�t&ۚ���s��@C��O�ᅥYu�֩]�Tl�Z�W��GC�m��x���$*�g_�:4g�IKA1��a�i�7���hi)r��W<��Gx��nH�6��v-�4�_�'�hy��p�<�%���=/�UhH��BXjG��%@sE�<����P�U�f�f��	OKK��u&iv-����Zk��>4�hP��vx���;�)���.c!�%O� e=������x���BK�����}7�f��A^��M�Uhf���tP�4�}S�bf�8�]:$mMt*�:��y���T�i�V�^w�F,MԇZ�����̼��i�Ԩ���$���gG(R�A��T�&RiNe���Q�2��ԡ�����Ae�-��*4Ĥ��XT����=�n�Q�jE�X÷���M=�X*?s��훒��HU/|6�?|c^;ԡ�h��4
$�,����4�C�A�^�&�K�@�2��t���b�Z`h�+���,r �+k�8�V��%��H��fiIyS�g�=c�k���l{͜-���"���n)L{���gn�gO	(9"Z*V�נ��at�PWw8���S�f��{m�OK���*���\=~>G�§��Ó\���i�m3�4�V�8�z��G?�#5i��(�������ܳ)�eW�śr4HI����h�i	��;��&Z�Q��AKٳ�ذ2�\������[G���f\}g h�}Sg�hZI�8J�i�������H����Iw��K~7��0Dr�5���*D�&��(PW��l�~z{��۟�!E�fpՓ�7$�9	Q�mn�qv}h�ϏJ¡ν?y)�Вr0j;��4e{���Rp��#��[8��+n��T@B���~,!�����xZ~7�f��`����43
���&i��㵥��h8��Z����7�hH�`�.6"@NHz��eս)I33䠁gS�%�MǳJ�����J�#���� �{�;y��f�߹q'ifG=lMw

4I� �� �
�%1MW�@�P��AIL�x�C�:��c��R�y�^l2,����lz�U��4I� �p�f�"K��^q$��Йnש�򴤔g��:4_|����L���
�ß5PHS��%��5�h�v���'Q	��UA��p��`i��xTJL@E������^8~�A��Et�(�D��,��dM0���'4y6�����E��Ҥ����H��CE9>!�i�կ��zэ���'ߏŦ�鷎�?N>ΌD��E�
d��crI�rv�ް�3�X�䊝�ѻ��,Ŝ�_�B3qA��{:4ߛ}��[w:���]�j�f6ի���7��2dh����ɛL7���LZ[���BK�a�X�x�KS�M"�n\b����}W��I<m�Ӓ��H�c/ɜR%��ϗ~|���ٌ%ܡ��%I>��*�޽>�����Z>'�i����� ����p���w�Z�x�INx��t�S��%���J:43X�Ӱ�Ԡ%��D�rS�@�`��GN����Z�{8:С�Һ��&I8NÝ�8bz�-�A��3i��vOj4��\����gsEG$-�v�����h�a��Sj;a�&��Q i����xZ�X՝�Z iF�i:�������}�A�c�ǰ�g��g#ifL�u�hؠ^�h����fݖ-��|�:+>j ��P���F�8�P�L^oУVh��pp�BC8�R���hZ�E�z����BK!H�5�qkv)i�o�p�d�vJ�m�\�    ��Fj^h6�ySҡr�{�B�5o�M�\�(�0,�O(�� i��0a�t�>���򢭋�KC���?}?v�����v��}6���E���.�h ��P9>�i���[*4\?��a��M<
("��f\�����	{ n5�xZR�S��H� �<��04͸�������4����f�����1�c����%<	v�<-es��Ժ�)f�LI��|���WGw�:L_��:4�w�뻨���	� |���#h`Z�ؘ��I���C�im�f��yo��ɮ=˄���b���!	���yԝ|�ϙ��Q��Jz���� S�w���X�1�q�syK#�������G�n�I�ٵr'fP��{@Qzۋme��%]�<��³�E����q4�>my�@�)F�,���f��I54�n�oa}^[{G}do��~t��o�v7.��ii4�AS63g��2�\�8���T���_�_OQVa��H�����\f�.]�0����S]������6IC��3���{Y"�������a9I�"�{:4ߛ�o����ը�C�x���l��G�49�jT˫��@�^��2X�N͞����V���%7��� Q�u0{o���3�]g(��lv�u��i)�J*Z�E�F\mN��p,'��:�5L��A+*�u�/jvb��&Eb���1�WfS���.�(�_�	Y`R��,� �`�FW����h}���P.��pzT��\�����ԪВƜ=�[��t��b��!�
-�͊El�*��K�[
KK�u���b`��,����-l̘�=fUh�(|D��:4��.�Xb�u|��z�	�~w��"�	�Өv�Bf�	I9e�4�l$-!��9Zқ�>ė�i�/=˞Z:��7m-�,�x�QQm�r�y�A�W\��Vj�?p4���ǎ��捯8�?o o��D�Ӿ�|=��@�H��lޚ�W/'o���,?)_ ��Y�o��{�8���y�Oh�x�¨���4���q�nb�khg�a'��}ޘ�Jm���P�\X�,M����
)諳�0Y��.''��Ќ�v}��jZ k����%x������!P�"��|�9vt�D�$<��c��	I ����p�C3NB�ׅ�4�d��iI��x5Z�Г�-`a5d-��]�8��Z��e��8�*@�0��H�gekUa��zT~E�`��-�ثai�7?؀��SE��ii��S�KW�`�1�*̌1�_8h�VW���etv��ʫ��ɜ4uh"g�o���篿���M�      y   p   x�3�4202�5��52S00�2��24�356�60�"e�gni�z6uó�u/�����M�4�2DWmael�gii�n����������؜�Ϸ,z�����}�E�)��\1z\\\ ن'�      {   �   x�u���0E��W�n�LK[�~�I�8�kHJ�{QY���ޓY
��Ʌޠv�8e��v����(�=}߄�o�
�1�l�N��eB4#]K���o����L�'�+%�R�TE�=�����Ӄ�.��bs��+��O�$-7��JQ!'p�6,�(Tǜ+>�r�n���������!;`�� F�j�      |   5  x��T=oA��~�V ���&�!("���v�w�������S�"�QP�(�1Mh�������`�{�K⏄/� ]3�y{�ｙm5Q�{��%9$�`�/��4D��C�i����,Dut#�Dz8�k76u�
�m��L)�S@m-oCx��z�
HH
܂���q5נ`僾=[� [H�����Z{����Uꕉ@Cg������^�*����;�kt����"�3~�������W���|��v2z��ҷ��O��|Q� k��z1s�w�1]���q����!�S�m�SPL[�=��I [td<�ȹ�0��/��u]ڡ����cP�}����7p�|%Md�ig}����ƴщ�3�d�Έ�%DO���y���u٭-�D+�&����b48_�����㽃���ߙ�A.�r�X"�k����Ls�ŀӌ��m��1�	�D3N�e*Gō�p7\��.��r����n&� ğӾ��HH�����i+ v��!�~~�"�+]�U��p�1�T��=:�����&<����|�Bd�Z�ݾ���\b      }   �  x��X]o�F}�����[�0�c��j��Zi�j�OM��=�6��cH�����&f��&��9��w�CLgМa~�M��(0��x 	kH ��21sb�d{��óK姞a���b��t<���ǟwF��N����"K�B~�gR��"M4�s�c�IEwF�G����a�~!ۄΝ,�o�<L��t�ܛ�y?��ߚ7:��F�tU�&�����k�_T]��]������]���kN��q��e��})����B<)��采O}q��� i!nC,��()?tvq�v-�w�t~�ƦNpFF����ںɐV��$��#�n�/s��*�R�Lޚ��;�J���طφr��\$����n��2Q��@�2R��s8�G�؋��x$�F�3�����5�f�BfS��S��`�w�/}��þ���u�Cd-$�� 5�#A p3�z�����څ��hz�����Q�c+���A]��p��W�|gԭ���{�=B��u2/9�r����5�`�����R��d���Lz��;��1�P�+�����^j�����3�V|���,�� ukaZO\b�=�
U�Io�a���q�gχa�=]q����:Q9�}��k���Cf�du�V�5������~	��*R��B��l�g@��M�V��L@q"��*$P����s��E��xГ�
��9�TyIʵ�䫋���E�Z��ܩ"����Z�[�ATB��i�����l����ϕ���~$�I}�	n*�f��j){w�de�_Y��KYu� L�&�a6� �f�oK�i���ߏ<�.�!?o�Gm���@tR� n�v���{�r�Gm�U�]Q��Lо�R@�T����*7ث�l�]�K��Α�<1/o��n�L�1�?N�����Rqx:�ys��g2}<ì֟�饏���)#�dŎek����p��o��<>ڽ�ƺ�}��u��ǫ���II�����.�O�_2�g�<��:��,�1鋽�N7OCݛ/��7�B�������Y���K��%���Im[�͸����v=�H,W������L}���d"�"0��{��h2��{�'��P̠�[�ک`"��V&@h*��}��}O"�,J���w��q��wO6!�ecp�+ڈGa��GV�Q�k��lI��c��c���(F��G���E�����X�ϔ��}x8�q�:�����X��|      ~      x������ � �         C   x�3202�5��52R0��24�26�344�60�4�-�����Y]]���d)i��B�j9K8K�b���� d��      �      x������ � �      �      x������ � �      �   �   x�}��� Eg�fcԥ��lbhyQb�����]L���ӽg9�^���Y4{�""���� g�ie:r�����`�J�p��`g��(�T��F:�)��uz�rc���m�o�ݱ[��9�����U<��l�R��KL�      �   D   x�3�4202�5��50R04�22�26�3�4�60�'�����Y�����Z��Y����Z����� �      �   �   x�U����0�5|a�@^+��Nwn��ѐ'�0DZ�����Zt��zOo�沀�X'�#%/�|��X �*O`�0AQ��2�t�箺tt~�zeEq�	-5����v�C��
uk�|#�����TI����7�v|�.��w��Տm'+���Q���FY�Th�uЍ��Ù�ר�9��ߌ��'����x����4�;�Bi�      �   �   x�}̽
�0@�9y�p'E�[-�M7�ܺ�$C!M!�T	��'����j�
ו�V�B�t��f#ەR�V�=�!�R��ދ��m�%�N���@�~�io�y2������~���a�M��l�\ct!_��r���w�s� d�=�      �      x������ � �      �      x��=�s�֝������;���e�v�m�t�dgw���x�A\�I0��#�vl�v�&��L��V�&�l��?#Pԧ�� ��x��I���d<"�����TZ�e�n�i�JȆv�	�O��&� ����ZD�{�Q|hC'����y�a?�L�O�e���Ȳj'�
Г�xIѡj'_���k'kNd�Я��Fh����۫��N=����3g�o�'��\'?�v���tU���z��a��9C�d�K�Rˋ�P��!���h��w�jpłq�N�;����`H�o��n����c�"�'�>�z��&T�i,C���M�P��;^�a+2|��ɒ��q�T�:�H X��B�aq(���k9�	Ps��Ǳ�ۚ�b	OG�,������|<��,�Wd����@$��N�aN�PU�<	��S@��K�@�TM�J:�M ��=@�+�W 2�B$�&��p�v����6�3c�.�W�:CH$�ͦ�6|��$�4���r�W@���L�Q�Y���¤N�b*��$-�@F�P}6$� ��Ǚ�B'dj\/���q}`��/���/�x��R�����@�5Ɖ�s��p
/�G���2S���ZÀ�� �2|i8T��6�lYD�Ul��߃ <V���`�i�b��˦�
�~X�3I<FE�fH-V�Ħ�����)!C�Eb��[y6�W|b�����CCsrX,<�b����1��	Z��&T��"�S�l��B�u~���d��;�L}�).T� �e�KǆL�T�ʒlXq��<�<	�uB؞Ly�0�r�hY�S�S�
۹�B�<�D��`ƞ��b�kU�F`���h�����y�"ũ�rl_�G:|�O�>5CG��p�'��
��S#W%*�.��3y(��!F�M3Nߵ`0���I	��gp/_1�=�n�87ԡ_<�/b����Ђ!��g_z����n�+���*ӝba��n���c_)%g�4 ��0�/{J���3�!=GE�/���"RJf�H�b&�O�$LW�M�I���?_�˦�}��>���uj��|k�Dj�����
,��/���`�h�>���N�FE�Ō:���ʑ!e!��Ñ�5��JmR����ʱWf�E�<�a��Z�ȇ:�o2����qo��yZ�'�rA�9C*QڒZPՕ�Pa����_�G ũ��1��J���Md^���Z��V�w����(�CBv�[`�]d���`�CugFVE��]2�hm�m��D"���9�ibլ�pp�����7����0y:��u�LC^����Y���+%{'k�(C��/ڥ�Q�&#�T1�U}*fE�����+���2�FP��cxY�'S����"�w��O�������c�d ��2n
(R�:�S�K"pσ!��s�ğj���g�m�+�.�E���ǳJ�b9��M�4f��դ���*8Žܟ3�S�_XFȱ.�&>5��B�+&gI!1����]-D�(D�>^b+��C�L��JQ
Ж�C.��)�y"f�,��bC��o�|v��g�1c��LWot��ō]�$�,*ͦń�� �Wx��{h-];���SV����o�����%6�lr�LضB�a�vtq�������Ɠ<���#R��h �]��������ȉdЂV���V"����L͕�!R��(�+��j#&��Rn1j�N�x���^>���]Q��FڅKⶽ����6��/�!O��cئ8�N��� m"M���(˶�������c�H$	�0V�,����=�LK����ݵ��66wn��V.u��SL�%4!�M����ɐL�'������ٝ�ky���11äk���wK�H��67�wny}�%U跛	K���1��]����w�"Bj�������+���y�f���S�A��:��8Q�otR��B�@.�ek��΍[ٛ���G	Pd���$����K �+��;_#�lm~�χ�6��j�[�D��p����K��.BW4l�	��Nt[�nmm|PX���4Rvdo�$�ݻ?u�_ھ�I����!ŠԊJa�𮭺�w�J!���TX'���J�Q-�N��j���"8+�M�C��o*,,"���$��u:�b���Bz��o<R���IB{�1�Ǻ���
��@�xo����C?�
�$�Wq�2Y�k�+@acQ�]6D���٥k�[��_�v?���^�q��m����&��V�Kπn|߽t��!8$�㘴��.�4�l8���[���y;wW���KŸ�J#i ҃YA�������G�p�%yYn$�&�R�JnW&>,���z��<F�J�u��<
F�B��~%�'��Bѭ�fk�z��F�rg�f������*�
��~۽�޽�z��o��l�?����k8�ؼ����'G���2R�
Y-�5���Q�P��o�V裲�@�d��:�9M�^���u���K���~�U.J	C���Ĵ�A.p��]�4͓PaE��,�w���i%��W��`o��M�MD�� :�
v�C�`6�O<�p���� �@w��{ <��������m����^�6���G�t���{�"�i)
EGQ����	o�y�� D)"��^����� ���2�������������w�Kmm|[����Ksl�|�eѳ��Y󘑪�F]㘭���6�,|I���w�ٳ�=��\+e��zv�뢼����\�v�lv�>Z�}�lv�x�/�@���/�����7����q�{�^��N���|��)�?��;x��1�N��4�_G����W�j �M_l��[\{�06ba9�rؖ(�ⴉ93���Ê�FY�H ;�-����<0:H���CD�|hM����C阋��{��EMճ�� �	���a���?�^.K/�ӱl^�oV 0�-Εw�7�`���}���W�_>�ݾX|DFj����+�Ju��������6lw٦��El��{q7��>~��s�ڭ_>��������U_�ڸ�
��N���vD��)� ��^ -���*��v�Oò
U��d�nt�v�8=V\+W�ص�H?������n��>�Ls-�'�ˎ��c0�������QŐ"��\��RBT�����	���t���~)�H3�rD7�L�X��ǎ�Ǫܙ�O" %��+ �eˑ6��h{�ǄE�d��$L����<�cE�HE] ^`����ͮ�b'�=����T4���n�Sg��#��l��s�sYB��_-��N�@[�n{�����(إ/O����3|St����6�T�:#+��?��{��O?WV�>p48��]�ۑ��*K��ǝ�����.J�T�WR0
_}����F�m|�����{���'�1]�[�n���c�I8G%n���j=�fH�)J�ZR�"78�Z0:n�̒�X�#��<����x�Z��
���gof�o��$+�@1U�g�f�.-�AE*)�'-&�����$�pb���2��.����#�ɰ\�6C���ޗ+&`����ǒTS�7:mSh4f��!�+2��}��:�
�T�@`<�����4�-��4����	�����T�O6�<�0�h�;@A����)2Z ���3���$�R���TWU$@���C�G�z�gK�*Q�ŀf8u��̢	0>!��}6%~�|rz�qD�J���D����P��Ӹ<��>�ڹ��W�����CT4���5@�6m(�������փ� e��$�����h�)6PG���g{���)]'�vSe���5o0���b�ͥA)F$S ]D�i�a8F���<���"a_����ɴ���I�iD�з��B��!�N���k�hJH��!gh���c�[��U���&���-�N�{���O���J�(N	�Q��_� F��+�s7�d8٤M&��t�\vA�@?�}�o�XRض�*	m3H��Ț�b����M�x����N��_7�{���(\��g-(2�,]qB`RQ�n%Zz��s�q��/J;���J(�뮎\ �  ��]��{糡ϒȦ�t�`���o��0��ߋ$\ݝJ���pօ����˼!��z�{����۟?�vC4���F�8n��9�~G}�[>��P���-��_{�#P�x`d��Cd����p�2��@�@NjH:��lD��E[��k>��H�lY�)(,9��_���۳}wuk�B9���\�4����[Y�N,�6.�=�+�l���{ ��J4�a� ;���ޏ_L��18ӱӈ��})�a��<��r� x��b�
v��`��s=�H������c����_��m	��ZL���-�mKY��(�Ve�e�X@X�Ѣ�U��(�L(��^�S)��ۃ�r��Dͭ������2~���	bPYP~|�I�����׫���#��Pj��
�B}�,�s���0ң��QN�t�`�(r�~�g�3M���f~�}~)���-��B'd�9������ýn�.γ_����g��֢,*�D�M��b�qts��;7������iRf]�)�k�s�^�!�^f�%՗-0�����Eu�G��X2�i���a2Ӧ��\�c��Y|���*�>�ב��yA��j������½DO(�o�~]���Ĵpa!�Κ'[��bvh�j1��ﻸ��@�_=\�._��������G9aP���g]j{9�E_��oV$m�2�&l9�B�yl���a�C$:�.$�˥��L�NZ�cV�Idb�n C�:D��X�4��w�~�>�����E��踡i����hrc	k��f�'xR!c��Q���{t}��{��/�}C҆��&��d�o��#�\yոD�#�����m� Ju�������om|�GL }��N;n��X���rQ&)�ʌD���y�N�4&pg������^C�͎�R'Ҁ@G�Q����;eM=�C���dmt��kT���vg�O �+g��\��A�+�~��n�Є��]���n��*J�;BC���Qb���(�y���-'�a&���I\�RO����M�kP���u��p�<�2B]����������cz^�6ZF��gLW@HD(&�ݫ ���ӓ�d���U�֎��MwՀ�D>PpS�6,����g���*FՈk��l��!���*�ڱA%E��sW"�ZrP�y1(��}��j9]�����ք���<8H��m�zYc��rAV�n��GYr)��c�\��z/
����7�%S�d� ���ev���Q�J�nq��&$a�o9,���F�����3$I�tj-/      �      x������ � �      �   �   x�}��n� �kx��OA�x�I��,�W�����~!tj��]����:��d)�3��;����,Ӭ<(��=It%aK4�o�΁v7n#�܊,�e|����k����̣5jFK~��|��<�~�����Vlz����l�aU~���-6�3%2��g9)KT�����!��H�W�Φ�jt�+:\W0!'��nmG?��j�{����]�      �   7   x�3�4202�54�52T00�21�22�360�60�'呚���P�_������� �/      �      x������ � �      �      x������ � �      �      x������ � �      �   W  x����N�0��}�8��q�8!n\�6���IIR6xz�?� �S"�����t�J̵�%jh�#wN��6P{�r�yp��E��ر�����S�W �B�3 ���ʸ�l��3a���|+�5ub� c������w�=�@M�NLm��77��!�� �稶�CC� TT�aB%,�4����BB����L�����0U��&��\��-�Y��J�z4n|���x=˒����(����z#�)��>��@�$x�8�����0&��q��H�~X����)k�Rk,q'M�;���;E����e%Kn��at|N��^�~-�1��7c���eY�	<B�w      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�u�An�0E��)��B"{��x����*�@\�����(w︆V���������,s��RVI��Q�J�#�Gr)+%TR�b��~T7F�d�}��>Nپ����m;P���^�N�9�����5�7jp��B�Mg{�~.h�����������y�w���Ic� .�;����ܰ�#��^�!�ˏ���_`i��_��e�8$�W=B�Dv�XD(x����ֺ����F��o-���8��-�$�dj�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   x  x����n�0��sy
��x_���@Hd+�ӗb�8�{�z�G�� ljG��!�p���� o��d�ɽ�l*�z���D��p��	'L޹T6��=wv�f(F*����m�����"6����	%L��/�O����9��$�9y'k.m	㵨���("�G�+��j�I���+�ID�H0a���s1��Ŏ4X#-h�	�wȠ��V�6�#�	�94��E���.�r��#��VHs�p��֌�>Wm����
H�k��S�l���fGl�qi ���s��˹�n�t.�zL�k;Q�غ��>t0<�F��ȉ�wz��x�b����; �aa�g���Lu^gy������'��D�$4�����l�3�*      �   �   x���;�0k������� � Q�HQ�/~��SPϛy���PMԠ�t�G�ֵ���ѱ�g� �R-#IY����zCjR��"P#K��1ᎎs�>�_�8�v�����t��]��_ 	�A�      �      x������ � �      �   v   x�3�4202�5��52R0��24�26�341�60�'哟���P\�_���ʙ�A�j������Լ����%+%�*�҂��Ĕb�Z���̪T���������A-'�>�2��4�=... �}-|      �   s   x�3�4202�5��52R0��24�26�345�60�H�Z([[XX�YZ�����d���k^�\�t���8c�8K8�8-8���2t���b9S�tC�9�kAr1~\1z\\\ �. �      �      x������ � �      �   ~  x�}Q�j�0>�>��)RFr��,����g7�ږ�'$���J�Bh/�^JK��&�u��y��B���@��f�}��L���5�Μ4�D�^Z�
:���CEKsܰt��v^��������x�/�{�G�+�0��s%��1K�Qk�N�0��޸���]�J�*�{����������T:Ҩ���$��\���dzx0M_!���O��W�~�^�"*��q���t�=j^�M=n�i`r��"n��T[�~�n���7�?�\��|�Zu��)��LE]ez�r~�w��lWO��I����ι^u��c%���5����pqu��W�[gVT,���S��]�u �T�8I�b��U/����=�Z[Q�)x�����@إj���d�(d��      �      x������ � �      �   �  x���K��@�ϙO��t��<�xT<)����i7�h��H{�����DA��.���ęoa�L�1�(+.�@����~�WD\�B@|Q��BȐ!�F�`�'!3.�-�@'S���f�NE	dշ�2"Nƅ��
�Y���b��~}<���}~���\5&�I$&V���בԦ#�3��ذ2uɬ��e�# j#�3�#	��g @�m���5�p^�Tu\�To�,Jr(�Q��J���ї��F�&��΃���v�`��?ݹ׼��
\p�u���Q�%����ւj-BNB�<�Qw��"�e"�q������f�U���᷻ͻ�k�����WX��jQ�"uF�c(ݖ�#	eky�i��uϗw!������g�?ڧ�O�\�N��(V�O�A^�k�@�G>�S]L&�A��D�h0ǥ������7Yk-�*b\ג;��y�.��ڮb�;]i�-Yd��
���WW.�����ܸ���1���~I�zV      �      x��\[sǕ~������43��i��+�ݭě��+�R���b[��^W�	 ��]"	� 	���H� xq!����yr~�~�{0)����k���t�����t�T��Qݮ~�RU����^���~�Y}a���i�w�.-��~�ɧ���Koxq�,���O�X�Ζ
|�����r����s��q����ɮ��e��O\�f�vx��Cj�)����~�x�ڔ'8��.���ʔ�L�=�TL���c�n��@��嗣^�%W������_L=z���_?/��G�>{�?����G?�w���z��黿��K�4��
�4�=.�����{��Zů������<����2���Z�r���^i��wTb��n�$���,��/Ύ�]}�ƫ!0�v�ׯ����4���n�о�k�p���F&�:c3,_=�ݳ��>�y�\״)-8�h7�ٜ5ݫO�k���=�W��;�U�����SvZ7������./5m���f�Ysf�ţFsS�E%�z5���G�}�/>���O�h�eu�z���]�U���Wv,��z�,�����y�)�����]@�=(
˝�ys7�^�oE��	�U.��x���	��k��*�׳��m�r#�"��i�;�$�PX���	d�HN�z�+GhLzܩ���{��9' n㠅f�7��=�%o��@�%_�X�/�Y>�Z��K=�W0n��C�B�+�L��=�y��,����/ g�f��va.�W㪏�_�n��b�������ss.�bi�&��D��o��e��0�+,�86F�2���9)}��[}�aLo���1��{l0�2ms-*H�+� ��F��^_ַJz���ʹ��]}&�Y=�6ˣ΂>����Y�!�v���J�Ԏq�ԻC9�3��1��2/e_��y��`����$h�_��)��Y�ct}�X�q��RF�` ����>�1���aH�x���b5�C@��t!n�=O�������]�ӷzb�i�M��LW��e�k�yhWO�z{ư \`�h�|Yn�%W�L\��i�ң(�E��|���%weS��e�3�F�����;���!�y�h���2qxc���G�?{�_Gg) �
�Pۗ��I�e������&.��X���B�x6!����ƠǗ�����,o��x�+l��,���)����u􇸁�ɰ|�����4qh7����]��,����d�����&'��f��nė��8����5=�߄��.�`�������s���Q�`%<4�G�~��4W����溯�9�k��F�6y�M�N���ޯ�}��S
���쫏�~���ōT3^E�"��/�|��g&���[h��X�fr��ʵ�q�q��
�䨳���:V}{z�O0����F�a�e{x5����������L�����	�I#Okr#��ųP�,$)�0-Fc�ş����Us�lٕx����j�l�y��F����&�i�X�'�ch�vI	1r��.i�)�o��I�=�{���#�b�M,����7�$hu��xf�y&{���"b�=�h��z��Ƒؐyh$���5��K�F����c'#h���J]�����41�7�*K��ax4~Z�5nN��0C�Q��X�^�%%o,�h�5�${ 	�`Gݬ1�A�F��jY����� A6��� �;��i���(�_�9�2>3i㨦/��d�8�'I�i٤���<�����m�7{%\���tѻk�$���%���֍���	@�*�6p����?`�|uz��&ͥ5��aYғ�PU� ��L�xխH�qY8=�{9�Z��b�+��溎�![7:9}-k��@�*�8k�j�bwk'=%�k+����%'�lj&��DB�*��2r�����7[[�b������^�7��z���QG�)3�˳LL�B$#�w�З�!�b��
�\��m�B�=�3�+���P,^�hA�iL���5��	I�tc�,���/F����I�ѷr*�߀��Y�	m���;�,�R�^ܔ�p�,Y�����0�� ��Y�х���4ϭ�5�T�X��$I�zU�X�F����M3�g�6�kV�F�M	�5��St�F�V�E3pdrU�5�ړ,'u�^�S`�P�Q���W:,I!ͨd.�)���U�8[��\X�ّ^�����6�.���P��X--�;q,�f�UPv'3�H^��s'6��N��NܲN�����ŏ�����dA��K�s[���*��{M��I�%뼝�����Kpp�z��0��H��ǣ� 62	a*Wx�̣��2 &X�5X�@ưz`�2	�d'ϋ�ABӟf���!�c$R�~��_�����B�cMd�,y� x�Ф������I��P���,�B��C�,y�<�)��h@)�	���<P!����#�zȶ^�|f4���xW����D�R���t���������.ik���F�"W�Jϗ,i��`l�R^*��=O�G/�c��@#'����+}�5���I�o���M�Q	�4������J�$�[!���K�3���^����]8I�Xd�Ec="-2l8��s۶�$�����T,�m��� -��h�33�f#?0+��_
�M�;�!�#��׋R",��#<�@{�/�	vR��E��(�9߱LPo����[c]Y2���6O�Q���h���b�aX�+G�+>��:�,�)����b_
b�Kҁ�ah�a��m~�Hv�-rp�G.1II�*#����īPF�D�r��^�b⼘B��fz����qc���HY|��������ߛ�z6��ƽ=�{��A������4e�{ob�W�4_��4�@�J,a�>����km�iJ��C}�cX!<���Z�����hf��쾲9W�k��k���a#X��C����0�t�^Y�Gd9��5րHf��3|���X�e���M�g˺�M[<c���c����42�	��r�WГ��5Xl�h�'�҄��Y1V�P5}f��D�>'��J�/Ҷ�I&��<��Z0?)s|��+�S5Xއ=_y���x (���"o�i��F��R7_���2�@��c��1گU�����H��/�T6Ѽ����>P5z@u�{^�[K����%ʠM��A�ݔ�{qˤl�]�"�����������@�Aq(S#�Ң&��iW��Ⱥ-K=Xc�T�ى������=�ؘK+D)��=Rx��q�@oE�.�u���:����(.�F�,֟ ј@d �i�j��r�N� ��P��3D��(�z2�T��4���9?R�|ܜK�ۈ�l�A&���P۬#�ϸ\���G���gÙq��	T�KSڥt�r�.hW��WU�����J��D!� i�Tr���P�r�.ұ0�$^���I�4˧f�ŷW��\2��70��V�7礖X+�6Ͽ�e�An~��Ŝ\��'.��o��T���S�)O`J�_���S길�z�����r��W����?}�ٳG �.Us��������s�[E��#3�Ot?	���٥)w��$����?~���"���W@9��jsk�}Ӄ�8^���Z!#7��t��W�O�¡�(?��_��*�����^���bO�2Ͻ����1?��V���!Tݪ_�����JCF�V�%�� �zoV��F(�a�q���k�m�Z���D�����+|>r�X]��Vy�ޯ��o�^��7����w�������si�	R�[�byR�i��K.���c��>p���t�`l_���n���g���>p���g���>p���g���>p���g���>���>*�lh�g.oV%�TLm��H��+n����4�_Qo+<�V��Zs�5�r���7���j�5�)ˑ��'�X�]�N���Y��F�
A�0r,?c;'0�=Dhiݲha#�#�ep���'J�t�Z�r�p�����z-7�o\ނ�Pͪ�W��������[q�"��P�f�Ma�y��@��KUMYZ6C�f$c�"`��*�'3m 2  �����^���X�2���Y��Xw�h֑ZKʒ 1VL@������>��A|yXߪ�̴-��2YHHn�9*�P�3�Y��X�4@��퉘�M���M]�8�$��@����Z(��䐧"��l?/c����w�W'�8�>��R�%r�xٟ��]�>{���g$���*+���75�����>Sa�I�i�����ʈ�l��[ad�B^���ǥ�Y�l���u\0&��h�%�09@H�'v$�����iaF]�M1?�?����V?����
=�]nr��(s�b^�hfiw�i��ۅ��~C?��P�0ꐢ�(N�/�I�"�l!�F�N�m'�I�F���I2�z��4�U�,]�Dս+j�%b�!��$$���
�-���j�R�XW�&OL��@u�y�%{ +�Lq�j+����\���d�aC!X��/��s�rF�6-{�7V%n�s��D��ZKD�S�Y��O�"܍u�˦/	���Mʁ\��6�X,��ޟu)f����݃�zR������F>�}��aw׾�V�@ha�t�F�U}���'�#V�/��R��#�)�F�e��&������׋�V5�����Y[���&yT�N���5M��ݻ�ǻ}ʤٟ��LΠ`�7��V�U�_qk����ڝ�N�?>e�(AB������T�滆���	�=<o	���G��~�XiH�h����MPiG��ƛ#5���w�>y��^%D���r���1�����)�Z{�Е���F�!7$��1��.S���i��*L����c~���
�M2��/y3'w3X��Y�1)WY��5/��ȼ�K�"{!9c/2v/ck������'.V]7�琝!i�"�3E3����c���7�Aͯ�  �~����O���>��<>q�g���}����H?�w�W��L���X�X��������q��{4E�݊F���,:�#Tb��?�s/X����wVNE������{*���'v�bÑ��5=�U=�����92��n���w+H�����������㇏\�_	�F��3���Y��tN�b���gl)kh�Xt�%
���u.���qq��s�e��ز��T��B�q1���z�K���x<ޠ�|ש�IBO���]5��qJU�^�굾ڽ�u�L��6�R��/��f�V�|bX�;�깆�w:����^(��ƭh��n��z��)��w�dP����T��rr����9L��r����?" cͻ�bd��[4cisi�©�~��ȥn��x4�r�X����P�����ǿ��'���,�Ү�zG�d��9k�5sΚ�Pg�l��opΚ9g͜�f�Y3笙s��9k�5sΚ9g͜�f�Y3笙s��9k����Y0�嬙�Wa��S�s
t?X�.xu���:�S�s
tN��)�9:�@���S�s
tN��)�9:�@���Ft^EU��|oT������?}���?=���B��NakAq���h�Os������𣧗����}�c�T9�K�0R���L'O+y�T���w�<�*�C]A탇����U&*      �   D   x�3���CC\F���	�`4�&h�M���6AKl��XE1D�1���P�O\1z\\\ Ip>S      �      x������ � �      �   �   x����
�0E��W��ZK��Lv��REBZ�����������HVsof��R�ׄ�i�*X,���c�"��A#��\>*=��Är�,��#,�����lKpAVW��V)5�v�G��η��E�`M����2��dPg�Z�Y��\5�P<�2��!��iء|9��qү��T�՜��y�;y�*֌a      �     x����n�@E��+�o �GԝZd8*�&�b�A�Z��ؤ6M���}���<�$**�[�:� �����H7]<&".�Tg��i��GM���q�mkMIOp,��P�s)lqWe$��ў�t�|��o'�e�dÓ���f�3�ó_�g�S}j��̙3���y+���`W�y��kG�d���r��n}���[A����ս&�o�=���w[VOe��q���x��_q�N�~9u��x��VMk��[/��9�^�u�|�u�}�Eya��      �      x������ � �      �   �   x�3202�5��50Q04�22�20�3���60�4�-��������Ql���d��]�u.������@�l�ΐĤ�T�?*���O�O�HM.-I��M���4��2)04MI�(�°��P����R%����eEU&y����w*�[~Q�gIj.ng���&�d�$gp��qqq �nZ�      �      x���Y��:�m�͜�3{r5���H���^��+�V���W��3�X�� �渘_��3o�����w�{t�m-�������g�)nC�+��y��_�t9���m�]����U����9�����ϱ���Ӯ����OY�=�Qs#��������v�S1��Or̍�!��C"�v���u��#������I�<$�_"9��"˓��1=�n�+������U3��#�?�u��v�9��/!���o��f�rYf��2J��z���.YOyr�]��+z�tou��u�F&λ��|]�b-SsJ�չZ�����xd֯������DL~Z���	M�̫���ٽ*"�?+6����vw]r!G�Jw��p�뾽FL���'9�bn$F=������嬌��̭����(��^�1��˺�z�NsmD�~��/��p��ӟ5���.˻�!r̯z���>��u��g��{��,�Fb���6�WIXŘ5��4�iX��~�F4Q���Jc�$G�C�F����n���kܦ׈���V�8}]/�3]	V/�ܨ��|y��Ww8"J����6?=�|�o�a9���UT�n�H��2n���:��{�=��ϷӁ��ɏ���cI!Ǐ�����m�~F���ŒI5�g���������J�9�N�nVŷ���Y�(�=�o����҈v��a7�o�峮�L����>]_����EL/�Qy�����ě��*�I�&��,\$�J0Y��?^E��E�r�\|�/�a��Z�<���?[J敟o����,ɪ������|{����)bJ����>d�{����O-�WC�:�y��ڻ��:��Ϭ�$�
&r����jh_� ��l��2��k�L#h�O�WU�γ,u��Cu���a!�ϧ��S3��%bZ�H�g"����z�n�z�X!j���0�z�°n0F	�ʡk$jg�hʼ�ώq1�iz��yov};k�B��<՟M^����y�oӟ���r����|x��գ��
e���g~E�n�6���O�u�v���?%��KF��5�4/f�g�Ie���8*�(n�Z�հ;���t�񽿽n�}.�z_��nYm��FTur)����y���,��Y��n�iF�Dis8�YWϷOA؉8�F*賢��e����X�e���8WDОt��О��"���n� #����-"Ȉ]�zƏ����B-�I�@-�I�жB����B�)�2ԣ_���H���)b�{O�*E�m"y������yL��Ҁ'���@G����%�>��"��W'SDLA,�E�����"�װ��(4�Q��P^w�a�>�"��Lv<?��eUtB���i�T�9٭�����~Or���H���K�g��Rn_i�t@U�{��Z ��Cb\��γn�|\�E��gy�� �5I"	�D.1�엠��֡�)r�#;�2�@�wd�	G�}��o�r�,#I.p��Y!2�bB��e* �T����,)A>���ٯ��y��bc9c��a!�gE~Ϟ�N�|�V�mU_�Q��C�,��o>����!�%������(~7�EUa0.���K�c�.�8���z�N_�� �:.��7Q�f�%
�'��G��'QSl�%�bI��&���M$�^l�F=�ci��l�2\l"Ư"2�WI���u����i�OaPݷ�6fy�y�����L�;z��ie�e)bbiCX�f�<�����Y�$p��\������>I���蓒'T`3��d�>V��^Z�,-
C[����g���i�̪������4}D���ײ!X8�t=�Z��BĬ�1-D�p�1C��W�+���~ne� ιSu��p���UG�W�2\uD�p���U'�2L-������g_�~���e�V�h9���}�+t�]����o����&I�a��pA���qט+N�~ �3n*�p~l�ƚ.���^j�TH��L���ON��*�V
5��Mb�{q��l�"��E$9n�`l�-w|3�6a8E{/�ŮZ��ʡς�"��`;�>��D�FZClg)�5�M	S1D8�aS�A��)B*L�����^
���1Í0f��8GTہU�Jf;1���dF.�aԲ,���X*$eH��QԪ,\D�r�_4	�חp��_H��Di�&J�hGřQ�����։�������+7V0R1���ݻ��9�֋�����澾�l~���O�ፄ�!�Ά��?K�A��L��aHː�iq�����j/2h�8�@�� sm�/2N���9Xq5��\��J$��,\3D�v�"\3D�&24M��D�P��p�qv1��+��p;
�4To�PR���#b��	�$v�
3@�bb܈�i"��h+V�@X��U&FDҟ�.t����̤UYh3�1D�0Kdb�C��?3Q�z7�6{�ӟ�O�����i)$v�'���1zBĄ�1�BĴ
�*D�*F9x�
I�����'���DM�ܨ�L(��	%g�p��}����Y.5f���R�n�-�I]=W��8\���)�*�����<
��g�Ӧ���6K�n�_nJ1!B�bJ1QD�bJ1�F�bJ1�H�bJq�J���K�dh����!�ԐLC���:0�}��N9�}�=��~1�t��4�D��}��`w"�X�\]����!���,�p����-�K-�(K�۱ lM.�0��\.�j]��\��^�$M51�H�T�����4pE6�qa`ʼf��6�ӁI�n7[�6�M7���":����?l��%��ucEa�a�0�*\W��U�l{{��b�{m�e17��s��C��׋{�t`I�'9���H��!1-�Y�..�zGLB��{��$�KL"�������ݵ���^b�կ�J+��T�΀�@��$�_B�@���^N�j����B��n �4,����%��\���ᕸF2��r���YaƄo
C��*y[$�l~[�_���@� W̠G�~�R�Hh���	����]�F�݉��%���N���ht�_P06�0P06�0&�X�F�i�'i_�Ң�e�Zp,�w��'�I����$��CE���p\d�	WB��0��-���^hma�������	Ɯ	u�Ƥ�`&<4lo�q``�#`���d->I"��̈́S��pc��nK"�h9l�UǳV�5JZ#q�d�5h&vKӒ�����0�33>1�33>1�8bf|ƌ��Y3>c�ga��,�g� �c�aD�M��4WM�����V�w�):�a� ݒ) �-.�I�Q��	PnZсf-w�Ƞ�dۊ�� &�4xf�5͚�TOf$/�rH��R�c�O�<���J+�纤q��ϒy3�ӟ���6���Z7!�{�$�j�d="\'bVÉ��p"����H�,%�XJ�4�{�q�k#�� "f׆�ٵ!bvm��]"{iDQ��3ӟ��3�{�����Ӂ���j�6ɰH~�GH_+��m���]n�"��qf{Z�7��ł�]�+�r��(�h����Κn18qx���������|�nɣI�6׊>��սK׹��E;�,�o.�R�C u#EA��Ƴ4�و�F�@}y��۟��b�Td|�uW�]�t����0��v+$nA�-��>y�폣���\Ib0@n$�:Y��<��,$�CQS�����e����8����u�:b�����_^�*�C����@Е��(k{D��0�m�aBc��3"WΑ1AH($aL�0&I�$��D�3Q�r���)�Q��S�D��@P7�[@8�n��Q����u�]���4P��P�D��@�D�Ș�����p팪E������3�#�wR�O\x�u[�Ӏ�d���$B�ŐJ�'a�#��J���ő�A2��
c��1�ڄ1�ڄ1ۄ1'ۄ1Gۄa@=�K|�"r��W���ez�A����(�σ��_�>��J�L�{��H���Me��,���AnnL�g�1��}�@dL�� �_�� �_a+8���W�8���W�8���W�8���W�    p���o뮽��M���F=5C3�1C3�1C3��2}�|=�e�\�T3ҟՓ�����O�&b���^�y�*އ�1ب-�ݏê��1�ZL6C	*�H2y6��0ftƌ��Q3:
cFGa��(��1'�������<��"�������A�od�݃�q��ǟ�q��ǟ�q��ǟ�s��1��0���8���_��caP�Ԭ�v�͒�jz�[��Y��g��_Y�;���_��t���"������rT�~��ɣ=�8L���I�d4r#vH����x�����x�����x��9�T�����-�����-�����-�����-����}16�{����&b�o"��&b�o"��&b�o"��&b�o1���x���[�}c�oa��-��1޷0�f*�����������������������1�0�#�x��@�c<aL�#W�y	)~����g.�	|$۪�g����,f���T�ټO��2̪��e~�#�?e��$؍�H�}�w b|"�w b|"�w b|"�w��3��0�w����A�;c|a�� ���1��0&����8D�U2+�B�Y!7+�f�@ܬ��q�B nV��
����L��V�g7��Y10;��%��B�#2������\�$�|���ϒq�Y2n>K��gɸ�,s�;�q��@
�C��ˉ����ˉ����ˉ����ˉ�\�`�c�ra�_.��˅1fR�c�F�c�?�τ�AKpq����'�fJ�]I���v�r&9kbmyl֘"��1F���9D��!bB�T�:�B��]�krI���0x5%n�e�0�f4qo2���?3�U�m,=��������\h��̩ef�h\�ha�7��D�pF,.�;vs��~�o?4'щЁ�)dV�9���1g��a�2fT�fd�0#sh�Ua�)��gn�`N�<���1��9��(���e�H^�(��e�H^F��e%/s����m�Z�����}qRbS)�����aF�2r$/sy��e��������}�lo�d1ψ��a�$e�?6�s�]ʈ����I��-3�%b&�D�Ė���1["fbK�Ll���Ma��P�	c5a��&�qՄ1��0|[݇Jh.=!£:8I/9�Cb�V�-֯����0^:�_�C�{��>�'J2A�*�C�?}����y[���<[����j|KB7���������.b��A �l8�\D��*�ys���9YEĜ�"b�v#³����o�ny�I3�1�=���c��O>���t�%1J1���RB)�g��P����OuЄ�C�+ܼ��1�/K3u��+��W����;��o#�B�obF�sX��9�G��#bf�D&�����ȯ���⸄��2�g�����ǚ/"�?M�&]�������F:Hs���\3I!�*�Y���[�X�0@Y�<J�"3�ǈ3�9�9�(�È3�9�9f� r#r�4@��o\'�t �F�ZfK�.^���NHD)f�'bF}"fԗ.�@D&�SKW6��]ߜ�&bL4c��MĘh"�D�1C��j;�󟡛���x+�$��O�A���F"�=xT�H�0"|5.��D�ԅw���Ƕ��1]<��H֤�w����|I��*+�q:�R�MQ\���]	9^f��ݤ��s��.�� ���t��4��b�	Kt���	.7�B��p'냟7Z�,)�m�q�o@�����m�q{o@�e0r�ͯ�/�r�j3Ӂ�-\���L��fM��Tm7�$Ӂ���]I�e>��4,ӰR�p�1K�4,ӰDL��;��B�Uv>�XNX���"b��4Z�v��@�X"��@��Epc��n�����=����a)��겓qk�W�����uX^|�++4xҁ`H��t�h(U��V�lt�r�<��RWηX̔�Q��n-BL_V�yqz4��y��Y��ߧD�C,d�q���^���~kT�$���[��	���\�o��ܽ������K��C�M���t)g�k���=fI��" ژ�'> �\�C��'�M[n�q�M���!k�$4&��u�����]�� f "b "f "b �`aK�@D����̠A�D̠A��\�/"��柙���O�3�D�*��*.8����·c�L�c6b)���Mq1���e"�)���2���L�ğ
gD�<�"Q_��\U�k�$����r�-��D-}���:�ov\1av���h��c���1�=��X��i3_m2��0&:����î����Pf[)S$��]��t�-]����}·���]!�!�i[y�|̉��+G��`��/����e���y���W�I�b3��D,1�4Xb�g���=�Zb��ǓH����-�K��$��d yf�Ab�08r���qU���- f$"b,�X���Ng9����k���Wپ�u���I>.�H?f���v ��c$�w/�"�S|nC���.����+���Fh<�#�ٖ��o�Hg��s�0\ �!�o�E}�DLF��}Z]���H#���D��@Ĝv#bN�1�݈��nD�i7"�sڍ�;�&�9�&�9�&�9�&-�$U���I"|0 v�Z�v�c	`'��I"fKY3�;�0&"��y'�H�<"f��Y�$R�+O��Y������'�	1&�Gt�8��Ǉ�W���H[Z���R̓��W̩Oa̩Oa̩Oa̹a���-;�&�x
k�YM��AD�uM�nӢ�t�E���8���s6k_祐��!fu��Y"bV����!"fu��Y"���8;����}��y��ma����e("f��Y�"b����� V�9����"z�t`_�Y���{{�"��/��"��b�&��eٝ�C��R�x����}Y>ƍ� �7N�a{dji�/a��%���1�.,�	w!B���Ŋ�Ct*��5m���b�a<�aY�b�v3�1{Dx7+��RZ[n�'�֖��ɠ�i�d���^�T�9�&�x��cy~j�_�_2��:PN�g���O����?Y3�<��k>"�o��סn����~/��9�HĄ J�������#b�����>"&���D|�Ԡ��c�L�<i�p1�}D��1�OdB���MƟ����$�5�s)��y?[u�-b:��R����\��RH��H��#b��i8"�መ�#b��D�5��Ac��@�"�8�����N��,����@4�nv*�e�x-�U���ǥ�=�s�t ��'�pP�L����2):���<*��1�
1G���C�D̀N�'b{1������ja�,]��M�m[�q��d���m,h㧹���������NZ1��1�1pDxE �쀠�e��Dcqю}\.ڑ1[�xaL�3{�9�G�l�1���wD̉8"�."���XPs2Hs�Gs�GsZG"#����LE`�{p��ϯ�g�&Ym��c1�)��l��nU�n�����,Ϋ���S1�#�'�����.:6E%���akT�F��EG����"1S"S�3���sy9�Vy�|FL�J8���Y.���a����Z�����Z��UJ�l"�k%2�5^+k�x�D��J�x�Dx�;-T��s"ƞ1�(�i+ �����̨@Č
D̨@Č
bW̨ ��1��0fT%��*6��ȄaS@��N�t���u�j��z3���Z�h�y\�NM#d��6&��1AD�	"bLc��Dd�5[�+,7'רe7��&�@����T�����)�o��D̴��is�ט2"Ɣ1#|�����  Sn {z+Յ��+�׿}0�S>��4$��竘��v�Gw:��N�p�&m:4ӡ��9$��ی|6RL�'b��|�q�L�y���`%��L��b;Y?��+���Z?��j(�<������B@�e���볞�=0���#'�p�E��aT��D�2���� �jf�nSa9�c���j�)��te��*0ąR���$�3�SB�!�DD�xN"<��ʒ�u�wI�s|�0��ǡ*    ��z��Q����0F�!���2�9L���!�K�����Ƅ�	cB�������n����]�ϼ%�:f���N}�qw�qw�qw�1�U�i&������-�*�	a��自�ˡ*t�����-k0܂GK1���H3� �.x�g40)�����U���,��Z��y�5U�Ȭ�c�ǹ�(����Euhob��'A(ĸ��͎	���Yd'bى�Ev"f���Yd'�م1�����]IU̿3/;���}r�]vӁ93\_6�Y�!��`�!�g����1=����n� q�>@ܦ���m� q�>@ܦsQ�gL� �<o���F��8lr�nD�A��a#����F��@�="B��p�d�c ,��~�g�~��_��,ھn�W�)�4b:���$k�E/�h�e�ja7�ȸ�>2n�����#c-�~.vק,���!O�?�������n����.��g��6���k���߼߂�ێ��p�͎C}��z�vm�h{	o��;��BF�ϊa�]���K�=�#��`D�X�� "GӸjK�\�%��g[���B[��,��졉$������8\���2.��
Ոpi��Yw#2��&�[���zҁZ@e:`������e��<Qj�}�DaІ�dQ�����B:Pz�E��c3O��|��{��7����=��:�"�����Z���L���qu���#�[�2�Q�.�VB��)I�eJ"f���Y�&b� ��5H"����h$6��[�(̬R��yE ���#�X:.�1��~�?$��dǏ���� b�,�ٕ b�nDL��F��1�nD���r�&�Y3��	c�݄1�yaLcRQͼ����1�"f�C��{��y3�!b��Dd��Xk�*��;ax��w22�0���'X�c:0&av'��_�CB���r��e��~f���AW �bfY�0�9�e���;L���D��@��7+D��`��t��L�V���X��ɫ��l�����άLt�B�D�1�-2���aLt�0Nɘ�aḶ0&�@�2�����>����k"��H_�s�ޏx1���_��;u^�^�����}���\I�����3Ey&����`��'b<"ƃ!b<"ƃ!b<i'��c<a�#��`�1�0&$�a,HĄx1授1wD��#b̝tc�1�Nc�1�Nc�A_O���x/.���ԧY�l�G��^�C�ɵn0-��%b�_"��f1[����z�FL~?�$b���$̭n(X�B#fi�<b>��#˼͌L��k"��'b"��'���1n�0��,~�����?e:pD�r���q����$G}�VӁ���=I��Fb�;��a:PS�=�17��Ę[��w�G򸼋����Ud��OV.���ƻ���th5v�=I�
��JǅVT�$�
"�L���%�2T!Ñ�.���)z괹��_l�fcF�A{fd�0#s�3*�32R���&��a�)��\6ǌ�0�=͕u̩#�]1�����Yɥ�`$/#G�27�I^q�����˄�I^�"+��ȑ�L8��enĒ����܈&y���$/#G�2�����K�2r$/tQ��6���DP��JJl����F)1��⽲(�YR&b����RFc�0<K"(�;���H���GL��fVW]�:�[!�+'/��͵kR���e���+c��v��]aX 7�9�GX :��mg���6��s��2��ɧ�x���y5O��S�ZFL6�v�<]��e��OpN EJõ���$\�D�pm��b�=�m��^�;qB���v��C�m���2]��6���ţ�W���ُ]8�o[A̢�ԡّ�s*��	� bB/�L�^�v�7�|08HβAq]ـL�����9ӟe˛���?�ǿO�! ��{��l�^	b ̓B��2���0������9�:�skY����~s�GLέ������7�8��}�lv�a�y�<�P���p����?�@&���R�n�ʬ��#̲,��#M��n�mq\؍Ca�s�Ҙ`�Ƭ S�A(�,S�Ľ��H7�c�f͙9��g�S#i�I��A�����=I�!7��k],U��"b�{n$�}j�Fb|�Ӂ$�H��ƿ�l�[
!b�L�P�BČ���$�+��s ���J2����3X+G�Hbp�=�@s�6s�YzJ����
hZ���K�e"b<<"��25�-�E&�����#bb��L�#&j������b17Q1o���^l�e��Ts33!���M�L��LL��x����m���Q"FI�L(	Q΃��Lp��ąIm9 �d��"�=�G�~DLf7�ťL�����_����l(�DfC�R"�(�O�oO�WU��*b��`L�-����������_`	 f.H�]Vd��rp���̨|'����]M���1��1�"�D�s>g"ΉLl2C��ɘ���ef�"Ƽ1�Ȅy#j��9�6wi1��DL����Ý���lDLg#b:���&��&��H*I|�ӼI��!b:p���to��1�+�O��i9"���c��&�G��aD7R�%,��"FK�-!bf����x�E|����0?�D.�g�5G��NN������w'�C�D1;#D�>�v�\Ȍ0 Y�'��S���1�,DХ�^z����3�@:��>k��]��4�����.�Qe"F�����ewؕ��m��$��^<��z���Ha�UŪ̫���)K��2rϳ��Ã�bi�595ÜL��0&��u`쁈A��DL�;�4�KũF>�c�w�2����FbaN��t���d~�֒��o�Y���w�x+��^0��jk-�᧙m{� �b6�)� �b6�)� �b��)� �b�$J1�LxR�6��R2�#i&L|)�4��y=���"b:0+�0�W�z��W�?��j߾���{�L��Ґ��n��m�\�	�jj�<����|XJN���wB�x'D�wB�x'DL��Q1#A��Hq1Jޓ��J�97!bLа0�`����1�d��s2D�9"�sN��9'CĜ�!���c��c��c�[sNFsN��l�1��D�(�J��Y1˚D̚��W��%�y&���ǉ4�
&��jcv�Y�q���3sF#�t�T����?aٟ�]ݏ���̪��OY,�̻�5ʜw��q�d�;rH�*����]%>4���%��5F
c�eZ�_ic���m��2V�'%���-4V=ҁ3����r���>b��Izv�Au�k&j�C����%�0LԾ,?�����!�}��&y]�q�t`��>/�f��C�o��a^����������e�:EL?\�:�����E��T�;�۪>��ZW��H�|�^��-S,"�����E��/�$"��aym����	�S�X�ƛ��w�
4v�fs��ߌ���A�2�C�2g5�^��32R��9���̉fd�0#�C~�n��P=�Ӂs�8��"���h���?��2[�e�����v��c��D&&�D�|0hA��2qg���w�� )�d6*��EŲW�a)��hNΰ9�Y�5b$+sp�Y�8���#y��3��9�#y9��98#y��>ɋ.?t������崿�Us��D̒:��N�,�1K�D�"�ۉL�v��4����D�?a����_(=�l����š��o7r<���c3+�l��E�h[:)�h[�~QF�Ef+nM��GS�E���#�"�G?�x*����c�Ũw�~��Y&$b�	��eB"�j�$�����bV���D"f%Q�l��(�YI��c	c�a�܍�3�i��^�2f݇]����efϜ��c!Ց��֘�Y"QFD�!�z� ��D�p������L=������ro��DL��L��)6�%	��9�HĘC"�ras��Tms������	V�k�G�{��b�s��b�s�2���Ғ�0���6�l}l�m���)"f�!b"f�!b����Q�H��`SyR�,F'feF'"ntƌN�I3:	���^��ד�;��$,Fj���Z6ۥ8fc_�2r$/�    ��e��%/#G�2g%/nɼ�������_��d\����,T��It�׀`zT"��=1g�0�!�B�t�H��j}�'��,sb�8/Aժ�6�Kbs�P&&q����l��q4�:��d�G���0#��~�ٜ�G�%��`�b'_eՓ�2� ~��O�Wy��u���y1xF����p����q0��4���gaF6�f1+�1�]I���J�|�D��X�H)R���pN���x�|�a���0#_�99��<��waF��l��wF�+3�]����*|Wf�L �|�a��0#�e�Q��*Ì|o�)��7�K1���Fr\X.�e���V]1�)��'���F"<G�LN���	39!b&'D�䄈��1K^D̤B�3��L*�1�
a̤BW��6�RD���\�3Z���9�����@��l�|W���l�(��f_Ou���;b:p�<>��~�Z�J1+n�ӈH�1��C�D����8I�@	O�'�B|��to���1 bVH�_���,�ON��qd�1C�0f��EsXh6aL����#bB_���I���W"&���	}%bB_���WTM�0&�U�*�	}Ƅ�
c���ڬ^�Xl *=g��F�H�'L_���<�������LN���{d/��3X���c;φ�n1��[]��K�.���������="b�#"�="b�#"�="b�#"�="��#a�{$�q��1�0�b����Q�"ퟰ��sL���Q,��!b�SX��V�k^g󍐣����y��O׿�8��n=���(����3"9��A�Z��jx%��q/�m,��g�|X�"b�{�%9�bn$���x1D�C�x1D�#i�a�.?S��i�_nW�!{=:�$���J~�#�xD��H�	c&�`���=���AaN�������������ݡ�ݡ�ޡK��pa�5,�t��PH�%"sƄ�g�p��VY(3���5.��~1.7�r1.7�r1.7�r˨f\na��-�q��1.�0��&ˑ�ENÚuڽ���>#��z�~��,�Y#$^�Xͮ�6m���8%�=I�ځ�H`�L����g�}/��#"��#"�Fc"�n""�n""&R��D�Q� ����/D�kџK[�1�2�gg��vX�ջh����=�i�.6������Lv�,$�0��^D��H����î>�����%'�6$�`�I���_ha��t��4?��%�GL������l��1b:���Η�?�}��w�$q��&�g��EytİnH��A��J+�>��1�D≈	a1������q�����6��V���L�c)��L��3��Ddb]Iz�,\�d�p1��͜��#�C����Kи�M�����q!���[sJ�ٵVӁ�/~Or�&~5�$��$��W�Ȃ_M"~5�b���e�����D��"&THt�D�c�X�1��	aL��0f�^3q�f��0�f����a9�o���I:3I�nt"f�N�L҉�I:3I'b&�D�$]3I�L҅1�93-�9�LĜ�"b�)A�.��}�3������Cl�M���.�O��zy*��_wI���ƒ�ry�sq �L�Z11��`��P�����o"��6s⚈y��;U+�9+�9�*�9�*����p�7G�'B�
oNf��s rB����$��dx? \>"Tf�|D�C+�jb-�A��=��9� ����D�c�ׅ1s�]saYO�]��o�y��<�$�I)��)���	��W��� �I.�`D�k.�y������߮���1�3"f~F��ψ���L�W���Ș�vy�������R�?�n}y��Ǥ���!�)+^��r��I1�HA����������y-Dx��}k�Y1�����D���1�_�	�/���d��'b,?t%9���3SD���0E�,L1�Z�l�Xk�Ș�)"faJzT������1���1|D��#b�	�'���	���j�c����g���F)�?a�l�p���5C��fO��WB��WB�Jk�â�-/ϮvF�h�aD���#7�y�*aN�Sʄu�/�aDP(��.*�d��J��	���U�����p���HvAQ[,�Dm�L�Eu�V���7J}�9u"bԉ�Q'"F���Ed��:]!ct�t���fs����%b6w���]"fs���ܕ��a]0�]��!�	+�l��ͥ�7��5b:��Ɨ���M���t�y�ٜ�����Y�A\�=5�Bn$��1��js~�_Ӂ���$�b&�C"	��ĸ��z/�ŮZ�4Y�t`��'�II��$�`�I�� �f��ɢ}�����%&9NsXb�˝,1�t����~�cZ�o�z{Z�i��^������ ��Y�\�����;3x�/��˹�	���6Xx,�1�DL�.EĄK1�Rd¥�1�Rp)a8E�Ϸ�l�h���	�qRg�pG���Z�3@x_u�ى�O2�]�Ĺ�ib�e#8��D̉)"&֘��5&�[�M�������������&��i8�FSAi��D8�����lj"5˂� |�Y�#b�`��%"f	��Y���7K0�L,�k�`Ș%"f	�ġ:�d�lT"\����eTP"|��C�N�`�0+FD̊�bDĬ1+FD�V��5+Fb�jAĬ��zPz8\T�ZASP-��X-Ԃ��jAĘH��jJ-�V�sp���h��隣����� �����XCČ5D�XCČ5D8�; aa#Bw�W��pw���� >�w��L�D�B����0�	
*�yFOެ�된�"��?�k寢��*����>��u��W�,b�3�Ǧ��U�o�ZHl�^��e�O��1b�SOr���H��W�1	�o�@"�o��DPE`��V#�fs�J���Rq��`�1O�c"�D}ؗa�1��1��17B1W,Kh���Lsy�0�*.a�uU���'��'c.I�\8$���G^U�^�^���*"\E�"�g�"��f�"b�X"�pA�"¸8�*"�Oѩ��A�ة��n�ml�1oC` 3;9���~~[�������~U��<�����E���z~<,~�E:��ǡ��_����
>�%��h(#5����FČ�D���\�4"PFjn�@ӈ@A�hDd��fg[���.fLĄ1a�DL�1fLĄ1a�DP��R�>��4į��vK3��eaLȲ0f�Ƅ,c&@r\f�"8�.���DJ�������B��3�ߟ����&�Nb�M̿T�1�,t�%ge��Z}nƣ���~Vge�^t�ߏ�����of��a�,�w'���D��?1��D��3�2����	��4�EM�lQAK��L߭�2�����5�@����-���. "fs����"b6�����"��߇$?GLV�<���?�m������vy��-ﱪ�?�.N��/f��()��"��1����?DL�!2�!�c:�9��4�3Ӂ#�<�E1[�D�'��)ޯ���lq
c�8�17Bc�����e`����<=�n�ⱋ��>q�3ϛ�K0�3w}	�3g���m��������H�tG"�;1ݑ�Dw$�#����j��b�/fՈZ��ThӁ���5>�Kr��ܶpl�]YdU�2|�0	��hJ1��bJ1k��l1����rZ�I3�#שHc���t���1�A"f:HĜ:%�p�����L�E�-�׎���~��Y1�]u�h0?�P�9E-u`��)�0�������s{�)%ҟ��������c 9�bu�������qc#ѷ��c1۝ݏ��T��P�&ȅuh�\(� �b�ܣ�P�ٻ����4ۻ��c��E�aD��&9�9f+Y�F���c���	�b漃/��`6WG~�8��Ƭ�Hi���2�� ��BIg����NN�LF���8HČ�D�b'3�1�3�1�3���3��0f�Rc��1�_��S9�E�0���Rܓ��bJq��rl#��^�    �P�{�	RB)�]$H1��H�5��!?3Z�q���]0��q��P�aD�{��r#r�H$r#r�� �ẘL5�!�.G0'3�HN`�����r��{����w�pK0vȢs2w,ѻsoR�q\/�#`\��ːb��)���)�+�T�����U�t ���D��g�g"�)Ŭ�1k"D̚�&BdbM��[!c�D�0 ��JN�.�ܓ�Zv/�1��șİ���������~�Ìr�6�qόrB�%�%�%c�a�@�~���� �dN�AE���dj9���X<�$.υ2�搽���2Q'����~J!�$�0'�5'�@MN�:W��ҷӁ��];�u�ݰ�ELb ���5����g��	�'b�����B���ٶ���������4�M��t`�Y��C<��e����0�DL�(>JĄ�1�DL�(>*��	Ƅ�
���`6��$$b"	��HB"&����$$b"	��HB"&�P��D
�6?���ĉa͉2��sb�ڋf:p�z�ĳ"�g�K���h���6}��e딍��1��DL0!LH�1��DL0!LH�z$�^ER�������c���Mh6"Q�PEs�W�ٰ�N�&�޷��Z��g���V,��6]��>��D�����*ɶ�������$�*En$·�6*HĨ ��D�
1*HĨ ��D�
��İ���Ϻj2���Ð�0c:H�]��.�G����nuH��d~�A b"�A b"�A-7�0L����t�fU|���$b�Xu�s�3?a�������r������ ���x�յ=n���x���:"BۃL"���D�MRD�����_1�K"�K�ly����"���r=h��� qM��=���éY��궑x���ɸ��lT��3%C��}���ذ��h
���g.��wJ���ό����pLfd�s2'�E��ŘnF�t3".�>��CQq���*�4�p4�R7��������2�n2a�{����˶��ߋˏ�珈�@P�LwY|-�3!y�(�E@���Yd���?3�����?Rf��,�X<��z��S��|���ʐ�����v;m����D��H���D��H���D��H���D��HD�@Q����<������2���;�0s?"o��nu��5�x�v�]�	��۸�pƼ@|�\Q�H</�/�K#j���O�u�I��z#�i�<+N��6?O���)/�x����u��
L�!	k֤���Ԓ��F��xB<�w�5��O$L�� ��I����U�^'M�4._��'4OX�z|N#��en��.�	�#l��A��OX����A�
k�T߇nݕ�l'g���lb�%���0��v����u�&ݖ�{���6�|AX�}�>����u�{�]���$�b�|��-�����_�O�����/�OXS��++v�Y�����G���}��O��jsXL~���{�������g�3��º���ǩ��y�L�YS�G����q�����#�oa��3s������������RN~���+7�MQ\���]M�D]�I��W�N"ꆴ��v�����D|<�g�*���5b:p�DȻ�P�q����t�X\ʩZ!jj�8�칝��b�V���]W��qX/�e�pDM��ݦE{�֓�#�
���s6k_��Tሚw �!�E�D0j�
'�;�M�D���Y�8�[�u�~�6�;����š���yX�K!�X�,FFp�e6>H�������YGL��u 
�+f���Qc1":�U��/�C�p1D�_d�#
-��~�,p������m���0a6�9�+{	��0��0��0f�TsvWs�4�K���Ì��R)�����|�\<�Y�t@���j��W�ȡ��D$��D̍�,4wm��AxV��BL��b.�%b.�%b���̰ ��\\X^G�\�KĄ�1�p�W�@� ��2gl��h9v���-��e"�z��x�����O*��| �\s1����T�]�+��L�*k��̌��7����+a�f)obϏ�9���L�;E�jB��t ���ט��!����������2��Y�����f2���0��%�F�� b�"fl!b�Q3�3��K֌-d��B�h�d�|?�����ݹ�O��]r.�Eٞ�������=I>:0�Fb��A�O�Y�s`b�́áa̮�0h���@ �v�͒�j�K$�O���X^�e����H���H�U�$]7?�=DL�������2��x?�~L�au�7��,vB�K�0�K���K���K���K���ew S�*�%ܥP`Ld��8��Bۍ?3x�hY����/�ǈ�O�<���j7���c�r�Y�f,gjD��iD��&sq�G1Wf1Wf1ޟt3��L��1�na̴[3��L������x���x���x���1������#�D�Bä&�ф1#�00�ߙ��\-���%��`����AJ� �٩���ZFU?ԏxSgg��B��b�B b.: bn1 b�71�1�1�qg��1�Ha�o&�9/�9/�99/*y薷4���L��w�,�}�W?Z�t�hD<���r;B�c�.y�u�\_�r�ZV�v��D42��qFV7���g��n1�ݥ���e�}=�6,e�ٙ�Q"e��.�>����Њk�]J1.�	K�e 7���̞��|���׈�O�U��'%$G-��M5��������C$�)��͛�D>�"b�l%bv���7[���#"�xD�v[��*$�����y8��9�@�t$"&�����7a�h���P���R��t`��̫���)ˈ�@�4�������s�_DL�a$ǭ�<��wU%�c1���qӴ��gwf"7��P6��@8���[RhOX3��LF,�Ē�Fd�b��_��J�R����0�����Ġsf2N��!b|G��AX�ƽd�i132R��qR���\3##���94G�О���q��03	"�<S^1m��1���ԙC���5�n�|��D�I
"�$s���9IAĜ��!\yD�I
�~Q�t!�$�^��iۗ�&��������lQ��b��#�g��������6C�t���F����E��~���-�1�/D����B�,�1�/D���?+�7��9�����t��]�!bz�s���C�'��Iק�HҨX���}Y_k�uUv�?��|hlҁ����x/��j�r�uj��~}�e��yH�k��$*���Q�yy�5dc8��ADViQ^~����LwTI�GY�������dU��z{H^��:FL/�q��j��wYTd4��6����t:�"�+���~�w�gV	�8�x�D̆,Ӂ��UL��m��/��o�"��Cn�8�/�*f��%�_�7���~L/���WKN"�%�_�v6�HDL8���Q��H}3Q�DLT)UJd"���YZg����M3���|�-� .�ph5sPv7k�#o���q+8;(��p�R��n
�{Gp�Q����0Xx�UN�sS���~)��2b�����Զ�8�l	c6��a(D~��պ���t�䜋u���G�9�dsK��}_~�X�N7~O����_�^V�}u�o�B:����$��XI�<$�_���}}�N?#n�t`��'�k㱼�n˰|�$��"�?�D�K���yH���y����(��dl0IP�H��o"���D�K�1GT.mt� "��Is��|}������@L����� Eaa�X�lzcȥs�+Q(\�D�'b��t�Y��1��8�-l�Fjk�F��j$R���H�F���p=
��Qs~^���d�p=���G"i��d�z$���Qlp�Ť�k���U"2��*��,\A2��+�H� "Y�����
�Q*\Ab��Dd�0P�%u�cY�B"y�
�W���*$R���H�Bq��Qo2��rS����K9�1^�;���H�X��7�p�	ߘ��0�ҜL bN&1'���	D̠Odj�֜L cN&1'���) ���    	D��"�ds2��9� ���	3я�5'Ș�0".�M�t�w��D��	�%&���BĄ�1a-D����g�;�&b:�,���&����}j���!I!�C�&>����z��\�nY�0Ϊ0Ϊ��'���� � �uE��`�{A&T��	"bB���P!"&T��	"b�:"N��qRs^��us�~zҁ�m���۽�	���	�DL{H���AĴ�D��/bw�틙4��&#2�dR�h2�زg�["fǖ�h,��	U$bBE�E��t"Ʀ1?�	KM��?3�}ß����w��ݢ<GL���G�����c)���p�M�1G�4�pDL�1Gd�ሚS֠1TD��"bw�6w�6v�D�|Xd�G�h���Y"fC`ȋK�d?�ԋ\$������L��MU�hC��IqI�G6�]�1��<����q�x	�H�ͪ�^é[����T"
1JD�(�DD�1:8���QC~+�����x���<���P"fs��9JĜ%b��Ȅ�ug@ɘW��0`f�S�2�63�Ո��j�`���O2�Iĭ�����\5��[Vve����_�l�cvX�1[,=a�z��k�5��jf	Lc���M!�;Ӂˑ0�i��%�(c�R)�TJ�,�1K��cēzH~;5��̢*�$��b��f�b8�ٍ#bv㈘�8���7�G���	��$3��!�ٍc�ٍ#bv�$�<\�D&%qed�?�!t}Pl��6��1�{�=a&6��5�{��ep?�E�����.4V+R�8\�<aL<�0S�����p-341#3d��i��!�������\_��3�R������V��CG��4-m<"�Q�S�v%���2�-#��Ő�2�f%� j4+�~Q����j&	ף0i�"�1���L�^
[���!�M.Ll�Lb�Lj�Lf�Lnꒌ��V��7�V�l6�N�c����z�1A�aLX�0&.C�!��'	3u�2XNX�<�R����LCU
��R�L���R�,\�K΅�x*B�2\�<J�:_���!�baȸ`2.���!��a�LĐ5s}aq]\�Ņ1]\�Ņ1]\�Ņqo���d]_\��e�O��ц�c&qY�0f'��ǑI�<N3�fb'���]��:m櫍�Wú�,@cV �1Kp-a���4�0K�>����1�a�z�0�KƸ��?]�����<a������$b�%c,�[IĘJ"�R1��Ȅ�$;����w��?.k��1vRc'�1vRc'�8;)����L�Ia��쇪�ˡ*��N
c�0�N
c�0�N
c�$g'�����;)�ջ}2n߃��� ��=ȸ}2n߃��� 3��A��Iy��ԥ0�.�1u)��KaL]
c�RS�d��RXS��H����{)����{)���d����Ka&쥰ί���ί$��J2ί$��J2ί$��J>y��J2S~%Yw���>.���>.���>.���¸w����D�� ���`/"&؋�	�"b����e"�D��?3�}#A�e2�W�}�1�W�}�1�W�}�*4�����+��rO���+���+���+��rw�D���r���KaL]
c�RS���ԥ0�.�6���u)�j�e�o�f�_ܕ�D~w�11"�8����mv(V{��J�4�bDL�1�E�4�ZD�v.�e��/C=��ˀ��ˀ��ˀ��ˀ��ˀ�m�ݰ���Ϻj2w����8 b���m"f׀���L��DQ?�3Ӂ�d�,���M�yDL�^�7E����!20O��1>�C1>�C1�Bd��n�&`�5h托Xg"&֙��u&bb����VD��$���I�0Qi��~ZD"��	�_��&���&c&�Ww�w�w�s��u��Y�����j�P�-��xX��ӁJ�q��9�H�AD�D�AD�D�ADL<8*���o.���)�MC��<"�(�0|a�C�2�G��g9���V��1x��/̑�l��9u�z�9C��
^�h$"\YCD�x1`���YZ�\�&���M3A��D���0���|�"���!:�hI��H� ҟ��E,���������N��uW�_�Ǐ�LP�h=ZW"�8����HNБ�n;�W�>�,"��=�Y�=f�m-d��	�1�	�1�	�1�	��pO�M�8kܸ�D�Lĸ�D�Lĸ�DP�2,CQM���j]F��莜&BИ#�0��t����ޞ�8"�?�2��C2+���i!�]&I��AG_;*��V:5�6�q��3��ҧ3���Z�8������]FA:�cv������l-d�6�0����MD�<�:|;9�'��%��D��"�:�	�%�l�[��/"�~1����_�!�
"b��D&��D� ��L������fx�i1�I��z�'�SQfB�����~"F�������l"F���&b4�ȄfK�f��&b4���l"F���&b4�ȄfE]��L�k�/Ҭ?���%b:�٧yv�����K ÚM�h6��D�f�����l"F���&2��R�N�Q�N��8��4�Mk4��l N��Li6Pj6��t������3���)b:p�~vx�}{z.�/��6�BĴ
�*DL�1�B�2{���&��H�_�r����#j��Y��F16���D�� blc#��[g�L�:K]���VG���yޤ��^�}��'�>T����C���M b� ���>@��"�2��l�F�Y�F���&b4���l"F���&b4�Ȅf��A�Y�L������զ���]?E�XGL
��g�X���~2�ڐ0�K�4.ӸDL�1�K�4.ӸD&Wjи6�qc@�B�"ƀ1��1 D&Q�%�����	�U���c��}r��ۈ�Oa��ׇ�㙝��_v����@8����H3��"bvM��j;6➳W�.f���q��*r�&\�G:���$GH���l1��t��'��c�|�#(��GAq��u?[^�m1������m��nK�t["��1ݖ��D&�-Q3���Wu٪�x�2��
�x�VE��!(�0D ��E������l�<ĳ��=^Տw�NH��hv�gD�pF�gD&�3��ΨL^f>l�Uz�n��T����~Y�y�E#d�!a"�!b�qD���#bZ�{cy�d��z��ӡ��є�+�Z �]�5�!Z��q{�@�!�G��q7 A{ps���Ӧ���6K�Ӂݵ�6 ��(��t`so��☯�w10P��c�Wy�ޅ4���]$$		�EBq��@���t�Q5�L���ֱ����$)���³���hÂ(�c�Ȥ�%_�=AD1'|}b�C
�@�|}bc|ba7�H&f��K,b����d���;<��y�?�ߏ|uZEL����u\���f1VR23��3S�P��d��W�!�K�;q��⌓I+e7�i���R�g@$g�
2�����4�_��X�C��a),.�BCH)�y$2�6Ȉ"W"b�@��k��g%��D����bu�٢˳]�t`3�ݗ��:<!Ǯ�0EQm��Ra��F�qh�� ��vf��� ng�ۙa5�5���L�� 5����bm��X ����e��י�4X	�/RkCP�MC q�8@\4��hv�������*��fh�S�t����R���l���A��"7_��@�|��/q�E ��2���Ԡ��ƍ�!blcc�C��"����1�n#�?3�!yŇ�b���e�t�<��{�Ϋ�E�𴌴�� �"%��H	 .R��� �"%�LEJ 5��5�����!�����q6�PC�g\w������H�0�|�8f��2�aD&<u�����5�L�2�f&�-�È>X���1��1��I-��s$�4�H^|��N�c��Ui�����8@"_��,oX��+N���&TD�F���nhFW"ft%bFW"ft%bN��xS9M3���)��������X���$    2Q`��AA"� sP��XqԠq>�L82����f���qm��1ب�ߪ�mw~�^B��L�f�$b�L"f�$b�L"f�$b�L"C&Q3d���L�tg"�&�P�F/�P67z	cn�fb%JX>Ą�38]����a�-���_�U��Z�l��1��D��T"�l*s6��9�JĜM%bΦ1gS����Ta��Ta��Ta��Ta̝x��axT��0椵0����q��n��?��G~�e�3:�6��V���&�Ms\Uq9\���Q�A(�\dK)�s�-��R�u��bJ17�R�A(Ō˔��t!eb覴��^H��� U��4	c��a���Kg�]C����i<wэ:s�� �bԙRB)F�)� �bԙRB)F�)� �bԙRB)���(� �2y.k�6�J�y���F���Ў6�/�������o��7JaJ1JB)��$�b�R��#�A�E�bJ1_D)��єbJ1=�RB)�gP��	R&z�M]�Ĉ9n�N��nX��}�t  �����r�w�t��E^y�	�h:"��=O)��)� �b*�Rܓ��2Qٔ6�� ������N���*j�/��{;�b�'��Q����ˮh�������C�?��g��,֋}�t`5�C7 @�H@E�}����^�EB)��U�l{{���
��R`���n��m��n&RB)0ie^�Mz^�bJ�I�γn�|\��H1���\�>kn�r�JE�A(�w�uS��d�D�A(��Cy�����p)�BoJ����},���.È^pz��v���z�U�aD�1�"�0"ǌ�"�0"ǌ�"�0":��ӡ`I����8/9�Q\�F�@�%�$���C��w]�de���ļ���j���ki��$�:�w˦���� &&�I"nP��uC��C�DLjK�o��3�G!�Q���G�z��%����D�� �jD����$�qقk�a�i��7��y��;�,+�.�`U/�Q$A�ىG.	,�,��a"��)*Kh$�}�8I��Ph�Q�4H#ɔ4
���)i$ɔFB�:�)�$��H(4�s �[IJ��Pb�`�3'�I�vi���-�6�,���pz���K�x	'�d���!��^�zxI^�	/�Q=���/ᄗl�^Rd��p�K�x/)D�K8�%�Ň�T"�%��]��KJ��N$���ó���\��c�������	�8�X+*�_��*
e���b�"1�Z'8�Z':&�pc��l�Sx	'���1D�KD��p�M�h�^�h*��^�)sxɢ��Nx!��*z�ª�Nx!��v�u>��[�o�}��8n��N�f�#`��pmۏ$��m�ޱ9���G�|	�zPpD��Mp��G4����G�<5�uZ����_�]x[�?��s�.�������1����Mc���7W��qw;�����m/'�
C�}u^.����9�x��ΏQ=��ݪ�xm�5���-���p�5��h'���9�&�ګ�;4��~wv��nv����"`�W�w_�����?�5�u�_-�C���l����?&��b0�5ax�LE�W1~tN���x�������iw��];$}ɥ�l�'���v�D�������8!������(�;����>��F�[�Tc���v�l���ucuZ�|�{��#*�?��Xw^��j�|�M�|�i��_�l�x����2��������u�}���f~��]؆m<�����u��]x����=���m���\�o���i4��P�c��NYB
߾��'E$�`�qԓ"R09�I	)e���$ο|����ہ�����]�<��5@�����Ab\�"R�[�b��y�)GZ�W`�ihd�j �bQJp��X�.9�bQJ8g�Ţ�` r�(%e\,J	'�V��.�s'�C#�[��y���|Rhd(42��1Ϳ؜���b}L�L&_���k�e�xhd�xh*V����Y���t1hףU�;�;���Ƞ�F-%2h)�AK�ZJd�R"����Ƞ�sg+W��A���A���A�,����7���E_忳]��R������װy>�f�Ǻy��]���>f�Uc�]-B��6���M�~��������S�G�p��]�sXSݐ���,k�X�5�𒏪��p�9p�ȑ�Q���Qx��h$�K-4j�%4
�����	�F��:e	��B#yM�Fݲ�FB����C�^YB#��H^�Q�,��Pb�ȋGt�%1 V��R�zY^�	/y*�����5�Kާ
�vY^�	/YL^��&��^��':'ڟsh�~`�V��=��/�Ag��[1<��mr����Äq4��&��^�hx�˚��6[|����]��.��Eҗ��8�AY)T8�%w-�De*&��^w?�Y1]��8D��k�8l[�S�;O�]��n�O���8=�C�g����,&�}���f�￧�p��\Rm�`��q,Rą���%��b�)��2�G,� ��B#)�h$� ��B#)�h$� ��B#)�h$� ��B#)�h$�`ղ�FR��0.Kh$IG#)i$�%R��I����	+)�b�K1^�	/)�K���b0���/)�K8�%E\xI1^�	/)�«[ք�p�K����,��^R���g�%�H�R*���\���^R*E���+��^�QxV�\�]��c�'���|#W��hǖR���u�{���D���D��H����bAgl>���͂�.lB�\{��t��������?���3�5p�Ǹsj]��F���"Q-�"Q"W����)��|�(�W�(�x��R�Dg�6��D�_�K%�/!����ľ�̞�_�W�x,��%��%��%�#=%�.w��O�m!���%U;�r���[��q#8���E���+������x�{�c�_ d%E�<ŢDbQ"ϰ(�GX��,J�%����x�7�]��m��{��.���W���;�klV#6����9|�y*ˁ�j	��H`�D+%X)��J�VJ*+�Xy%�R"�Q"Q����HUA�D!J$
QR����g��F�s��7��������,_�U�>x�f��c=������5m/����l���us��n���lO���wٲ^�!�/%����_� �H���Q��;�|������l�����x��h������{��|5�O���kF5߹��\3^VRDB
7�ŕ'E$��ʳs�"R�.�)"!�｣��"R��^���k��{H�%�Qi$��F_�{ObL�F�������TVܝ�3N�y"!�U>������u��f���:��kl�$���3H$�Sb_9�ľr�}���$y�R��uЛߛ�s��v�Hx�(�}t�m��lS"g�9۔�٦D�6%r�)�8۔�l���x�z��yA���PA�{�^Γ��5~�Z�ۅ��N����Z�F�P��<��?��Kh��-�c�<���,'3�%�"����"����"����"����"����"ɌIf4�d}A1�	NE�	^�6����	1�#�_��y,�]x��(~�m;�,Ye)�(K�DYJ$�R"Q����TDYJ�ޔqO�M)�{SJ�ޔ�7�D�M)�{SJ�ޔ��{����9�i~g**���`}m,���[��}z�'����^��JJw[�=���>zK:!y����i:x����4��%���u�ê�ߝ��!~%���a���5����i]��Z��w!��B"]��Z��!��� ��Q����\w�F��E"$8��{o6�ϛ���--�j���Y9	����X9	����T���J�k���N�7?��MY�R޻��N�[sP���$�`�=��!� ��>Hl������ �����N�xo���~��|2%8��~kߝ_;��_���NϫJ%n�yY�K�9݌v���<$��I��E�T�� $E�qRd��"�8)2�I�j����N����v�Z���Q�`�;���5@i�)1o���?����l��$�q5z31L�|�
�}����|���J$�PRB(�ۥ�|7>�6�������P��Y?�2����yC?�4��õ���-�    S"a�	���8!�pBb���>�	I�8!�5ڟv�~`���r=(��A�\J�zP"׃�������zDʋO�����]W�u�رsH��CJ�R"�9���9��6���jWyHc*����}:h� �Y����xu>||���O�q�]_F�P�g ���a����a��O�E7*���Ǒ'3H�Ȕ(=�"��Ph$u���0��B#)�h$O���%4�j/:�H`$IAH#y�M#��HjF�ss	�F2�K#y�N#��(�9^:�C���*�*�iY�( ��^��1����ϱ1��_�iƨ�V��r}떬(�dE�$+J$YQ"ɊIV�H���"YQ�.h� A�wAZqA������o�� ���D.%rA(�y6������5�����kޟ�;�����.�G���{��u�αh���Jw�D�%݁Rv�;۟�C��u���UzL����1�����L���ֽ�qo�kܺ��w)�va�9:�3�m����u�NH�tBJ�R"���
�H7�D�%݀��'����� h��A���7��;X�0+?�Zj/J�j�D�J�R�DjJ�:�D�:%Ui8��6���y%���DJOJ�h�D�=J�P�D�S"�~���|
ME�Z���������98����5#�r�<¨�F��0Jd�Q"#�a���DFXd��Za��㕐F��0Jd�Q"#�a���DFXt?a��a��F7��n_��~�k��h+ObP!>��� E$�H�!E$�H�"E$�H�#E$�H%E$�H/&E$���:)"�%���b0�B\�!۟'ù�/�.��x0Yu���ّiB(d�h���!�&A��C����"Ç��E�)67�Rl�>�ج(2|H�)3�(=��|9�&xUs\䢷�����?���t��wǝ�~������B��"!E�)"!E�)"!E�)"!E�)"!E�)"!E�)"!E�)"�%����b��B\�V2��<���֎������촧���"7ç��;�S���m�)��WP"=�TL�P/c�wj��2�8q#���q����`����7���l��C��������:����?�ťD..%rq)��K�}�����Cj��=�B�,ƍ�2>.$��z�.H,���9�\�}��eэ��h�+����D���P�,ﯘp�Ql���xb���H���W���ݿ�x(K^9s�Ze	�,p�#��-��,��ʒ�ke	WVR���r��ʒ��eI�=,Kx��d3^(�7eI��$v�)Kx��64^��"�|��^3���2�g)N�"U�,n.� ������_,ɺet}�N�^��Zj�DR%��(��F��6J*R��ڨ��F	�(����$�����i����my�N�vA(�B�\J�P"���B�]j�P���������_�� ݯ�����k�_c�/�_��-V�Y�ux��/�v��U綘t��Y�����m�޷�����fڻ�P-�"D��E�HH�/t�"R�]����B)"��k���m"ȩz�G^�&�r#+����[�ȷ�H	)�g�����h$R����l����t��>>����ڏ���d�c0\��p9���5	����2|,���#�<���qL�RRDB�RRDB�RRDB�RRD'מc��T=U$�B\���8&F))"!E�1%2Hi$R�������8N���L�S��a��!���o����va#|����������u����x8_�k�Ӱ���F����rj�3��՜wo>���|�X�kl�=��t��L��G1	��.� ��A!�I#Jl�OHl�O�Ʒ$�τĶτQ��W�k_p)���u��Η;��A�E3w�đT���%������M���M���M���M�d��@���I��M�r�z�3۟_������f�ms��u��E������kl��gg���B��"!E�!)"!EF*)"!E3)��(2�I��@��@��{��B�b��R1�I�z��=���?w~*;����6��/�����_آ3�����b5�N����7�.��g�M�Л�ڣ�,\���J�HHA�fP'K�oP'�>������������I	)��܉������C�������6)"!}�;q�"��sܭ;��h��;n���_)�n��MpX����h���B;�pY�Q��Mp� �v�`�~Mg�Vs�������u�nlV���4kHL�B�"!Eb)"!E�	)"!E�	)"!E�	)"!E�	)"!E�	)"!E�	)"�%�$��h�#�$8�	�D���&8M�#��H4	�h�#�$8�	z)�����������zh���huZM$�P!�@��"���"���"���"���"���"���"��D��,�����Z/����:�c7?߷��崱�@�HH��@�HH��@�HH��@�HH��@�HH��@�HH��@�HH��C�i�#�'8�	�����&8�~�#��H�	�h�#�'8�	_X��g�ͼ?��BÇ���]xPX���վ����r}�-kl�e�G��������a�_���n�ie�-�"��Kf�H�!Œ(xH�d�R,��"��Kf�H�!Œ(xH�d��"q��G�NpD�;�Mp$�G4����G�NpD���r�|݆�mc���Sh��'��A�Ʀq��:���k�魘����y�i���f2�L���l��D�X��"1���"1���"1���"1���"1���"1���"1��D���D�i�#!)8�	�����&8��#��HH
�h�#!)8�	z)����1��"�	����v&���}��C��EB��RDB���(�R$��"R$��"R$��"R$��"R$��"��QM"�&8M�#��H4	�h�#�$8�	�D���&8M�#��Pjw.���<�njl����|6;]ڵ����-���**$X(R$X�"R$X�"R$X�"R$X�"R$X�"R$X�"R$X�"��Q+�1Mp$VG4��X�GbEpD��Mp$VG4��*�mD��L8��Z_�ug6l5��g��v���M�<=���#�xc��`��.�n�&J
q4!�%�%�"��G�,Kh$I|�Q�,��Ph$!�F���FB��DIu�	�FHi$��Ph$��F���FB���c��	%ƈl:ʒт	+��"'�n�%��^��&��^�«Yք�p�K�Gx�ʚ�NxI�	�vY^�	/�ψh^\G��F���m�9l�$Qa��	)��K0��3vP,{�b��y�$5�b��A���=cł:(���ؠ�3vP,�GI��ł-9݂c���\��(I�D��X$G"Np,��#�$8���K�����5����(��c�Z�ϧz�*��5Y<�����Skl�@�������C�}K�_[�Nc�{6b7.�!%oH��}N��Ӵު��CMJ��	'\��k�}�p����j�5�%��B�x<g��?o��e	1�[���N������#n�%4
���Cg�\ϳ��Ze	��B#~�k?_�ƍ��p�vYB#����8G��z�H�NYB#�����9^F��m<�Q�,��Ph�ܰo����`}��èW��H(4��F����Y�ۓi��	%F	_{]����5y4�iP�ĀLX!�,W�Y��Z�{��GЄ�p#{2lw��sL�VY^��&��f��ڹ6��>�9Ԅ�p��x��^^�M��W��	/�D��߮����a��	/��M7����&��7zeMx	'�П���}1}կ�nz�˚�Nd_�Wyz����y��נ��D%��¸�mX���-��Nx�N���=+ބ�
n�!�'�+)����X��5�g�Ƣy�\k���YO���T�$��
��.�Mp�.?j
r�� F
�8e	)R�"R$Փ"R$��"R$I�"R$�"��Ԓ]�ˈ&8�9�#��Hv�d��H��h�#�,8�	�d���&8���#��H�	�hȱ�A�i�#�!8�	NE�^�6��B�ˇT�e	)0�_���&>.� -	  ��uZmW�Ck��ok���>�w��Y2Ֆy�"Y%8�	�dr$�#i���"i���"i���"i���"i���"i��ĥ��]F4�����|6�MZ�gw��F�/�DB���K�����G�WpDI_�Mp$}G4�����E��W]4�����"m�B\�K2���y8T����e��u�>'�e�R��߁`�lu��<��>{���~�����ی��w����;�Mpd֗��p����Y_����)$2�K#I��H�#E$�H�#E$�H�#E$�H�#E$�H�#E$�H�#E$ѧ$�E�Mp$�G4��ۯ�Hn
����&8�w�#��H�	�h�#y'8�	����&"�䝈I�	����&8�&x��"ޑ�va92�k��ڿ�Ĝ�<�q0�������l�k��r�[���R��:gG�=o$���ȑ;'rl�{��sP��bO�@�9;P��(6g�={���@�k�؜(����㥶'b�26gG�=�"���ȑ���#ǞR�csv��(rlΎ{�D��ّcO�ȱ9;r�96g�>�G��ȱ�9�؜9UOfȫ��#�n�L����� n�4hY��#�%ۅ�8����Rv�;'���l�����l0�H��6P$!�b�m�HB �f�@��@�Ͷ�"	��mE)6��K-� ��Ͷ�#� 86�F����$9��c�`�H>�M��#� 86	F����$9��c�`�X> G'�ȑ|�#�"�j�\��)'��,KH�����9#.������F���v�jl6���O��j�������������8>��.l�����͢��эz�Fkt�6�8�KJ�����t��^�k��Ͳ�FB�fZ__���wd�Q�,��Ph����l��r���è]��H(4BL�u���uy=na�)Kh$!�v��tt����0�%4
�O�U{|9�֏V�ʒ;e	�6[�q�uln�0�%4J�"�ˮwެv���N��$�`�
������۬ߝ�9Ԅ�p�*^���u�9V��(k�K8�a� ��eMx	'�02Y'�W��	/�'k��j�5�%����d�^��&��^��I«[ք�p���uKx�ʚ�Nxq�3�D/َ?����;m��)DϊM�#!Wp�X�������|�l�U�?۽v�޾k���Z���v�����P�K��c�]���^c�/�O�E7*�eyR�"
=�̡�Ph$
��̡�Ph$
��̡�P⺾%,Ph$eN\�FR�D�(Kh$I�B#)sh$I�B#)sh$�ER��Iʜ؂	+)OheeNx	'��<	/)s�K8�%�IxI�^�	/�L�#�~�qT�d=j��H�.5S��:�%5Sx	'���	/���K8�%�NxI�^�	/�u�Kj��NxI�^R3��p"OW�6�YQ3Ev���1 <���xp}���ۅ=�G��j�}�G�Pbw��f6:�G���==څ����T�k p��\�'u!R��S�	�FR��H�	%N�[�
�FR�ĥ(Kh$J\���FB��T(4�:�FB��T(4�:�FB��T(4�:�FB�Q$
��Ή�-�����VV焗p�K��:'��^R����9�%��"��4	/ᄗ��%�Ix	'���/)M�K8�%%ExIi^�	/))�KJ��NxII^R���p"�V��YQ�DB���1��.���\��Q����I�<��'�yg[c�/��_����wo��]���y��x����Y�{*�-c�QQ�sȓ:��P�)u��B#�Ph$u��B#�Ph$u��B#�Ph$u��B#�Ph$u��B#�Ph$u��C!
��Ή�R��(�%�TY[0a%�	���	/ᄗ�'�%uNx	'��>	/�s�K8�%�IxI�^�	/�O�K��Nxa|����G�/�7��	�Mq�R4ŁK�^R4��p�K���)��^R섗M�%����MxVM��+�q������?_��v���?�\34�^5�p�%%�\EI	�kb�$%xX�H	�&7R�ŕ���#`Q"%�n\o�׋k	C#A24�B#A)42�C#�642�B#�$�ME-�*���ϻ������oI����K��v�&���g����e���흜������&8���Y_M�,�&E$���iRDB�,�&E$���iRDB�,�&E$���iRD�Z�NG�Mpd�tpDY_Y_Y;�G�NG4�����Mpd�tpDY;ѐck��1Mpd�tpD��5����W��	.�FX�%�g�?o����
;�|�<���y�����kǬ@��LJ��D�J��D�J��DjJ���QQ��VJ���H�_��___�6U�3      �      x���k��ʕ��ί��I03��	ߏ�%���D�43�A�,�E��*_����1fƃ��`��3H2��	2r�kt�4��Br�ެ�ݻ{������WW��X��jժ�V�e!�@�aT`��@T#n0rK�/8���Kt��U�pt����uȊ�QD������8���{��뿧���C�����ר�����u�Y)�>��`���w#D��b�+�<�d�-"(����W�]������3�#4}�K�Y��!�G0�׫��_uf�yð�� 4�����;,���?�����E�� ��Rs��uՌ�Ō��o�iR�P��8z�%k��,_//�o�7��:@5�z��rc�tNXpA3�yi���䎥(a�>�Q���|�G��A��6�;�z�heHm�����;)b���qu���Q0N��&�v�q�$pMЊ3����?��	T����l���a=�;�,ǝp���_�f:��<?����G����^�oט&W��M���0ޘ�kH�t���z��ۧ��Po7mV>Ѫ�|�Bi�%�4��{�z���f��qX���?�A3�G�6�v��!Y�q���e,xW�3��`Qo�m3��lˀ߽~��܍7��
����/����[&y8$�'~��i=�rX��L;���ˮ>7�q�9kW"h�Y���>�PwM����-�#�bHz?M�f�p"�<�e��qX8�*�!�^O8�Z�/ �&�;?�1�]C��z���ҷR�D&D�X�-N[�mI4����'���F;v�w����u?����Q��;��Y1}��{���E	ÑJ�? ��E�r�^�vB#�[��[G�9���x��Pw�=��O��E���)w��ۼ8��:8�IoN��0X���Z�+n�fj�W�������O�7+��l��m2��`��,1F$�l�]T�<�MS�&���M�1J6���������?AEI`�v-o�~��h�S�"�R������lG�&=L�|S��8�H�
ŉo=2@
e���χi�k!�z^��(���Go��oK�ͫߛ߼�H3Os����l����8%y{-j",F�O;���ٹcF1,V�y{���,��
��Vcs�#bk��:77�/�Q�{���(����w�-�i%k��J��7{i�$� ���W���?بR�QG��;����v\c?��Q�O�u�	fL���e�q�T�1��G�Q�)���+
���F]=/�G�.�`5���w����Ay�l�q9[#_L�u��Jך��d4�i	V؟�&7��i�W��~�x��	�{�B��8h�1{�;+ey� ���CϬ�`<O�,n��]��;�i����<�T�Q]������S����
k��9�}ґ�n���zZ�;u�ʛ�~)�i��϶,���3Zi(h�0���-�;W�i~��a��A�H�s�T]�YWȨ3K��s�����N�i�#��+D.� }����2�Cj����q�8J���A��"'"�6�� �׉GB��A�G���B<Y�}�/��_�����/���w:+�lL��ȵW�!ed�F��lK���s|��&�zcI͎��-l&�U��M�5>��?����q��6���o�mh�]k���S-��`N!�Z��mG'�� �3u��ִc��o�]8	�k�����W���_������_���1����A�H/2�gTO�2G�]M�C��Y$ k�$�z���ݮ�g�l���wYX#��������P��O��Wi-���*I���];��sK��q?
�O��Lxh��%�	��JX�G-���(�o���1^L�� 9~��^Vߍw,�d�Qp=V+tmаY]2�$s��g��6!ZZ�#dCR�m�y��&-�F#'k&=�t��:ډN#u��K�/֦��I�-a�Sޏ�O@��a;����׭Ӹ�N+H�ƽߞ��8Ă�qA��Bn���[���+���nv"��7����z!v��|��4�Bk:�f�+:��� 7�ϧ�lm���e�`�G�`�n[F\'c]�i
�.�y�CD�b�C=/� ��������~�����7�o~���qa�QC�z!�@�34��8�U�<t�pc,��u�j�p��i� �8��.e>���>@�L#�T�鐗L�Nt�n�kٟg�������i�f��A	v6�l��h��0+�G�Y���eU�%�"��GEx�b�N��
F
Ă��Hj7��Y�$����Z��E�AjA{�#�gP�"��2C�P������8�#3���AR�Iݓ�sX�V�p)ʁ���$#n�~��g����uF��u�"�q6��4m��s�]�`Z�#���L�e����Â�����)#�Y�5��]�U������1e�6�a���6��0���z���z,3���eޏ�( D�,��y�eۇ���rH�e}׀Z������LYa��h"6ʥ��S����KL��K�ߔ�n�� �H�`b��X)���9�a��'ip��N[�u�;, ��(���h�M�Z?qҖ�O{p��
��k}�{] �&�p��п����S@O�Ů}&��������&G�_����--j���I��4O6�x͛�>�YY�Z��>{����{���~]����Lk�$��(t��E�zM2n��]J�
x���%I�5��ʷl�>�ϑ�֢A� l�+�M�X��!��b�¤�;�@���DT�s�,�f��%�f�p��|��[��N��A��l�6j�#�2Ya�7/�g�"���B�螛k��~|�4�C�P��ƃ�Ҷ�y�/�o�j�@e�! e���f�ը�`3HE�3�JP��� Ѓ�2�.�k<�Y��"X-�;yv���Q�N1dXXV&S	y֔}����smo�|v]��t��,��b�R��0J[++���_�g���42���-�@
ɹpV�_�%w-�d��yk� vhң$��t�����܎����!��v4]2����~�iF��]��͎Ĵ�u�C>�pbpD5�V�y�������
��n�6�����|T/�I48kc�]�`ǳ���Ы�)�oeP���@L1?���>�6Vg7Km����
�z{ǔ���Y�i]������M5eT��q5n�$A��g<�	k�
{��b��I3��� >q�ެ"�x%y9Z��8Y�ltT�(�)b)��K55~s�X�n
��v3]s4вV�e^j����3���-�ti��4S�0�X߬��z$K��
��V���Ht^���{P�ۥސ$9��x���l�J����#E����zE�4������9B��0�h}�J_�^t���~N�� �ܱ7�sD?ԣF&+/t�\��[�	��q3�{�
�D���׸�ʎ�F(����gT9��G��g��c���xZ#{a�u!r\��qEu�������W������?����˯����7��W�������7�׿�ş������?������d*сm��PD(��H����U��8[fL�'��^�9p�^ϜT0W{"���T4ڥԌ���A��q&f��'e�*ѲJQ�{������ٞ��ފe?��,{K��Ǖ��}?�]�g��ڻ;�g]X���WGU�ꡭY���0)�r=}=uͱ����|i�A���]�|s��!bpM��7�Pp�Ȕ;�`m�({*��z�Wei[�B$G�_�\�{��R�k���b�4P����ӚG�]<�
��k�e�^��"���mk\��m�Fh)�����\"tKH��]X�B���.�{�?.o�#��E�T��!��"��8yV�B�J���T�.G�rl�(��&�$�S.�S��=+���WF\���Q�%����ւ��8�� W%5���7?�g���N��B+��uc	��6nTV�n��3��>��|���6���1A"��BIR���N�����S��$Ȭ�O	J��C�d2;�r��J�Wn�z��	𲬩"A��ˇbY_�������O��7{�v�)F�KTI$j�vr)�;�����|    zC>q'�~��X�cZ7d�����2�X�πTB�am
�qa>�Rz��X����ߩTæ���۟������$�u�PE�c����	x}r���z�����q��}or_A����#H�����z�L��Y�	]�#�gEP�&�O�-��c�+�M�>�O(�y��ÎҞ��u���LA�o7�]�$={��:��*�3�D��!��0d@�e(�Ҭh��U��7w�أ*Ж)��-�#���,�f�{ښl�:A��[9���:o���ST��Y�}k1yc���tU�|�I]����u>��,��֊����t�{����_{�JXEn@M2�kM�����4U��K�y��% ��wc4��P�}C�^�s�F�F=��Y#��b�P�i*N	��/��P+;Q�D+n�U�R+����&	���?U����1/����Lg�㜶�ȗy��%/�{�L��Q�ڶh�K��`z��&e]�� �{�~�n� �>("z��pS���Ψ��&\
�E��b�Ie]F��M4HoJD�����1YR1����W@Os�\��R��я�J�Ѷ��� �z�2(��S�����GX�J��T�t{Ftݗ'��֊���f��a�8�`�2��V໵��p���^��d�C�%kj�uֻ~�{�0��d:�z9Y�����5�,�1�b.fs��/lL�ѴYs@}���Py<�Ԁz�j+�^�{����
��$.q�	8vS>Q����^���	�$�.hz�Z�Ot]�>P����d����H#��ȧ��UO����B�,Y	����=�>w��^e���-�%�����ȗ�X�h�!���'��ð������<CE��!��Dۗ��lc|�N��8�M���$DB3�Z9��T@?�x7L�o�_��D:���a�J�^_x;��a�ʼ7GWp<������׬��,�q�N�-8��c>Qr}�}��\ڜ�3w����RC����x�V,�)o$��Lh|��A�ї?x� �����>1���5vl�>�]��f�{b�����Y2n����'���o�q�t'��!v�S��sz�Ʋ����x�Ʋ�����A�t,{�M�s�E�������j6�M��i�O��x��7:���#]GG4�LuEA�]%�cG�˭���&�c��ˤ������@`:���qz?QtA~�-yEKk�&L��T���v�襒��M��фr��7��;��!�c��Ӿf�P԰���{Z^���]�M���t��5���"7�}Q��yv��H:��9-ϣs^����m�ĮD��#�.[�I��
�bP)�/���2l�O�N�H8C��d~4X�#T;U�XȪ���vK=�w�B�ya���P��_ �*�/��2k¤f�����b�����U�XȪ���ƬZ']�u����}Av��#��,F�U����L�B8�:���F �(�H�wF��ճ[4�'�v=�9��9����)��0�H�S�Ck�h�^]�dU�3��0B@c�Ům�u��jre�H�Cn����P1�ǕA��M��{Ķiڱ4D�����YO|�e&eL���8����V��(��������0sCw$����x8�E��H��M�f0�8;ۤ��t������`���o$/J�7vR&@�m�4�9�^�Z���6�#bӧ>����T|�q��2�;�tP�bjH��91��`ￍ]�m؜��!n����q�����pVĆ6���M���$�V^�� �?�vԕ��(��*�vf`����.]�����E�T#W5���4���u��U]�IV���-�<�( �tՅ]������L��/~��Z�/����~�*M-\�!�������k�NU�Fď�12_��r�Q�6�B*�2��XKb�|Зa��P�<+	�(�������H��m?5I�Z�p�XF�ɞ�Apty��4#)�j��b�,�ep�a>fzU��y���G�>$#���ή�@#M�O���b��`t�����=*-4kb6��"����̔�/I�VjE�RF��tI�"ĩ���/gS.��X[�vh��;�����DRG�L�ᕙ�Y�ƥ�%�\+R�����i��b���)�2�e�jS�yX� ���;G�����d�fc圮���!w�:��!�u5̆���i�ŏU��:�i*���"�ql����N;��-�>�P�ٲ6��w20��*EH|�*�o9�2?4���	�tZLM3{���[�����;���.k�H
����yv
��M&2g�4�&iZ�T�2�N1��t�j	ڌ�I���a#Ŵc�y�	�A�M��,�:���4�r�4@ ���T�e���BEˤ@����O�H�Mn�j�Sb�:(��yv��݆�lד4w+��ڤ��Y�Ȳ�끩�h
��V޳�H�?��X�;�����j��XT¶٩ίKc�je?jO% �q$��ٶۣ_����%)�U�ޕR���@˱(��BIF���;�U�_��^�ֽ����j�j�I�c�B�s�f4��79K0uLJ��q�=f�s�k�G�Om�Ěl�̟O���"F;C#j�*j�4S���4��x(�M�0�a3.��2
���U��m\�������Y���hW�R	j����\m	�@m㢀?..�����r\цϸ�z7P�P�j2�������x��uV�f�ŲC�����U\�m\���%��ъ�ֽt�ŷ�a�VZj��������h{���b8/<�"t�NtC�z��@m㢀?��9t�$�y���d��2��"SpQ��qQ��_��F�[ߎL� ;�:�#�HO<��rʁ[mm3 ��\O���.�^������z��0xn���Ή����C��L'�(�DީSՙ�n3�G�t]��������3ǟ��(�%��Q�!��VL`�k�Ȋ�	�l�8�]n��5e�U
�rT)��S�c >4>�ZM��*4$C�2��|��
�BU�UoS� �q��}�q�4��*��
�«�'�ަj���u���^�Cd�աo7"���ѝ�	E-�o!v3�yg|�wW�3@!����\�P�N�`�)�Ƙs����+�u`����p����}�3������BZV��V3�������o]�~�p5�n�����D�/4{{w��H�ڝ1�_I����1� \�*�6o�O��r'o���~�UJ��\'[����Q��HJY	91S�r����S��5���a�;��}V��p;���6g�3����y��׳b���^-�r�ݕ��vW*�����.�nyp�0�6Bo��&ξ���_���m�����+c�F=֠����, ��Iia�D-��m���<��cf�K����
��]9<����Q�f�F���i<�d���߬Q=�v�ʔAB;����հl=]3^����0�����B�0��8	-���Ĉ葥�.���H��6(ꈺ�� ���4Yr\��V6�"���JqD���\��e��0��|<܆<��7��9���Q+�
��	M�*�?��q	��|dw����)=x���DNXδ�5���wk9�����JĚރε�L`�4v��Ðl�7b%��ې������z��R?Wr�o�����t�i$Oْ�W6��@�����L�&W��������ۂB�ϟ&{�� �6�to�ym(�W}߁�7m�Pjg,��O��-����q�/13�֏�03�o��ٲ�E'q�5&g�X�V�4�������>��6���9� �U�PͲD�V�[���"�G��艩D��ևdƥ����u��m\���e����7��Mnly�3�ON�������p?�z�<��34C�&C�E�i����a�- 7�3��9c���.�g��,���zV{��ߛ�g�Th|	�8��v�wR��c�$�x��wJ���Z�-�屭YT"&M�t-э*��#/����b����h� |�9�_V��5��.c8��!1o�z�V�S�Mz��t�,#J-�ì�l���m���cU��%,�    �R����pdiV��{�O�e&A�%IK<�s�h����D���s��a,�ͯBo�$g��aQ`��s�Ts-��D�ȹ0ܬ�.y:��B��T��nJ�$1�~�ϝX�Kk1��M�:I�������cY�G���!��󒎸�O� ۠@����y�>]4%p��ܼ$��4��a��R-��@,��z�ٻ[��O��������$E͊u��R:f�ag������?��ؤm�9<+T?|�;�֍ؑ;"���e"1�Q@*!��0�6��|4���g#�_�&V��p�w����p[����u9������v��S�ٸUf�Gw\�{ߛ�4����ˑ_��z�L���9�!��Ф:�������8��3�����9�o~:�`���ϼ��I�S�6t�p�,�wO�űw��¢��Y����pJ\޳�V}+p��Uw�
T�3�E��|���0S'�$�$l�\�)nb��=�.�^`�~��ja����C�J|������ß�5�����_�kBjRs����(n
聊����ԣ�/PV�	�tx�2���}6Y/����eB��
f%ԥ�h6$^��}+�)��0��^�����_��.{�\˱S��U��A9Aܔ����;yS�)NF������GZ����?�z9�Џ��;��C>���/�ń�(��}k/5�à�����		L#s���B�������҇�sH�ed^F+a�h$�A�}�z{�L�8m�(Ǧ�2��4�6��.ƙN�,��\���>��aY�!J7N���خE)����-��q�nf����`m>9p��L�xh�
�E��Uo�C<#������� ����2ɞ�&`3j����4"���־��v�̆&��"A���1��v3
Ģ!*������կ��������o���E�"*߼����[�M���uv�b���N���6F�q��S��V���^��-l�c`$vʢYW���|�d��O�XG&��Fq������9 '/��ě��xTI��Ak�H
�����=spՂO�£
�i&�ك1g���3=#�A��\�m�}���V�3�j�\��H�Pb,NxcSdE�J"Lߕ�>0��!Q�|��Յ���ǭ��ac�Ez�R��������ǰ m�ҀeݸzB��})dr2]�=�����4�B-E�(��\@?�o����9=�(���+��[����
�'�ަj�J۠�����5�q�|�~�fH��B>���&t$��p`
4��m�;.1&��:Ӊ�7�|@�[�.k	jЁ������G�$a�\G�-����gmg��BJ�$5���Z�C���@,�Q=�	�������j�a
e�!�Z�r���rcW+�}�t��d��\��2���LD�ZWI��ݴ���t]f�h~6p:T%f�l���tݗ:I��d� ����%���V�H�]/������\�rc�o�{ �M�0���J�=1U6Z�����/Sv�Z��aRe�c Gs"�ț^�1����<
�	Θ�ܝ4�F��"B I�Ќ�S;/m�5�ϐ��) m�ﰺf���u�q�F��}O-��|�����d��h��Ʀ��_�>uRy؆����?�����]n�����iv��08Q��S�@��%�焩��q۟^���y��&���*���<��[ �^�`��Yh�ۂ�Y�1El��7�_킨m��DK|�!��ҳ�b1���I4�WՅ'ln�ka���'�4gH���nnÊK�-Y��ҡ�6�,�1� 8)�h�R?�w'Et�,U����n*D�9Q�������QZ�]��Q�g��� �<%�KN�t9�P8?�M��h����V9��-�*&�uu��h~�[�{��ZMN�zH[3���	@��1򆋧cP�	P+���EMsd��q7�{{�>���:v�,鳸eJ��M�����|K�Ï��{�I�@��=�|-��^L�ҍ]+�b��,"(���^��zhz3����P}�Mv�Q��vm{$�z ���4M�4�.�����(G #e�������ԭ�%�t��#��� ���@7nX�5�lT��h#�cA�mR��`�-z-w���ޢ�$G���w��v�5�����رCB���,�:���ȫ��(�t$u�|6��$č��e�=�9L��N���BԮ,Slڴ#�>�@,��z�!r���Po��Y�Ή�`���v���l�$�Q=%{3���J8뾟پQ����|ș�Sw���W'�t=�1���KF�ֶ)����4���]�7͗��T�c$�@�!8=��&�_]#g�p�����W���#���.��F�����*P���q�u�Xk�����ޱ="/�Wvu����F2�ԫ�mI4�m�9w���E!(b�W&4h]�k�J�
�
�#q���t'~���+"���{NhU��Z�S;�.P�{Kܽ�P�9}d�0���U�ܗ��fD��S���@X����0tιCQ�SM�Ii�o���^暅w���k�ܬ�+޸&-@bU�۠~��(���)�Xs��v��1�=�}j�����$1��h- '��L;��s('�}�vЄ�xD�܇V +�=G��*����ȲOE�M�Ohc4�w@�B���vͧ�e^OBNi�I��� ./+=*��0b9}�'�+����a����H� ���l{n��
Ă���!�P���7z
b�Ų���!��A�4ߘ[�8#��f�2�`@8���mLAbAP}$ģD^����$	I�w�S�/�q-o!}�P�)4��)C.w�!�O��p�P�-�Jܸ���z�G��_�.4lS�>MQ���oԽi�OUay=�$I���"�g`��{'��"o��+ױ��َ��>��L���]��!7���,4:�s�AQ�Z~�E(�f�+lw�=���Y������E��&�m��x��k���NM����A��b.�����r�o�.����͟��7���o���Bc���Y��c0>$�|��T�(��` ��j�(F�}X�j�PT=E��_}�/~����&ӿ�A���m2t������k�����먶wJ��C6�E���u5����L���$�&{��E�����:��(3P\c?,������N��>�4����� M�X^H�ʛ�#�ΤQc7q�z�`U�:V<��s�x�5J����=�R�񛧶p�"z9ܨ_R��Q�N���%���1C9<
xs`U�S׍��Í��`���,!g�y�O
��9UZ���[�JD�������g��J�*�e�ZZ��<��?��޴� ���m4ف�	�T�2o*�4Q�U�y�@,��H�#<�s{Z�&�Sg�Z��C����iBAH�P,���Ah���ߕ��)π�BV�};lU,Q ���:uB�[xd�Y$������rr�#�(�.P�*���3�R�rI�(:����S=��\�}��hN���WN�ʪmOT\/1�:!9���y0.܁7:�$6$��<�]?����uk ��:4'�]"�X�n�,��)?��!}�f��lH>Ђ!��e���6�8t�2�뭺��خ-���lk)Ћ���&��ܮN�b��y��|����{��z􏂋"�bۀ��Z 	DYֆ�։����E�,� �k��\t�oko�×t�TB��d�������D>�pL+�̞�U����^��H�����h�gQ9�&\/h�_�p��}
3���ڹ8G�K]ߪ�;��QpOO����\Ėǧ"_�|��� ����ي{F�!�8x�6�׃<��mz�Jڜ�0�< '�0\"!(����Ӥ`�����ϪG���7a m��Mk� h�.�>��I����IV�osMe�Y9ʈ��Bf���?
.��؏�0�HO�EÊ�~�nZ�b�Ҫu	 ����;E�N���~��񉏂���S�lה@P,M�rd���;X�����}��xL^�1�G�GNT�E{�u�_"Q���GƧ^49�� �"��<?{T�8�G�1(.�u�� �����b~�X��S ~  �����C���������M�	ܰf~C���/�w�N�0H�"uA�X~�~yk�YF>�{��]����Tm��ȋb���c�Rc�mDԇ�XK�]��/�]4�mnJV�` �s��|1�]��m��bf�`�x,��~�lc�ɑ��\�C[�^X�/�mD�e��vTX��Q�Jү�>�����<�zv�KE�֖��جN��qh�v��b���`T�1�{&��V�.W��R��lP��I����un�t��:+~;��N���m>U���^�� ��FW+�y�� ��������6�i�z��+�y݅t�2��jU�+�QJ�ih�.�z��8SG��|*,:7B�&�11���Y����P+=$��� ܲm��J��s+MV����W*Y��I�-81���X�0��Oh�3�DZ��P��e�kbˌ��c�5�>�̫H�>�O�T�uB��ԝ���i���#ko�H/�]�x�fmá����	_�����������8%�l�[?^W����|��~��1�mV�����rE��O��ӑ?o?X��;y׳B$���;f s���D��-����1n?�BUv>�;N~՝E
�}��*��	0
��Đ�~O!�H�;��;�g~���S���W���Z"��]ϓݴ���:v'�.�P#�v�2*�x�	B��˫0��On� ���w�ޱ�7n|�f����q���U�W���k���&�����&�����^|x�mE�>��Z=9�-���[�۴�+��@��&�k
m�q�d$��R�����ӄ�w��p�,��2�,;�^��9�%�Gɑ�y��ճ���w�.k�տs:���K4-ʏ�]�[M`�S']��}�hׁ����l���x�C��u�4Di��ѧh��6���}e�yn]i��0*cn�a�v9P 7�z���4ן�����z�,RԬ�r�#�SZ�>��� x@���w���{&T?|k5����
�8�C$Ī�7��|A�@�h��Fk)�^��&V��p�w�36�k�o�~�Nc[�®s��������R�����H�Q0�d�~�>��L�������F��dJ9�'����L�$*{^&�w�#����%`^��ۀ���i��i�IqbяK��"�!�<����7�>��T�Y�nGa�Y�^���P�j�b�x
��������n��9�k�ӟ���������c������l=��O15�Fo��j�6��IU��+�犳��i�fB���k-xE�h4��ί���i���t8�-�����cYŅk�a�]��01����Q���z�(���N�h��@������e7ϐ�������N�f��.T
�6n
������wA�.��f�-� hr��������YG�&Z7�� ��c�݀r������r�-p���2�GG�W9m&����ﱧi`�������L�v�ض��]��P�Y[�H�g` 8���B<���e�{���^���m5 ��sJ�M�Ŏb�rH�$�]���
}���#�u&(�(�$)*_m�S/�z.��I�":�s�J��(&'�'�G��#?��&���6�Y�
�.hs��v�h]
Զ֥�?���P����¸uB{�1��D�I��R�E���E\\�=p��%^�;����G-�Gj�Ej������P�0����[eı�����N�6n
���ܝ��~���,g�LM���]
�6n
��g�ؐ�E���rW����{g��!Rv��s^tU����g6��F�̠@,̠�>#�>�O�1�Z�j��.j�O]��@�������%>��A�\�cC�C� \�@��p6����5�CA�w5��ZTu%;C�e0�H�"']\'�s��v��]��= ^Ӿ���箺���x��,�k=	V�pb���2��Đ�'��/�n��Y�������gJ1.7��au͊鳐����4x=5!9�����aFV��E)�.�^�D�<�$�(�?���2�6��˦� �3zaK��;�Xm���h#6|�)�#`�d
d����m���Q\�&{��b����/�4<0�;}泌.�Z�oT�3"ꖑ$n$����V�'����m��M9�1�d�4�ɡ��/x9U�x{4�R��7$gV�ˌϊ]��N��[������)����s{�&5�0��q뭰��=RpS��qS�7��,��V��z�������W��b�K}23�)�1ֵ��N8Q��y}+�!��íj]/P�+��x^�fIleg3n0h���� ;դZ��qS�?<�����8h=mƭ0==�C���TQ��qS���3w'n���=^DH��6y@����3$�l��e�췙_��
�LFb!�z a�!�_����W��8y���?P0O�Oq�{��> <��|��x����u��q��_�(�yC`E@�î�y�'��^J��zo9F��]�ix����=�n�n��A����T�Ы� �Y&�8[rx��E*�oT|��Kj�:A��#���$|Q{,6c4�HO0��c�-����W��n�����\���"'�|Z�� $� CL���zDŔ���[��9,��Qf@��&F�ɹ�N>���W1�5'� g�;n��wM����V����0�(ȥ��h<5��4h����ԇ~W���9����͒�kk{&�4c�t���֐t=)���,M3�1�$-A�2���1̆��-���"�FS0Ǩg<#�1�iI��x�<��7�-��Z36����֐����(+<��J��u�̆�m�mc�V:�=��mx*���00�7��?�hx�D�V���[�]��j���������;q#�^8�l�q�*&��Z�io
�6n
������R�ױ<{崊KG�Bǃ�U�|���E~\�܎��;Co�����Ӯ�T���ࡀ>�Wcٵ�"Dd^j�k6���@m�����;+��ڜ��M��`f!�K�:Y��qS�?<�r�m�2���v'�=Ea�Y�zF{�����i
��N�Po�=L���`.}70��J��I_j������QRq�Z��C�|qk����el��5-�R�V��
�}���=�1J���H��t��&jƟ�<��8���kq�Z�g�����U�*
Զ�V��_Y�k3i�����([�K�8�ٲԍѶΊL/M�k�J�͌P��i�
!��������zj�z����Pn:X�E���E��4�x³Q�5A���Bmd�'���#kt=*R=D)���(���3�U���8↞�.��������P-��@m����2���VE�ꕾ�U�<�r{���o/��N�7�a׈���6�,���x�=�SuI�Y�U������hZo���Ymj�vzd���vќ�ЃZw��q�h�=2QY�5�G,��"�c��FC]�{����$z�З��.��k͌���ݓ�ݒ8����抇J(��5�/����=Ɔ�R�F���(X�3�����y(�r�(N�A�P�ʃ�_6<�C>������O6����A��-��A�u�����f�!/�z��k����s.n�fT���CA�X���ȕ��:��EU��xYj[U�?<eT��J�z)۶`M����ी��u �_��7�oo/��Z�OW+�x������ͫW����L      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   8  x�}��J1��٧�]�Lf2�dO��x�%f�C[i�A�'<�'�}!��]h�Zp2�|���c�)�)�bg�#n������Fד���^�媬rڨI�<?ȶ�f>31�H)x�IT@�K}>��"֊��Ba�ZJ/bk����:?f}wo��9�5���i-�)7�]�$�������hn��+]��Ė졌��q�}VE�+��U�K�9`�^�0Z�1"8��й��8����(��#��t;-�c�S�}�{{}2ۍ���,5�8 ��>�a8e>�<��#ǘ��#�9'����V�6o���*���      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     