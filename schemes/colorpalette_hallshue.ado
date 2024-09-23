*! version 1.0.0, Hall, 23jul2024
cap program drop colorpalette_hallshue
program colorpalette_hallshue
	syntax [, n(str) ]
	c_local P ///
		0 114 178, ///
		20 81 124, ///
		0 85 201, ///
		17 184 251, ///
		153 186 223, ///
		129 216 208, /// 6th
		193 5 52, ///
		214 68 74, ///
		215 99 100, ///
		250 127 111, ///
		223 158 155, ///
		166 64 160, /// 12th
		157 214 233%50, ///
		192 192 192%40, ///
		0 114 178%80, ///
		214 68 74%80
	c_local N ///
		blue.dim ({bf:CI Line}), ///
		blue.dim2, ///
		blue.cite, ///
		blue.light, ///
		blue.ice, ///
		Tiffany, /// 6th
		red.strawberry, ///
		red.rouge, ///
		red.meat, ///
		red.orange, ///
		red.peach, ///
		poison, /// 12th
		{bf:CI Area}, ///
		gs12%40 {bf:CI Area 2}, ///
		{bf:Scatter Fill 1}, ///
		{bf:Scatter Fill 2}
	c_local class qualitative
	c_local note Hall's Palette
	c_local source https://econometrics.club
end

