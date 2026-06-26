# MenuBuilder  


`MenuRebuilder.ms` is a MaxScript framework for building, saving, managing, and rebuilding custom **3ds Max menu-bar menus** and **quad menus**.  


It is designed for 3ds Max 2025+  
Custom menus must be rebuilt on every 3ds Max launch.  

The script allows multiple independent tools to add their own menu data into one shared JSON file. On startup, all saved menu definitions are loaded from JSON and rebuilt automatically.  


---  

## Main Idea - Create MENUS and QUAD menus from macroscripts  

	 *.mcr  
		↓  
	  Menu  
		↓  
	Quad Menu  


---  

# Macroscript Definition  


``` maxscript  
macroscript _macro_name  
category:   "MENU NAME"  
toolTip:    "ITEM NAME"  
icon:       "MENU:true"  
buttontext: "Redundand param"  
()  

```  