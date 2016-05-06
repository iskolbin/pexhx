package pex;

@:enum abstract PexBlend(Int) {
	var Zero = 0;
	var One = 1;
	var Src = 2;
	var OneMinusSrc = 3;
	var SrcAlpha = 4;
	var OneMinusSrcAlpha = 5;
	var DstAlpha = 6;
	var OneMinusDstAlpha = 7;
	var DstColor = 8;
	var OneMinusDstColor = 9;
}
