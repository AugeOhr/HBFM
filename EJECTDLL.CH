#define VERSION_XP                  5.0
#define VERSION_VISTA               6.0
#define VERSION_WIN7                6.01
#define VERSION_WIN8                6.02
#define VERSION_WIN81               6.03
#define VERSION_WIN10              10.0
#define VERSION_WIN10OLD            6.04

#define NULL                        0
#define MAX_PATH                    200
#define MIN_PATH                    10
#define FORMAT_MESSAGE_FROM_SYSTEM  0x00001000

#define GUID_DEVINTERFACE_VOLUME     "{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}"
#define GUID_DEVINTERFACE_DISK       "{53f56307-b6bf-11d0-94f2-00a0c91efb8b}"
#define GUID_DEVINTERFACE_FLOPPY     "{53f56311-b6bf-11d0-94f2-00a0c91efb8b}"
#define GUID_DEVINTERFACE_CDROM      "{53f56308-b6bf-11d0-94f2-00a0c91efb8b}"
#define GUID_DEVINTERFACE_USB_DEVICE "{A5DCBF10-6530-11D2-901F-00C04FB951ED}"

//
// Configuration Manager CONFIGRET return status codes
//
#define CR_SUCCESS                  (0x00000000)
#define CR_DEFAULT                  (0x00000001)
#define CR_OUT_OF_MEMORY            (0x00000002)

//
// Flags for CM_Query_And_Remove_SubTree
//
#define CM_REMOVE_UI_OK             0x00000000
#define CM_REMOVE_UI_NOT_OK         0x00000001
#define CM_REMOVE_NO_RESTART        0x00000002
#define CM_REMOVE_BITS              0x00000003

// Flags controlling what is included in the device information set built
// by SetupDiGetClassDevs
//
#define DIGCF_DEFAULT               0x00000001  // only valid with DIGCF_DEVICEINTERFACE
#define DIGCF_PRESENT               0x00000002
#define DIGCF_ALLCLASSES            0x00000004
#define DIGCF_PROFILE               0x00000008
#define DIGCF_DEVICEINTERFACE       0x00000010

//
// Flags for SP_DEVICE_INTERFACE_DATA.Flags field.
//
#define SPINT_ACTIVE                0x00000001
#define SPINT_DEFAULT               0x00000002
#define SPINT_REMOVED               0x00000004

#define METHOD_BUFFERED             0
#define METHOD_IN_DIRECT            1
#define METHOD_OUT_DIRECT           2
#define METHOD_NEITHER              3

#define FILE_ANY_ACCESS             0
#define FILE_SPECIAL_ACCESS         (FILE_ANY_ACCESS)
#define FILE_READ_ACCESS            ( 0x0001 )    // file & pipe
#define FILE_WRITE_ACCESS           ( 0x0002 )    // file & pipe

#define FILE_DEVICE_MASS_STORAGE    0x0000002d
#define IOCTL_STORAGE_BASE          FILE_DEVICE_MASS_STORAGE

#xtranslate CTL_CODE( <dt> , <fn> , <mtd> , <acc> ) =>;
nOr( nLShift(<dt>,16) , nLShift(<acc>,14) , nLShift(<fn>,2) , <mtd> )

#define IOCTL_STORAGE_GET_DEVICE_NUMBER  CTL_CODE(IOCTL_STORAGE_BASE, 0x0420, METHOD_BUFFERED, FILE_ANY_ACCESS)

#define FILE_FLAG_BACKUP_SEMANTICS     0x02000000
#define FILE_FLAG_OVERLAPPED           0x40000000

#define FSCTL_LOCK_VOLUME              0x00090018
#define FSCTL_UNLOCK_VOLUME            0x0009001C
#define FSCTL_DISMOUNT_VOLUME          0x00090020

#define IOCTL_STORAGE_EJECT_MEDIA      0x002D4808  // IOCTL_DISK_EJECT_MEDIA
#define IOCTL_STORAGE_MEDIA_REMOVAL    0x002D4804


#define SE_ERR_FNF                     2  // File not found.
#define SE_ERR_PNF                     3  // Path not found.
#define SE_ERR_ACCESSDENIED            5  // Access denied.
#define SE_ERR_OOM                     8  // Out of memory.
#define SE_ERR_SHARE                   26 // Cannot share an open file.
#define SE_ERR_ASSOCINCOMPLETE         27 // File association information not complete.
#define SE_ERR_DDETIMEOUT              28 // DDE operation timed out.
#define SE_ERR_DDEFAIL                 29 // DDE operation failed.
#define SE_ERR_DDEBUSY                 30 // DDE operation is busy.
#define SE_ERR_NOASSOC                 31 // File association not available.
#define SE_ERR_DLLNOTFOUND             32 // Dynamic-link library not found.
