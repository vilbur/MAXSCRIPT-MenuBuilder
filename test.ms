(
global SplineKnotData_v
global SplinePartData_v
global SplineShapeData_v
global SplineExactRebuild_v
global SplineExactRebuild

struct SplineKnotData_v
(
	knot_type = #corner,
	line_type = #line,
	point_value = [0,0,0],
	in_vec = [0,0,0],
	out_vec = [0,0,0],

	on create do
	(
	)
)

struct SplinePartData_v
(
	is_closed = false,
	knots_data = #(),
	segment_mat_ids = #(),

	on create do
	(
	)
)

struct SplineShapeData_v
(
	node_name = "",
	splines_data = #(),

	on create do
	(
	)
)

struct SplineExactRebuild_v
(
	/* isSplineNode
	Checks if node can be processed by native spline functions.
	*/
	function isSplineNode source_node =
	(
		is_ok = false

		if (isValidNode source_node) then
		(
			if ((superClassOf source_node) == Shape) then
			(
				try
				(
					dummy_count = numSplines source_node
					is_ok = true
				)
				catch
				(
					is_ok = false
				)
			)
		)

		is_ok -- return
	),

	/* collectSplineData
	Collects knot data and segment material IDs from source spline.
	*/
	function collectSplineData source_node =
	(
		spline_shape_data = undefined

		if (this.isSplineNode source_node) then
		(
			spline_shape_data = SplineShapeData_v()
			spline_shape_data.node_name = source_node.name
			spline_shape_data.splines_data = #()

			spline_count = numSplines source_node

			for spline_i = 1 to spline_count do
			(
				spline_part_data = SplinePartData_v()
				spline_part_data.is_closed = isClosed source_node spline_i
				spline_part_data.knots_data = #()
				spline_part_data.segment_mat_ids = #()

				knot_count = numKnots source_node spline_i

				for knot_i = 1 to knot_count do
				(
					knot_data = SplineKnotData_v()
					knot_data.knot_type = getKnotType source_node spline_i knot_i
					knot_data.line_type = getLineType source_node spline_i knot_i
					knot_data.point_value = getKnotPoint source_node spline_i knot_i
					knot_data.in_vec = getInVec source_node spline_i knot_i
					knot_data.out_vec = getOutVec source_node spline_i knot_i

					append spline_part_data.knots_data knot_data
				)

				segment_count = knot_count - 1

				if (spline_part_data.is_closed) then
				(
					segment_count = knot_count
				)

				if (segment_count < 0) then
				(
					segment_count = 0
				)

				for segment_i = 1 to segment_count do
				(
					segment_mat_id = 1

					try
					(
						segment_mat_id = getSegMatID source_node spline_i segment_i
					)
					catch
					(
						segment_mat_id = 1
					)

					append spline_part_data.segment_mat_ids segment_mat_id
				)

				append spline_shape_data.splines_data spline_part_data
			)
		)

		spline_shape_data -- return
	),

	/* clearSplineNode
	Deletes all existing splines from target node before rebuilding.
	*/
	function clearSplineNode target_node =
	(
		is_ok = false

		if (this.isSplineNode target_node) then
		(
			spline_count = numSplines target_node

			if (spline_count > 0) then
			(
				for spline_i = spline_count to 1 by -1 do
				(
					deleteSpline target_node spline_i
				)
			)

			updateShape target_node
			is_ok = true
		)

		is_ok -- return
	),

	/* rebuildSplineNode
	Rebuilds target spline from stored spline data.
	*/
	function rebuildSplineNode target_node spline_shape_data =
	(
		is_ok = false

		if ((this.isSplineNode target_node) and (spline_shape_data != undefined)) then
		(
			this.clearSplineNode target_node

			for spline_i = 1 to spline_shape_data.splines_data.count do
			(
				spline_part_data = spline_shape_data.splines_data[spline_i]

				addNewSpline target_node
				new_spline_index = numSplines target_node

				for knot_i = 1 to spline_part_data.knots_data.count do
				(
					knot_data = spline_part_data.knots_data[knot_i]

					addKnot target_node new_spline_index knot_data.knot_type knot_data.line_type knot_data.point_value knot_data.in_vec knot_data.out_vec
				)

				if (spline_part_data.is_closed) then
				(
					close target_node new_spline_index
				)
			)

			updateShape target_node

			for spline_i = 1 to spline_shape_data.splines_data.count do
			(
				spline_part_data = spline_shape_data.splines_data[spline_i]

				for segment_i = 1 to spline_part_data.segment_mat_ids.count do
				(
					try
					(
						setSegMatID target_node spline_i segment_i spline_part_data.segment_mat_ids[segment_i]
					)
					catch
					(
					)
				)
			)

			updateShape target_node
			is_ok = true
		)

		is_ok -- return
	),

	/* createSecondAndRebuildCurrent
	Creates second spline and rebuilds both duplicate and current spline from captured data.
	*/
	function createSecondAndRebuildCurrent source_node =
	(
		second_node = undefined

		if (this.isSplineNode source_node) then
		(
			spline_shape_data = this.collectSplineData source_node

			second_node = copy source_node name:(uniqueName (source_node.name + "_rebuilt"))
			this.rebuildSplineNode second_node spline_shape_data
			this.rebuildSplineNode source_node spline_shape_data

			select #(source_node, second_node)

			format "Spline rebuilt: %\n" source_node.name
			format "Second spline created: %\n" second_node.name
		)
		else
		(
			format "Selected node is not valid spline shape.\n"
		)

		second_node -- return
	),

	/* printSplineData
	Prints knot positions and segment material IDs for debug comparison.
	*/
	function printSplineData source_node =
	(
		if (this.isSplineNode source_node) then
		(
			format "\n--- SPLINE DEBUG: % ---\n" source_node.name

			for spline_i = 1 to (numSplines source_node) do
			(
				knot_count = numKnots source_node spline_i
				is_closed_value = isClosed source_node spline_i

				format "spline % | knots % | closed %\n" spline_i knot_count is_closed_value

				for knot_i = 1 to knot_count do
				(
					format "  knot % pos = %\n" knot_i (getKnotPoint source_node spline_i knot_i)
				)

				segment_count = knot_count - 1

				if (is_closed_value) then
				(
					segment_count = knot_count
				)

				for segment_i = 1 to segment_count do
				(
					segment_mat_id = 1

					try
					(
						segment_mat_id = getSegMatID source_node spline_i segment_i
					)
					catch
					(
						segment_mat_id = 1
					)

					format "  segment % mat_id = %\n" segment_i segment_mat_id
				)
			)
		)

		ok -- return
	),

	/* buildTestSpline
	Creates test spline with two sub-splines and custom segment material IDs.
	*/
	function buildTestSpline =
	(
		try
		(
			delete (getNodeByName "SplineExactRebuild_Test_Source")
		)
		catch
		(
		)

		test_node = SplineShape name:"SplineExactRebuild_Test_Source"

		addNewSpline test_node
		addKnot test_node 1 #corner #line [0,0,0] [0,0,0] [0,0,0]
		addKnot test_node 1 #corner #line [100,0,0] [100,0,0] [100,0,0]
		addKnot test_node 1 #corner #line [100,100,0] [100,100,0] [100,100,0]
		addKnot test_node 1 #corner #line [0,100,0] [0,100,0] [0,100,0]
		close test_node 1

		addNewSpline test_node
		addKnot test_node 2 #corner #line [150,0,0] [150,0,0] [150,0,0]
		addKnot test_node 2 #corner #line [250,50,0] [250,50,0] [250,50,0]
		addKnot test_node 2 #corner #line [300,0,0] [300,0,0] [300,0,0]

		updateShape test_node

		setSegMatID test_node 1 1 2
		setSegMatID test_node 1 2 3
		setSegMatID test_node 1 3 4
		setSegMatID test_node 1 4 5

		setSegMatID test_node 2 1 6
		setSegMatID test_node 2 2 7

		updateShape test_node

		select test_node

		test_node -- return
	),

	on create do
	(
	)
)

SplineExactRebuild = SplineExactRebuild_v()
)