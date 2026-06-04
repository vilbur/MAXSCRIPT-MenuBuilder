--filein( getFilenamePath(getSourceFileName()) + "/Menu/Menu.ms" )	--"./Menu/Menu.ms"
--filein( getFilenamePath(getSourceFileName()) + "/RcMenu/RcMenu.ms" )	--"./RcMenu/RcMenu.ms"
--filein( getFilenamePath(getSourceFileName()) + "/QuadMenu/QuadMenu.ms" )	--"./QuadMenu/QuadMenu.ms"
--filein( getFilenamePath(getSourceFileName()) + "/QuadMenuManager/QuadMenuManager.ms" )	--"./QuadMenuManager/QuadMenuManager.ms"
--filein( getFilenamePath(getSourceFileName()) + "/MenuCreator/MenuCreator.ms" )	--"./MenuCreator/MenuCreator.ms"
--

global menu_rebuilder_file_version = 0.15
global MenuBuildManager
global MenuRebuilder_qmnx_clear_guard = false
global QuadDefaultQmnxClear_v


/* HEPERS */ 
filein( getFilenamePath(getSourceFileName()) + "/XmlParser/XmlParser.ms" )	--"./XmlParser/XmlParser.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuJsonIO/MenuJsonIO.ms" )	--"./MenuJsonIO/MenuJsonIO.ms"
filein( getFilenamePath(getSourceFileName()) + "/QuadDefaultQmnxClear/QuadDefaultQmnxClear.ms" )	--"./QuadDefaultQmnxClear/QuadDefaultQmnxClear.ms"

/* LIBRARY */ 
filein( getFilenamePath(getSourceFileName()) + "/MenuDefinition/MenuDefinition.ms" )	--"./MenuDefinition/MenuDefinition.ms"

--filein( getFilenamePath(getSourceFileName()) + "/MenuLoader/MenuLoader.ms" )	--"./MenuLoader/MenuLoader.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuRebuilder/MenuRebuilder.ms" )	--"./MenuRebuilder/MenuRebuilder.ms"


/* UI */ 
filein( getFilenamePath(getSourceFileName()) + "/JsonManagerRollout/JsonManagerRollout.ms" )	--"./JsonManagerRollout/JsonManagerRollout.ms"


