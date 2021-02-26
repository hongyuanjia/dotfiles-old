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

    context.AddBar();
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
    sticky.CreateWorkspaces(monitors[0], "1|Work", "2|File");
    sticky.CreateWorkspaces(monitors[1], "3|Misc", "4|Idle");

    // Ignore program filters
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("Flow.Launcher.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("Everything.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("Zoom.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("IDMan.exe"));

    // Put Total Commander to "2|File" workspace by default
    context.WindowRouter.AddRoute((window) => window.ProcessFileName.Equals("TotalCMD64.exe") ? context.WorkspaceContainer["2|File"] : null);

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