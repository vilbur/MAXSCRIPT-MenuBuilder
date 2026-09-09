/*
	MenuManagerUI.ms
	Version: 0.92
	UI for MENU_MANAGER_GLOBAL macro management
	TreeView-based macroscript inspector + install/reset tools
*/

global MENU_MANAGER_GLOBAL
global MenuManagerUICallbacks

try (destroyDialog MenuManagerUI_ROLLOUT) catch()

struct MenuManagerUICallbacks_Struct
(
    version = 0.92,

    function buildMacroTree paths treeView =
    (
        treeView.Nodes.Clear()

        for i = 1 to paths.count do
        (
            item = paths[i]
            if item == undefined then continue

            source_path = ""
            display_path = ""

            -- Handle both simple Strings and Objects with properties
            if classOf item == String then
            (
                source_path = item
                display_path = item
            )
            else
            (
                try (source_path = item.path) catch (source_path = "")
                try (display_path = item.name) catch (display_path = source_path)
            )

            parts = filterString display_path "\\/"

            -- Full source paths are stored on leaf nodes, but only the containing
            -- directory and filename are shown in the tree.
            if classOf item == String and parts.count >= 2 then
                parts = #(parts[parts.count - 1], parts[parts.count])
            
            -- Fallback in case filterString returns empty
            if parts.count == 0 then parts = #(display_path)

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

                if p == parts.count and node != undefined then
                    node.Tag = source_path
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
                    if node.Tag != undefined then return node.Tag as string
                    return node.FullPath
                )
            )
        )
        catch()
        return undefined
    ),

    function setChildNodesChecked parent_node is_checked =
    (
        if parent_node != undefined and parent_node.Nodes.Count > 0 then
        (
            for child_index = 0 to parent_node.Nodes.Count - 1 do
            (
                child_node = parent_node.Nodes.Item[child_index]
                child_node.Checked = is_checked
                this.setChildNodesChecked child_node is_checked
            )
        )
    ),

    function collectCheckedLeafPaths nodes selected_paths =
    (
        if nodes.Count > 0 then
        (
            for node_index = 0 to nodes.Count - 1 do
            (
                node = nodes.Item[node_index]
                if node.Nodes.Count > 0 then
                (
                    this.collectCheckedLeafPaths node.Nodes selected_paths
                )
                else if node.Checked and node.Tag != undefined then
                (
                    appendIfUnique selected_paths (node.Tag as string)
                )
            )
        )
        selected_paths -- return
    ),

    function getSelectedMacros treeView =
    (
        selected_paths = #()
        this.collectCheckedLeafPaths treeView.Nodes selected_paths

        -- Keep highlighted-node selection useful when no boxes are checked.
        if selected_paths.count == 0 then
        (
            selected_path = this.getSelectedMacro treeView
            if selected_path != undefined then append selected_paths selected_path
        )

        selected_paths -- return
    ),

    function getExistingSelectedPaths selected_paths =
    (
        existing_paths = #()
        missing_count = 0

        for source_path in selected_paths do
        (
            if doesFileExist source_path then
                appendIfUnique existing_paths source_path
            else
                missing_count += 1
        )

        if missing_count > 0 then
            messageBox ((missing_count as string) + " selected file(s) could not be found and were skipped.") title:"Menu Manager UI"

        existing_paths -- return
    ),

    function installMenusFromSelected selections =
    (
        try
        (
            if selections == undefined or selections.count == 0 then
            (
                messageBox "Check one or more menu files first." title:"Menu Manager UI"
            )
            else
            (
                selected_paths = this.getExistingSelectedPaths selections
                if selected_paths.count > 0 then
                (
                    selected_manager = QuadMenuManager_v()
                    selected_manager.addMacrosToMenus selected_paths
                    selected_manager.createMenus()
                    format "Installed % selected menu file(s).\n" selected_paths.count
                )
            )
        )
        catch
        (
            this._showException()
        )
    ),

    function installQuadMenusFromSelected selections =
    (
        try
        (
            if selections == undefined or selections.count == 0 then
            (
                messageBox "Check one or more quad configuration files first." title:"Menu Manager UI"
            )
            else
            (
                selected_paths = this.getExistingSelectedPaths selections
                if selected_paths.count > 0 then
                (
                    selected_manager = QuadMenuManager_v()
                    selected_manager.quadDir selected_paths
                    selected_manager.createQuadMenus()
                    format "Installed % selected quad configuration file(s).\n" selected_paths.count
                )
            )
        )
        catch
        (
            this._showException()
        )
    ),

    function resetMenus =
    (
        --try
        --(
        --    if isProperty MENU_MANAGER_GLOBAL #resetMenus then
        --    (
			if queryBox ( "REMOVE MENU: \"" + MENU_MANAGER_GLOBAL.MenuBuildManager.custom_menu_root_title +"\"\n\nFROM MAIN MENU BAR ?" ) title:"Title"  beep:false then
                MENU_MANAGER_GLOBAL.resetMenus()
        --    )
        --)
        --catch()
    ),

    function resetQuads =
    (
        try
        (
            if isProperty MENU_MANAGER_GLOBAL #resetQuads then
            (
                MENU_MANAGER_GLOBAL.resetQuads()
            )
        )
        catch()
    ),
	
	private
	
	/** Show exception
	 */
	function _showException =
	(
		--format "\n"; print "MenuManagerUICallbacks_Struct._showException()"
		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
	),
	/**
	 */
	on create do
	(
		--format "\n"; print "MenuManagerUICallbacks_Struct.onCreate()"
	)
	
)

