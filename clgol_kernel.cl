__kernel void addCellValue(__read_only image2d_t sourceImage, sampler_t sampler, float2 coords, __local int *value) {
	float pixel = read_imagef(sourceImage, sampler, coords).x;
	if(pixel) {
		*value += 1;
	}
}

__kernel void gol(
		__read_only 	image2d_t universe,
		__write_only 	image2d_t output,
						sampler_t sampler) {
	float x_unit = 1.0 / WIDTH;
	float y_unit = 1.0 / HEIGHT;
	
	float2 coords = (float2){get_global_id(0) / (float) WIDTH, get_global_id(1) / (float) HEIGHT};
	
	float2 tl	= (float2){coords.x - x_unit, coords.y + y_unit};
	float2 t	= (float2){coords.x, coords.y + y_unit};
	float2 tr = (float2){coords.x + x_unit, coords.y + y_unit};
	float2 l 	= (float2){coords.x - x_unit, coords.y};
	float2 r 	= (float2){coords.x + x_unit, coords.y};
	float2 bl = (float2){coords.x - x_unit, coords.y - y_unit};
	float2 b 	= (float2){coords.x, coords.y - y_unit};
	float2 br = (float2){coords.x + x_unit, coords.y - y_unit};
	
	int currentState;
	__local int neighbourCount;
	neighbourCount = 0;
	
	addCellValue(universe, sampler, tl, 	&neighbourCount);
	addCellValue(universe, sampler, t, 	&neighbourCount);
	addCellValue(universe, sampler, tr, 	&neighbourCount);
	addCellValue(universe, sampler, l, 	&neighbourCount);
	addCellValue(universe, sampler, r, 	&neighbourCount);
	addCellValue(universe, sampler, bl, 	&neighbourCount);
	addCellValue(universe, sampler, b, 	&neighbourCount);
	addCellValue(universe, sampler, br, 	&neighbourCount);
	
	currentState = (int) read_imagef(universe, sampler, coords).x;
	
	float4 pixel;
	
	if (currentState == 1) {
		if (neighbourCount == 2 || neighbourCount == 3) { pixel.x = 1.0; }
		else { pixel.x = 0.0; }
	} else if (neighbourCount == 3) { pixel.x = 1.0; }
	else { pixel.x = 0.0; }
	
	int2 out_coord = (int2){get_global_id(0), get_global_id(1)};
	
	write_imagef(output, out_coord, pixel);
}