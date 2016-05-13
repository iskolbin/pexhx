package pex;

class PexEmitter {
	// Common
	public static inline var ParticleTimeToLive = 0;
	public static inline var ParticleStartPosX = 1;
	public static inline var ParticleStartPosY = 2;
	public static inline var ParticleRed = 3;
	public static inline var ParticleGreen = 4;
	public static inline var ParticleBlue = 5;
	public static inline var ParticleAlpha = 6;
	public static inline var ParticleRedDelta = 7;
	public static inline var ParticleGreenDelta = 8;
	public static inline var ParticleBlueDelta = 9;
	public static inline var ParticleAlphaDelta = 10;
	public static inline var ParticleSize = 11;
	public static inline var ParticleSizeDelta = 12;
	public static inline var ParticleRotation = 13;	
	public static inline var ParticleRotationDelta = 14;	
	
	// For gravity emitter type
	public static inline var ParticlePositionX = 15;
	public static inline var ParticlePositionY = 16;
	public static inline var ParticleDirectionX = 17;
	public static inline var ParticleDirectionY = 18;
	public static inline var ParticleRadialAcceleration = 19;
	public static inline var ParticleTangentialAcceleration = 20;

	// For radial emitter type
	public static inline var ParticleAngle = 15;
	public static inline var ParticleAngleDelta = 16;
	public static inline var ParticleRadius = 17;
	public static inline var ParticleRadiusDelta = 18;

	public static inline var PARTICLE_PARAMETERS = 21; 
	
	public var emitterType: PexEmitterType = Gravity;
	public var maxParticles = 500;
	public var particles = new Array<Float>();
	public var particleCount = 0;
	public var duration = 0.0;
	public var elapsedTime = 0.0;
	public var blendFuncSource: PexBlend = SrcAlpha;
	public var blendFuncDestination: PexBlend = One;

	public var angle = 0.0;
	public var angleVariance = 0.0;
	
	public var particleLifespan = 2.0;
	public var particleLifespanVariance = 1.9;
	public var startParticleSize = 70.0;
	public var startParticleSizeVariance = 49.5;
	public var finishParticleSize = 10.0;
	public var finishParticleSizeVariance = 5.0;
	public var rotationStart = 0.0;
	public var rotationStartVariance = 0.0;
	public var rotationEnd = 0.0;
	public var rotationEndVariance = 0.0;

	public var maxRadius = 100.0;
	public var maxRadiusVariance = 0.0;
	public var minRadius = 0.0;
	public var minRadiusVariance = 0.0;
	public var rotatePerSecond = 0.0;
	public var rotatePerSecondVariance = 0.0;

	public var startColorRed = 1.0;
	public var startColorRedVariance = 0.0;
	public var finishColorRed = 0.0;
	public var finishColorRedVariance = 0.0;
	public var startColorGreen = 0.3;
	public var startColorGreenVariance = 0.0;
	public var finishColorGreen = 0.0;
	public var finishColorGreenVariance = 0.0;
	public var startColorBlue = 0.0;
	public var startColorBlueVariance = 0.0;
	public var finishColorBlue = 0.0;
	public var finishColorBlueVariance = 0.0;
	public var startColorAlpha = 0.6;
	public var startColorAlphaVariance = 0.0;
	public var finishColorAlpha = 0.0;
	public var finishColorAlphaVariance = 0.0;

	public var sourcePositionX = 0.0;
	public var sourcePositionXVariance = 0.0;
	public var sourcePositionY = 0.0;
	public var sourcePositionYVariance = 0.0;
	public var radialAcceleration = 0.0;
	public var radialAccelerationVariance = 0.0;
	public var tangentialAcceleration = 0.0;
	public var tangentialAccelerationVariance = 0.0;
	public var gravityX = 0.0;
	public var gravityY = 0.0;
	public var speed = 0.0;
	public var speedVariance = 0.0;
	public var texture = "";
	public var yCoordFlipped = false;

	public var active = false;
	public var restart = false;
	var emitCounter = 0.0;

	public function new() {
	}

	@:extern inline function sin( v: Float ) return Math.sin( v );

	@:extern inline function cos( v: Float ) return Math.cos( v );

	@:extern inline function rnd1to1() {
		return Math.random() * 2.0 - 1.0;	
	}

	@:extern inline function clamp( value: Float ) {
		return (value < 0.0 ? 0.0 : (value < 1.0 ? value : 1.0));
	}

