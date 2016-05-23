package pex;

import haxe.macro.Expr;
import haxe.macro.Context;

class PexIo {
	public static inline function deg2rad( deg: Float ): Float {
		return deg * 0.017453292519943;
	}

	public static function initFromXml( ps: PexEmitter, xml: Xml ) {
		var root = xml.firstElement();

		if (root.nodeName != "particleEmitterConfig" && root.nodeName != "lanicaAnimoParticles") {
			throw 'Expecting "particleEmitterConfig" or "lanicaAnimoParticles", but "${root.nodeName}" found';
		}

		var map : Map<String, Xml> = new Map<String, Xml>();

		for (node in root.elements()) {
			map[node.nodeName.toLowerCase()] = node;
		}

		ps.emitterType = switch( parseIntNode(map["emitterType"])) {
			case 0: Gravity;
			case 1: Radial;
			case _: Gravity;
		}
		ps.maxParticles = parseIntNode(map["maxparticles"]);
		ps.duration = parseFloatNode(map["duration"]);
		ps.gravityX = parseFloatNode(map["gravity"], "x");
		ps.gravityY = parseFloatNode(map["gravity"], "y");
	
		ps.particleLifespan = parseFloatNode(map["particlelifespan"]);
		ps.particleLifespanVariance = parseFloatNode(map["particlelifespanvariance"]);

		ps.speed = parseFloatNode(map["speed"]);
		ps.speedVariance = parseFloatNode(map["speedvariance"]);
		ps.sourcePositionX = parseFloatNode(map["sourceposition"], "x");
		ps.sourcePositionY = parseFloatNode(map["sourceposition"], "y");
		ps.sourcePositionXVariance = parseFloatNode(map["sourcepositionvariance"], "x");
		ps.sourcePositionYVariance = parseFloatNode(map["sourcepositionvariance"], "y");
		ps.angle = deg2rad(parseFloatNode(map["angle"]));
		ps.angleVariance = deg2rad(parseFloatNode(map["anglevariance"]));
	
		ps.startParticleSize = parseFloatNode(map["startparticlesize"]);
		ps.startParticleSizeVariance = parseFloatNode(map["startparticlesizevariance"]);
		ps.finishParticleSize = parseFloatNode(map["finishparticlesize"]);
		ps.finishParticleSizeVariance = parseFloatNode(map["finishparticlesizevariance"]);
		
		ps.startColorRed = parseFloatNode(map["startcolor"], "red");
		ps.startColorRedVariance = parseFloatNode(map["startcolorvariance"], "red");
		ps.finishColorRed = parseFloatNode(map["finishcolor"], "red");
		ps.finishColorRedVariance = parseFloatNode(map["finishcolorvariance"], "red");
		ps.startColorGreen = parseFloatNode(map["startcolor"], "green");
		ps.startColorGreenVariance = parseFloatNode(map["startcolorvariance"], "green");
		ps.finishColorGreen = parseFloatNode(map["finishcolor"], "green");
		ps.finishColorGreenVariance = parseFloatNode(map["finishcolorvariance"], "green");
		ps.startColorBlue = parseFloatNode(map["startcolor"], "blue");
		ps.startColorBlueVariance = parseFloatNode(map["startcolorvariance"], "blue");
		ps.finishColorBlue = parseFloatNode(map["finishcolor"], "blue");
		ps.finishColorBlueVariance = parseFloatNode(map["finishcolorvariance"], "blue");
		ps.startColorAlpha = parseFloatNode(map["startcolor"], "alpha");
		ps.startColorAlphaVariance = parseFloatNode(map["startcolorvariance"], "alpha");
		ps.finishColorAlpha = parseFloatNode(map["finishcolor"], "alpha");
		ps.finishColorAlphaVariance = parseFloatNode(map["finishcolorvariance"], "alpha");
		
		ps.minRadius = parseFloatNode(map["minradius"]);
		ps.minRadiusVariance = parseFloatNode(map["minradiusvariance"]);
		ps.maxRadius = parseFloatNode(map["maxradius"]);
		ps.maxRadiusVariance = parseFloatNode(map["maxradiusvariance"]);
	
		ps.rotationStart = deg2rad(parseFloatNode(map["rotationstart"]));
		ps.rotationStartVariance = deg2rad(parseFloatNode(map["rotationstartvariance"]));
		ps.rotationEnd = deg2rad(parseFloatNode(map["rotationend"]));
		ps.rotationEndVariance = deg2rad(parseFloatNode(map["rotationendvariance"]));
		ps.rotatePerSecond = deg2rad(parseFloatNode(map["rotatepersecond"]));
		ps.rotatePerSecondVariance = deg2rad(parseFloatNode(map["rotatepersecondvariance"]));
	
		ps.radialAcceleration = parseFloatNode(map["radialacceleration"]);
		ps.radialAccelerationVariance = parseFloatNode(map["radialaccelvariance"]);
		ps.tangentialAcceleration = parseFloatNode(map["tangentialacceleration"]);
		ps.tangentialAccelerationVariance = parseFloatNode(map["tangentialaccelvariance"]);
	
		ps.blendFuncSource = cast parseIntNode(map["blendfuncsource"]);
		ps.blendFuncDestination = cast parseIntNode(map["blendfuncdestination"]);
		ps.texture = map["texture"].get( "name" );
		ps.yCoordFlipped = parseIntNode(map["ycoordflipped"]) == 1;

		return ps;
	}

