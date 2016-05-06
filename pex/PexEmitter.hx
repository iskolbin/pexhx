package pex;

class PexEmitter {
	public static inline var ParticleX = 0;
	public static inline var ParticleY = 1;
	public static inline var ParticleRot = 2;
	public static inline var ParticleSize = 3;
	public static inline var ParticleLifespan = 4;
	public static inline var ParticleSpeed = 5;
	public static inline var ParticleTanAccel = 6;
	public static inline var ParticleRadAccel = 7;
	public static inline var ParticleRed = 8;
	public static inline var ParticleGreen = 9;
	public static inline var ParticleBlue = 10;
	public static inline var ParticleAlpha = 11;
	public static inline var PARTICLE_PARAMETERS = 12; 
	
	public var type: PexEmitterType = Gravity;
	public var maxParticles = 500;
	public var particles: Array<Float> = [];
	public var particlesCount = 0;
	public var sourceBlend: PexBlend = SrcAlpha;
	public var destBlend: PexBlend = One;

	public var angle = 0.0;
	public var angleVar = 0.0;
	
	public var lifespan = 2.0;
	public var lifespanVar = 1.9;
	public var startSize = 70.0;
	public var startSizeVar = 49.5;
	public var finishSize = 10.0;
	public var finishSizeVar = 5.0;
	public var rotationStart = 0.0;
	public var rotationStartVar = 0.0;
	public var rotationEnd = 0.0;
	public var rotationEndVar = 0.0;

	public var maxRadius = 100.0;
	public var maxRadiusVar = 0.0;
	public var minRadius = 0.0;
	public var minRadiusVar = 0.0;
	public var rotatePerSecond = 0.0;
	public var rotatePerSecondVar = 0.0;

	public var startRed = 1.0;
	public var startRedVar = 0.0;
	public var finishRed = 0.0;
	public var finishRedVar = 0.0;
	public var startGreen = 0.3;
	public var startGreenVar = 0.0;
	public var finishGreen = 0.0;
	public var finishGreenVar = 0.0;
	public var startBlue = 0.0;
	public var startBlueVar = 0.0;
	public var finishBlue = 0.0;
	public var finishBlueVar = 0.0;
	public var startAlpha = 0.6;
	public var startAlphaVar = 0.0;
	public var finishAlpha = 0.0;
	public var finishAlphaVar = 0.0;

	public var x = 0.0;
	public var xVar = 0.0;
	public var y = 0.0;
	public var yVar = 0.0;
	public var radialAccel = 0.0;
	public var radialAccelVar = 0.0;
	public var tanAccel = 0.0;
	public var tanAccelVar = 0.0;
	public var gravityX = 0.0;
	public var gravityY = 0.0;
	public var speed = 0.0;
	public var speedVar = 0.0;

	public function new() {
	}

	public function update( dt: Float ) {
	}
}
