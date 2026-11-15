# HB Bulk AHK_JS Downloader
Download link: 
https://github.com/mmarcincin/HB-bulk-AHK_JS-downloader/archive/master.zip
----------------------
HB_Bulk_AHK_JS_Downloader 0.0.1
----------------------
hybrid script using both autohotkey and javascript for downloading humble bundle DRM-Free files

Autohotkey script requires Autohotkey program (works in autohotkey 1.1).
- Autohotkey download link: https://www.autohotkey.com/download/ahk-install.exe

!!! This type of downloading simulates user input. When you launch javascript from the bookmark, you should not interact with PC unless you want to interrupt download. !!!
----------------------

It is possible to use compiled ahk script without the need to download autohotkey program.
Because of broad nature of what autohotkey scripts can do, I opted to keep it transparent instead.

This script creates folder structure in downloads subfolder where ahk script is located:
downloads\BundleName\BookName\file.ext
- Script is setup to start downloading files every ~6 secs.
- When downloading is complete javascript will show you the message 'Bundle download complete!'.

If full filepath goes over 260 characters:
1. It automatically trims filename after first - or _, alternatively to 20 character + extension.
2. If trimming filename is not enough. It shortens the BookName to 40 characters.

Browser setup
----------------------
You need to enable these settings in browser for downloader to work properly.

For Chromium browser users - Chrome, Opera, Brave, Microsoft Edge, etc
-----------------------------------------------------------------
1. Downloads: go to chrome://settings/downloads and enable 'Ask where to save each file before downloading'.
2. Pop-up Settings: go to chrome://settings/content/popups and add https://www.humblebundle.com to 'Allowed to send pop-ups and use redirects' list.
3. PDF Viewer: go to chrome://settings/content/pdfDocuments and set it to download PDF


For Firefox browser users
----------------------
1. Downloads: Type about:preferences#general into the address bar and scroll down to Downloads. From there, you can change your default save folder or check Always ask you where to save files.
2. Pop-up Settings: Type about:preferences#privacy into the address bar and scroll down to Permissions. Look for Block pop-up windows to toggle the blocker on or click Exceptions to allow specific websites.
3. PDF Viewer: Type about:preferences#general into the address bar and scroll down to Files and Applications. Under Applications, find Portable Document Format (PDF) and change the action to Save File or your preferred PDF app.

Javascript bookmark setup
----------------------
Create empty bookmark, you can name it 'HB_Bulk_AHK-JavaScript-Downloader' and paste text from HB_Bulk_AHK-JavaScript-Downloader-js.txt inside url of bookmark.

If you can't create empty bookmark save any website not already saved as bookmark and modify it's name and url.

I recommend placing in on bookmarks bar for quick access.

How to use it
----------------------
1. Launch HB_Bulk_AHK_JS_Downloader.ahk
- You can use following hotkey to control autohotkey script (can be modified in script itself):
  - ctrl+shift+s and win+Numpad/, close script
  - ctrl+shift+r, restart script
  - win+Numpad+, suspend script - toogle - in suspended state doesn't react to hotkeys above
  - You can also close the script with your mouse in the system tray next to time (might be hidden under ^ based on your settings).

2. On specific bundle page with ebooks or DRM-free downloads, launch the 'HB_Bulk_AHK-JavaScript-Downloader' javascript from bookmarks bar.

!!! This type of downloading simulates user input. When you launch javascript from the bookmark, you should not interact with PC unless you want to interrupt download. !!!
----------------------