-- Initialize the global struct instance
MenuManagerUICallbacks = MenuManagerUICallbacks_Struct()


rollout MenuManagerUI_ROLLOUT "Menu Manager UI"
(
    dotNetControl tv_menus "TreeView" pos:[8,8] width:350 height:400
    dotNetControl tv_quads "TreeView" pos:[366,8] width:350 height:400

    button btnInstallMenus "INSTALL SELECTED MENUS" pos:[8,416] width:170 height:32
    button btnResetMenus "RESET MENUS" pos:[188,416] width:170 height:32

    button btnInstallQuads "INSTALL SELECTED QUADS" pos:[366,416] width:170 height:32
    button btnResetQuads "RESET QUADS" pos:[546,416] width:170 height:32

    button btnRefresh "REFRESH" pos:[273,460] width:170 height:32

    local macro_data = #()
    local quad_data = #()

    function updateMacroData =
    (
        macro_data = #()
        
        if MENU_MANAGER_GLOBAL != undefined then
        (
            if isProperty MENU_MANAGER_GLOBAL #macroscripts_to_import then
            (
                for mcr_path in MENU_MANAGER_GLOBAL.macroscripts_to_import do
                    appendIfUnique macro_data mcr_path
            )
        )
    )

    function updateQuadData =
    (
        quad_data = #()
        
        if MENU_MANAGER_GLOBAL != undefined then
        (
            if isProperty MENU_MANAGER_GLOBAL #quad_cfg_files then
            (
                for quad_cfg_path in MENU_MANAGER_GLOBAL.quad_cfg_files do
                    appendIfUnique quad_data quad_cfg_path
            )
        )
    )
	
    on MenuManagerUI_ROLLOUT open do
    (
		
		/** Dark theme tree view
		 */
		function darkThemeTreeView tv =
		(
			-- Apply Dark Theme to the TreeView
			local drawingColor = dotNetClass "System.Drawing.Color"
			--format "\n"; print "MenuManagerUICallbacks_Struct.darkThemeTreeView()"
			tv.BackColor = drawingColor.FromArgb 45 45 45       -- Dark Gray background
			tv.ForeColor = drawingColor.FromArgb 220 220 220    -- Light Gray text
			tv.LineColor = drawingColor.FromArgb 150 150 150    -- Mid Gray hierarchy lines
		)
		
        setDialogSize MenuManagerUI_ROLLOUT [724, 500]

        tv_menus.CheckBoxes = true
        tv_quads.CheckBoxes = true
        tv_menus.HideSelection = false
        tv_quads.HideSelection = false

        -- Dynamically append the version to the rollout title
        MenuManagerUI_ROLLOUT.title = "Menu Manager UI v" + (MenuManagerUICallbacks.version as string)
        
        updateMacroData()
        updateQuadData()
		
		darkThemeTreeView tv_menus
		
		darkThemeTreeView tv_quads

		
        MenuManagerUICallbacks.buildMacroTree macro_data tv_menus
        
		
		--for macro in macro_data do
		--format "macro: %\n" macro
		
		--format "MENU_MANAGER_GLOBAL.quad_cfg_files[1]: %\n" MENU_MANAGER_GLOBAL.quad_cfg_files[1]
		
		--quad_data = MENU_MANAGER_GLOBAL.quad_cfg_files
		--quad_data = #( Dictionary #( #path, MENU_MANAGER_GLOBAL.quad_cfg_files[1] ) #( #name, "Test" ) )
		--quad_data = #( MENU_MANAGER_GLOBAL.quad_cfg_files[1]  )
		
		MenuManagerUICallbacks.buildMacroTree quad_data tv_quads
		
    )

    on btnInstallMenus pressed do
    (
        selections = MenuManagerUICallbacks.getSelectedMacros tv_menus

        MenuManagerUICallbacks.installMenusFromSelected selections
    )

    on btnInstallQuads pressed do
    (
        selections = MenuManagerUICallbacks.getSelectedMacros tv_quads

        MenuManagerUICallbacks.installQuadMenusFromSelected selections
    )

    on tv_menus AfterCheck sender event_args do
    (
        local tree_view_action = dotNetClass "System.Windows.Forms.TreeViewAction"
        if event_args.Action != tree_view_action.Unknown then
            MenuManagerUICallbacks.setChildNodesChecked event_args.Node event_args.Node.Checked
    )

    on tv_quads AfterCheck sender event_args do
    (
        local tree_view_action = dotNetClass "System.Windows.Forms.TreeViewAction"
        if event_args.Action != tree_view_action.Unknown then
            MenuManagerUICallbacks.setChildNodesChecked event_args.Node event_args.Node.Checked
    )

    on btnResetMenus pressed do
    (
        MenuManagerUICallbacks.resetMenus()
    )

    on btnResetQuads pressed do
    (
        MenuManagerUICallbacks.resetQuads()
    )

    on btnRefresh pressed do
    (
        updateMacroData()
        updateQuadData()
        MenuManagerUICallbacks.buildMacroTree macro_data tv_menus
        MenuManagerUICallbacks.buildMacroTree quad_data tv_quads
    )
)


/*

createDialog MenuManagerUI_ROLLOUT 724 500

*/
