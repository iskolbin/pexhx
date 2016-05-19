package pex.backend;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageElement;
import js.html.Image;
import js.Browser;

import pex.PexEmitter;

class PexHtml5CanvasRenderer {
	var context: CanvasRenderingContext2D;
	var tintCache = new Map<String,Array<Image>>();
	public var additive = true;

	public function new( canvas: CanvasElement ) {
		context = canvas.getContext2d();
	}
	
	// See for details:
	// http://www.playmycode.com/blog/2011/06/realtime-image-tinting-on-html5-canvas/
	public function lookupTint( img: ImageElement ) {
		if ( !tintCache.exists( img.src )) {
			var w = img.width;
			var h = img.height;
			var rgbks = [];

			var canvas = Browser.document.createCanvasElement();
			canvas.width = w;
			canvas.height = h;

			var ctx = canvas.getContext2d();
			ctx.drawImage( img, 0, 0 );

			var pixels = ctx.getImageData( 0, 0, w, h ).data;

			// 4 is used to ask for 3 images: red, green, blue and
			// black in that order.
			for ( rgbI in 0...4 ) {
				var canvas = Browser.document.createCanvasElement();
				canvas.width  = w;
				canvas.height = h;

				var ctx = canvas.getContext('2d');
				ctx.drawImage( img, 0, 0 );
				var toImg = ctx.getImageData( 0, 0, w, h );
				var toData = toImg.data;
				var len = pixels.length;
				var i = 0;
				while ( i < len ) {
					toData[i  ] = (rgbI == 0) ? pixels[i  ] : 0;
					toData[i+1] = (rgbI == 1) ? pixels[i+1] : 0;
					toData[i+2] = (rgbI == 2) ? pixels[i+2] : 0;
					toData[i+3] =               pixels[i+3]    ;
					i += 4;
				}	

				ctx.putImageData( toImg, 0, 0 );

				// image is _slightly_ faster then canvas for this, so convert
				var imgComp = new Image();
				imgComp.src = canvas.toDataURL();

				rgbks.push( imgComp );
			}

			tintCache[img.src] = rgbks;
			return rgbks;

		} else {
			return tintCache.get( img.src ); 
		}
	}	

	public function render( emitter: PexEmitter, image: ImageElement ) {
		var predCompositeOp = context.globalCompositeOperation;
		var predAlpha = context.globalAlpha;
		context.globalCompositeOperation = additive ? "lighter" : "destination-over";
		
		var idx = emitter.getShiftedIndex(0);
		for ( i in 0...emitter.particleCount ) {
			var color = emitter.getARGB(idx);
			var size = emitter.getSize(idx);
			var a = color >>> 0x18;
			if ( a > 0 && size > 0.0 ) {
				var x = emitter.getX(idx) - 0.5*size;
				var y = emitter.getY(idx) - 0.5*size;
			
				context.globalAlpha = (color >>> 0x18)/0xff;
				
				var rgb = color & 0xffffff;
				if ( rgb != 0xffffff ) {
					var r = (color & 0xff0000) >>> 0x10;
					var g = (color & 0x00ff00) >>> 0x8;
					var b = (color & 0x0000ff);
					var images = lookupTint( image );
					context.globalCompositeOperation = additive ? "lighter" : "destination-over";
					context.globalAlpha = 1.0;
					context.drawImage( images[3], x, y, size, size );
					context.globalCompositeOperation = "lighter";
					if ( r > 0 ) {
						context.globalAlpha = r / 0xff;
						context.drawImage( images[0], x, y, size, size );
					}
					if ( g > 0 ) {
						context.globalAlpha = g / 0xff;
						context.drawImage( images[1], x, y, size, size );
					}
					if ( b > 0 ) {
						context.globalAlpha = b / 0xff;
						context.drawImage( images[2], x, y, size, size );
					}
				} else {
					context.drawImage( image, x, y, size, size );
				}
			}
			idx = emitter.incrementShiftedIndex(idx);
		}

		context.globalAlpha = predAlpha;
		context.globalCompositeOperation = predCompositeOp;
	}
}
