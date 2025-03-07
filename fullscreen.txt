
 Add-Type @"

 using System;

 using System.Runtime.InteropServices;

 public class User32 {

     [DllImport("user32.dll")]

     public static extern int FindWindow(string lpClassName, string lpWindowName);

     [DllImport("user32.dll")]

     public static extern int GetWindowLong(int hwnd, int nIndex);

     [DllImport("user32.dll")]

     public static extern int SetWindowLong(int hwnd, int nIndex, int dwNewLong);

     [DllImport("user32.dll")]

     public static extern bool ShowWindow(int hwnd, int nCmdShow);

 }

 public class WindowHelper {

     public static void LockFullscreenPowerShell() {

         int hwnd = User32.FindWindow("ConsoleWindowClass", null);

         if (hwnd == 0) return;

         User32.ShowWindow(hwnd, 3); // SW_MAXIMIZE

         int GWL_STYLE = -16;

         int WS_SYSMENU = 0x80000;   // Removes the close button

         int WS_CAPTION = 0xC00000;  // Removes the title bar

         int WS_THICKFRAME = 0x40000; // Removes resizable borders

         int WS_BORDER = 0x800000;    // Removes thin window border

         int WS_DLGFRAME = 0x400000;  // Removes the dialog frame

         int style = User32.GetWindowLong(hwnd, GWL_STYLE);

         style &= ~WS_SYSMENU;   // Remove close button

         style &= ~WS_CAPTION;   // Remove title bar (prevents dragging)

         style &= ~WS_THICKFRAME; // Remove resizable borders

         style &= ~WS_BORDER;    // Remove thin border

         style &= ~WS_DLGFRAME;  // Remove dialog frame border

         User32.SetWindowLong(hwnd, GWL_STYLE, style);

     }

 }

 "@

 [WindowHelper]::LockFullscreenPowerShell()

 Write-Host "PowerShell is now fully locked in place with no title bar, no borders, and no close button."

