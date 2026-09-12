/*
	MenuManagerUI.ms
	Version: 1.04
	UI for MENU_MANAGER_GLOBAL macro management
	TreeView-based macroscript inspector + install/reset tools
*/

global MENU_MANAGER_GLOBAL
global MenuManagerUICallbacks

try (destroyDialog MenuManagerUI_ROLLOUT) catch()

struct MenuManagerUICallbacks_Struct
(
    version = 1.04,

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
                -- If it is a leaf node, return its stored source value
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

    function collectVisibleNodes nodes visible_nodes =
    (
        if nodes.Count > 0 then
        (
            for node_index = 0 to nodes.Count - 1 do
            (
                local node = nodes.Item[node_index]
                append visible_nodes node
                if node.IsExpanded then
                    this.collectVisibleNodes node.Nodes visible_nodes
            )
        )

        visible_nodes -- return
    ),

    function findTreeNodeIndex nodes target_node =
    (
        local found_index = 0

        for node_index = 1 to nodes.count while found_index == 0 do
        (
            if nodes[node_index].Equals target_node then
                found_index = node_index
        )

        found_index -- return
    ),

    function isShiftKeyPressed =
    (
        local control_class = dotNetClass "System.Windows.Forms.Control"
        local modifier_text = control_class.ModifierKeys.ToString()

        findString modifier_text "Shift" != undefined -- return
    ),

    function setCheckedNodeRange tree_view first_node last_node is_checked =
    (
        local visible_nodes = #()
        this.collectVisibleNodes tree_view.Nodes visible_nodes

        local first_index = this.findTreeNodeIndex visible_nodes first_node
        local last_index = this.findTreeNodeIndex visible_nodes last_node

        if first_index == 0 or last_index == 0 then
        (
            last_node.Checked = is_checked
            this.setChildNodesChecked last_node is_checked
        )
        else
        (
            local range_start = first_index
            local range_end = last_index

            if range_start > range_end then
            (
                range_start = last_index
                range_end = first_index
            )

            for node_index = range_start to range_end do
            (
                local node = visible_nodes[node_index]
                node.Checked = is_checked
                this.setChildNodesChecked node is_checked
            )
        )
    ),

    function toggleNodeFromClick tree_view event_args selection_anchor =
    (
        local mouse_buttons = dotNetClass "System.Windows.Forms.MouseButtons"
        local hit_locations = dotNetClass "System.Windows.Forms.TreeViewHitTestLocations"
        local next_anchor = selection_anchor

        if event_args.Button == mouse_buttons.Left then
        (
            local hit_info = tree_view.HitTest event_args.Location
            local hit_location = hit_info.Location

            if hit_location != hit_locations.PlusMinus then
            (
                if this.isShiftKeyPressed() and selection_anchor != undefined then
                (
                    local is_checked = event_args.Node.Checked
                    if hit_location != hit_locations.StateImage then
                        is_checked = not event_args.Node.Checked

                    this.setCheckedNodeRange tree_view selection_anchor event_args.Node is_checked
                )
                else if hit_location != hit_locations.StateImage then
                (
                    local is_checked = not event_args.Node.Checked
                    event_args.Node.Checked = is_checked
                    this.setChildNodesChecked event_args.Node is_checked
                )

                next_anchor = event_args.Node
            )
        )

        next_anchor -- return
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
                messageBox "Check one or more menu names first." title:"Menu Manager UI"
            )
            else
            (
                MENU_MANAGER_GLOBAL.createMenus which:selections
                format "Installed % selected menu(s).\n" selections.count
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
                    selected_manager = MenuManager_v()
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
        try
        (
            if MENU_MANAGER_GLOBAL == undefined or not (isProperty MENU_MANAGER_GLOBAL #resetMenus) then
            (
                messageBox "Menu manager is not available." title:"Menu Manager UI"
            )
            else if queryBox ("REMOVE NORMAL MENUS?\n\nQuad menus will be preserved.") title:"Reset Menus" beep:false then
            (
                format "Resetting normal menus. Please wait...\n"
                try (windows.processPostedMessages()) catch()
                MENU_MANAGER_GLOBAL.resetMenus()
                format "Finished resetting normal menus.\n"
            )
        )
        catch
        (
            this._showException()
            messageBox "Reset menus failed. See the MAXScript Listener for details." title:"Menu Manager UI"
        )
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
		format "\n"; print "MenuManagerUICallbacks_Struct._showException()"
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
    local menu_selection_anchor = undefined
    local quad_selection_anchor = undefined

    function updateMacroData =
    (
        macro_data = #()
        
        if MENU_MANAGER_GLOBAL != undefined then
        (
            if isProperty MENU_MANAGER_GLOBAL #menus_data then
            (
                for menu_name in MENU_MANAGER_GLOBAL.menus_data.keys do
                    appendIfUnique macro_data menu_name
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
    function increaseTreeFontByOnePixel tree_view =
    (
        local pixel_in_points = 0.75
        local font_size = tree_view.Font.SizeInPoints + pixel_in_points
        tree_view.Font = dotNetObject "System.Drawing.Font" tree_view.Font.FontFamily font_size tree_view.Font.Style
    )

    function countVisibleTreeNodes nodes =
    (
        local visible_count = 0

        if nodes.Count > 0 then
        (
            for node_index = 0 to nodes.Count - 1 do
            (
                local node = nodes.Item[node_index]
                visible_count += 1
                if node.IsExpanded then
                    visible_count += countVisibleTreeNodes node.Nodes
            )
        )

        visible_count -- return
    )

    function updateTreeLayout =
    (
        local dialog_width = 724
        local layout_height = 140
        local minimum_tree_height = 240
        local max_window_margin = 48
        local max_window_rect = windows.getWindowPos #max
        local max_dialog_height = 540

        if max_window_rect != undefined then
            max_dialog_height = max_window_rect.h - max_window_margin

        if max_dialog_height < minimum_tree_height + layout_height then
            max_dialog_height = minimum_tree_height + layout_height

        local max_tree_height = max_dialog_height - layout_height
        local menu_required_height = (countVisibleTreeNodes tv_menus.Nodes * tv_menus.ItemHeight) + 6
        local quad_required_height = (countVisibleTreeNodes tv_quads.Nodes * tv_quads.ItemHeight) + 6
        local tree_height = menu_required_height

        if quad_required_height > tree_height then tree_height = quad_required_height
        if tree_height < minimum_tree_height then tree_height = minimum_tree_height
        if tree_height > max_tree_height then tree_height = max_tree_height

        tv_menus.height = tree_height
        tv_quads.height = tree_height
        tv_menus.Scrollable = menu_required_height > tree_height
        tv_quads.Scrollable = quad_required_height > tree_height

        local button_y = 16 + tree_height
        btnInstallMenus.pos = [8, button_y]
        btnResetMenus.pos = [188, button_y]
        btnInstallQuads.pos = [366, button_y]
        btnResetQuads.pos = [546, button_y]
        btnRefresh.pos = [273, button_y + 44]

        setDialogSize MenuManagerUI_ROLLOUT [dialog_width, tree_height + layout_height]

        if max_window_rect != undefined then
        (
            local dialog_size = getDialogSize MenuManagerUI_ROLLOUT
            local dialog_position = getDialogPos MenuManagerUI_ROLLOUT
            local centered_y = (max_window_rect.y + ((max_window_rect.h - dialog_size.y) / 2)) as integer
            setDialogPos MenuManagerUI_ROLLOUT [dialog_position.x, centered_y]
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
		
        tv_menus.CheckBoxes = true
        tv_quads.CheckBoxes = true
        tv_menus.Sorted = true
        tv_quads.Sorted = true
        tv_menus.HideSelection = false
        tv_quads.HideSelection = false

        -- Dynamically append the version to the rollout title
        MenuManagerUI_ROLLOUT.title = "Menu Manager UI v" + (MenuManagerUICallbacks.version as string)
        
        updateMacroData()
        updateQuadData()
		
		darkThemeTreeView tv_menus
		
		darkThemeTreeView tv_quads

        increaseTreeFontByOnePixel tv_menus
        increaseTreeFontByOnePixel tv_quads

		
        MenuManagerUICallbacks.buildMacroTree macro_data tv_menus
        
		
		--for macro in macro_data do
		--format "macro: %\n" macro
		
		--format "MENU_MANAGER_GLOBAL.quad_cfg_files[1]: %\n" MENU_MANAGER_GLOBAL.quad_cfg_files[1]
		
		--quad_data = MENU_MANAGER_GLOBAL.quad_cfg_files
		--quad_data = #( Dictionary #( #path, MENU_MANAGER_GLOBAL.quad_cfg_files[1] ) #( #name, "Test" ) )
		--quad_data = #( MENU_MANAGER_GLOBAL.quad_cfg_files[1]  )
		
		MenuManagerUICallbacks.buildMacroTree quad_data tv_quads
		updateTreeLayout()
		
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

    on tv_menus AfterExpand sender event_args do
    (
        updateTreeLayout()
    )

    on tv_menus AfterCollapse sender event_args do
    (
        updateTreeLayout()
    )

    on tv_quads AfterExpand sender event_args do
    (
        updateTreeLayout()
    )

    on tv_quads AfterCollapse sender event_args do
    (
        updateTreeLayout()
    )

    on tv_menus NodeMouseClick sender event_args do
    (
        menu_selection_anchor = MenuManagerUICallbacks.toggleNodeFromClick sender event_args menu_selection_anchor
    )

    on tv_quads NodeMouseClick sender event_args do
    (
        quad_selection_anchor = MenuManagerUICallbacks.toggleNodeFromClick sender event_args quad_selection_anchor
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
        menu_selection_anchor = undefined
        quad_selection_anchor = undefined
        updateMacroData()
        updateQuadData()
        MenuManagerUICallbacks.buildMacroTree macro_data tv_menus
        MenuManagerUICallbacks.buildMacroTree quad_data tv_quads
        updateTreeLayout()
    )
)


/*

createDialog MenuManagerUI_ROLLOUT 724 540

*/
