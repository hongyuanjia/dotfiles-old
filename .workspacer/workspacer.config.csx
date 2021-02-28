#r "C:\Program Files\workspacer\workspacer.Shared.dll"
#r "C:\Program Files\workspacer\plugins\workspacer.Bar\workspacer.Bar.dll"
#r "C:\Program Files\workspacer\plugins\workspacer.ActionMenu\workspacer.ActionMenu.dll"
#r "C:\Program Files\workspacer\plugins\workspacer.FocusIndicator\workspacer.FocusIndicator.dll"

using System;
using workspacer;
using workspacer.Bar;
using workspacer.ActionMenu;
using workspacer.FocusIndicator;

Action<IConfigContext> doConfig = (context) =>
{
    // Uncomment to switch update branch (or to disable updates)
    //context.Branch = Branch.None

    context.AddBar(new BarPluginConfig(){
        BarTitle = "workspacer.Bar",
        BarHeight = 20,
        FontSize = 12,
        FontName = "Consolas",
        DefaultWidgetForeground = Color.Blue,
        DefaultWidgetBackground = Color.White,
        Background = Color.White,
});
    // when selecting a window show a red border
    context.AddFocusIndicator(new FocusIndicatorPluginConfig() {
        BorderColor = Color.Teal,
        TimeToShow = 1000
    });

    var actionMenu = context.AddActionMenu();

    // Use "Global" mode
    var sticky = new StickyWorkspaceContainer(context, StickyWorkspaceIndexMode.Global);
    context.WorkspaceContainer = sticky;

    var monitors = context.MonitorContainer.GetAllMonitors();

    if (context.MonitorContainer.NumMonitors > 1) {
        sticky.CreateWorkspaces(monitors[0], "1|Focus", "2|File", "3|Code", "4|Web", "5|Literature");
        sticky.CreateWorkspaces(monitors[1], "6|IM", "7|Misc", "8|Idle");
    } else {
        sticky.CreateWorkspaces(monitors[0], "1|Focus", "2|File", "3|Code", "4|Web", "5|Literature", "6|IM", "7|Misc", "8|Idle");
    }

    // Ignore program filters
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("Flow.Launcher.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("Everything.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("Zoom.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("IDMan.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("gitkraken.exe"));

    // Put program to various workspace by default
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("TotalCMD64.exe") ? context.WorkspaceContainer["2|File"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("code.exe") ? context.WorkspaceContainer["3|Code"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("rstudio.exe") ? context.WorkspaceContainer["3|Code"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("msedge.exe") ? context.WorkspaceContainer["4|Web"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("zotero.exe") ? context.WorkspaceContainer["5|Literature"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("Acrobat.exe") ? context.WorkspaceContainer["5|Literature"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("SumatraPDF.exe") ? context.WorkspaceContainer["5|Literature"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("slack.exe") ? context.WorkspaceContainer["6|IM"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("WeChat.exe") ? context.WorkspaceContainer["6|IM"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("WeChatApp.exe") ? context.WorkspaceContainer["6|IM"] : null);
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("wechatweb.exe") ? context.WorkspaceContainer["6|IM"] : null);

    // Custom keybindings
    KeyModifiers mod = KeyModifiers.Alt;

    // Remove keybindings that conflict with Flow Launcher
    context.Keybinds.Unsubscribe(mod, Keys.Space);
    context.Keybinds.Unsubscribe(mod, Keys.T);
    context.Keybinds.Unsubscribe(mod | KeyModifiers.LShift, Keys.Space);

    context.Keybinds.Subscribe(mod, Keys.T,
        () => context.Workspaces.FocusedWorkspace.NextLayoutEngine(), "next layout");

    context.Keybinds.Subscribe(mod | KeyModifiers.LShift, Keys.T,
        () => context.Workspaces.FocusedWorkspace.PreviousLayoutEngine(), "previous layout");

    context.Keybinds.Subscribe(mod, Keys.F,
        () => context.Windows.ToggleFocusedWindowTiling(), "toggle tiling for focused window");
};
return doConfig;