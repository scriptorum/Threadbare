package inscrutablegames;

import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.text.TextFormat;
import openfl.text.Font;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.display.Tilesheet;

// The Assets class is not available at this stage of the bootstrap,
// so you must use the "native Haxe" way of loading embedded assets.
@:bitmap("assets/art/inscrutablegames.png") class LogoImage extends BitmapData {}
@:font("assets/font/AccidentalPresidency.ttf") class MainFont extends Font { }

/**
 * This is my Inscrutable Games web preloader, it's not used for CPP targets.
 * Supports -D defines:
 *    freezeloader
 */
class Preloader extends NMEPreloader
{
	private static inline var LOGO_WIDTH:Int = 386;
	private static inline var LOGO_HEIGHT:Int = 136;

	private var tf:TextField;
	private var tiles:Tilesheet;
	private var tileData:Array<Float>;
	private var loadComplete:Bool = false;
	private var percentLoaded:Float = 0;

	#if slowloader
	private static inline var SLOW_LOAD_MIN:Int = 5 * 1000; // minimum preload time in ms if -Dslowloader
	private var loadStart:Int = 0;
	private var slowLoaded:Bool = false;
	#end

	public function new()
	{
		super();

		// Meh. Dislike NMEPreloader. Painful to work around it.
		removeChild(outline);
		removeChild(progress);

        graphics.beginFill(0x88786f);
        graphics.drawRect(0, 0, getWidth(), getHeight());
        graphics.endFill();
            	
		tileData = [
			  (getWidth() - LOGO_WIDTH) / 2, -LOGO_HEIGHT / 2 + getHeight() * 1/2 , 0,
		];

		tiles = new Tilesheet(new LogoImage(0,0));
		tiles.addTileRect(new Rectangle(0, 0, LOGO_WIDTH, LOGO_HEIGHT));
		tiles.drawTiles(graphics, tileData, true);

		var format = new TextFormat();
		format.align = TextFormatAlign.CENTER;
		format.size = 24;
		format.color = 0xFFFFFF;
		format.bold = true;
		format.font = new MainFont().fontName;

		tf = new TextField();
		tf.width = getWidth() * 1/4;
		tf.height = 200;
		tf.text = "Loading";
		tf.x = getWidth() * 3/4;
		tf.y = getHeight() * 7/8;
		tf.selectable = false;
		tf.defaultTextFormat = format;
		addChild(tf);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		onEnterFrame(null);
	}
	
	// Just need NMEPreloader for the onLoaded call
	override public function onLoaded(): Void
	{
		loadComplete = true;
		onEnterFrame(null);
	}

	private function onEnterFrame(_)
	{
		// Support "slow loading" to demo preloader when running local
		#if slowloader
			if(loadStart == 0)
				loadStart = Lib.getTimer();
			else if(!slowLoaded)
			{
				var slowLoadPct:Float = (Lib.getTimer() - loadStart) / SLOW_LOAD_MIN;
				percentLoaded = Math.max(percentLoaded, slowLoadPct);
				if(slowLoadPct >= 1.0)
				{
					slowLoaded = true;
					percentLoaded = 1.0;
				}
			}
		#end

		tf.text = Std.int(percentLoaded * 100) + "%";

		if(loadComplete #if (slowloader) && slowLoaded #end)
		{
			#if freezeloader
				tf.text = "100%";
			#else
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				super.onLoaded();
			#end
		}
	}

	// Sooooo many things I dislike about NMEPreloader
	override public function onUpdate(loaded:Int, total:Int): Void
	{
		// Have I mentioned I don't like NMEPreloader?
		percentLoaded = Math.min(0, loaded / total);
	}
}