	@:extern inline function initParticle() {
		var index = particleCount * PARTICLE_PARAMETERS;

		if ( index+PARTICLE_PARAMETERS > particles.length ) {
			for ( i in index...index+PARTICLE_PARAMETERS ) particles.push( 0.0 );
			particleCount++;
		}

		// Common
		particles[index+ParticleTimeToLive] = Math.max(0.0001, particleLifespan + particleLifespanVariance * rnd1to1());
		particles[index+ParticleStartPosX] = sourcePositionX;
		particles[index+ParticleStartPosY] = sourcePositionY;
		particles[index+ParticleRed] = clamp(startColorRed + startColorRedVariance * rnd1to1());
		particles[index+ParticleGreen] = clamp(startColorGreen + startColorGreenVariance * rnd1to1());
		particles[index+ParticleBlue] = clamp(startColorBlue + startColorBlueVariance * rnd1to1());
		particles[index+ParticleAlpha] = clamp(startColorAlpha + startColorAlphaVariance * rnd1to1());
		var redTmp = clamp(finishColorRed + finishColorRedVariance * rnd1to1());
		var greenTmp = clamp(finishColorGreen + finishColorGreenVariance * rnd1to1());
		var blueTmp = clamp(finishColorBlue + finishColorBlueVariance * rnd1to1());
		var alphaTmp = clamp(finishColorAlpha + finishColorAlphaVariance * rnd1to1()); 
		particles[index+ParticleRedDelta] = (redTmp - particles[index+ParticleRed]) / particles[index+ParticleTimeToLive];
		particles[index+ParticleGreenDelta] = (greenTmp- particles[index+ParticleGreen]) / particles[index+ParticleTimeToLive];
		particles[index+ParticleBlueDelta] = (blueTmp - particles[index+ParticleBlue]) / particles[index+ParticleTimeToLive];
		particles[index+ParticleAlphaDelta] = (alphaTmp - particles[index+ParticleAlpha]) / particles[index+ParticleTimeToLive];
		particles[index+ParticleSize] = Math.max(0.0, startParticleSize + startParticleSizeVariance * rnd1to1());
		particles[index+ParticleSizeDelta] = (Math.max(0.0, finishParticleSize + finishParticleSizeVariance * rnd1to1()) - particles[index+ParticleSize]) / particles[index+ParticleTimeToLive];
		particles[index+ParticleRotation] = rotationStart + rotationStartVariance * rnd1to1();
		particles[index+ParticleRotationDelta] = (rotationEnd + rotationEndVariance * rnd1to1() - particles[index+ParticleRotation]) / particles[index+ParticleTimeToLive];

		var computedAngle = angle + angleVariance * rnd1to1();

		// For gravity emitter type
		var directionSpeed = speed + speedVariance * rnd1to1();

		particles[index+ParticlePositionX] = particles[index+ParticleStartPosX] + sourcePositionXVariance * rnd1to1();
		particles[index+ParticlePositionY] = particles[index+ParticleStartPosY] + sourcePositionYVariance * rnd1to1();
		particles[index+ParticleDirectionX] = Math.cos(computedAngle) * directionSpeed;
		particles[index+ParticleDirectionY] = Math.sin(computedAngle) * directionSpeed;
		particles[index+ParticleRadialAcceleration] = radialAcceleration + radialAccelerationVariance * rnd1to1();
		particles[index+ParticleTangentialAcceleration] = tangentialAcceleration + tangentialAccelerationVariance * rnd1to1();

		// For radial emitter type
		particles[index+ParticleAngle] = computedAngle;
		particles[index+ParticleAngleDelta] = (rotatePerSecond + rotatePerSecondVariance * rnd1to1()) / particles[index+ParticleTimeToLive];
		particles[index+ParticleRadius] = maxRadius + maxRadiusVariance * rnd1to1();
		particles[index+ParticleRadiusDelta] = (minRadius + minRadiusVariance * rnd1to1() - particles[index+ParticleRadius]) / particles[index+ParticleTimeToLive];
	}

