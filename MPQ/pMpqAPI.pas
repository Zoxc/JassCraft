unit pMpqAPI;

interface

uses
  Windows;

{

  ShadowFlare MPQ API Library. (c) ShadowFlare Software 2002

  All functions below are actual functions that are part of this
  library and do not need any additional dll files.  It does not
  even require Storm to be able to decompress or compress files.

  This library emulates the interface of Lmpqapi and Storm MPQ
  functions, so it may be used as a replacement for them in
  MPQ extractors/archivers without even needing to recompile
  the program that uses Lmpqapi or Storm.  It has a few features
  not included in Lmpqapi and Storm, such as extra flags for some
  functions, setting the locale ID of existing files, and adding
  files without having to write them somewhere else first.  Also,
  MPQ handles used by functions prefixed with "SFile" and "Mpq"
  can be used interchangably; all functions use the same type
  of MPQ handles.  You cannot, however, use handles from this
  library with storm or lmpqapi or vice-versa.  Doing so will
  most likely result in a crash.

  Revision History:
  06/12/2002 1.07 (ShadowFlare)
  - No longer requires Storm.dll to compress or decompress
    Warcraft III files
  - Added SFileListFiles for getting names and information
    about all of the files in an archive
  - Fixed a bug with renaming and deleting files
  - Fixed a bug with adding wave compressed files with
    low compression setting
  - Added a check in MpqOpenArchiveForUpdate for proper
    dwMaximumFilesInArchive values (should be a number that
    is a power of 2).  If it is not a proper value, it will
    be rounded up to the next higher power of 2

  05/09/2002 1.06 (ShadowFlare)
  - Compresses files without Storm.dll!
  - If Warcraft III is installed, this library will be able to
    find Storm.dll on its own. (Storm.dll is needed to
    decompress Warcraft III files)
  - Fixed a bug where an embedded archive and the file that
    contains it would be corrupted if the archive was modified
  - Able to open all .w3m maps now

  29/06/2002 1.05 (ShadowFlare)
  - Supports decompressing files from Warcraft III MPQ archives
    if using Storm.dll from Warcraft III
  - Added MpqAddFileToArchiveEx and MpqAddFileFromBufferEx for
    using extra compression types

  29/05/2002 1.04 (ShadowFlare)
  - Files can be compressed now!
  - Fixed a bug in SFileReadFile when reading data not aligned
    to the block size
  - Optimized some of SFileReadFile's code.  It can read files
    faster now
  - SFile functions may now be used to access files not in mpq
    archives as you can with the real storm functions
  - MpqCompactArchive will no longer corrupt files with the
    MODCRYPTKEY flag as long as the file is either compressed,
    listed in "(listfile)", is "(listfile)", or is located in
    the same place in the compacted archive; so it is safe
    enough to use it on almost any archive
  - Added MpqAddWaveFromBuffer
  - Better handling of archives with no files
  - Fixed compression with COMPRESS2 flag

  15/05/2002 1.03 (ShadowFlare)
  - Supports adding files with the compression attribute (does
    not actually compress files).  Now archives created with
    this dll can have files added to them through lmpqapi
    without causing staredit to crash
  - SFileGetBasePath and SFileSetBasePath work more like their
    Storm equivalents now
  - Implemented MpqCompactArchive, but it is not finished yet.
    In its current state, I would recommend against using it
    on archives that contain files with the MODCRYPTKEY flag,
    since it will corrupt any files with that flag
  - Added SFMpqGetVersionString2 which may be used in Visual
    Basic to get the version string

  07/05/2002 1.02 (ShadowFlare)
  - SFileReadFile no longer passes the lpOverlapped parameter it
    receives to ReadFile.  This is what was causing the function
    to fail when used in Visual Basic
  - Added support for more Storm MPQ functions
  - GetLastError may now be used to get information about why a
    function failed

  01/05/2002 1.01 (ShadowFlare)
  - Added ordinals for Storm MPQ functions
  - Fixed MPQ searching functionality of SFileOpenFileEx
  - Added a check for whether a valid handle is given when
    SFileCloseArchive is called
  - Fixed functionality of SFileSetArchivePriority when multiple
    files are open
  - File renaming works for all filenames now
  - SFileReadFile no longer reallocates the buffer for each block
    that is decompressed.  This should make SFileReadFile at least
    a little faster

  30/04/2002 1.00 (ShadowFlare)
  - First version.
  - Compression not yet supported
  - Does not use SetLastError yet, so GetLastError will not return any
    errors that have to do with this library
  - MpqCompactArchive not implemented

  This library is freeware, you can do anything you want with it but with
  one exception.  If you use it in your program, you must specify this fact
  in Help|About box or in similar way.  You can obtain version string using
  SFMpqGetVersionString call.

  THIS LIBRARY IS DISTRIBUTED "AS IS".  NO WARRANTY OF ANY KIND IS EXPRESSED
  OR IMPLIED. YOU USE AT YOUR OWN RISK. THE AUTHOR WILL NOT BE LIABLE FOR 
  DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING
  OR MISUSING THIS SOFTWARE.

  Any comments or suggestions are accepted at blakflare@hotmail.com (ShadowFlare)
}

