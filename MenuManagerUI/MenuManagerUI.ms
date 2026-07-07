/*
	MenuManagerUI.ms
	Version: 0.90
	UI for MENU_MANAGER_GLOBAL macro management
	TreeView-based macroscript inspector + install/reset tools
*/

global MENU_MANAGER_GLOBAL
global MenuManagerUICallbacks

try (destroyDialog MenuManagerUI_ROLLOUT) catch()

struct MenuManagerUICallbacks_Struct
(
    version = 0.90,

    function buildMacroTree nodes treeView =
    (
        treeView.Nodes.Clear()

        for i = 1 to nodes.count do
        (
            item = nodes[i]
            if item == undefined then continue

            path = ""
            name = ""

            -- Handle both simple Strings and Objects with properties
            if classOf item == String then
            (
                path = item
                name = item
            )
            else
            (
                try (path = item.path) catch (path = "Unknown")
                try (name = item.name) catch (name = item as string)
            )

            parts = filterString path "\\/"
            
            -- Fallback in case filterString returns empty
            if parts.count == 0 then parts = #(path)

            currentCollection = treeView.Nodes
            node = undefined

            for p = 1 to parts.count do
            (
                part = parts[p]
                if part == "" then continue

                found = false

                for n = 0 to currentCollection.Count-1 do
                (
                    if currentCollection.Item[n].Text == part then
                    (
                        node = currentCollection.Item[n]
                        currentCollection = node.Nodes
                        found = true
                        exit
                    )
                )

                if found == false then
                (
                    node = currentCollection.Add(part)
                    currentCollection = node.Nodes
                )
            )
        )
    ),

    function getSelectedMacro treeView =
    (
        try
        (
            node = treeView.SelectedNode
            if node != undefined then
            (
                -- If it's a leaf node, return its full path
                if node.Nodes.Count == 0 then
                (
                    return node.FullPath
                )
            )
        )
        catch()
        return undefined
    ),

    function installMenusFromSelected sel =
    (
        try
        (
            if sel != undefined then
            (
                if isProperty MENU_MANAGER_GLOBAL #addMacrosToMenus then
                (
                    MENU_MANAGER_GLOBAL.addMacrosToMenus #(sel)
                    print ("Installed menu for: " + sel)
                )
            )
        )
        catch()
    ),

    function installQuadMenusFromSelected sel =
    (
        try
        (
            if sel != undefined and isProperty MENU_MANAGER_GLOBAL #_fileInMacroscriptFiles then
            (
                MENU_MANAGER_GLOBAL._fileInMacroscriptFiles #(sel)
                print ("Installed quad menu for: " + sel)
            )
        )
        catch()
    ),

    function resetMenus =
    (
        try
        (
            if isProperty MENU_MANAGER_GLOBAL #resetMenus then
            (
                MENU_MANAGER_GLOBAL.resetMenus()
            )
        )
        catch()
    ),

    function resetQuadMenus =
    (
        try
        (
            if isProperty MENU_MANAGER_GLOBAL #resetQuadMenus then
            (
                MENU_MANAGER_GLOBAL.resetQuadMenus()
            )
        )
        catch()
    )
)

-- Initialize the global struct instance
MenuManagerUICallbacks = MenuManagerUICallbacks_Struct()


rollout MenuManagerUI_ROLLOUT "Menu Manager UI"
(
    dotNetControl tv "TreeView" width:350 height:400

    button btnInstallMenus "Install && Show Menus" width:170
    button btnInstallQuads "Install && Show QuadMenus" width:170

    button btnResetMenus "Reset Menus" width:170
    button btnResetQuads "Reset QuadMenus" width:170

    button btnRefresh "Refresh" width:170

    local macro_data = #()

    function updateMacroData =
    (
        macro_data = #()
        
        if MENU_MANAGER_GLOBAL != undefined then
        (
            if isProperty MENU_MANAGER_GLOBAL #macroscripts_to_import then
            (
                for mcr_path in MENU_MANAGER_GLOBAL.macroscripts_to_import do
                (
                    parts = filterString mcr_path "\\/"
                    
                    if parts.count >= 2 then
                    (
                        parentDir = parts[parts.count - 1]
                        fileName = parts[parts.count]
                        
                        -- Construct the tree hierarchy string
                        treePath = "macroscripts_to_import\\" + parentDir + "\\" + fileName
                        append macro_data treePath
                    )
                    else
                    (
                        -- Fallback for root-level files
                        if parts.count == 1 then
                        (
                            append macro_data ("macroscripts_to_import\\" + parts[1])
                        )
                    )
                )
            )
        )
    )

    on MenuManagerUI_ROLLOUT open do
    (
        -- Dynamically append the version to the rollout title
        MenuManagerUI_ROLLOUT.title = "Menu Manager UI v" + (MenuManagerUICallbacks.version as string)
        
        -- Apply Dark Theme to the TreeView
        local drawingColor = dotNetClass "System.Drawing.Color"
        tv.BackColor = drawingColor.FromArgb 45 45 45       -- Dark Gray background
        tv.ForeColor = drawingColor.FromArgb 220 220 220    -- Light Gray text
        tv.LineColor = drawingColor.FromArgb 150 150 150    -- Mid Gray hierarchy lines
        
        updateMacroData()
        MenuManagerUICallbacks.buildMacroTree macro_data tv
    )

    on btnInstallMenus pressed do
    (
		MENU_MANAGER_GLOBAL.createMenus()
		
        --sel = MenuManagerUICallbacks.getSelectedMacro tv
        --MenuManagerUICallbacks.installMenusFromSelected sel
    )

    on btnInstallQuads pressed do
    (
		MENU_MANAGER_GLOBAL.createQuadMenus()
		
        --sel = MenuManagerUICallbacks.getSelectedMacro tv
        --MenuManagerUICallbacks.installQuadMenusFromSelected sel
    )

    on btnResetMenus pressed do
    (
        MenuManagerUICallbacks.resetMenus()
    )

    on btnResetQuads pressed do
    (
        MenuManagerUICallbacks.resetQuadMenus()
    )

    on btnRefresh pressed do
    (
        updateMacroData()
        MenuManagerUICallbacks.buildMacroTree macro_data tv
    )
)