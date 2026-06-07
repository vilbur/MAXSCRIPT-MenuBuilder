/*
    Proof of Concept: Replace Default Viewport Right-Click Quad Menu
    API: ICuiQuadMenuMgr (3ds Max 2025 / 2026)
*/

-- 1. Create a fake MacroScript item
macroScript PoC_FakeItem category:"PoC_Category" tooltip:"Fake Item"
(
    on execute do ( messageBox "Custom Quad Menu active!" title:"PoC" )
)

(
    local quadMenuMgr = maxOps.GetICuiQuadMenuMgr()
    local viewportContextId = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e"
    local viewportContext = quadMenuMgr.GetContextById viewportContextId
    
    if viewportContext != undefined do
    (
        -- 2. Create the parent Quad Menu
        local customQuad = viewportContext.CreateQuadMenu (genGUID()) "MyPoC_Quad"
        
        -- 3. FIX: Create the quadrant menu explicitly instead of getting it
        -- Syntax: <quadMenu>.CreateMenu <guid> <title> <quadPosEnum>
        local topRightMenu = customQuad.CreateMenu (genGUID()) "MyPoC_TopRight" #TopRight
        
        -- 4. Add the macroscript action to the newly created quadrant
        local actionName = "PoC_FakeItem`PoC_Category" 
        topRightMenu.CreateAction (genGUID()) 647394 actionName
        
        -- 5. Bind the custom Quad Menu to Right-Click (no modifier keys)
        viewportContext.SetRightClickModifiers customQuad #nonePressed
        
        print "Default right-click viewport quad menu replaced successfully."
    )
)