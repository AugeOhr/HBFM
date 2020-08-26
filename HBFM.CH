#define LV_NAME                        1
#define LV_EXT                         2
#define LV_SIZE                        3
#define LV_DATE                        4
#define LV_TIME                        5
#define LV_ATTR                        6

#define LVIS_FOCUSED                   0x1
#define LVIS_SELECTED                  0x2
#define LVIS_CUT                       0x4
#define LVIS_DROPHILITED               0x8
#define LVIS_GLOW                      0x10
#define LVIS_ACTIVATING                0x20
#define LVIS_OVERLAYMASK               0xf00
#define LVIS_STATEIMAGEMASK            0xF000

#define LVNI_SELECTED                  0x02

#define AW_FORM                        1
#define AW_OBJ                         2
#define AW_WDIR                        3
#define AW_XXX                         4
#define AW_GOLAST                      5
#define AW_SORT                        6
#define AW_DESCEND                     7

#define DRIVE_UNKNOWN                  0
#define DRIVE_NO_ROOT_DIR              1
#define DRIVE_REMOVABLE                2
#define DRIVE_FIXED                    3
#define DRIVE_REMOTE                   4
#define DRIVE_CDROM                    5
#define DRIVE_RAMDISK                  6

#define WM_DEVICECHANGE                0x0219
#define DBT_DEVICEARRIVAL              0x8000
#define DBT_DEVICEQUERYREMOVE          0x8001
#define DBT_DEVICEQUERYREMOVEFAILED    0x8002
#define DBT_DEVICEREMOVEPENDING        0x8003
#define DBT_DEVICEREMOVECOMPLETE       0x8004
#define DBT_DEVTYP_VOLUME              2

#define IM_UNKNOWN                     1
#define IM_FIXDRIVE1                   2
#define IM_USBSTICK                    3
#define IM_SYSDRIVE                    4
#define IM_FIXDRIVE                    5
#define IM_NETDRIVE                    6
#define IM_CDROM                       7
#define IM_RAMDISK                     8

#define ILC_COLOR32                    32
#define ILC_COLOR16                    16
#define ILC_MASK                       1

#define ILD_NORMAL                     0

/*
#define YELLOW  { 255,  255,    0 }
#define PINK    { 255,  128,  192 }
#define RED     { 255,    0,    0 }
#define FUCHSIA { 255,    0,  255 }
#define BROWN   { 128,   64,   64 }
#define ORANGE  { 255,  128,   64 }
#define GREEN   {   0,  255,    0 }
#define PURPLE  { 128,    0,  128 }
#define BLACK   {   0,    0,    0 }
#define WHITE   { 255,  255,  255 }
#define GRAY    { 128,  128,  128 }
#define BLUE    {   0,    0,  255 }
*/

#define CSIDL_MYDOCUMENTS               0x000c        // logical "My Documents" desktop icon
#define CSIDL_MYMUSIC                   0x000d        // "My Music" folder
#define CSIDL_MYVIDEO                   0x000e        // "My Videos" folder
#define CSIDL_COMMON_MUSIC              0x0035        // All Users\My Music
#define CSIDL_COMMON_PICTURES           0x0036        // All Users\My Pictures
#define CSIDL_COMMON_VIDEO              0x0037        // All Users\My Video
#define CSIDL_RESOURCES                 0x0038        // Resource Direcotry
#define CSIDL_RESOURCES_LOCALIZED       0x0039        // Localized Resource Direcotry
#define CSIDL_COMMON_OEM_LINKS          0x003a        // Links to All Users OEM specific apps
#define CSIDL_CDBURN_AREA               0x003b        // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning

#define SHGFI_ICON 0x000000100
#define SHGFI_DISPLAYNAME 0x000000200
#define SHGFI_TYPENAME 0x000000400
#define SHGFI_ATTRIBUTES 0x000000800
#define SHGFI_ICONLOCATION 0x000001000
#define SHGFI_EXETYPE 0x000002000
#define SHGFI_SYSICONINDEX 0x000004000
#define SHGFI_LINKOVERLAY 0x000008000
#define SHGFI_SELECTED 0x000010000
#define SHGFI_ATTR_SPECIFIED 0x000020000

#define SHGFI_LARGEICON 0x000000000
#define SHGFI_SMALLICON 0x000000001
#define SHGFI_OPENICON 0x000000002
#define SHGFI_SHELLICONSIZE 0x000000004
#define SHGFI_PIDL 0x000000008
#define SHGFI_USEFILEATTRIBUTES 0x000000010

#define SHGFI_ADDOVERLAYS 0x000000020
#define SHGFI_OVERLAYINDEX 0x000000040

#define FILE_ATTRIBUTE_READONLY             0x00000001
#define FILE_ATTRIBUTE_HIDDEN               0x00000002
#define FILE_ATTRIBUTE_SYSTEM               0x00000004
#define FILE_ATTRIBUTE_DIRECTORY            0x00000010
#define FILE_ATTRIBUTE_ARCHIVE              0x00000020
#define FILE_ATTRIBUTE_DEVICE               0x00000040
#define FILE_ATTRIBUTE_NORMAL               0x00000080

