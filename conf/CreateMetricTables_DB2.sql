-- CDC Statistics Warehouse
-- Statements to create DB2 tables and views used by the CDCCollectStats utility

SET SCHEMA CDCSTATS;
CREATE TABLE CDC_STATS_ALL (
	SRC_DATASTORE VARCHAR(30) NOT NULL, 
	SUBSCRIPTION VARCHAR(30) NOT NULL, 
	COLLECT_TS TIMESTAMP NOT NULL,
	SRC_TGT CHAR(1) NOT NULL,
	METRIC_ID INTEGER NOT NULL,
	METRIC_VALUE BIGINT,
	CONSTRAINT CDC_STATS_ALL_PK PRIMARY KEY(SRC_DATASTORE,SUBSCRIPTION,COLLECT_TS,SRC_TGT,METRIC_ID))
	COMPRESS YES;
	
CREATE OR REPLACE VIEW CDC_STATS_SRC_DATASTORE AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 1001, METRIC_VALUE)) AS SRC_DS_TIME_CHECK_MISSED,
		MAX(DECODE(METRIC_ID, 1002, METRIC_VALUE)) AS SRC_DS_FREE_MEMORY_BYTES,
		MAX(DECODE(METRIC_ID, 1003, METRIC_VALUE)) AS SRC_DS_MAX_MEMORY_BYTES,
		MAX(DECODE(METRIC_ID, 1004, METRIC_VALUE)) AS SRC_DS_TOTAL_MEMORY_BYTES,
		MAX(DECODE(METRIC_ID, 1005, METRIC_VALUE)) AS SRC_DS_GARBAGE_COLL_CNT,
		MAX(DECODE(METRIC_ID, 1006, METRIC_VALUE)) AS SRC_DS_GARBAGE_COLL_CPU_MS,
		MAX(DECODE(METRIC_ID, 1007, METRIC_VALUE)) AS SRC_DS_GLOBAL_MEM_MGR_BYTES,
		MAX(DECODE(METRIC_ID, 2401, METRIC_VALUE)) AS SRC_DS_NETWORK_ERRORS
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='S'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_SRC_DB_WORKLOAD AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 1103, METRIC_VALUE)) AS SRC_DB_TOTAL_TX,
		MAX(DECODE(METRIC_ID, 1301, METRIC_VALUE)) AS SRC_DB_IN_SCOPE_TX,
		MAX(DECODE(METRIC_ID, 1310, METRIC_VALUE)) AS SRC_DB_TX_HIST_0X_TO_1_2X,
		MAX(DECODE(METRIC_ID, 1311, METRIC_VALUE)) AS SRC_DB_TX_HIST_1_2X_TO_X,
		MAX(DECODE(METRIC_ID, 1312, METRIC_VALUE)) AS SRC_DB_TX_HIST_X_TO_2X,
		MAX(DECODE(METRIC_ID, 1313, METRIC_VALUE)) AS SRC_DB_TX_HIST_2X_TO_4X,
		MAX(DECODE(METRIC_ID, 1314, METRIC_VALUE)) AS SRC_DB_TX_HIST_4X_TO_8X,
		MAX(DECODE(METRIC_ID, 1315, METRIC_VALUE)) AS SRC_DB_TX_HIST_8X_LARGER
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='S'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_SRC_READ_PARS AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 101, METRIC_VALUE)) AS SRC_READ_DB_BYTES_PROC,
		MAX(DECODE(METRIC_ID, 1101, METRIC_VALUE)) AS SRC_READ_PHYSICAL_BYTES_READ,
		MAX(DECODE(METRIC_ID, 1104, METRIC_VALUE)) AS SRC_READ_THREAD_CPU_MS_PER_S,
		MAX(DECODE(METRIC_ID, 1201, METRIC_VALUE)) AS SRC_PARS_DISK_WRITES_BYTES,
		MAX(DECODE(METRIC_ID, 1202, METRIC_VALUE)) AS SRC_PARS_DISK_READS_BYTES,
		MAX(DECODE(METRIC_ID, 1203, METRIC_VALUE)) AS SRC_PARS_DISK_SIZE_BYTES,
		MAX(DECODE(METRIC_ID, 1304, METRIC_VALUE)) AS SRC_PARS_DDL_OPERATIONS,
		MAX(DECODE(METRIC_ID, 1401, METRIC_VALUE)) AS SRC_SCRAPE_DISK_WRITES_BYTES,
		MAX(DECODE(METRIC_ID, 1402, METRIC_VALUE)) AS SRC_SCRAPE_DISK_READ_BYTES,
		MAX(DECODE(METRIC_ID, 1403, METRIC_VALUE)) AS SRC_SCRAPE_DISK_SIZE_BYTES
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='S'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_SRC_ENG AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 102, METRIC_VALUE)) AS SRC_ENG_BYTES_PROC,
		MAX(DECODE(METRIC_ID, 104, METRIC_VALUE)) AS SRC_ENG_PRE_FILTER_INS,
		MAX(DECODE(METRIC_ID, 105, METRIC_VALUE)) AS SRC_ENG_PRE_FILTER_UPD,
		MAX(DECODE(METRIC_ID, 106, METRIC_VALUE)) AS SRC_ENG_PRE_FILTER_DLT,
		MAX(DECODE(METRIC_ID, 107, METRIC_VALUE)) AS SRC_ENG_POST_FILTER_INS,
		MAX(DECODE(METRIC_ID, 108, METRIC_VALUE)) AS SRC_ENG_POST_FILTER_UPD,
		MAX(DECODE(METRIC_ID, 109, METRIC_VALUE)) AS SRC_ENG_POST_FILTER_DLT,
		MAX(DECODE(METRIC_ID, 118, METRIC_VALUE)) AS SRC_ENG_LATENCY_VALUE_SECS,
		MAX(DECODE(METRIC_ID, 1501, METRIC_VALUE)) AS SRC_ENG_ROWS_DERIVED_COL,
		MAX(DECODE(METRIC_ID, 1502, METRIC_VALUE)) AS SRC_ENG_ROWS_CALLING_SRC_DB,
		MAX(DECODE(METRIC_ID, 1503, METRIC_VALUE)) AS SRC_ENG_ROWS_CALL_USER_EXITS,
		MAX(DECODE(METRIC_ID, 1504, METRIC_VALUE)) AS SRC_ENG_THREAD_CPU_MS_PER_S,
		MAX(DECODE(METRIC_ID, 1507, METRIC_VALUE)) AS SRC_ENG_MBCS_CONV_BYTES
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='S'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_SRC_COMMS AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 103, METRIC_VALUE)) AS SRC_COMMS_BYTES_PROC,
		MAX(DECODE(METRIC_ID, 2402, METRIC_VALUE)) AS SRC_COMMS_NETWORK_LATENCY_MS,
		MAX(DECODE(METRIC_ID, 2404, METRIC_VALUE)) AS SRC_COMMS_MISS_RND_TRIP,
		MAX(DECODE(METRIC_ID, 2406, METRIC_VALUE)) AS SRC_COMMS_KEEP_ALIVE_SENT,
		MAX(DECODE(METRIC_ID, 2408, METRIC_VALUE)) AS SRC_COMMS_BYTES_SENT
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='S'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_TGT_DATASTORE AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 1001, METRIC_VALUE)) AS TGT_DS_TIME_CHECK_MISSED,
		MAX(DECODE(METRIC_ID, 1002, METRIC_VALUE)) AS TGT_DS_FREE_MEMORY_BYTES,
		MAX(DECODE(METRIC_ID, 1003, METRIC_VALUE)) AS TGT_DS_MAX_MEMORY_BYTES,
		MAX(DECODE(METRIC_ID, 1004, METRIC_VALUE)) AS TGT_DS_TOTAL_MEMORY_BYTES,
		MAX(DECODE(METRIC_ID, 1005, METRIC_VALUE)) AS TGT_DS_GARBAGE_COLL_CNT,
		MAX(DECODE(METRIC_ID, 1006, METRIC_VALUE)) AS TGT_DS_GARBAGE_COLL_CPU_MS,
		MAX(DECODE(METRIC_ID, 1007, METRIC_VALUE)) AS TGT_DS_GLOBAL_MEM_MGR_BYTES,
		MAX(DECODE(METRIC_ID, 2401, METRIC_VALUE)) AS TGT_DS_NETWORK_ERRORS
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='T'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_TGT_COMMS AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 201, METRIC_VALUE)) AS TGT_COMMS_BYTES_PROC,
		MAX(DECODE(METRIC_ID, 2403, METRIC_VALUE)) AS TGT_COMMS_NETWORK_LATENCY_MS,
		MAX(DECODE(METRIC_ID, 2405, METRIC_VALUE)) AS TGT_COMMS_MISS_RND_TRIP_RSP,
		MAX(DECODE(METRIC_ID, 2407, METRIC_VALUE)) AS TGT_KEEP_ALIVE_RECEIVED,
		MAX(DECODE(METRIC_ID, 2409, METRIC_VALUE)) AS TGT_BYTES_RECEIVED
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='T'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_TGT_ENG AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 202, METRIC_VALUE)) AS TGT_ENG_BYTES_PROC,
		MAX(DECODE(METRIC_ID, 204, METRIC_VALUE)) AS TGT_ENG_SRC_INS,
		MAX(DECODE(METRIC_ID, 205, METRIC_VALUE)) AS TGT_ENG_SRC_UPD,
		MAX(DECODE(METRIC_ID, 204, METRIC_VALUE)) AS TGT_ENG_SRC_DLT,
		MAX(DECODE(METRIC_ID, 2101, METRIC_VALUE)) AS TGT_ENG_THREAD_CPU_MS_PER_S,
		MAX(DECODE(METRIC_ID, 2103, METRIC_VALUE)) AS TGT_ENG_ROWS_EVAL_EXPR,
		MAX(DECODE(METRIC_ID, 2104, METRIC_VALUE)) AS TGT_ENG_ROWS_CALL_TGT_DB,
		MAX(DECODE(METRIC_ID, 2105, METRIC_VALUE)) AS TGT_ENG_ROWS_CALL_UE,
		MAX(DECODE(METRIC_ID, 2106, METRIC_VALUE)) AS TGT_ENG_MBCS_CONV_BYTES,
		MAX(DECODE(METRIC_ID, 2107, METRIC_VALUE)) AS TGT_ENG_NET_EFF_REMOVAL
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='T'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_TGT_APP AS
	SELECT SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS,
		MAX(DECODE(METRIC_ID, 207, METRIC_VALUE)) AS TGT_APP_INS,
		MAX(DECODE(METRIC_ID, 208, METRIC_VALUE)) AS TGT_APP_UPD,
		MAX(DECODE(METRIC_ID, 209, METRIC_VALUE)) AS TGT_APP_DLT,
		(MAX(DECODE(METRIC_ID, 207, METRIC_VALUE)) + MAX(DECODE(METRIC_ID, 208, METRIC_VALUE)) + MAX(DECODE(METRIC_ID, 209, METRIC_VALUE))) AS TGT_APP_TOTAL_OPS,
		MAX(DECODE(METRIC_ID, 216, METRIC_VALUE)) AS TGT_APP_LATENCY_S,
		MAX(DECODE(METRIC_ID, 2301, METRIC_VALUE)) AS TGT_APP_THREAD_CPU_MS_PER_S,
		MAX(DECODE(METRIC_ID, 2303, METRIC_VALUE)) AS TGT_APP_CDR_CONFLICTS,
		MAX(DECODE(METRIC_ID, 2304, METRIC_VALUE)) AS TGT_APP_ADAPTIVE_APP_CHANGES,
		MAX(DECODE(METRIC_ID, 2305, METRIC_VALUE)) AS TGT_APP_APP_COMMITS,
		MAX(DECODE(METRIC_ID, 2306, METRIC_VALUE)) AS TGT_APP_AVERAGE_ARRAY_SIZE,
		MAX(DECODE(METRIC_ID, 2307, METRIC_VALUE)) AS TGT_APP_DATA_ERRORS_IGNORED,
		MAX(DECODE(METRIC_ID, 2308, METRIC_VALUE)) AS TGT_APP_SLOW_DB_OPERATIONS,
		MAX(DECODE(METRIC_ID, 1706, METRIC_VALUE)) AS TGT_APP_HTTP_PST_CNT,
		MAX(DECODE(METRIC_ID, 1710, METRIC_VALUE)) AS TGT_APP_HTTP_PST_SIZ_0_10,
		MAX(DECODE(METRIC_ID, 1711, METRIC_VALUE)) AS TGT_APP_HTTP_PST_SIZ_11_100,
		MAX(DECODE(METRIC_ID, 1712, METRIC_VALUE)) AS TGT_APP_HTTP_PST_SIZ_101_1000,
		MAX(DECODE(METRIC_ID, 1713, METRIC_VALUE)) AS TGT_APP_HTTP_PST_SIZ_1001_HIGH,
		MAX(DECODE(METRIC_ID, 2108, METRIC_VALUE)) AS TGT_APP_RETRY_ATTEMPT_CNT
	FROM CDC_STATS_ALL
		WHERE SRC_TGT='T'
	GROUP BY SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS;
	
