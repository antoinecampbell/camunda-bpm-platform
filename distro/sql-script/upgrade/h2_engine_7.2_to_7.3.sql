-- case management --

ALTER TABLE ACT_RU_CASE_EXECUTION
  ADD SUPER_EXEC_ varchar(64);

ALTER TABLE ACT_RU_CASE_EXECUTION
  ADD REQUIRED_ bit;

-- history --

ALTER TABLE ACT_HI_ACTINST
  ADD CALL_CASE_INST_ID_ varchar(64);

ALTER TABLE ACT_HI_PROCINST
  ADD SUPER_CASE_INSTANCE_ID_ varchar(64);

ALTER TABLE ACT_HI_CASEINST
  ADD SUPER_PROCESS_INSTANCE_ID_ varchar(64);

ALTER TABLE ACT_HI_CASEACTINST
  ADD REQUIRED_ bit;

ALTER TABLE ACT_HI_OP_LOG
  ADD JOB_ID_ varchar(64);

ALTER TABLE ACT_HI_OP_LOG
  ADD JOB_DEF_ID_ varchar(64);

create table ACT_HI_JOB_LOG (
    ID_ varchar(64) not null,
    TIMESTAMP_ timestamp not null,
    JOB_ID_ varchar(64) not null,
    JOB_DUEDATE_ timestamp,
    JOB_RETRIES_ integer,
    JOB_EXCEPTION_MSG_ varchar(4000),
    JOB_EXCEPTION_STACK_ID_ varchar(64),
    JOB_STATE_ integer,
    JOB_DEF_ID_ varchar(64),
    JOB_DEF_TYPE_ varchar(255),
    JOB_DEF_CONFIGURATION_ varchar(255),
    ACT_ID_ varchar(64),
    EXECUTION_ID_ varchar(64),
    PROCESS_INSTANCE_ID_ varchar(64),
    PROCESS_DEF_ID_ varchar(64),
    PROCESS_DEF_KEY_ varchar(64),
    DEPLOYMENT_ID_ varchar(64),
    SEQUENCE_COUNTER_ integer,
    primary key (ID_)
);

create index ACT_IDX_HI_JOB_LOG_PROCINST on ACT_HI_JOB_LOG(PROCESS_INSTANCE_ID_);
create index ACT_IDX_HI_JOB_LOG_PROCDEF on ACT_HI_JOB_LOG(PROCESS_DEF_ID_);

create index ACT_IDX_HI_ACT_INST_COMP on ACT_HI_ACTINST(EXECUTION_ID_, ACT_ID_, END_TIME_, ID_);
create index ACT_IDX_HI_CAS_A_I_COMP on ACT_HI_CASEACTINST(CASE_ACT_ID_, END_TIME_, ID_);

-- history: add columns PROC_DEF_KEY_, PROC_DEF_ID_, CASE_DEF_KEY_, CASE_DEF_ID_ --

ALTER TABLE ACT_HI_PROCINST
  ADD PROC_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_ACTINST
  ADD PROC_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_TASKINST
  ADD PROC_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_TASKINST
  ADD CASE_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_VARINST
  ADD PROC_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_VARINST
  ADD PROC_DEF_ID_ varchar(64);

ALTER TABLE ACT_HI_VARINST
  ADD CASE_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_VARINST
  ADD CASE_DEF_ID_ varchar(64);

ALTER TABLE ACT_HI_DETAIL
  ADD PROC_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_DETAIL
  ADD PROC_DEF_ID_ varchar(64);

ALTER TABLE ACT_HI_DETAIL
  ADD CASE_DEF_KEY_ varchar(255);

ALTER TABLE ACT_HI_DETAIL
  ADD CASE_DEF_ID_ varchar(64);

ALTER TABLE ACT_HI_INCIDENT
  ADD PROC_DEF_KEY_ varchar(255);

-- sequence counter

ALTER TABLE ACT_RU_EXECUTION
  ADD SEQUENCE_COUNTER_ integer;

ALTER TABLE ACT_HI_ACTINST
  ADD SEQUENCE_COUNTER_ integer;

ALTER TABLE ACT_RU_VARIABLE
  ADD SEQUENCE_COUNTER_ integer;

ALTER TABLE ACT_HI_DETAIL
  ADD SEQUENCE_COUNTER_ integer;

ALTER TABLE ACT_RU_JOB
  ADD SEQUENCE_COUNTER_ integer;
