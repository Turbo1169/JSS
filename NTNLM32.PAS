{$A-,B-,F-,G+,I-,N-,R-,S-,V-,W-,X+}
{***************************************************************************}
{*                                                                         *}
{*                             NTNLM32.PAS                                 *}
{*                                                                         *}
{*  Copyright 1989-1993  Rainbow Technologies Inc. All Rights Reserved     *}
{*                                                                         *}
{***************************************************************************}

unit NTNLM32;
interface
uses
  WinTypes;

const

  {- ERROR CODES returned by the client interface routines -}

  CL_SUCCESS                      =   0;
  NN_SERVER_NOT_FOUND             =  -1;   {- (nu) Connect()              -}
  NN_INVALID_CONNECTION           =  -2;   {- (nu) all except Connect()   -}
  NN_ALGO_NOT_FOUND               =  -3;   {- FindFirst() FindNext()      -}
  NN_OUT_OF_HANDLES               =  -4;   {- FindFirst()                 -}
  NN_HANDLE_ALREADY_LOCKED        =  -5;   {- Lock()                      -}
  NN_HANDLE_LOCKED                =  -6;   {- Query() UnLock()            -}
  NN_INVALID_FUNCTION             =  -7;   {- garbage packets             -}
  NN_INVALID_UNIT                 =  -8;   {- Unit_Status() Unit_Info()   -}
  CL_RPC_ERROR                    =  -9;   {- open_first_key()            -}
  CL_ALGO_NOT_FOUND               = -10;   {- open_first_key()            -}
  CL_OUT_OF_HANDLES               = -11;   {- open_first_key()            -}
  CL_NO_NETINEL_SERVERS           = -12;   {- open_first_key()            -}
  CL_BAD_HANDLE                   = -13;   {- open_next_key() close_key() -}
  CL_NO_MORE_KEYS                 = -14;   {- open_next_key()             -}
  CL_HANDLE_LOCKED                = -15;   {- query_key()                 -}
  CL_HANDLE_ALREADY_LOCKED        = -16;   {- lock_key()                  -}
  CL_SERVER_DIED                  = -17;   {- all except open_first_key() -}
  CL_SERVER_PROTOCOL              = -18;   {- Connect()                   -}
  CL_NETWORK_INIT                 = -19;   {- Connect()                   -}
  CL_SERVER_NOT_FOUND             = -20;   {- Connect()                   -}
  CL_CANNOT_CONNECT               = -21;   {- Connect()                   -}
  CL_SERVER_BUSY                  = -22;   {- Connect()                   -}
  NN_KEY_REMOVED                  = -23;
  CL_CLIENT_BUSY                  = -24;   {- (Windows) all               -}
                                           {- (OS/2) set_parms            -}
  CL_TASK_TABLE_FULL              = -25;   {- (Windows) DLL can't accept  -}
                                           {-           more users.       -}
  CL_API_ERROR                    = -26;   {-                             -}
  CL_INVALID_REQUEST              = -27;   {- (OS/2) set_parms            -}
  CL_INVALID_HANDLE_TBL_REQ       = -28;
  CL_MEMORY_ALLOCATION_ERR        = -29;
  CL_VERSION_NOT_SUPPORTED        = -30;
  CL_LOADER_NOT_INSTALLED         = -31;
  CL_UNSUPPORTED_PROTOCOL         = -32;
  CL_ASL_OPTION_NOT_AVAILABLE     = -33;
  CL_ASL_MAX_LICENSE_REACHED      = -34;
  CL_ASL_LICENSE_TABLE_FULL       = -35;
  CL_ASL_KEY_REMOVED              = -36;
  CL_ASL_KEY_CONTENT_CHANGED      = -37;
  CL_ASL_OUT_OF_RANGE             = -38;
  CL_ASL_NOT_INUSE_BY_YOU         = -39;
  CL_INVALID_ASLCMD               = -40;
  CL_ASL_RSP_PTR_NULL             = -41;
  CL_FNCT_NOT_AVAIL_IN_LOCAL_MODE = -43;
  NN_BAD_HANDLE                   = -47;
  NN_GET_LIB_PARAMS_ERROR         = -48;
  NN_INVALID_LIB_PARAMS_FUNC      = -49;
  NN_INVALID_KEY_TYPE             = -50;
  NN_SET_LIB_PARAMS_ERROR         = -51;
  CL_DRVR_CONFIGURE_ERR           = -52;
  CL_GET_DRVR_INFO_ERR            = -53;
  CL_INIT_RDP_ERR                 = -54;
  CL_HANDLE_NOT_FOUND             = -55;
  CL_TASK_NOT_FOUND               = -56;

  {- size of a data block for query_key() -}
  QUERY_DATA_SIZE                 = 64;
  SERVER_NAME_SIZE                = 9;

type
  c_cmd_block = record
                  COMMAND : Word;
                  CELL_ADDRESS : Word;
                  CELL_DATA : Word;
                end;

  query_data = record
                 case Boolean of
                   True : (PRO : array[0..QUERY_DATA_SIZE - 1] of Char);
                   False : (C : c_cmd_block);
               end;

const
  {- values for C_CMD_BLOCK.COMMAND field -}
  QC_READ_OP      =  1;

  {- values for C_CMD_BLOCK.CELL_ADDRESS field -}
  QC_HIGH_WATER   = 60;
  QC_RESERVED_1   = 60;
  QC_SERIAL_NO    = 61;
  QC_DEV_ID       = 62;
  QC_PRODUCT_CODE = 63;

  {- information block structure for get_info_key() -}

type
  key_info_block = record
     max_clients : SmallInt; {- maximum number of open handles (0=unlimited) -}
     client_count : SmallInt; {- actual number of currently open handles -}
     locked : SmallInt; {- flag to indicate locked -}
     time_out_ticks : LongInt;
  end;

  key_info_w_handle = record
     kib: key_info_block;
     handle: SmallInt;
  end;

const
  STATS_BLOCK_SIZE = 2500;

type
  stats_block_ptr = ^stats_block;
  stats_block = record
   size : array[0..STATS_BLOCK_SIZE - 1] of Char;
  end;

  {- Function flags - Functions supported by set_rnbo_parms -}
const
  WPF_YIELD        = 1;
  WPF_NETBIOS_CMDS = 2;
  WPF_SET_PROTOCOL = 4;
  SRWP_FLAGS       = WPF_YIELD;

const
  {-  Transport type identifiers  -}
  XP_FIRST      = 0;              {- For internal use - matches 1st entry.-}
  XP_DEFAULT    = 0;              {- Entry to be chosen by client lib.    -}
  XP_IPX        = 1;              {- IPX/SPX                              -}
  XP_PIPES      = 2;              {- Named Pipes                          -}
  XP_NBIOSN     = 3;              {- NetBIOS (NETAPI)                     -}
  XP_NBIOSA     = 4;              {- NetBIOS (NB30 via ACSNETB)           -}
  XP_LOCAL      = 5;              {- Local server                         -}
  XP_NWLINK_IPX = 6;              {- Microsoft's IPX/SPX                  -}
  XP_NETBIOS_ANY= 7;              {- Scans all NETBIOS lana's             -}
  XP_TCP_IP     = 8;              {- Microsoft's TCP/IP stack 'T'         -}
  XP_LAST       = 8;              {- For internal use - matches last entry.-}
  XP_TERMINATOR = 255;            {- Input - terminator for partially     -}
                                  {-         filled-in array              -}
  XP_UNUSED     = 255;            {- Response - unused array element      -}
  XP_SKIP       = 0;              {- Internal use - unsed array element   -}

  PROTOCOL_ARRAY_SIZE = 16;       {- Size of protocols in RNBO_PARMS      -}

type
 (*          Revision 1 RNBO_PARMS structure definition                  *)
 (* Flags field values - Functions supported by set_rnbo_windows_parms   *)

  RNBO_PARMS = record
                 flags : LongInt;      {- For version compatibility      -}
                 hdl : SmallInt;       {- -1 - All client handles        -}
                 yield : SmallInt;     {- Yield to Windows during network ops  -}
                                       {-          0 = disabled          -}
                                       {-          1 = enabled           -}
                 busyFunc : TFarProc;  {- App's function called by DLL   -}
                 netbios_commands : SmallInt;
                                       {- Max NetBIOS cmds active concurrently -}
                 protocols : array[0..PROTOCOL_ARRAY_SIZE - 1] of Byte; {char}
                                       {- protocols to be used by client lib -}
               end;


  {-          Revision 2 RNBO_PARMS structure definition                  -}

  {- Flags field value - indicates Revision 2 structure.                  -}
const
  RBP_REV_2 = $02000000;              {- ID for Rev 2 RNBO_PARMS structure. -}

  {- Function codes -}
  RBP_USE_HARDWIRED_PPORTS      =  1;      {- Use parallel port addrs  -}
                                           {- defined by the library   -}
  RBP_USE_SPECIFIED_PPORTS      =  2;      {- Use parallel port addrs  -}
                                           {- as specified by parms    -}
  RBP_DEFINE_DEPARTMENT_NAME    =  3;      {- Define department name   -}
  RBP_USE_MAX_SERVERS           =  4;      {- Use to limit the number  -}
                                           {- of servers searched per  -}
                                           {- IPX and NetBIOS transports -}
  RBP_DEFINE_PROTOCOLS          =  5;      {- Set client protocols from  -}

  RBP_USE_LOCAL_NETNAME         =  7;
  RBP_USE_IPXSPX_RECV_TIMEOUT   =  8;
  RBP_SET_MACHINE_TYPE          =  9;
  RBP_SET_DRIVER_TYPE           = 10;
  RBP_SET_ERROR_MODE            = 11;
  RBP_SET_TIMEOUT               = 12;
  RBP_SET_TCPIP_TIMEOUT_SEC     = 13;    { Set timeout delay (sec)    }
                                         { TCP/IP Only                }

  RBP_SET_TCPIP_RETRIES         = 14;    { Set # of retries           }
                                         { TCP/IP Only                }

  RBP_SET_TCPIP_SUBNET_MASK     = 15;    { Set Subnet Mask            }
                                         { Null-term string 15 + null }
                                         { TCP/IP Only                }

  RBP_GET_DRIVER_INFO           = 1;
  RBP_GET_KEY_INFO              = 2;
  RBP_GET_SERVER_INFO           = 3;

  RB_AUTO_MACHINE               = 0;
  RB_IBM_MACHINE                = 1;
  RB_NEC_MACHINE                = 2;
  RB_FMR_MACHINE                = 3;

  RB_ROUTER_USE_LOCAL_DRVR      = 1;
  RB_ROUTER_USE_SYS_DRVR        = 2;
  RB_ROUTER_AUTODETECT_DRVR     = 3;

  RB_COMPATIBLE_ERROR_MODE      = 0;
  RB_EXTENDED_ERROR_MODE        = 1;

  USE_PERMANENT_NODE_NAME       = 1;
  CREATE_NETBIOS_UNIQUE_NAME    = 2;

  NETWORK_NAME_SIZE             = 64;
  SUBNET_MASK_LEN_TCPIP         = 17;




type
 PPORTS_T = record
              port1 : SmallInt;
              port2 : SmallInt;
              port3 : SmallInt;
            end;


DRVR_INFO = record
        machine_type: SmallInt;
        driver_type: SmallInt;
        error_mode: SmallInt;
        os_driver_type: byte;
        major_version: byte;
        minor_version: byte;
        revision: byte;
end;


SERVER_INFO_BLOCK = record
       major_version: SmallInt;
       minor_version: SmallInt;
       number_of_keys: SmallInt;
       startup_timestamp: longint;
       network_name: array [0..NETWORK_NAME_SIZE-1] of char;
end;

 RB_GET_PARAMETERS = record
                CASE Word of
                  RBP_GET_DRIVER_INFO: (drv_info : DRVR_INFO);
                  RBP_GET_KEY_INFO: (key_info: KEY_INFO_BLOCK);
                  RBP_GET_SERVER_INFO: (srvr_info: SERVER_INFO_BLOCK);
                end;

 RNBO_GET_PARAMETERS_T = record
   RNBO_FUNC : SmallInt;
          p2 : RB_GET_PARAMETERS;
  end;

 VERSION_STRUCT = record
 major_ver : SmallInt;
 minor_ver : SmallInt;
 revision  : SmallInt;
 os_drv_type  : SmallInt;
 end;

 RB_PARAMETERS = record
                CASE Word of
                  RBP_USE_SPECIFIED_PPORTS: (pports : PPORTS_T);
                  RBP_DEFINE_DEPARTMENT_NAME: (deptname : array[0..SERVER_NAME_SIZE-1] of Char);
                  RBP_USE_MAX_SERVERS: (max_servers : Word);
                  RBP_DEFINE_PROTOCOLS: (protocols : array[0..PROTOCOL_ARRAY_SIZE - 1] of Byte);
                  RBP_USE_LOCAL_NETNAME: (nb_local_name_opt : Word);
                  RBP_USE_IPXSPX_RECV_TIMEOUT: (ipxspx_receive_timeout: word);
                  RBP_SET_MACHINE_TYPE: (machine_type: SmallInt);
                  RBP_SET_DRIVER_TYPE: (driver_type:SmallInt);
                  RBP_SET_ERROR_MODE: (error_mode:SmallInt);
                  RBP_SET_TIMEOUT: (keyinfo: key_info_w_handle);
                  RBP_SET_TCPIP_TIMEOUT_SEC : (timeout_sec_TCPIP : LongInt);
                  RBP_SET_TCPIP_RETRIES     : (timeout_retries_TCPIP : LongInt);
                  RBP_SET_TCPIP_SUBNET_MASK : (subnet_mask_TCPIP : array[0..SUBNET_MASK_LEN_TCPIP] of Char);
                  $FFFF : (version_struc : VERSION_STRUCT);
                end;

  RNBO_PARAMETERS_T = record
                   RNBO_FUNC : Word;
                   p2 : RB_PARAMETERS;
               end;

   ASL_PARAMS = record
                  asl_command         : Word;
                  asl_sublicense      : Word;
                  end;

   ASL_RESPONSE = record
                  asr_sublicense      : Word;
                  asr_present_total   : Longint;
                  asr_present_inuse_by_all : Longint;
                  asr_present_inuse_by_you : Longint;
                  asr_missing_inuse_by_all : Longint;
                  asr_missing_inuse_by_you : Longint;
                  end;

   (*****************  Access Sub license Op Code  *****************)
const
   ASL_OPEN                    = 0 ;
   ASL_CLOSE                   = 1 ;
   ASL_GET_INFO                = 2 ;

function set_blocking_mode(handle : SmallInt; bmode : SmallInt) : SmallInt; STDCALL;
function open_first_key(type_id : Char; algo_id : LongInt) : SmallInt; STDCALL;
function open_next_key(handle : SmallInt) : SmallInt; STDCALL;
function close_key(handle : SmallInt) : SmallInt; STDCALL;
function lock_key(handle : SmallInt) : SmallInt; STDCALL;
function unlock_key(handle : SmallInt) : SmallInt; STDCALL;
function cancel_lock_key(handle : SmallInt) : SmallInt; STDCALL;
function query_key(handle : SmallInt; var data : query_data) : SmallInt; STDCALL;
function get_info_key(handle : SmallInt; var info : key_info_block) : SmallInt; STDCALL;
function set_info_key(handle : SmallInt; var info : key_info_block) : SmallInt; STDCALL;
procedure detach_from_dll; STDCALL;
function set_rnbo_windows_parms(var pblock : RNBO_PARMS) : SmallInt; STDCALL;
function set_rnbo_lib_parameters(var pblock : RNBO_PARAMETERS_T) : SmallInt; STDCALL;
function get_rnbo_lib_parameters(handle: SmallInt; var pblock : RNBO_GET_PARAMETERS_T) : SmallInt; STDCALL;
function get_statistics(user_block : stats_block_ptr;
                        block_size : Word;
                        reset_after_get : BOOL) : Word; STDCALL;
function access_sub_license( handle   : SmallInt  ;
                             var params : ASL_PARAMS ;
                             var response: ASL_RESPONSE   ) : SmallInt ; STDCALL;
implementation
{$WARNINGS OFF}
  function open_first_key;          STDCALL; EXTERNAL 'NSLMS32.DLL' index 4;
  function open_next_key;           STDCALL; EXTERNAL 'NSLMS32.DLL' index 5;
  function close_key;               STDCALL; EXTERNAL 'NSLMS32.DLL' index 6;
  function lock_key;                STDCALL; EXTERNAL 'NSLMS32.DLL' index 7;
  function unlock_key;              STDCALL; EXTERNAL 'NSLMS32.DLL' index 8;
  function cancel_lock_key;         STDCALL; EXTERNAL 'NSLMS32.DLL' index 9;
  function query_key;               STDCALL; EXTERNAL 'NSLMS32.DLL' index 10;
  function get_info_key;            STDCALL; EXTERNAL 'NSLMS32.DLL' index 11;
  function set_info_key;            STDCALL; EXTERNAL 'NSLMS32.DLL' index 12;
  function set_blocking_mode;       STDCALL; EXTERNAL 'NSLMS32.DLL' index 14;
  procedure detach_from_dll;        STDCALL; EXTERNAL 'NSLMS32.DLL' index 15;
  function set_rnbo_windows_parms;  STDCALL; EXTERNAL 'NSLMS32.DLL' index 16;
  function get_statistics;          STDCALL; EXTERNAL 'NSLMS32.DLL' index 17;
  function set_rnbo_lib_parameters; STDCALL; EXTERNAL 'NSLMS32.DLL' index 18;
  function get_rnbo_lib_parameters; STDCALL; EXTERNAL 'NSLMS32.DLL' index 23;
  function access_sub_license;      STDCALL; EXTERNAL 'NSLMS32.DLL' index 20;
{$WARNINGS ON}
end.