CREATE OR REPLACE VIEW CDC_STATS_TGT_APP_THROUGPUT
AS WITH DELTAS AS 
(SELECT
   ROW_NUMBER() OVER (PARTITION BY SRC_DATASTORE, SUBSCRIPTION ORDER BY COLLECT_TS) row,
   SRC_DATASTORE, SUBSCRIPTION, COLLECT_TS, TGT_APP_INS, TGT_APP_UPD, TGT_APP_DLT, TGT_APP_TOTAL_OPS
 FROM CDC_STATS_TGT_APP)
SELECT B.SRC_DATASTORE, B.SUBSCRIPTION, B.COLLECT_TS, 
  (B.COLLECT_TS-A.COLLECT_TS) TGT_APP_TIME_DELTA,
  (B.TGT_APP_INS-A.TGT_APP_INS) AS TGT_APP_INS_DELTA,
  (B.TGT_APP_UPD-A.TGT_APP_UPD) AS TGT_APP_UPD_DELTA,
  (B.TGT_APP_DLT-A.TGT_APP_DLT) AS TGT_APP_DLT_DELTA,
  (B.TGT_APP_TOTAL_OPS-A.TGT_APP_TOTAL_OPS) AS TGT_APP_TOTAL_OPS_DELTA,
  ((B.TGT_APP_INS-A.TGT_APP_INS)/(B.COLLECT_TS-A.COLLECT_TS)) AS TGT_APP_INS_PER_S,
  ((B.TGT_APP_UPD-A.TGT_APP_UPD)/(B.COLLECT_TS-A.COLLECT_TS)) AS TGT_APP_UPD_PER_S,
  ((B.TGT_APP_DLT-A.TGT_APP_DLT)/(B.COLLECT_TS-A.COLLECT_TS)) AS TGT_APP_DLT_PER_S,
  ((B.TGT_APP_TOTAL_OPS-A.TGT_APP_TOTAL_OPS)/(B.COLLECT_TS-A.COLLECT_TS)) AS TGT_APP_TOTAL_OPS_PER_S
FROM DELTAS A INNER JOIN DELTAS B
ON A.SRC_DATASTORE=B.SRC_DATASTORE AND A.SUBSCRIPTION=B.SUBSCRIPTION AND B.ROW=A.ROW+1
WHERE ((B.TGT_APP_INS-A.TGT_APP_INS)/(B.COLLECT_TS-A.COLLECT_TS)) >=0 AND
      ((B.TGT_APP_UPD-A.TGT_APP_UPD)/(B.COLLECT_TS-A.COLLECT_TS)) >= 0 AND
      ((B.TGT_APP_DLT-A.TGT_APP_DLT)/(B.COLLECT_TS-A.COLLECT_TS)) >= 0;
	
CREATE TABLE CDC_SUB_STATUS (
	SRC_DATASTORE VARCHAR(30) NOT NULL, 
	SUBSCRIPTION VARCHAR(30) NOT NULL, 
	COLLECT_TS TIMESTAMP NOT NULL,
	SUBSCRIPTION_STATUS VARCHAR(30),
	CONSTRAINT CDC_SUB_STATUS PRIMARY KEY(SRC_DATASTORE,SUBSCRIPTION,COLLECT_TS))
	COMPRESS YES;
	
	