import pex.PexIo;
import pex.PexEmitter;
import pex.backend.PexHtml5CanvasRenderer;
import js.Browser;
import js.html.ImageElement;
import js.html.CanvasElement;

class Html5Editor {
	static var particleEmitter: PexEmitter;
	static var particleRenderer: PexHtml5CanvasRenderer;
	static var particleImage: ImageElement;
	static var canvas: CanvasElement;
	
	static var ui = [
		[
			["General","@Label"],
			["Save","@Label"],
			["Export Particle","@Button","exportParticle"],
			["Include .PLIST file","@Checkbox"],
			["Load","@Label"],
			["Load Particle","@Button","loadParticle"],
			["Edit","@Label"],
			["Edit Texture","@Button","editTexture"],
			["Edit Background","@Button","editBackground"],
		],
		
		[
			["Particles","@Label"],

			["Emitter type","@Label"],
			["emitterType","Gravity|Radial"],

			["@Particle configuration"],
			["Max particles", "1~1000", "maxParticles"],
			["Particle lifespan", "0.0~10.0", "particleLifespan"],
			["Particle lifespan var.", "0.0~10.0", "particleLifespanVariance"],
			["Start size", "0.0~70.0", "startSize"],
			["Start size var.", "0.0~70.0", "startSizeVariance"],
			["Finish size", "0.0~70.0", "finishSize"],
			["Finish size var.", "0.0~70.0", "finishSizeVariance"],
			["Angle", "0.0~360.0", "angle"],
			["Angle Var.", "0.0~360.0", "angleVariance"],
			["Rotation start", "0.0~360.0", "rotationStart"],
			["Rotation start var.", "0.0~360.0", "rotationStartVariance"],
			["Rotation finish", "0.0~360.0", "rotationFinish"],
			["Rotation finish var.", "0.0~360.0", "rotationFinishVariance"],

			["Particle behavior","@Label"],
			["Gravity emitter","@Label"],
			["Position x", "-500.0~500.0", "sourcePositionX"],
			["Position x var.", "-500.0~500.0", "sourcePositionXVariance"],
			["Position y", "-500.0~500.0", "sourcePositionY"],
			["Position y var.", "-500.0~500.0", "sourcePositionYVariance"],
			["Speed", "0.0~500.0", "speed"],
			["Speed var.", "0.0~500.0", "speedVariance"],
			["Gravity x", "-500.0~500.0", "gravityX"],
			["Gravity y", "-500.0~500.0", "gravityY"],
			["Tan. accel.", "-500.0~500.0", "tangentialAcceleration"],
			["Tan. accel. var.", "-500.0~500.0", "tangentialAccelerationVariance"],
			["Radial accel.","-500.0~500.0", "radialAcceleration"],
			["Radial accel. var.","-500.0~500.0", "radialAccelerationVariance"],

			["Radial emitter","@Label"],
			["Max radius", "0.0~500.0", "maxRadius"],
			["Max radius var.", "0.0~500.0", "maxRadiusVariance"],
			["Min radius", "0.0~500.0", "minRadius"],
			["Min radius var.", "0.0~500.0","minRadiusVariance"],
			["Deg/sec", "-360.0~360.0", "rotatePerSecond"],
			["Deg/sec var.", "-360.0~360.0", "rotatePerSecondVariance"],
		],
		[	
			["Color","@Label"],
			["Start","@Label"],
			["R", "0.0~1.0", "startColorRed"],
			["G", "0.0~1.0", "startColorGreen"],
			["B", "0.0~1.0", "startColorBlue"],
			["A", "0.0~1.0", "startColorAlpha"],

			["Finish","@Label"],
			["R", "0.0~1.0", "finishColorRed"], 
			["G", "0.0~1.0", "finishColorGreen"],
			["B", "0.0~1.0", "finishColorBlue"],
			["A", "0.0~1.0", "finishColorAlpha"],
		],
		[
			["Color variance","@Label"],
			["Start","@Label"],
			["R", "0.0~1.0", "startColorRedVariance"],
			["G", "0.0~1.0", "startColorGreenVariance"],
			["B", "0.0~1.0", "startColorBlueVariance"],
			["A", "0.0~1.0", "startColorAlphaVariance"],

			["Finish","@Label"],
			["R", "0.0~1.0", "finishColorRedVariance"], 
			["G", "0.0~1.0", "finishColorGreenVariance"],
			["B", "0.0~1.0", "finishColorBlueVariance"],
			["A", "0.0~1.0", "finishColorAlphaVariance"],

			["Blend function","@Label"],
			["Source", "Zero|One|Src|One - Src|SrcAlpha|One - SrcAlpha|DstAlpha|One-DstAlpha|DstColor|One-DstColor", "blendFuncSource"],
			["Destination", "Zero|One|Src|One - Src|SrcAlpha|One - SrcAlpha|DstAlpha|One-DstAlpha|DstColor|One-DstColor", "blendFuncDestination"],
		]
	];	

	public static function makeHtmlFromPair( s: Array<String> ) return switch( s ) {
		case [title, "@Label"]: '<h3>$title</h3>';
		case [title, "@Button", action]: '<input type="button" onclick=$action>$title</input>';
		case [title, "@Checkbox"]: '<input type="checkbox">$title</input>';
		case [title, params, variable, def]:
			switch ( params.split("~")) {
				case [min,max]: '<input type="range" min="$min" max="$max" step="${(Std.parseFloat(max)-Std.parseFloat(min))/10}" value="$def"><input>';
				case e:
					'<p><label for="$variable">$title</label>\n<select id="$variable">${e[0].split("|").map(function(s) return '<option>$s</option>').join('\n')}</select></p>';
			}
		case _: throw 'Bad pair: $s';
	}

	public static function main() {
		particleEmitter = PexIo.loadFromXmlCompileTime( "html5editor/particle.pex" );
		
		canvas = cast Browser.document.getElementById( "canvas-editor" );//createCanvasElement();
		canvas.style.backgroundColor = "black";
			
		
		particleRenderer = new PexHtml5CanvasRenderer( canvas );
		particleImage = cast Browser.document.getElementById("particleImage");
		particleEmitter.start( Math.POSITIVE_INFINITY );
		Browser.window.requestAnimationFrame( update );
	}

	static var start = 0.0;

	public static function update( timestamp: Float ) {
		if ( start == 0.0 ) {
			start = timestamp;
		} else {
			particleEmitter.update( 0.001*(timestamp - start));
			start = timestamp;
		}
		canvas.getContext2d().clearRect( 0, 0, canvas.width, canvas.height );
		particleRenderer.render( particleEmitter, particleImage );
		
		Browser.window.requestAnimationFrame( update );
	}
}
