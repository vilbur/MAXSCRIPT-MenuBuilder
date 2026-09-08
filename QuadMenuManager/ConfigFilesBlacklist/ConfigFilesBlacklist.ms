/** Config files blacklist
  
	Test file paths against array of masks
  
  
 */
struct ConfigFilesBlacklist_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	common	= #(), -- blacklist for menus and quads E.G.: #( "*\\bak*", "*-UNUSED*" )
	menus	= #(), -- blacklist for menus
	quads	= #(), -- blacklist for quads
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/* Test if file match blacklist mask
	*/ 
	function isOnBlacklist file_path blacklist:#COMMON =
	(
		format "\n"; print "ConfigFilesBlacklist_v.isOnBlacklist()"
		format "this.menus: %\n" this.menus
		/* GET PATTERNS */ 
		patterns = case blacklist of
		(
			#MENUS: this.common + this.menus
			#QUADS: this.common + this.quads

			default: common
		)
		
		format "patterns: %\n" patterns
		
		/* TEST PATTERNS */ 
		(for pattern in patterns where matchPattern file_path pattern:pattern collect pattern).count > 0
	),
	
	
	private
	

	/**
	 */
	on create do
	(
	)
)