	public static function decodeXml( xmlContent: String ): PexEmitter {
		return initFromXml( new PexEmitter(), Xml.parse( xmlContent ));
	}

	public static function encodeXml( emitter: PexEmitter ): String {
		return 
'<particleEmitterConfig>
  <texture name="${emitter.texture}"/>
  <sourcePosition x="${emitter.sourcePositionX}" y="${emitter.sourcePositionY}"/>
  <sourcePositionVariance x="${emitter.sourcePositionXVariance}" y="${emitter.sourcePositionYVariance}"/>
  <speed value="${emitter.speed}"/>
  <speedVariance value="${emitter.speedVariance}"/>
  <particleLifespan value="${emitter.particleLifespan}"/>
  <particleLifespanVariance value="${emitter.particleLifespanVariance}"/>
  <angle value="${emitter.angle}"/>
  <angleVariance value="${emitter.angleVariance}"/>
  <gravity x="${emitter.gravityX}" y="${emitter.gravityY}"/>
  <radialAcceleration value="${emitter.radialAcceleration}"/>
  <tangentialAcceleration value="${emitter.tangentialAcceleration}"/>
  <radialAccelVariance value="${emitter.radialAccelerationVariance}"/>
  <tangentialAccelVariance value="${emitter.tangentialAccelerationVariance}"/>
  <startColor red="${emitter.startColorRed}" green="${emitter.startColorGreen}" blue="${emitter.startColorBlue}" alpha="${emitter.startColorAlpha}"/>
  <startColorVariance red="${emitter.startColorRedVariance}" green="${emitter.startColorGreenVariance}" blue="${emitter.startColorBlueVariance}" alpha="${emitter.startColorAlphaVariance}"/>
  <finishColor red="${emitter.finishColorRed}" green="${emitter.finishColorGreen}" blue="${emitter.finishColorBlue}" alpha="${emitter.finishColorAlpha}"/>
  <finishColorVariance red="${emitter.finishColorRedVariance}" green="${emitter.finishColorGreenVariance}" blue="${emitter.finishColorBlueVariance}" alpha="${emitter.finishColorAlphaVariance}"/>
  <maxParticles value="${emitter.maxParticles}"/>
  <startParticleSize value="${emitter.startParticleSize}"/>
  <startParticleSizeVariance value="${emitter.startParticleSizeVariance}"/>
  <finishParticleSize value="${emitter.finishParticleSize}"/>
  <FinishParticleSizeVariance value="${emitter.finishParticleSizeVariance}"/>
  <duration value="${emitter.duration}"/>
  <emitterType value="${emitter.emitterType}"/>
  <maxRadius value="${emitter.maxRadius}"/>
  <maxRadiusVariance value="${emitter.maxRadiusVariance}"/>
  <minRadius value="${emitter.minRadius}"/>
  <minRadiusVariance value="${emitter.minRadiusVariance}"/>
  <rotatePerSecond value="${emitter.rotatePerSecond}"/>
  <rotatePerSecondVariance value="${emitter.rotatePerSecondVariance}"/>
  <blendFuncSource value="${emitter.blendFuncSource}"/>
  <blendFuncDestination value="${emitter.blendFuncDestination}"/>
  <rotationStart value="${emitter.rotationStart}"/>
  <rotationStartVariance value="${emitter.rotationStartVariance}"/>
  <rotationEnd value="${emitter.rotationEnd}"/>
  <rotationEndVariance value="${emitter.rotationEndVariance}"/>
</particleEmitterConfig>';
	}

	macro public static function initFromXmlCompileTime( ps: ExprOf<PexEmitter>, xmlPath: String ): Expr {
		var data = sys.io.File.getContent( xmlPath );
		return macro PexIo.initFromXml( ${ps}, Xml.parse($v{data}) );
	}

	macro public static function loadFromXmlCompileTime( xmlPath: String ): Expr {
		var data = sys.io.File.getContent( xmlPath );
		return macro PexIo.initFromXml( ${macro new pex.PexEmitter()}, Xml.parse($v{data}) );
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
