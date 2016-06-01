import pex.PexIo;
import pex.PexEmitter;
import pex.backend.PexHtml5CanvasRenderer;
import js.Browser;
import js.html.*;

class Html5Editor {
	static var particleEmitter: PexEmitter;
	static var particleRenderer: PexHtml5CanvasRenderer;
	static var particleImage: ImageElement;
	static var canvas: CanvasElement;
	
	static function makeHtml( s: Array<String>, pad: String="" ): Element return switch( s ) {
		case [title, "@Label"]: var e = Browser.document.createElement("h3");
														e.innerText = title;
														e;

		case [title, "@Button", action]: var e = Browser.document.createInputElement();
																		 e.type = "button";
																		 //e.onclick = action;
																		 e.value = title;
																		 e;
		
		case [title, "@Checkbox", action]: var e = Browser.document.createInputElement();
																			 e.type = "checkbox";
																			 //e.onclick = action;
																			 e.value = title;
																			 e;	 
		
		case [title, params, variable, def]: switch ( params.split("~")) {
				case [min,max]: var e = Browser.document.createDivElement();
												e.innerText = title;
												var range = Browser.document.createInputElement();
												range.id = variable;
												range.type = "range";
												range.min = min;
												range.max = max;
												range.value = def;
												range.step = '${Std.parseFloat(max)/100}';
												e.appendChild( range );
												var span = Browser.document.createSpanElement();
												span.id = '${variable}Label';
												span.innerText = def;
												range.oninput = function() {
													span.innerText = range.value;
													PexIo.setParamFromString( particleEmitter, range.id, range.value );
												}
												e.appendChild( span );
												e;
				case options:
					var e = Browser.document.createDivElement();
					var label = Browser.document.createLabelElement();
					label.htmlFor = variable;
					var select = Browser.document.createSelectElement();
					var optionsArray = options[0].split("|");
					select.id = variable;
					select.oninput = function() {
						PexIo.setParamFromString( particleEmitter, select.id, '${select.selectedIndex}'	);
					}
					e.appendChild( select );
					for ( s in optionsArray ) {
						var option = Browser.document.createOptionElement();
						option.innerText = s;
						option.selected = s == def;
						select.add( option ); 
					}
					e;
			}

		case _: throw 'Bad pair: $s';
	}


	public static function collectHtml( uispecs: Array<Array<Array<String>>>, mdparts: Array<String>, lgparts: Array<String> ) {
		var index = 0;
		var editorDiv = Browser.document.createDivElement();
		editorDiv.className = "pure-g";
		var canvas = Browser.document.createCanvasElement();
		canvas.id = "canvas-editor";
		canvas.className = "pure-u-1 pure-u-lg-1-2";
		editorDiv.appendChild( canvas );
		for ( col in uispecs ) {
			var div = Browser.document.createDivElement();
			div.className = 'pure-u-1 pure-u-md-${mdparts[index]} pure-u-lg-${lgparts[index]}';
			for ( row in col ) {
				div.appendChild( makeHtml( row ));
			}
			editorDiv.appendChild( div );
			index += 1;
		}
		return editorDiv;
	}
	
	public static function main() {
		var body = Browser.document.getElementsByTagName( "body" )[0];
		var wrapperDiv = Browser.document.createDivElement();
		wrapperDiv.appendChild( collectHtml( EditorUi.SPECS, EditorUi.MD_PARTS, EditorUi.LG_PARTS ));
		body.appendChild( wrapperDiv );

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
		canvas.width = canvas.offsetWidth;
		canvas.height = canvas.offsetHeight;

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
