global menu_rebuilder_file_version = 0.15
global MenuBuildManager
global MenuRebuilder_qmnx_clear_guard = false
global QuadDefaultQmnxClear_v
global MenuRebuilder_v


/* HEPERS */ 
--filein( getFilenamePath(getSourceFileName()) + "/XmlParser/XmlParser.ms" )	--"./XmlParser/XmlParser.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuJsonIO/MenuJsonIO.ms" )	--"./MenuJsonIO/MenuJsonIO.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuNativeDataIO/MenuNativeDataIO.ms" )	--"./MenuNativeDataIO/MenuNativeDataIO.ms"
filein( getFilenamePath(getSourceFileName()) + "/QuadDefaultQmnxClear/QuadDefaultQmnxClear.ms" )	--"./QuadDefaultQmnxClear/QuadDefaultQmnxClear.ms"

/* LIBRARY */ 
filein( getFilenamePath(getSourceFileName()) + "/MenuDefinition/MenuDefinition.ms" )	--"./MenuDefinition/MenuDefinition.ms"

--filein( getFilenamePath(getSourceFileName()) + "/MenuLoader/MenuLoader.ms" )	--"./MenuLoader/MenuLoader.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuRebuilder/MenuRebuilder.ms" )	--"./MenuRebuilder/MenuRebuilder.ms"

/* UI */ 
filein( getFilenamePath(getSourceFileName()) + "/JsonManagerRollout/JsonManagerRollout.ms" )	--"./JsonManagerRollout/JsonManagerRollout.ms"

filein( getFilenamePath(getSourceFileName()) + "/MenuBuildManager/MenuBuildManager.ms" )	--"./MenuBuildManager/MenuBuildManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/QuadMenuManager/QuadMenuManager.ms" )	--"./QuadMenuManager/QuadMenuManager.ms"
