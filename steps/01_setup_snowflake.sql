USE ROLE ACCOUNTADMIN;

CREATE OR ALTER WAREHOUSE QUICKSTART_WH 
  WAREHOUSE_SIZE = XSMALL 
  AUTO_SUSPEND = 300 
  AUTO_RESUME= TRUE;

CREATE OR ALTER DATABASE QUICKSTART_COMMON;

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/AzizKanchwala') -- INSERT YOUR GITHUB USERNAME HERE
  ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY quickstart_common.public.quickstart_repo
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/AzizKanchwala/sfguide-getting-started-with-snowflake-devops'; -- INSERT URL OF FORKED REPO HERE

CREATE OR ALTER DATABASE QUICKSTART_{{environment}};

CREATE OR REPLACE NOTIFICATION INTEGRATION email_integration
  TYPE=EMAIL
  ENABLED=TRUE;

CREATE OR ALTER SCHEMA bronze;
CREATE OR ALTER SCHEMA silver;
CREATE OR ALTER SCHEMA gold;

CREATE OR REPLACE FILE FORMAT bronze.json_format TYPE = 'json';
CREATE OR ALTER STAGE bronze.raw;

copy files into @bronze.raw from @quickstart_common.public.quickstart_repo/branches/main/data/airport_list.json;
