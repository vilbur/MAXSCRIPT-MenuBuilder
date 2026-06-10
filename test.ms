/*
Create one spline shape for weld threshold test.
Total X length is 20 cm and middle gap is 1 mm.
*/
function createWeldThresholdTestSpline length_value:(units.decodeValue "20cm") gap_value:(units.decodeValue "1mm") =
(
	delete (for object_node in objects where object_node.name == "_TEST_spline_weld_threshold" collect object_node)

	test_shape = splineShape name:"_TEST_spline_weld_threshold"

	left_x = 0.0
	gap_left_x = (length_value - gap_value) * 0.5
	gap_right_x = gap_left_x + gap_value
	right_x = length_value

	addNewSpline test_shape
	addKnot test_shape 1 #corner #line [left_x, 0, 0]
	addKnot test_shape 1 #corner #line [gap_left_x, 0, 0]

	addNewSpline test_shape
	addKnot test_shape 2 #corner #line [gap_right_x, 0, 0]
	addKnot test_shape 2 #corner #line [right_x, 0, 0]

	updateShape test_shape

	test_shape.wirecolor = yellow
	test_shape.name = "_TEST_spline_weld_threshold"

	format "Created: %\n" test_shape.name
	format "Length: %\n" (units.formatValue length_value)
	format "Gap: %\n" (units.formatValue gap_value)
	format "Knots before weld: %\n" ((numKnots test_shape 1) + (numKnots test_shape 2))

	select test_shape

	test_shape -- return
)

/*
Weld selected middle knots of test spline.
Use threshold bigger than 1 mm to weld, smaller than 1 mm to fail.
*/
function weldThresholdTestSpline shape_node threshold_value:(units.decodeValue "2mm") =
(
	if isValidNode shape_node then
	(
		convertToSplineShape shape_node

		subObjectLevel = 1

		setKnotSelection shape_node 1 #(2)
		setKnotSelection shape_node 2 #(1) keep:true

		weldSpline shape_node threshold_value
		updateShape shape_node

		total_knots = 0

		for spline_index = 1 to (numSplines shape_node) do
		(
			total_knots += numKnots shape_node spline_index
		)

		format "Weld threshold: %\n" (units.formatValue threshold_value)
		format "Splines after weld: %\n" (numSplines shape_node)
		format "Knots after weld: %\n" total_knots

		select shape_node
	)

	shape_node -- return
)


--test_shape = createWeldThresholdTestSpline()

----weldThresholdTestSpline $ threshold_value:(units.decodeValue "0.5mm")
weldThresholdTestSpline $ threshold_value:(units.decodeValue "0mm")

--test_shape = createWeldThresholdTestSpline()
--weldThresholdTestSpline test_shape threshold_value:(units.decodeValue "2mm")
