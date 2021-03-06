package;

class EditorUi {
	public static var SPECS = [
		[
			["Save","@Label"],
			["Export Particle","@Button","exportParticle"],
			["Include .PLIST file","@Checkbox", "includePlistFile"],
			["Load","@Label"],
			["Load Particle","@Button","loadParticle"],
			["Edit","@Label"],
			["Edit Texture","@Button","editTexture"],
			["Edit Background","@Button","editBackground"],
		],
		
		[
			["Particle configuration", "@Label"],
			["Type","Gravity|Radial", "emitterType", "Gravity"],
			["Max particles", "0~1000", "maxParticles","500"],
			["Particle lifespan", "0.0~10.0", "particleLifespan","2.0"],
			["Particle lifespan var.", "0.0~10.0", "particleLifespanVariance","1.9"],
			["Start size", "0.0~70.0", "startParticleSize","70.0"],
			["Start size var.", "0.0~70.0", "startParticleSizeVariance","49.5"],
			["Finish size", "0.0~70.0", "finishParticleSize","10.0"],
			["Finish size var.", "0.0~70.0", "finishParticleSizeVariance","5.0"],
			["Angle", "0.0~360.0", "angle","270.0"],
			["Angle Var.", "0.0~360.0", "angleVariance","0.0"],
			["Rotation start", "0.0~360.0", "rotationStart","0.0"],
			["Rotation start var.", "0.0~360.0", "rotationStartVariance","0.0"],
			["Rotation end", "0.0~360.0", "rotationEnd","0.0"],
			["Rotation end var.", "0.0~360.0", "rotationEndVariance","0.0"],

			["Gravity emitter","@Label"],
			["Position x", "-500.0~500.0", "sourcePositionX","0.0"],
			["Position x var.", "-500.0~500.0", "sourcePositionXVariance","0.0"],
			["Position y", "-500.0~500.0", "sourcePositionY","0.0"],
			["Position y var.", "-500.0~500.0", "sourcePositionYVariance","0.0"],
			["Speed", "0.0~500.0", "speed","100.0"],
			["Speed var.", "0.0~500.0", "speedVariance","30.0"],
			["Gravity x", "-500.0~500.0", "gravityX","0.0"],
			["Gravity y", "-500.0~500.0", "gravityY","0.0"],
			["Tan. accel.", "-500.0~500.0", "tangentialAcceleration","0.0"],
			["Tan. accel. var.", "-500.0~500.0", "tangentialAccelerationVariance","0.0"],
			["Radial accel.","-500.0~500.0", "radialAcceleration","0.0"],
			["Radial accel. var.","-500.0~500.0", "radialAccelerationVariance","0.0"],

			["Radial emitter","@Label"],
			["Max radius", "0.0~500.0", "maxRadius", "100.0"],
			["Max radius var.", "0.0~500.0", "maxRadiusVariance", "0.0"],
			["Min radius", "0.0~500.0", "minRadius", "0.0"],
			["Min radius var.", "0.0~500.0","minRadiusVariance", "0.0"],
			["Deg/sec", "-360.0~360.0", "rotatePerSecond", "0.0"],
			["Deg/sec var.", "-360.0~360.0", "rotatePerSecondVariance", "0.0"],
		],
		[	
			["Color","@Label"],
			["Start","@Label"],
			["R", "0.0~1.0", "startColorRed", "1.0"],
			["G", "0.0~1.0", "startColorGreen", "0.3"],
			["B", "0.0~1.0", "startColorBlue", "0.0"],
			["A", "0.0~1.0", "startColorAlpha", "0.6"],

			["Finish","@Label"],
			["R", "0.0~1.0", "finishColorRed","1.0"], 
			["G", "0.0~1.0", "finishColorGreen", "0.3"],
			["B", "0.0~1.0", "finishColorBlue", "0.0"],
			["A", "0.0~1.0", "finishColorAlpha", "0.0"],
			
			["Color variance","@Label"],
			["Start","@Label"],
			["R", "0.0~1.0", "startColorRedVariance", "0.0"],
			["G", "0.0~1.0", "startColorGreenVariance", "0.0"],
			["B", "0.0~1.0", "startColorBlueVariance", "0.0"],
			["A", "0.0~1.0", "startColorAlphaVariance", "0.0"],

			["Finish","@Label"],
			["R", "0.0~1.0", "finishColorRedVariance", "0.0"], 
			["G", "0.0~1.0", "finishColorGreenVariance", "0.0"],
			["B", "0.0~1.0", "finishColorBlueVariance", "0.0"],
			["A", "0.0~1.0", "finishColorAlphaVariance", "0.0"],

			["Blend function","@Label"],
			["Source", "Zero|One|Src|One - Src|SrcAlpha|One - SrcAlpha|DstAlpha|One-DstAlpha|DstColor|One-DstColor", "blendFuncSource","SrcAlpha"],
			["Destination", "Zero|One|Src|One - Src|SrcAlpha|One - SrcAlpha|DstAlpha|One-DstAlpha|DstColor|One-DstColor", "blendFuncDestination","One"],
		],
	];	
	
	public static var LG_PARTS = ["2-24","6-24","4-24"];

	public static var MD_PARTS = ["2-12","6-12","4-12"];
}
