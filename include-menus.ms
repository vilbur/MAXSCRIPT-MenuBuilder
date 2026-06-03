--filein( getFilenamePath(getSourceFileName()) + "/Menu/Menu.ms" )	--"./Menu/Menu.ms"
--filein( getFilenamePath(getSourceFileName()) + "/RcMenu/RcMenu.ms" )	--"./RcMenu/RcMenu.ms"
--filein( getFilenamePath(getSourceFileName()) + "/QuadMenu/QuadMenu.ms" )	--"./QuadMenu/QuadMenu.ms"
--filein( getFilenamePath(getSourceFileName()) + "/QuadMenuManager/QuadMenuManager.ms" )	--"./QuadMenuManager/QuadMenuManager.ms"
--filein( getFilenamePath(getSourceFileName()) + "/MenuCreator/MenuCreator.ms" )	--"./MenuCreator/MenuCreator.ms"
--


global menu_rebuilder_file_version = 0.09
global MenuRebuilder
global MenuBuildManager


filein( getFilenamePath(getSourceFileName()) + "/XmlParser/XmlParser.ms" )	--"./XmlParser/XmlParser.ms"

filein( getFilenamePath(getSourceFileName()) + "/MenuBuildManager/MenuBuildManager.ms" )	--"./MenuBuildManager/MenuBuildManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuRebuilder/MenuRebuilder.ms" )	--"./MenuRebuilder/MenuRebuilder.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuJsonIO/MenuJsonIO.ms" )	--"./MenuJsonIO/MenuJsonIO.ms"
filein( getFilenamePath(getSourceFileName()) + "/MenuDefinition/MenuDefinition.ms" )	--"./MenuDefinition/MenuDefinition.ms"
filein( getFilenamePath(getSourceFileName()) + "/JsonManagerRollout/JsonManagerRollout.ms" )	--"./JsonManagerRollout/JsonManagerRollout.ms"