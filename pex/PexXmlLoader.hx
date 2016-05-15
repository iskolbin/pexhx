package pex;

import haxe.macro.Expr;
import haxe.macro.Context;

class PexXmlLoader {
	public static inline function deg2rad( deg: Float ): Float {
		return deg * 0.017453292519943;
	}

	public static function init( ps: PexEmitter, xml: Xml ) {
		var root = xml.firstElement();

		if (root.nodeName != "particleEmitterConfig" && root.nodeName != "lanicaAnimoParticles") {
			throw 'Expecting "particleEmitterConfig" or "lanicaAnimoParticles", but "${root.nodeName}" found';
		}

		var map : Map<String, Xml> = new Map<String, Xml>();

		for (node in root.elements()) {
			map[node.nodeName] = node;
		}

		ps.emitterType = switch( parseIntNode(map["emitterType"])) {
			case 0: Gravity;
			case 1: Radial;
			case _: Gravity;
		}
		ps.maxParticles = parseIntNode(map["maxParticles"]);
		ps.duration = parseFloatNode(map["duration"]);
		ps.gravityX = parseFloatNode(map["gravity"], "x" );
		ps.gravityY = parseFloatNode(map["gravity"], "y" );
	
		ps.particleLifespan = parseFloatNode(map["particleLifeSpan"]);
		ps.particleLifespanVariance = parseFloatNode(map["particleLifespanVariance"]);

		ps.speed = parseFloatNode(map["speed"]);
		ps.speedVariance = parseFloatNode(map["speedVariance"]);
		ps.sourcePositionX = parseFloatNode(map["sourcePosition"], "x");
		ps.sourcePositionY = parseFloatNode(map["sourcePosition"], "y");
		ps.sourcePositionXVariance = parseFloatNode(map["sourcePositionVariance"], "x");
		ps.sourcePositionYVariance = parseFloatNode(map["sourcePositionVariance"], "y");
		ps.angle = deg2rad(parseFloatNode(map["angle"]));
		ps.angleVariance = deg2rad(parseFloatNode(map["angleVariance"]));
	
		ps.startParticleSize = parseFloatNode(map["startParticleSize"]);
		ps.startParticleSizeVariance = parseFloatNode(map["startParticleSizeVariance"]);
		ps.finishParticleSize = parseFloatNode(map["finishParticleSize"]);
		ps.finishParticleSizeVariance = parseFloatNode(map["finishParticleSizeVariance"]);
		
		ps.startColorRed = parseFloatNode(map["startColor"], "red");
		ps.startColorRedVariance = parseFloatNode(map["startColorVariance"], "red");
		ps.finishColorRed = parseFloatNode(map["finishColor"], "red");
		ps.finishColorRedVariance = parseFloatNode(map["finishColorVariance"], "red");
		ps.startColorGreen = parseFloatNode(map["startColor"], "green");
		ps.startColorGreenVariance = parseFloatNode(map["startColorVariance"], "green");
		ps.finishColorGreen = parseFloatNode(map["finishColor"], "green");
		ps.finishColorGreenVariance = parseFloatNode(map["finishColorVariance"], "green");
		ps.startColorBlue = parseFloatNode(map["startColor"], "blue");
		ps.startColorBlueVariance = parseFloatNode(map["startColorVariance"], "blue");
		ps.finishColorBlue = parseFloatNode(map["finishColor"], "blue");
		ps.finishColorBlueVariance = parseFloatNode(map["finishColorVariance"], "blue");
		ps.startColorAlpha = parseFloatNode(map["startColor"], "alpha");
		ps.startColorAlphaVariance = parseFloatNode(map["startColorVariance"], "alpha");
		ps.finishColorAlpha = parseFloatNode(map["finishColor"], "alpha");
		ps.finishColorAlphaVariance = parseFloatNode(map["finishColorVariance"], "alpha");
		
		ps.minRadius = parseFloatNode(map["minRadius"]);
		ps.minRadiusVariance = parseFloatNode(map["minRadiusVariance"]);
		ps.maxRadius = parseFloatNode(map["maxRadius"]);
		ps.maxRadiusVariance = parseFloatNode(map["maxRadiusVariance"]);
	
		ps.rotationStart = deg2rad(parseFloatNode(map["rotationStart"]));
		ps.rotationStartVariance = deg2rad(parseFloatNode(map["rotationStartVariance"]));
		ps.rotationEnd = deg2rad(parseFloatNode(map["rotationEnd"]));
		ps.rotationEndVariance = deg2rad(parseFloatNode(map["rotationEndVariance"]));
		ps.rotatePerSecond = deg2rad(parseFloatNode(map["rotatePerSecond"]));
		ps.rotatePerSecondVariance = deg2rad(parseFloatNode(map["rotatePerSecondVariance"]));
	
		ps.radialAcceleration = parseFloatNode(map["radialAcceleration"]);
		ps.radialAccelerationVariance = parseFloatNode(map["radialAccelVariance"]);
		ps.tangentialAcceleration = parseFloatNode(map["tangentialAcceleration"]);
		ps.tangentialAccelerationVariance = parseFloatNode(map["tangentialAccelVariance"]);
	
		ps.blendFuncSource = cast parseIntNode(map["blendFuncSource"]);
		ps.blendFuncDestination = cast parseIntNode(map["blendFuncDestination"]);
		ps.texture = map["texture"].get( "name" );
		ps.yCoordFlipped = parseIntNode(map["yCoordFlipped"]) == 1;

		return ps;
	}

	public static function load( xml: Xml ): PexEmitter {
		return init( new PexEmitter(), xml );
	}

	macro public static function initCompileTime( ps: ExprOf<PexEmitter>, xmlPath: String ): Expr {
		var data = sys.io.File.getContent( xmlPath );
		return macro PexXmlLoader.init( ${ps}, Xml.parse($v{data}) );
	}

	macro public static function loadCompileTime( xmlPath: String ): Expr {
		var data = sys.io.File.getContent( xmlPath );
		return macro PexXmlLoader.init( ${macro new pex.PexEmitter()}, Xml.parse($v{data}) );
	}

	static function parseIntNode( node: Xml, attr: String = "value" ): Int {
		return (node == null ? 0 : parseIntString(node.get(attr)));
	}

	static function parseFloatNode( node: Xml, attr: String = "value" ): Float {
		return (node == null ? 0 : parseFloatString(node.get(attr)));
	}

	static function parseIntString( s: String ): Int {
		if (s == null) {
			return 0;
		}

		var result = Std.parseInt( s );
		return (result == null ? 0 : result);
	}

	static function parseFloatString( s: String ): Float {
		if (s == null) {
			return 0;
		}

		var result = Std.parseFloat( s );
		return (Math.isNaN(result) ? 0.0 : result);
	}
}