type
  SFMPQVERSION = record
    Major: WORD; 
    Minor: WORD;
    Revision: WORD; 
    Subrevision: WORD;
  end;

function MpqGetVersionString(): LPCSTR; stdcall; external 'SFmpq.dll';

function MpqGetVersion(): single; stdcall; external 'SFmpq.dll';

function SFMpqGetVersionString(): LPCSTR; stdcall; external 'SFmpq.dll';

function SFMpqGetVersionString2(lpBuffer: LPCSTR;  dwBufferLength: DWORD): DWORD; stdcall; external 'SFmpq.dll';

function SFMpqGetVersion(): SFMPQVERSION; stdcall; external 'SFmpq.dll';

{ Returns 0 if the dll version is equal to the version your program was compiled}
{ with, 1 if the dll is newer, -1 if the dll is older.}

function SFMpqCompareVersion(): integer; stdcall; external 'SFmpq.dll';

{ General error codes}
const
  MPQ_ERROR_MPQ_INVALID = $85200065; 
  MPQ_ERROR_FILE_NOT_FOUND = $85200066; 
  MPQ_ERROR_DISK_FULL = $85200068; {Physical write file to MPQ failed. Not sure of exact meaning}
  MPQ_ERROR_HASH_TABLE_FULL = $85200069; 
  MPQ_ERROR_ALREADY_EXISTS = $8520006A; 
  MPQ_ERROR_BAD_OPEN_MODE = $8520006C; {When MOAU_READ_ONLY is used without MOAU_OPEN_EXISTING}
  MPQ_ERROR_COMPACT_ERROR = $85300001; 
  
  { MpqOpenArchiveForUpdate flags}
  MOAU_CREATE_NEW = $00; 
  MOAU_CREATE_ALWAYS = $08; {Was wrongly named MOAU_CREATE_NEW}
  MOAU_OPEN_EXISTING = $04;
  MOAU_OPEN_ALWAYS = $20; 
  MOAU_READ_ONLY = $10; {Must be used with MOAU_OPEN_EXISTING}
  MOAU_MAINTAIN_LISTFILE = $01; 
  
  { MpqAddFileToArchive flags}
  MAFA_EXISTS = $80000000; {Will be added if not present}
  MAFA_UNKNOWN40000000 = $40000000; 
  MAFA_MODCRYPTKEY = $00020000; 
  MAFA_ENCRYPT = $00010000; 
  MAFA_COMPRESS = $00000200; 
  MAFA_COMPRESS2 = $00000100; 
  MAFA_REPLACE_EXISTING = $00000001; 
  
  { MpqAddFileToArchiveEx compression flags}
  MAFA_COMPRESS_STANDARD = $08; {Standard PKWare DCL compression}
  MAFA_COMPRESS_DEFLATE = $02; {ZLib's deflate compression}
  MAFA_COMPRESS_WAVE = $81; {Standard wave compression}
  MAFA_COMPRESS_WAVE2 = $41; {Unused wave compression}
  
  { Flags for individual compression types used for wave compression}
  MAFA_COMPRESS_WAVECOMP1 = $80; {Main compressor for standard wave compression}
  MAFA_COMPRESS_WAVECOMP2 = $40; {Main compressor for unused wave compression}
  MAFA_COMPRESS_WAVECOMP3 = $01; {Secondary compressor for wave compression}
  
  { ZLib deflate compression level constants (used with MpqAddFileToArchiveEx and MpqAddFileFromBufferEx)}
  Z_NO_COMPRESSION = 0; 
  Z_BEST_SPEED = 1; 
  Z_BEST_COMPRESSION = 9; 
  Z_DEFAULT_COMPRESSION = (-1); 
  
  { MpqAddWaveToArchive quality flags}
  MAWA_QUALITY_HIGH = 1; 
  MAWA_QUALITY_MEDIUM = 0; 
  MAWA_QUALITY_LOW = 2; 

  { SFileGetFileInfo flags}
  SFILE_INFO_BLOCK_SIZE = $01; {Block size in MPQ}
  SFILE_INFO_HASH_TABLE_SIZE = $02; {Hash table size in MPQ}
  SFILE_INFO_NUM_FILES = $03; {Number of files in MPQ}
  SFILE_INFO_TYPE = $04; {Is MPQHANDLE a file or an MPQ?}
  SFILE_INFO_SIZE = $05; {Size of MPQ or uncompressed file}
  SFILE_INFO_COMPRESSED_SIZE = $06; {Size of compressed file}
  SFILE_INFO_FLAGS = $07; {File flags (compressed, etc.), file attributes if a file not in an archive}
  SFILE_INFO_PARENT = $08; {Handle of MPQ that file is in}
  SFILE_INFO_POSITION = $09; {Position of file pointer in files}
  SFILE_INFO_LOCALEID = $0A; {Locale ID of file in MPQ}
  SFILE_INFO_PRIORITY = $0B; {Priority of open MPQ}
  SFILE_INFO_HASH_INDEX = $0C; {Hash index of file in MPQ}
  
  { SFileListFiles flags}
  SFILE_LIST_MEMORY_LIST = $01; { Specifies that lpFilelists is a file list from memory, rather than being a list of file lists}
  SFILE_LIST_ONLY_KNOWN = $02; { Only list files that the function finds a name for}
  SFILE_LIST_ONLY_UNKNOWN = $04; { Only list files that the function does not find a name for}
  SFILE_TYPE_MPQ = $01; 
  SFILE_TYPE_FILE = $02; 
  
  SFILE_OPEN_HARD_DISK_FILE = $0000; {Open archive without regard to the drive type it resides on}
  SFILE_OPEN_CD_ROM_FILE = $0001; {Open the archive only if it is on a CD-ROM}
  SFILE_OPEN_ALLOW_WRITE = $8000; {Open file with write access}
  SFILE_SEARCH_CURRENT_ONLY = $00; {Used with SFileOpenFileEx; only the archive with the handle specified will be searched for the file}
  SFILE_SEARCH_ALL_OPEN = $01; {SFileOpenFileEx will look through all open archives for the file}
type
  MPQHANDLE = THandle;
  pMPQHandle = ^MPQHandle;
  PLONG = ^Integer;
  LPOVERLAPPED = ^OVERLAPPED;
  
  FILELISTENTRY = record
    dwFileExists: DWORD; { Nonzero if this entry is used}
    lcLocale: LCID; { Locale ID of file}
    dwCompressedSize: DWORD; { Compressed size of file}
    dwFullSize: DWORD; { Uncompressed size of file}
    dwFlags: DWORD; { Flags for file}
    szFileName: array [0..Pred(260)] of char; 
  end;

  pFILELISTENTRY = ^FILELISTENTRY;
  
  pMPQARCHIVE = pointer;
  pMPQFILE = pointer;
  pMPQHEADER = pointer;
  pBLOCKTABLEENTRY = pointer;
  pHASHTABLEENTRY = pointer;
  
  MPQHEADER = record
    dwMPQID: DWORD; {"MPQ\x1A" for mpq's, "BN3\x1A" for bncache.dat}
    dwHeaderSize: DWORD; { Size of this header}
    dwMPQSize: DWORD; {The size of the mpq archive}
    wUnused0C: WORD; { Seems to always be 0}
    wBlockSize: WORD; { Size of blocks in files equals 512 << wBlockSize}
    dwHashTableOffset: DWORD; { Offset to hash table}
    dwBlockTableOffset: DWORD; { Offset to block table}
    dwHashTableSize: DWORD; { Number of entries in hash table}
    dwBlockTableSize: DWORD; { Number of entries in block table}
  end;
  
  {Archive handles may be typecasted to this struct so you can access}
  {some of the archive's properties and the decrypted hash table and}
  {block table directly.}
  MPQARCHIVE = record
    lpNextArc: pMPQARCHIVE; { Arranged according to priority with lowest priority first}
    { Pointer to the next ARCHIVEREC struct. Pointer to addresses of first and last archives if last archive}
    lpPrevArc: pMPQARCHIVE; { Pointer to the previous ARCHIVEREC struct. 0xEAFC5E23 if first archive}
    szFileName: array [0..Pred(260)] of char; { Filename of the archive}
    hFile: THandle; { The archive's file handle}
    dwFlags1: DWORD; { Some flags, bit 1 (0 based) seems to be set when opening an archive from a CD}
    dwPriority: DWORD; { Priority of the archive set when calling SFileOpenArchive}
    lpLastReadFile: pMPQFILE; { Pointer to the last read file's FILEREC struct. Only used for incomplete reads of blocks}
    dwUnk: DWORD; { Seems to always be 0}
    dwBlockSize: DWORD; { Size of file blocks in bytes}
    lpLastReadBlock: pBYTE; { Pointer to the read buffer for archive. Only used for incomplete reads of blocks}
    dwBufferSize: DWORD; { Size of the read buffer for archive. Only used for incomplete reads of blocks}
    dwMPQStart: DWORD; { The starting offset of the archive}
    lpMPQHeader: pMPQHEADER; { Pointer to the archive header}
    lpBlockTable: pBLOCKTABLEENTRY; { Pointer to the start of the block table}
    lpHashTable: pHASHTABLEENTRY; { Pointer to the start of the hash table}
    dwFileSize: DWORD; { The size of the file in which the archive is contained}
    dwOpenFiles: DWORD; { Count of files open in archive + 1}
    MpqHeader: MPQHEADER; 
    dwFlags: DWORD; {The only flag that should be changed is MOAU_MAINTAIN_LISTFILE}
    lpFileName: PChar; 
  end;
  
  {Handles to files in the archive may be typecasted to this struct}
  {so you can access some of the file's properties directly.}
  MPQFILE = record
    lpNextFile: pMPQFILE; { Pointer to the next FILEREC struct. Pointer to addresses of first and last files if last file}
    lpPrevFile: pMPQFILE; { Pointer to the previous FILEREC struct. 0xEAFC5E13 if first file}
    szFileName: array [0..Pred(260)] of char; { Filename of the file}
    hPlaceHolder: THandle; { Always 0xFFFFFFFF}
    lpParentArc: pMPQARCHIVE; { Pointer to the ARCHIVEREC struct of the archive in which the file is contained}
    lpBlockEntry: pBLOCKTABLEENTRY; { Pointer to the file's block table entry}
    dwCryptKey: DWORD; { Decryption key for the file}
    dwFilePointer: DWORD; { Position of file pointer in the file}
    dwUnk1: DWORD; { Seems to always be 0}
    dwBlockCount: DWORD; { Number of blocks in file}
    lpdwBlockOffsets: pDWORD; { Offsets to blocks in file. There are 1 more of these than the number of blocks}
    dwReadStarted: DWORD; { Set to 1 after first read}
    dwUnk2: DWORD; { Seems to always be 0}
    lpLastReadBlock: pBYTE; { Pointer to the read buffer for file. Only used for incomplete reads of blocks}
    dwBytesRead: DWORD; { Total bytes read from open file}
    dwBufferSize: DWORD; { Size of the read buffer for file. Only used for incomplete reads of blocks}
    dwConstant: DWORD; { Seems to always be 1}
    lpHashEntry: pHASHTABLEENTRY; 
    lpFileName: PChar; 
  end;
  
  BLOCKTABLEENTRY = record
    dwFileOffset: DWORD; { Offset to file}
    dwCompressedSize: DWORD; { Compressed size of file}
    dwFullSize: DWORD; { Uncompressed size of file}
    dwFlags: DWORD; { Flags for file}
  end;
  
  HASHTABLEENTRY = record
    dwNameHashA: DWORD; { First name hash of file}
    dwNameHashB: DWORD; { Second name hash of file}
    lcLocale: LCID; { Locale ID of file}
    dwBlockTableIndex: DWORD; { Index to the block table entry for the file}
  end;

{ Storm functions implemented by this library}
function SFileOpenArchive(lpFileName: LPCSTR;  dwPriority: DWORD;  dwFlags: DWORD;  hMPQ: pMPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';
function SFileCloseArchive(hMPQ: MPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';
function SFileGetArchiveName(hMPQ: MPQHANDLE;  lpBuffer: LPCSTR;  dwBufferLength: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function SFileOpenFile(lpFileName: LPCSTR;  hFile: pMPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';
function SFileOpenFileEx(hMPQ: MPQHANDLE;  lpFileName: LPCSTR;  dwSearchScope: DWORD;  hFile: pMPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';
function SFileCloseFile(hFile: MPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';
function SFileGetFileSize(hFile: MPQHANDLE;  lpFileSizeHigh: PDWORD): DWORD; stdcall; external 'SFmpq.dll';
function SFileGetFileArchive(hFile: MPQHANDLE;  hMPQ: pMPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';
function SFileGetFileName(hFile: MPQHANDLE;  lpBuffer: LPCSTR;  dwBufferLength: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function SFileSetFilePointer(hFile: MPQHANDLE;  lDistanceToMove: integer;  lplDistanceToMoveHigh: PLONG;  dwMoveMethod: DWORD): DWORD; stdcall; external 'SFmpq.dll';
function SFileReadFile(hFile: MPQHANDLE;  lpBuffer: pointer;  nNumberOfBytesToRead: DWORD;  lpNumberOfBytesRead: PDWORD;  lpOverlapped: LPOVERLAPPED): BOOL; stdcall; external 'SFmpq.dll';
function SFileSetLocale(nNewLocale: LCID): LCID; stdcall; external 'SFmpq.dll';
function SFileGetBasePath(lpBuffer: LPCSTR;  dwBufferLength: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function SFileSetBasePath(lpNewBasePath: LPCSTR): BOOL; stdcall; external 'SFmpq.dll';

{ Extra storm-related functions}
function SFileGetFileInfo(hFile: MPQHANDLE;  dwInfoType: DWORD): DWORD; stdcall; external 'SFmpq.dll';
function SFileSetArchivePriority(hMPQ: MPQHANDLE;  dwPriority: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function SFileFindMpqHeader(hFile: THandle): DWORD; stdcall; external 'SFmpq.dll';
function SFileListFiles(hMPQ: MPQHANDLE;  lpFileLists: LPCSTR;  lpListBuffer: pFILELISTENTRY;  dwFlags: DWORD): BOOL; stdcall; external 'SFmpq.dll';

{ Archive editing functions implemented by this library}
function MpqOpenArchiveForUpdate(lpFileName: LPCSTR;  dwFlags: DWORD;  dwMaximumFilesInArchive: DWORD): MPQHANDLE; stdcall; external 'SFmpq.dll';
function MpqCloseUpdatedArchive(hMPQ: MPQHANDLE;  dwUnknown2: DWORD): DWORD; stdcall; external 'SFmpq.dll';
function MpqAddFileToArchive(hMPQ: MPQHANDLE;  lpSourceFileName: LPCSTR;  lpDestFileName: LPCSTR;  dwFlags: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function MpqAddWaveToArchive(hMPQ: MPQHANDLE;  lpSourceFileName: LPCSTR;  lpDestFileName: LPCSTR;  dwFlags: DWORD;  dwQuality: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function MpqRenameFile(hMPQ: MPQHANDLE;  lpcOldFileName: LPCSTR;  lpcNewFileName: LPCSTR): BOOL; stdcall; external 'SFmpq.dll';
function MpqDeleteFile(hMPQ: MPQHANDLE;  lpFileName: LPCSTR): BOOL; stdcall; external 'SFmpq.dll';
function MpqCompactArchive(hMPQ: MPQHANDLE): BOOL; stdcall; external 'SFmpq.dll';

{ Extra archive editing functions}
function MpqAddFileToArchiveEx(hMPQ: MPQHANDLE;  lpSourceFileName: LPCSTR;  lpDestFileName: LPCSTR;  dwFlags: DWORD;  dwCompressionType: DWORD;  dwCompressLevel: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function MpqAddFileFromBufferEx(hMPQ: MPQHANDLE;  lpBuffer: pointer;  dwLength: DWORD;  lpFileName: LPCSTR;  dwFlags: DWORD;  dwCompressionType: DWORD;  dwCompressLevel: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function MpqAddFileFromBuffer(hMPQ: MPQHANDLE;  lpBuffer: pointer;  dwLength: DWORD;  lpFileName: LPCSTR;  dwFlags: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function MpqAddWaveFromBuffer(hMPQ: MPQHANDLE;  lpBuffer: pointer;  dwLength: DWORD;  lpFileName: LPCSTR;  dwFlags: DWORD;  dwQuality: DWORD): BOOL; stdcall; external 'SFmpq.dll';
function MpqSetFileLocale(hMPQ: MPQHANDLE;  lpFileName: LPCSTR;  nOldLocale: LCID;  nNewLocale: LCID): BOOL; stdcall; external 'SFmpq.dll';

{ These functions do nothing.  They are only provided for}
{ compatibility with MPQ extractors that use storm.}

function SFileDestroy(): BOOL; stdcall; external 'SFmpq.dll';
procedure StormDestroy(); stdcall; external 'SFmpq.dll';

implementation


end.
