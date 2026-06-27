
/*
MenuManagerUI_0.01.ms
UI for MENU_MANAGER_GLOBAL macro management
TreeView-based macroscript inspector + install/reset tools
*/

global MENU_MANAGER_GLOBAL
global MenuManagerUI

try (destroyDialog MenuManagerUI_ROLLOUT) catch()

function buildMacroTree nodes treeView
(
    treeView.Nodes.Clear()

    rootDict = dotNetObject "System.Collections.Hashtable"

    for i = 1 to nodes.count do
    (
        item = nodes[i]
        if item == undefined then continue

        path = ""
        name = ""

        try (path = item.path) catch (path = "Unknown")
        try (name = item.name) catch (name = item)

        parts = filterString path "\\"

        parentNode = treeView.Nodes

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
)

function getSelectedMacro treeView
(
    try
    (
        node = treeView.SelectedNode
        if node == undefined then return undefined
        return node.Text
    )
    catch
    (
        return undefined
    )
)

function installMenusFromSelected selectedName =
(
    if selectedName == undefined then return false

    try
    (
        if isProperty MENU_MANAGER_GLOBAL #installMenus then
            MENU_MANAGER_GLOBAL.installMenus selectedName
        else if isProperty MenuRebuilder #installMenus then
            MenuRebuilder.installMenus selectedName
    )
    catch()
)

function installQuadMenusFromSelected selectedName =
(
    if selectedName == undefined then return false

    try
    (
        if isProperty MENU_MANAGER_GLOBAL #installQuadMenus then
            MENU_MANAGER_GLOBAL.installQuadMenus selectedName
        else if isProperty QuadMenuManager #installQuadMenus then
            QuadMenuManager.installQuadMenus selectedName
    )
    catch()
)

function resetMenus =
(
    try
    (
        if isProperty MENU_MANAGER_GLOBAL #resetMenus then
            MENU_MANAGER_GLOBAL.resetMenus()
    )
    catch()
)

function resetQuadMenus =
(
    try
    (
        if isProperty MENU_MANAGER_GLOBAL #resetQuadMenus then
            MENU_MANAGER_GLOBAL.resetQuadMenus()
    )
    catch()
)

rollout MenuManagerUI_ROLLOUT "Menu Manager UI"
(
    dotNetControl tv "TreeView" width:350 height:400

    button btnInstallMenus "Install && Show Menus" width:170
    button btnInstallQuads "Install && Show QuadMenus" width:170

    button btnResetMenus "Reset Menus" width:170
    button btnResetQuads "Reset QuadMenus" width:170

    button btnRefresh "Refresh" width:170

    local macro_data = #()

    on MenuManagerUI_ROLLOUT open do
    (
        try (macro_data = MENU_MANAGER_GLOBAL.macroscripts) catch (macro_data = #())

        buildMacroTree macro_data tv
    )

    on btnInstallMenus pressed do
    (
        sel = getSelectedMacro tv
        installMenusFromSelected sel
    )

    on btnInstallQuads pressed do
    (
        sel = getSelectedMacro tv
        installQuadMenusFromSelected sel
    )

    on btnResetMenus pressed do
    (
        resetMenus()
    )

    on btnResetQuads pressed do
    (
        resetQuadMenus()
    )

    on btnRefresh pressed do
    (
        try (macro_data = MENU_MANAGER_GLOBAL.macroscripts) catch (macro_data = #())
        buildMacroTree macro_data tv
    )
)

createDialog MenuManagerUI_ROLLOUT 420 520