	@:extern inline function updateParticle( index: Int, dt: Float ) {

		if ( particles[index+ParticleTimeToLive] <= dt ) {
			return false;
		}
		
		particles[index+ParticleTimeToLive] -= dt;
	
		switch ( emitterType ) {
			case Radial:
				particles[index+ParticleAngle] += particles[index+ParticleAngleDelta] * dt;
				particles[index+ParticleRadius] += particles[index+ParticleRadiusDelta] * dt;

				var radius = particles[index+ParticleRadius];
				particles[index+ParticlePositionX] = particles[index+ParticleStartPosX] - cos(angle) * radius;
				particles[index+ParticlePositionY] = particles[index+ParticleStartPosY] - sin(angle) * (yCoordFlipped ? -radius : radius);
			
			case Gravity:
				var radialX = 0.0;
				var	radialY = 0.0;
				var x = particles[index+ParticlePositionX] - particles[index+ParticleStartPosX];
				var y = particles[index+ParticlePositionY] - particles[index+ParticleStartPosY];

				if ( yCoordFlipped ) {
					y = -y;
				}

				if ( x != 0.0 || y != 0.0 ) {
					var invlength = 1.0 / Math.sqrt( x * x + y * y);

					radialX = x * invlength;
					radialY = y * invlength;
				}

				var tangentialX = -radialY;
				var tangentialY = radialX;

				radialX *= particles[index+ParticleRadialAcceleration];
				radialY *= particles[index+ParticleRadialAcceleration];

				tangentialX *= particles[index+ParticleTangentialAcceleration];
				tangentialY *= particles[index+ParticleTangentialAcceleration];

				particles[index+ParticleDirectionX] += (radialX + tangentialX + gravityX) * dt;
				particles[index+ParticleDirectionY] += (radialY + tangentialY + gravityY) * dt;

				particles[index+ParticlePositionX] = x + particles[index+ParticleDirectionX] * dt + particles[index+ParticleStartPosX];
				var y_ = y + particles[index+ParticleDirectionY] * dt;
				particles[index+ParticlePositionY] = (yCoordFlipped ? -y_ : y_) + particles[index+ParticleStartPosY];
		}

		particles[index+ParticleRed] += particles[index+ParticleRedDelta] * dt;
		particles[index+ParticleGreen] += particles[index+ParticleGreenDelta] * dt;
		particles[index+ParticleBlue] += particles[index+ParticleBlueDelta] * dt;
		particles[index+ParticleAlpha] += particles[index+ParticleAlphaDelta] * dt;

		particles[index+ParticleSize] = Math.max(0.0, particles[index+ParticleSize] + particles[index+ParticleSizeDelta]*dt);

		particles[index+ParticleRotation] += particles[index+ParticleRotationDelta ] * dt;

		return true;
	}

	public function update( dt: Float ) {
		if ( dt < 0.0001 ) {
			return false;
		}
		
		var emissionRate = maxParticles / Math.max( 0.0001, particleLifespan );
		if ( active && emissionRate > 0.0 ) {
			var rate = 1.0 / emissionRate;
			emitCounter += dt;

			while ( particleCount < maxParticles && emitCounter > rate ) {
				initParticle();
				emitCounter -= rate;
			}

			if ( emitCounter > rate ) {
				emitCounter = (emitCounter % rate);
			}

			elapsedTime += dt;

			if ( duration >= 0.0 && duration < elapsedTime ) {
				stop();
			}
		}

		var updated = particleCount > 0;
		var index = 0;
		var indexShifted = 0;
		var lastIndex = particleCount - 1;
		var lastIndexShifted = lastIndex * PARTICLE_PARAMETERS;
		while ( index < particleCount ) {
			var result = updateParticle( indexShifted, dt );

			if ( result ) {
				index += 1;
				indexShifted += PARTICLE_PARAMETERS;
			} else {
				if ( index != lastIndex ) {
					for ( i in 0...PARTICLE_PARAMETERS ) {
						particles[indexShifted+i] = particles[lastIndexShifted+i];
					}	
				}
				particleCount -= 1;
				lastIndex -= 1;
				lastIndexShifted -= PARTICLE_PARAMETERS;
			}
		}

		if ( particleCount > 0 ) {
			updated = true;
		} else if ( restart ) {
			active = true;
		}

		return updated;	
	}

	public function stop() {
		active = false;
		emitCounter = 0.0;
		elapsedTime = 0.0;
	}

	public function pause() {
		active = false;	
	}

	public function reset() {
		stop();
		var indexShifted = 0;
		for ( i in 0...particleCount ) {
			particles[indexShifted+ParticleTimeToLive] = 0.0;
			indexShifted += PARTICLE_PARAMETERS;
		}
	}
	
	public function start( ?duration_: Float ) {
		active = true;
		if ( duration_ != null ) {
			duration = duration_;
		}
	}
}
