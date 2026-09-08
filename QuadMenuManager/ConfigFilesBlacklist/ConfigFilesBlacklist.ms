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
		/* GET PATTERNS */ 
		masks = case blacklist of
		(
			#MENUS: this.common + this.menus
			#QUADS: this.common + this.quads

			default: common
		)
												  
		/* TEST PATTERNS */ 
		(for pattern in blacklist where matchPattern file_path pattern:pattern collect pattern).count > 0
	),
	
	
	private
	

	/**
	 */
	on create do
	(
	)
)