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
			["Start size", "0.0~70.0", "startSize","70.0"],
			["Start size var.", "0.0~70.0", "startSizeVariance","49.5"],
			["Finish size", "0.0~70.0", "finishSize","10.0"],
			["Finish size var.", "0.0~70.0", "finishSizeVariance","5.0"],
			["Angle", "0.0~360.0", "angle","270.0"],
			["Angle Var.", "0.0~360.0", "angleVariance","0.0"],
			["Rotation start", "0.0~360.0", "rotationStart","0.0"],
			["Rotation start var.", "0.0~360.0", "rotationStartVariance","0.0"],
			["Rotation finish", "0.0~360.0", "rotationFinish","0.0"],
			["Rotation finish var.", "0.0~360.0", "rotationFinishVariance","0.0"],

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
	
	public static var PARTS = ["2-24","6-24","4-24"];

	public static function makeHtml( s: Array<String>, pad: String="" ) return switch( s ) {
		case [title, "@Label"]: '$pad<h3>$title</h3>';
		case [title, "@Button", action]: '$pad<input type="button" onclick="$action">$title</input>';
		case [title, "@Checkbox", action]: '$pad<input type="checkbox" onclick="$action">$title</input>';
		case [title, params, variable, def]:
			switch ( params.split("~")) {
				case [min,max]: 
					'${pad}<div>' +
					'${title}<input id="$variable" type="range" min="$min" max="$max" step="${Std.parseFloat(max)/100}" value="$def" oninput="document.getElementById(\'${variable}Label\').innerHTML=document.getElementById(\'${variable}\').value;">' + 
					'<span id="${variable}Label">$def</span>' + 
					"</div>";
				case e:
					var options = ${e[0].split("|").map(function(str) return pad + "  <option" + ((def==str) ? " selected" : "") + ">" + str + "</option>");
					'$pad<p><label for="$variable">$title</label>\n$pad<select id="$variable">\n${options.join('\n')}\n$pad</select></p>';
			}
		case _: throw 'Bad pair: $s';
	}


	public static function collectHtml( uispecs: Array<Array<Array<String>>>, uiparts: Array<String> ) {
		var buf = new StringBuf();
		var index = 0;
		buf.add( '<div class="pure-g">\n' );
		buf.add( '  <canvas id="canvas-editor" class="pure-u-1 pure-u-lg-1-2"></canvas>\n');
		for ( col in uispecs ) {
			buf.add( '    <div class="pure-u-1 pure-u-lg-${uiparts[index]}">\n' );
			for ( row in col ) {
				buf.add( makeHtml( row, "      " ));
				buf.add( "\n" );
			}
			buf.add( "    </div>\n" );
			index += 1;
		}
		buf.add("</div>\n");
		return buf.toString();
	}
}
